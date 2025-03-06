

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
PRINT N'Creating [dbo].[tblLog]...';


GO
CREATE TABLE [dbo].[tblLog] (
    [LogID]        INT            IDENTITY (1, 1) NOT NULL,
    [LogDateTime]  DATETIME       NOT NULL,
    [Severity]     INT            NOT NULL,
    [ModuleName]   VARCHAR (50)   NOT NULL,
    [Message]      VARCHAR (1024) NULL,
    [ErrorMessage] VARCHAR (2048) NULL,
    [StackTrace]   VARCHAR (MAX)  NULL,
    [UserID]       VARCHAR (20)   NULL,
    CONSTRAINT [PK_tblLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);


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
PRINT N'Creating [dbo].[tblLog].[IX_tblLogID_ModuleName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblLogID_ModuleName]
    ON [dbo].[tblLog]([ModuleName] ASC);


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
PRINT N'Creating [dbo].[tblLog].[IX_tblLogID_LogDateTime]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblLogID_LogDateTime]
    ON [dbo].[tblLog]([LogDateTime] ASC);


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
PRINT N'Altering [dbo].[tblLocation_AfterUpdate_TRG]...';


GO
ALTER TRIGGER tblLocation_AfterUpdate_TRG 
  ON tblLocation
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LocationCode INT
	SELECT @LocationCode=Inserted.LocationCode FROM Inserted

	-- Update GeoData
	IF UPDATE(Zip)
		BEGIN
			UPDATE tblLocation SET GeoData=
			(SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
			FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
			FROM Inserted
			WHERE tblLocation.LocationCode = @LocationCode
		END

     -- delete this facility from tblTaxAddress if an address field has changed - Addr1, Addr2, City, State, Zip
	DELETE FROM tblTaxAddress 
	WHERE TableType = 'LC' AND TableKey IN 
	(SELECT inserted.LocationCode
	   FROM  inserted
	   INNER JOIN deleted
	   ON inserted.LocationCode = deleted.LocationCode
	   WHERE ISNULL(deleted.Addr1, '') <> ISNULL(inserted.Addr1, '')
	   OR ISNULL(deleted.Addr2, '') <> ISNULL(inserted.Addr2, '')
	   OR ISNULL(deleted.City, '') <> ISNULL(inserted.City, '')
	   OR ISNULL(deleted.State, '') <> ISNULL(inserted.State, '')
	   OR ISNULL(deleted.Zip, '') <> ISNULL(inserted.Zip, '')
	)

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
PRINT N'Creating [dbo].[tblDoctor_AfterUpdate_TRG]...';


GO

CREATE TRIGGER [dbo].[tblDoctor_AfterUpdate_TRG]
    ON [dbo].[tblDoctor]
AFTER UPDATE
AS
BEGIN
    
    SET NOCOUNT ON

    DELETE 
    FROM tblTaxAddress 
    WHERE TableType = 'DR' 
      AND TableKey IN (SELECT DISTINCT ins.DoctorCode 
                        FROM inserted AS ins
                                  INNER JOIN deleted as del ON del.DoctorCode = ins.DoctorCode
                       WHERE ISNULL(ins.Addr1, '') <> ISNULL(del.Addr1, '')
                          OR ISNULL(ins.Addr2, '') <> ISNULL(del.Addr2, '') 
                          OR ISNULL(ins.City, '') <> ISNULL(del.City, '')
                          OR ISNULL(ins.State, '') <> ISNULL(del.State, '') 
                          OR ISNULL(ins.Zip, '') <> ISNULL(del.Zip, ''))

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
PRINT N'Creating [dbo].[tblEWFacility_AfterUpdate_TRG]...';


GO

CREATE TRIGGER [dbo].[tblEWFacility_AfterUpdate_TRG]
	ON [dbo].[tblEWFacility] 
AFTER UPDATE
AS 

BEGIN
     -- DEV NOTE: if an address field has changed - Address, City, State, Zip
	 -- delete this facility from tblTaxAddress
SET NOCOUNT ON

DELETE FROM tblTaxAddress 
WHERE TableType = 'OF' AND TableKey IN 
(SELECT DISTINCT inserted.EWFacilityID
   FROM  inserted
   INNER JOIN deleted
   ON inserted.EWFacilityID = deleted.EWFacilityID
   WHERE ISNULL(deleted.Address, '') <> ISNULL(inserted.Address, '') 
   OR ISNULL(deleted.City, '') <> ISNULL(inserted.City, '') 
   OR ISNULL(deleted.State, '') <> ISNULL(inserted.State, '') 
   OR ISNULL(deleted.Zip, '') <> ISNULL(inserted.Zip, '')
)

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

/* Removing because I think it is still being tested in IMECentricEW */
/*
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
AS

--
-- Hartford Data patching 
--

set nocount on 

Print 'Fixing up Company Names'

-- fix up the Company Names 
UPDATE hi SET hi.IntName = isnull(hm.NewOfficeName, hi.IntName), hi.LitOrAppeal = IIF(hm.IsLawOffice = 1, 'Litigation', 'NA')
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordOfficeMap as hm on hi.IntName = hm.CurrentOfficeName

Print 'Fixing up Specialties and Sub-Specialties'
-- fix up the specialities
UPDATE hi SET hi.Specialty = isnull(sm.NewSpecialtyName, hi.Specialty)
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordSpecialtyMap as sm on hi.Specialty = sm.CurrentSpecialtyName

-- fix up the sub-specialities
UPDATE hi SET hi.SubSpecialty = isnull(ssm.NewSpecialtyName, hi.SubSpecialty)
	from ##tmp_HartfordInvoices as hi
 	left outer join ##tmp_HartfordSubSpecialtyMap as ssm on hi.SubSpecialty = ssm.CurrentSpecialtyName
	
Print 'Fixing up Service Types'
UPDATE hi SET hi.ServiceType = CASE 
								WHEN hi.ServiceTypeID = 1 THEN 'IME'
								WHEN hi.ServiceTypeID = 2 THEN 'MRR'
								WHEN hi.ServiceTypeID = 3 THEN 'MRR'
								WHEN hi.ServiceTypeID = 4 THEN 'MRR'
								WHEN hi.ServiceTypeID = 5 THEN 'MRR'
								WHEN hi.ServiceTypeID = 6 THEN 'MRR'
								WHEN hi.ServiceTypeID = 7 THEN 'Other'
								WHEN hi.ServiceTypeID = 8 THEN 'Addendum - IME'
								WHEN hi.ServiceTypeID = 9 THEN 'Other'
								ELSE 'Other'
							  END
FROM ##tmp_HartfordInvoices as hi

Print 'Check for FCE services via Sub-Speciality'
UPDATE hi SET hi.ServiceType = CASE
								WHEN hi.SubSpecialty like '%FCE%' THEN 'FCE'
								ELSE hi.ServiceType
							   END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Line of Business'
UPDATE hi SET hi.LOB = CASE hi.LOB
						WHEN '1' THEN 'Liability'
						WHEN '2' THEN 'Auto'
						WHEN '3' THEN 'Work Comp'
						WHEN '4' THEN 'Group Benefits'
						WHEN '5' THEN 'Auto'
						ELSE 'Work Comp'
                       END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Coverage Types'
UPDATE hi SET hi.CoverageType = CASE 
									WHEN hi.CoverageType = 'Workers Comp' THEN 'Work Comp'
									WHEN hi.CoverageType like 'First Party Auto' THEN 'AMC'
									WHEN hi.CoverageType like 'Third Party Auto' THEN 'Auto Lit'
									WHEN hi.CoverageType = 'Liability' THEN 'Liability'
									WHEN hi.CoverageType = 'Disability' THEN 'LTD'									
									WHEN hi.CoverageType = 'Other' AND hi.ServiceTypeID = 3 THEN 'ABI'
									ELSE 'Other'
								END
from ##tmp_HartfordInvoices as hi

Print 'Fixing up Network and Juris TAT'
UPDATE hi SET hi.InOutNetwork = CASE 
									WHEN hi.InOutNetwork = '1' THEN 'Out'
									WHEN hi.InOutNetwork = '2' THEN 'In'
									ELSE ''
								END,
		      hi.JurisTAT = CASE 
								WHEN hi.ServiceVariance > 0 THEN 'No'
								ELSE 'Yes'				
		                    END			  
FROM ##tmp_HartfordInvoices as hi

Print 'Set Service Variance to NULL (per the spec)'
UPDATE hi SET ServiceVariance = NULL 
  FROM ##tmp_HartfordInvoices as hi
  
Print 'Getting Exception Data'
UPDATE hi SET hi.PrimaryException = CASE 
									WHEN (SRD.DisplayOrder = 1 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
									ELSE ''
								 END,
			  hi.SecondaryException = CASE
									WHEN (SRD.DisplayOrder = 2 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
								    ELSE ''
								 END,
			  Comments = ISNULL(Comments, '') + ISNULL(SE.Descrip + ' ', '')

FROM ##tmp_HartfordInvoices as hi
	LEFT OUTER JOIN tblSLARule as SR on hi.SLARuleID = SR.SLARuleID
	LEFT OUTER JOIN tblSLARuleDetail as SRD on SR.SLARuleID = SRD.SLARuleID
	LEFT OUTER JOIN tblCaseSLARuleDetail as CSRD ON (hi.CaseNbr = CSRD.CaseNbr AND SRD.SLARuleDetailID = CSRD.SLARuleDetailID)
	LEFT OUTER JOIN tblSLAException as SE ON CSRD.SLAExceptionID = SE.SLAExceptionID
	

Print 'Update Primary and Secondary Exceptions'
UPDATE hi SET PrimaryDriver = CASE 
									WHEN hi.PrimaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.PrimaryException = 'CL' THEN 'Provider'
									WHEN hi.PrimaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.PrimaryException = 'NS' THEN 'Claimant'
									WHEN hi.PrimaryException = 'SA' THEN 'Provider'
									WHEN hi.PrimaryException = 'SR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'AR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'C' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'NA' THEN 'NA'
                                 END,
				SecondaryDriver = CASE 
									WHEN hi.SecondaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.SecondaryException = 'CL' THEN 'Provider'
									WHEN hi.SecondaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.SecondaryException = 'NS' THEN 'Claimant'
									WHEN hi.SecondaryException = 'SA' THEN 'Provider'
									WHEN hi.SecondaryException = 'SR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'AR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'C' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'NA' THEN 'NA'
                                 END
FROM ##tmp_HartfordInvoices as hi

-- return file result set
select * 
	from ##tmp_HartfordInvoices

set nocount off
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
*/


/* Removing because I think it is still being tested in IMECentricEW */
/*
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
	'ExamWorks' as Vendor,
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(14), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	ISNULL(AH.ServiceState, C.Jurisdiction) as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",	
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ISNULL(ca.datereceived, c.DateReceived) as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(8)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments,
	c.DoctorReason 
INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

print 'Data retrieved'
set nocount off
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
*/


/* Already Deployed */
/*
PRINT N'Altering [dbo].[spGetAllBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetAllBusinessRules
(
	@eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON


	SELECT distinct * INTO #tmp_GetAllBusinessRules
	FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder,
	 tmpBR.Skip
	FROM
	(
		SELECT 1 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
			LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
		WHERE 1=1
			AND (BRC.BillingEntity IN (0,2))
			AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

		UNION

		SELECT 2 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
			LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
		WHERE 1=1
			AND (BRC.BillingEntity IN (1,2))
			AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

		UNION

		SELECT 3 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
		WHERE 1=1
			AND (BRC.EntityType='SW')
	) AS tmpBR
		INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
		LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
		LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
	WHERE BR.IsActive=1
		and BR.EventID=@eventID
		AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
		AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
		AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
		AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	DELETE FROM #tmp_GetAllBusinessRules WHERE Skip = 1

	SELECT * FROM #tmp_GetAllBusinessRules


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
*/

/* Already Deployed */
/*
PRINT N'Altering [dbo].[spGetBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetBusinessRules
(
	@eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON


	DECLARE @groupDigits INT

	SET @groupDigits = 10000000

	SELECT * INTO #tmp_GetBusinessRules
	FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,
	 ROW_NUMBER() OVER (PARTITION BY BR.BusinessRuleID ORDER BY tmpBR.GroupID*@groupDigits+(CASE tmpBR.EntityType WHEN 'SW' THEN 4 WHEN 'PC' THEN 3 WHEN 'CO' THEN 2 WHEN 'CL' THEN 1 ELSE 9 END)*1000000+tmpBR.ProcessOrder) AS RowNbr,
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder,
	 tmpBR.Skip
	FROM
	(
	SELECT 1 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (0,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 2 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (1,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 3 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	WHERE 1=1
	AND (BRC.EntityType='SW')
	) AS tmpBR
	INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
	LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
	LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
	WHERE BR.IsActive=1
	and BR.EventID=@eventID
	AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
	AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
	AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
	AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR
	WHERE sortedBR.RowNbr=1
	ORDER BY sortedBR.BusinessRuleID

	DELETE FROM #tmp_GetBusinessRules WHERE Skip = 1

	SELECT * FROM #tmp_GetBusinessRules

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
*/


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

/* To be done in the first of the year. */
/* Removing these for now               */
/*
-- Issue 12326 - to set TaxHandling to "non-default" value (enables processing for TX Sales Tax Lookup)
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (155, 'SetInvoiceTaxHandling', 'Accounting', 'Return Tax State to set desired taxHandling', 1, 1801, 0, 'TaxHandling', 'TaxState', NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL)
GO

*/


-- Issue 12443 - new token for In/Out of Network
INSERT INTO tblMessageToken ([Name]) VALUES ('@QuoteNetworkYN@')
GO
