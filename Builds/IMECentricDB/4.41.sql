

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [dbo].[vwMedRecCases]...';


GO
CREATE VIEW [dbo].[vwMedRecCases]
AS 
	    SELECT 
			C.CaseNbr,
			C.ExtCaseNbr, 
			DATEDIFF(DAY, C.LastStatusChg, GETDATE()) AS IQ,
			DATEDIFF(DAY, c.RPAMedRecRequestDate, GETDATE()) AS IQReq,
			DATEDIFF(DAY, c.RPAMedRecCompleteDate, GETDATE()) AS IQComp,
			E.FirstName + ' ' + E.LastName AS ExamineeName,
			Com.IntName AS CompanyName,
			D.FirstName + ' ' + D.LastName AS DoctorName,
			C.ApptTime,
			C.OfficeCode,
			C.ServiceCode,
			C.SchedulerCode,
			C.QARep,
			C.MarketerCode,
			Com.ParentCompanyID,
			C.DoctorLocation,
			D.DoctorCode,
			Com.CompanyCode,
			C.CaseType,
			C.Status AS CaseStatus,
			Q.StatusDesc,
			E.ChartNbr,		
			Serv.Description, 
			ServType.EWServiceTypeID, 
			ServType.Name As ServiceTypDesc,
			CT.ShortDesc AS CaseTypeDesc,
			C.RPAMedRecRequestDate,
			C.RPAMedRecUploadStatus,
			C.RPAMedRecUploadAckDate,
			C.RPAMedRecUploadAckUserID,
			C.RPAMedRecCompleteDate
    FROM tblCase AS C
			LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
			LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
			LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode	
			LEFT OUTER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
			LEFT OUTER JOIN tblServices AS Serv ON Serv.ServiceCode = C.ServiceCode
			LEFT OUTER JOIN tblEWServiceType AS ServType ON ServType.EWServiceTypeID = Serv.EWServiceTypeID
			LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[pr_USTMedExtraction]...';


GO
-- =============================================
-- Author:		Doug Leveille
-- Create date: 2023-07-27
-- Description:	This stored procedure will generate a list of cases to pull medical record from client web sites for the RPA process.  It has two queries with a Union.
-- Query 1 pulls cases from all offices that are IMEs or MRR based on the queue the cases are in and ApptDate.
-- Query 2 pulls cases that are based on office specific case type and services that are in the awaiting medical records queue.
-- The SP then updates tblCase.RPAMedRecRequestDate with the date submitted and tblCase.RPAMedRecUploadStatus to 'Processing'

-- =============================================
CREATE PROCEDURE [dbo].[pr_USTMedExtraction] 
AS
BEGIN

/* This stored procedure will generate a list of cases to pull medical record from client web sites for the RPA process.  It has two queries with a Union.
Query 1 pulls cases from all offices that are IMEs or MRR based ApptDate and days in advance.
Query 2 pulls cases that are based on office specific case type and services that are in the awaiting medical records queue.

The SP then updates tblCase.RPAMedRecRequestDate with the date submitted and tblCase.RPAMedRecUploadStatus to 'Processing'
*/

--Load a temp table with the configuration information.  This includes which parent companies to pull cases for and other parameters.
select
	ParentCo = (select [dbo].[fnGetParamValue](C.Param, 'ParentCo=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType),
	ParentCompanyID = convert(integer,(select [dbo].[fnGetParamValue](C.Param, 'ParentCompanyID=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType)),
	URL = (select [dbo].[fnGetParamValue](C.Param, 'URL=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType),
	UserID = (select [dbo].[fnGetParamValue](C.Param, 'UserID=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType),
	Password = (select [dbo].[fnGetParamValue](C.Param, 'Password=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType),
	FilenameKeyword = (select [dbo].[fnGetParamValue](C.Param, 'FilenameKeyword=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType),
	DaysInAdvance = convert(integer,(select [dbo].[fnGetParamValue](C.Param, 'DaysInAdvance=') 
												FROM tblConfiguration as CF where CF.Name = 'RPA MedRec SP' and CF.ConfigurationType = c.ConfigurationType))
into #Temp_RPACredentials
from tblconfiguration c with (nolock) where c.name = 'RPA MedRec SP'

--load the #temp_RPACriteria table from tblcodes.  This table will include all the Parent Co, office, casetype, and service specific criteria for including cases

select 
	(select [dbo].[fnGetParamValue](c.value, 'Keyword=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCo,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceCode
into #temp_RPACriteria
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUpload'

--load the #temp_RPAOfficesToExclude table from tblcodes.  This table will include all the Keyword, office, casetype, and service types to exclude from list

select 
	(select [dbo].[fnGetParamValue](c.value, 'ParentCo=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCo,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceType
into #temp_RPAOfficesToExclude
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUploadExclude'

--load the #temp_RPAOverride table from tblcodes.  This table will include all the Keyword, office, casetype, and service types where we want to use a different days in advance than tblconfiguration

select 
	(select [dbo].[fnGetParamValue](c.value, 'ParentCo=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCo,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'DaysInAdvance=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as DaysInAdvance
into #temp_RPAOverride
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUploadOverride'

--Test #temp_RPACriteria
--select
--t.ParentCo,
--t.officecode,
--o.description,
--t.casetype ,
--ct.description,
--t.ServiceCode,
--s.Description,
--st.name as ServiceType
--from #temp_RPACriteria T
--inner join tbloffice o on o.officecode = t.OfficeCode
--inner join tblcasetype ct on ct.code = t.casetype
--inner join tblservices s on s.servicecode = t.servicecode
--inner join tblewservicetype st on st.EWServiceTypeID = s.EWServiceTypeID
--order by t.parentco,
--o.description,
--s.description


SELECT * into #Temp_RPACasesToPull from (
 SELECT 
	c.casenbr,
	(select convert(varchar,DBID) from tblControl) + '-' + convert(varchar,c.casenbr) as SystemKeyVal,  
	case when cl.companycode = 77443 then 'GBStradix' --GBCARE  Have to hard code this because also under parent company of GB but has different config information
		 else RPAC.ParentCo 
		 end as Keyword,
	c.jurisdiction as Jurisdiction,
	c.claimnbr as Claim#,
	c.addlclaimnbrs as AltCaseIds,
	e.firstname  as ClaimantFirstName,
	e.lastname as ClaimantLastName,
	isnull(convert(varchar, c.apptdate, 101),'') as ExamDate,
	isnull((select top 1 convert(varchar,cd.dateadded,101) from tblcasedocuments cd with (nolock) 
				 where cd.casenbr = c.casenbr and cd.CaseDocTypeID in (7,8,9,10,11) -- all types of medical records
				 and cd.sfilename like  + '%' + case when cl.companycode = 77443 then 'GBStradix' else RPAC.FilenameKeyword  end + '%' 
				 order by cd.dateadded desc),'01/01/1900') as StartDate,
	case when RPAC.ParentCo = 'ESIS' then '' --	ESIS does not have a referral ID in IMEC
		 when RPAC.ParentCo = 'Hartford' then '' --	Hartford does not have a referral ID in IMEC
		 when RPAC.ParentCo = 'Liberty' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') --	Get from Liberty Tab
											FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual')
		 when RPAC.ParentCo = 'Travelers' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'TimeTrakReferralNbr=') --	Get from Travelers Tab
											FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Travelers')
		 when RPAC.parentCo = 'Zurich' then '' -- not required for Zurich
		 when RPAC.parentCo = 'GB' then '' -- not required for GB
		 else ''end as ReferralID,
	case when RPAC.ParentCo = 'Liberty' then RPAC.URL + (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') 
											FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual') 
		 when cl.companycode = 77443 then 'https://www.stradix.com' --GBCare
		 else RPAC.URL end as CustomerURL,
	o.MedRecNotifyEmail as EmailAlertTo,
	tz.BaseUtcOffsetSec,
	st.mapping1,
	DaysInAdvance = coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
	where Temp1.officecode = c.officecode 
			and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
			and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
			and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)),RPAC.DaysInAdvance )


	FROM tblcase c with (nolock) 
	inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
	inner join tbloffice o with (nolock) on o.officecode = c.OfficeCode
	inner join tblclient cl with (nolock) on cl.clientcode = coalesce(c.billclientcode, c.clientcode)
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	inner join tblEWParentCompany pc with (nolock) on pc.ParentCompanyID = co.ParentCompanyID 
	inner join #temp_RPACredentials RPAC with (nolock) on RPAC.ParentCompanyID = pc.parentcompanyid
	inner join tblservices s with (nolock) on s.ServiceCode = c.servicecode
	inner join tblEWServiceType st with (nolock) on st.EWServiceTypeID = s.EWServiceTypeID
	inner join tblEWTimeZone tz with (nolock) on tz.EWTimeZoneID = o.EWTimeZoneID
	left join tblcasetype ct with (nolock) on ct.code = c.casetype
	left join tblEWBusLine lob with (nolock) on lob.EWBusLineID = ct.EWBusLineID
	left join tblcontrol ctrl with (nolock) on ctrl.installid = 1
WHERE 
	(
		(st.Mapping1 = 'MRR' and c.apptdate is null and c.status = 3) -- record reviews that aren't schedule yet in awaiting scheduling
	or
		(st.mapping1 in ('IME') and 
			convert(varchar,c.apptdate, 101) = convert(varchar, (getdate() + 
			coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
			where Temp1.officecode = c.officecode 
				and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
				and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
				and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)),RPAC.DaysInAdvance)) ,101)
		)

	)
	and pc.ParentCompanyID = RPAC.ParentCompanyID
	and c.status not in (8,9)
	and (c.RPAMedRecRequestDate is null or convert(varchar,c.RPAMedRecRequestDate,101) <> convert(varchar,getdate(),101)) -- don't submit case more than once per day
	and o.officecode not in (select Temp.officecode  from #temp_RPAOfficesToExclude Temp with (nolock) 
		where Temp.officecode = c.officecode 
				and  (Temp.ParentCo = RPAC.ParentCo or Temp.ParentCo = 'All') 
				and  (Temp.CaseType = c.casetype or Temp.CaseType = -1)
				and  (Temp.ServiceType = s.EWServiceTypeID or Temp.Servicetype = -1)
		)
UNION

-- pick up all cases joining the RPACriteria table.  These are case that are case service specific
	SELECT 
		c.casenbr,
		(select convert(varchar,DBID) from tblControl) + '-' + convert(varchar,c.casenbr) as SystemKeyVal,  
		case when cl.companycode = 77443 then 'GBStradix' --GBCARE
			 else RPAC.ParentCo 
			 end as Keyword,
		c.jurisdiction as Jurisdiction,
		c.claimnbr as Claim#,
		c.addlclaimnbrs as AltCaseIds,
		e.firstname  as ClaimantFirstName,
		e.lastname as ClaimantLastName,
		isnull(convert(varchar, c.apptdate, 101),'') as ExamDate,
	isnull((select top 1 convert(varchar,cd.dateadded,101) from tblcasedocuments cd with (nolock) 
				 where cd.casenbr = c.casenbr and cd.CaseDocTypeID in (7,8,9,10,11) -- all types of medical records
				 and cd.sfilename like  + '%' + case when cl.companycode = 77443 then 'GBStradix' else RPAC.FilenameKeyword  end + '%' 
				 order by cd.dateadded desc),'01/01/1900') as StartDate,
		case when RPAC.ParentCo = 'ESIS' then '' --	ESIS does not have a referral ID in IMEC
			 when RPAC.ParentCo = 'Hartford' then '' --	Hartford does not have a referral ID in IMEC
			 when RPAC.ParentCo = 'Liberty' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') --	Get from Liberty Tab
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual')
			 when RPAC.ParentCo = 'Travelers' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'TimeTrakReferralNbr=') --	Get from Travelers Tab
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Travelers')
			 when RPAC.parentCo = 'Zurich' then '' -- not required for Zurich
			 when RPAC.parentCo = 'GB' then '' -- not required for GB
			 else ''end as ReferralID,
		case when RPAC.ParentCo = 'Liberty' then RPAC.URL + (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') 
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual') 
			 when cl.companycode = 77443 then 'https://www.stradix.com' --GBCare
			 else RPAC.URL end as CustomerURL,
		o.MedRecNotifyEmail as EmailAlertTo,
		tz.BaseUtcOffsetSec,
		st.mapping1,
		DaysInAdvance = coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
		where Temp1.officecode = c.officecode 
				and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
				and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
				and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)),RPAC.DaysInAdvance )

		FROM #temp_RPACriteria t
		inner join tblcase c with (nolock) on  t.officecode = c.officecode and t.casetype = c.casetype and t.servicecode = c.servicecode
		inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
		inner join tbloffice o with (nolock) on o.officecode = c.OfficeCode
		inner join #temp_RPACredentials RPAC with (nolock) on RPAC.ParentCo = t.ParentCo
		inner join tblservices s with (nolock) on s.ServiceCode = c.servicecode
		inner join tblEWServiceType st with (nolock) on st.EWServiceTypeID = s.EWServiceTypeID
		inner join tblEWTimeZone tz with (nolock) on tz.EWTimeZoneID = o.EWTimeZoneID
		left join tblcasetype ct with (nolock) on ct.code = c.casetype
		left join tblEWBusLine lob with (nolock) on lob.EWBusLineID = ct.EWBusLineID
		left join tblclient cl with (nolock) on cl.clientcode = coalesce(c.billclientcode, c.clientcode)
		left join tblcompany co with (nolock) on co.companycode = cl.companycode
		left join tblEWParentCompany pc with (nolock) on pc.ParentCompanyID = co.ParentCompanyID 
	WHERE 
		(convert(varchar,c.apptdate,101) = convert(varchar, getdate() + 
		coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
		where Temp1.officecode = c.officecode 
				and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
				and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
				and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)),RPAC.DaysInAdvance ,101)) and st.EWServiceTypeID in (6,7,9,999) ) 
		and pc.ParentCompanyID = RPAC.ParentCompanyID
		and c.status not in (8,9)
		and (c.RPAMedRecRequestDate is null or convert(varchar,c.RPAMedRecRequestDate,101) <> convert(varchar,getdate(),101)) -- don't submit case more than once per day
		and o.officecode not in (select Temp.officecode  from #temp_RPAOfficesToExclude Temp with (nolock) 
			where Temp.officecode = c.officecode 
				and  (Temp.ParentCo = RPAC.ParentCo or Temp.ParentCo = 'All') 
				and  (Temp.CaseType = c.casetype or Temp.CaseType = -1)
				and  (Temp.ServiceType = s.EWServiceTypeID or Temp.Servicetype = -1))
		 
	) as Tmp

Select 
	SystemKeyVal,
	Keyword,
	Jurisdiction,
	Claim#,
	AltCaseIds,
	ClaimantFirstName,
	ClaimantLastName,
	ExamDate,
	StartDate,
	ReferralID,
	CustomerURL,
	EmailAlertTo

from #Temp_RPACasesToPull
Order by BaseUtcOffsetSec desc, Mapping1 desc

-- Update tblCase with date submitted and status so RPA Tracker is accurate

update c
	set RPAMedRecRequestDate = getdate(),
	    RPAMedRecUploadStatus = 'Processing'
	From tblcase c
	inner join #Temp_RPACasesToPull rpa on rpa.casenbr = c.casenbr

END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
-- Sprint 116
