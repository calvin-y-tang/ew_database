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

/* This stored procedure will generate a list of cases to pull medical record from client web sites for the RPA process.  

The SP then updates tblCase.RPAMedRecRequestDate with the date submitted and tblCase.RPAMedRecUploadStatus to 'Processing'
*/

-- 11/6/23  Doug L added Office (GPFacility) to output 
-- 11/16/23 Doug L added previouscasedownloaddate to change start date if records were downloaded on an associated case
-- 11/20/23 Doug L Changed logic for MRR to only find cases that are in awaiting medical records and not in awaiting scheduling

declare @DayOffset as int;
set @DayOffset = 1 -- Allows us to run for days in advance of normal for testing

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

--select * from #Temp_RPACredentials
--load the #temp_RPACriteria table from tblcodes.  This table will include all the Parent Co, office, casetype, and service specific criteria for including cases

select 
	(select [dbo].[fnGetParamValue](c.value, 'ParentCompanyID=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCompanyID,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceCode
into #temp_RPACriteria
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUpload'

--select * from #temp_RPACriteria
--load the #temp_RPAOfficesToExclude table from tblcodes.  This table will include all the Keyword, office, casetype, and service types to exclude from list

select 
	(select [dbo].[fnGetParamValue](c.value, 'ParentCo=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCo,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceType

into #temp_RPAOfficesToExclude
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUploadExclude'

--select * from #temp_RPAOfficesToExclude
--load the #temp_RPAOverride table from tblcodes.  This table will include all the Keyword, office, casetype, and service types where we want to use a different days in advance than tblconfiguration

select 
	(select [dbo].[fnGetParamValue](c.value, 'ParentCo=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID ) as ParentCo,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'OfficeCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as OfficeCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'CaseType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as CaseType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceType=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceType,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'ServiceCode=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as ServiceCode,
	convert(integer,(select [dbo].[fnGetParamValue](c.value, 'DaysInAdvance=') FROM tblCodes c with (nolock) where cd.CodeID = c.CodeID )) as DaysInAdvance
into #temp_RPAOverride
from tblcodes cd where category = 'RPA' and SubCategory = 'MedRecUploadOverride'

SELECT * into #Temp_RPACasesToPull from (
	SELECT 
--		o.description as Office,
		c.casenbr,
		s.description as Service,
		(select convert(varchar,DBID) from tblControl) + '-' + convert(varchar,c.casenbr) as SystemKeyVal,  
		case	when cl.companycode = 77443 then 'GBSTRADIX' --GBCARE
				else RPAC.FilenameKeyword
				end as Keyword,
		c.jurisdiction as Jurisdiction,
		c.claimnbr as Claim#,
		c.addlclaimnbrs as AltCaseIds,
		e.firstname  as ClaimantFirstName,
		e.lastname as ClaimantLastName,
		c.mastercasenbr,
		isnull(convert(varchar, c.apptdate, 101),'') as ExamDate,
		isnull((select top 1 convert(varchar,cd.dateadded,101) from tblcasedocuments cd with (nolock) 
				 where cd.casenbr = c.casenbr and cd.CaseDocTypeID in (7,8,9,10,11) -- all types of medical records
				 and cd.sfilename like  + '%' + case when cl.companycode = 77443 then 'GBSTRADIX' else RPAC.FilenameKeyword  end + '%' 
				 order by cd.dateadded desc),'01/01/1900') as CurrentCaseLastDownload,
		-- Get the last download date from the previous master case
		case when s.description = 'Re-Evaluation' then (select top 1 convert(varchar,cd.dateadded,101) from tblcase c1 with (nolock) 
															inner join tblcasedocuments cd with (nolock) on cd.casenbr = c1.casenbr
															 where cd.CaseDocTypeID in (7,8,9,10,11) -- all types of medical records
															 and cd.sfilename like + '%' + case when cl.companycode = 77443 then 'GBSTRADIX' else RPAC.FilenameKeyword  end + '%' 
															 and c1.mastercasenbr = c.mastercasenbr
															 order by cd.dateadded desc)
		else ''
		end
		as PreviousCaseLastDownload,
		case when RPAC.ParentCo = 'ESIS' then '' --	ESIS does not have a referral ID in IMEC
			 when RPAC.ParentCo = 'Hartford' then '' --	Hartford does not have a referral ID in IMEC
			 when RPAC.ParentCo = 'Liberty' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') --	Get from Liberty Tab
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual')
			 when RPAC.ParentCo = 'Travelers' then (select top 1 [dbo].[fnGetParamValue](CD.Param, 'TimeTrakReferralNbr=') --	Get from TimeTrak Tab
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Travelers')
			 when RPAC.parentCo = 'Eclaim' then '' -- not required for eClaim
			 when RPAC.parentCo = 'GB Riskfax' then '' -- not required for GB
			 else ''end as ReferralID,
		case when RPAC.ParentCo = 'Liberty' then RPAC.URL + (select top 1 [dbo].[fnGetParamValue](CD.Param, 'ReferralNumber=') + '&vo=1' 
												FROM tblCustomerData as CD with (nolock) where c.Casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CD.CustomerName = 'Liberty Mutual') 
			 when cl.companycode = 77443 then 'https://www.stradix.net/CaseManagement/OpenReferrals' --GBCare
			 else RPAC.URL end as CustomerURL,
		o.MedRecNotifyEmail as EmailAlertTo,
		tz.BaseUtcOffsetSec,
		st.mapping1,
		DaysInAdvance = coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
		where Temp1.officecode = c.officecode 
				and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
				and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
				and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)
				and  (Temp1.ServiceCode = s.ServiceCode or Temp1.ServiceCode = -1)),RPAC.DaysInAdvance ),
		SelectDate = (convert(datetime,(getdate()-- +  @dayoffset 
			+ coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
			where Temp1.officecode = c.officecode 
					and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
					and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
					and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)
					and  (Temp1.ServiceCode = s.ServiceCode or Temp1.ServiceCode = -1)),RPAC.DaysInAdvance )))),
		Office = fc.GPFacility
		FROM tblcase c with (nolock) 
		inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
		inner join tbloffice o with (nolock) on o.officecode = c.OfficeCode
		inner join tblservices s with (nolock) on s.ServiceCode = c.servicecode
		inner join tblEWServiceType st with (nolock) on st.EWServiceTypeID = s.EWServiceTypeID
		inner join tblEWTimeZone tz with (nolock) on tz.EWTimeZoneID = o.EWTimeZoneID
		inner join tblewfacility fc with (nolock) on o.EWFacilityID = fc.EWFacilityID
		inner join tblqueues q with (nolock) on q.statuscode = c.status
		left join tblcasetype ct with (nolock) on ct.code = c.casetype
		left join tblEWBusLine lob with (nolock) on lob.EWBusLineID = ct.EWBusLineID
		left join tblclient cl with (nolock) on cl.clientcode = coalesce(c.billclientcode, c.clientcode)
		left join tblcompany co with (nolock) on co.companycode = cl.companycode
		left join tblEWParentCompany pc with (nolock) on pc.ParentCompanyID = co.ParentCompanyID 
		inner join #temp_RPACriteria t on  t.parentcompanyid = co.ParentCompanyID and t.officecode = c.officecode and t.casetype = c.casetype and t.servicecode = c.servicecode -- only include records allowed by temp table
		inner join #temp_RPACredentials RPAC with (nolock) on RPAC.ParentCompanyID = co.ParentCompanyID
		WHERE 
			--Include Record Reviews that are not scheduled and in awaiting scheduling
--			((st.Mapping1 = 'MRR' and c.apptdate is null and c.status = 3) -- record reviews that aren't scheduled yet in awaiting scheduling
			((st.Mapping1 = 'MRR' and q.statusdesc = 'Awaiting Medical Records') -- record reviews that are in awaiting medical records
			or
			--Include IMEs that have an an appt date up to the daysinadvance but also greater than today
			(convert(datetime,(getdate() + 
			coalesce((select DaysInAdvance from #temp_RPAOverride Temp1
			where Temp1.officecode = c.officecode 
					and  (Temp1.ParentCo = RPAC.ParentCo or Temp1.ParentCo = 'All') 
					and  (Temp1.CaseType = c.casetype or Temp1.CaseType = -1)
					and  (Temp1.ServiceType = s.EWServiceTypeID or Temp1.Servicetype = -1)
					and  (Temp1.ServiceCode = s.servicecode or Temp1.ServiceCode = -1)),RPAC.DaysInAdvance)--+@DayOffset					
					))  > c.ApptTime and convert(date, c.ApptTime) > convert(date, getdate() + @DayOffset) --and st.EWServiceTypeID in (6,7,9,999) ) 
			and st.Mapping1 <> 'MRR')
			and q.statusdesc = 'Awaiting Medical Records') -- only pickup cases in Awaiting Medical Records Queue

			and pc.ParentCompanyID = RPAC.ParentCompanyID
			and c.status not in (8,9) --no cancelled or completed cases
			and (c.RPAMedRecRequestDate is null or convert(varchar,c.RPAMedRecRequestDate,101) <> convert(varchar,getdate(),101)) -- don't submit case more than once per day
			and o.officecode not in (select Temp.officecode  from #temp_RPAOfficesToExclude Temp with (nolock) 
				where Temp.officecode = c.officecode 
					and  (Temp.ParentCo = RPAC.ParentCo or Temp.ParentCo = 'All') 
					and  (Temp.CaseType = c.casetype or Temp.CaseType = -1)
					and  (Temp.ServiceType = s.EWServiceTypeID or Temp.Servicetype = -1))
		
	) as Tmp

	-- remove the unwanted records from the temp table before we return the final result and update 
	DELETE FROM #Temp_RPACasesToPull WHERE ((keyword = 'ICASE') and (ISNULL(TRIM(ReferralID), '') = ''))

	SELECT
		SystemKeyVal,
		Keyword,
		Jurisdiction,
		Claim#,
		AltCaseIds,
		ClaimantFirstName,
		ClaimantLastName,
		ExamDate,
		Case when CurrentCaseLastDownload <> '01/01/1900' then CurrentCaseLastDownload
			 when mastercasenbr is not null and service = 'Re-Evaluation' and PreviousCaseLastDownload is not null then PreviousCaseLastDownload
	--		 when mastercasenbr is not null and service = 'Re-Evaluation' and  PreviousCaseApptDate is not null then PreviousCaseApptDate
		else '01/01/1900'
		end as StartDate,
		isnull(ReferralID,'') as ReferralID,
		CustomerURL,
		EmailAlertTo,
		Office
		--,mapping1
		--,DaysInAdvance
		--,SelectDate
		--,Service
	from #Temp_RPACasesToPull	
	Order by BaseUtcOffsetSec desc, Mapping1 desc	

	-- update records
	UPDATE c
		set RPAMedRecRequestDate = getdate(),
			RPAMedRecUploadStatus = 'Processing'
		From tblcase c
		inner join #Temp_RPACasesToPull rpa on rpa.casenbr = c.casenbr

END
GO