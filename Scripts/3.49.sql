
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
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [DataHandlingForDupSubCase] INT CONSTRAINT [DF_tblOffice_DataHandlingForDupSubCase] DEFAULT ((1)) NOT NULL;


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
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [ShowOpenBlockTimeAppts] BIT CONSTRAINT [DF_tblWebUser_ShowOpenBlockTimeAppts] DEFAULT ((0)) NOT NULL;


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
PRINT N'Creating [dbo].[tblCustomerMapping]...';


GO
CREATE TABLE [dbo].[tblCustomerMapping] (
    [CustomerMappingID] INT           IDENTITY (1, 1) NOT NULL,
    [EntityType]        VARCHAR (2)   NOT NULL,
    [EntityID]          INT           NOT NULL,
    [TableType]         VARCHAR (50)  NOT NULL,
    [TableKey]          INT           NOT NULL,
    [MappingName]       VARCHAR (50)  NOT NULL,
    [MappingValue]      VARCHAR (100) NOT NULL,
    [IsPrimary]         BIT           NOT NULL,
    CONSTRAINT [PK_tblCustomerMapping] PRIMARY KEY CLUSTERED ([CustomerMappingID] ASC)
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
PRINT N'Creating [dbo].[tblCustomerMapping].[IX_tblCustomerMapping_MappingNameTableTypeTableKeyEntityTypeEntityID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCustomerMapping_MappingNameTableTypeTableKeyEntityTypeEntityID]
    ON [dbo].[tblCustomerMapping]([MappingName] ASC, [TableType] ASC, [TableKey] ASC, [EntityType] ASC, [EntityID] ASC);


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
PRINT N'Creating [dbo].[tblCustomerMapping].[IX_tblCustomerMapping_EntityTypeEntityIDTableType]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCustomerMapping_EntityTypeEntityIDTableType]
    ON [dbo].[tblCustomerMapping]([EntityType] ASC, [EntityID] ASC, [TableType] ASC);


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
PRINT N'Creating [dbo].[DF_tblCustomerMapping_IsPrimary]...';


GO
ALTER TABLE [dbo].[tblCustomerMapping]
    ADD CONSTRAINT [DF_tblCustomerMapping_IsPrimary] DEFAULT ((0)) FOR [IsPrimary];


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
PRINT N'Altering [dbo].[vwRptProgressiveReExam]...';


GO
ALTER VIEW vwRptProgressiveReExam
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 CL.EmployeeNumber,
 C.DoctorSpecialty,

 C.DateReceived,
 C.DateOfInjury,
 C.ApptDate,
 C.OrigApptTime AS OrigApptDate,
 LC.ReExamNoticePrintedDate AS DateIMENotice,
 LC.RptFinalizedDate AS OriginalIMERptFinalizedDate, 

 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],
 IIF(C.IsAutoReExam=1, 'Yes', 'No') AS [AutoRe-Exam],

 CL.CompanyCode,
 dbo.fnDateValue(C.ApptDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblCase AS LC ON C.PreviousCaseNbr = LC.CaseNbr
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 WHERE 1=1
 AND S.EWServiceTypeID=1
 AND C.IsReExam=1
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
PRINT N'Creating [dbo].[fnParseKeyValueStringForKey]...';


GO
CREATE FUNCTION [dbo].[fnParseKeyValueStringForKey]
(
	@QueryString AS VARCHAR(MAX),
	@QueryKey AS VARCHAR(100), 
	@pairSeparator CHAR(1),
	@kvSeparator CHAR(1)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @QueryStringPair VARCHAR(MAX)
	DECLARE @Key VARCHAR(100)
	DECLARE @Value VARCHAR(MAX)
	DECLARE @result VARCHAR(MAX)
	
	-- loop across the KeyValue pair string processing each KeyValue pair until we find that one we are looking for
	WHILE LEN(@QueryString) > 0
	BEGIN
		-- extract the Key Value pair
		SET @QueryStringPair = LEFT ( @QueryString, ISNULL(NULLIF(CHARINDEX(@pairSeparator, @QueryString) - 1, -1), LEN(@QueryString)))
		-- is key we are looking for contained in the pair?
		IF CHARINDEX(@QueryKey, @QueryStringPair) > 0
		BEGIN
			-- this is the key we want; extract value from the key value pair and return
			SELECT @result = REPLACE(SUBSTRING( @QueryStringPair, ISNULL(NULLIF(CHARINDEX(@kvSeparator, @QueryStringPair), 0), LEN(@QueryStringPair)) + 1, LEN(@QueryStringPair)), '"', '')
			BREAK
		END
		--  remove keyvalue pair just processed from query string and loop
		SET @QueryString = SUBSTRING( @QueryString, ISNULL(NULLIF(CHARINDEX(@pairSeparator, @QueryString), 0), LEN(@QueryString)) + 1, LEN(@QueryString))
    END

    RETURN @result

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
PRINT N'Creating [dbo].[fnGetParamValue]...';


GO
CREATE FUNCTION [dbo].[fnGetParamValue]
(
	@QueryString AS VARCHAR(MAX),
	@QueryKey AS VARCHAR(100)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	RETURN dbo.fnParseKeyValueStringForKey(@QueryString, @QueryKey, ';', '=')

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
PRINT N'Creating [dbo].[vwRptProgressivePeerBills]...';


GO
CREATE VIEW [dbo].[vwRptProgressivePeerBills]
AS
SELECT
	CPB.CaseNbr,
	C.RptFinalizedDate AS DateSentToClient,
	C.InvoiceAmt,
	CPB.ProviderName,
	CPB.ProviderZip,
	CM.MappingValue AS Region,
	CPB.ServiceDate,
	CPB.ServiceEndDate,
	CPB.ServiceRendered,
	CPB.BillAmount,
	CPB.BillAmountApproved,
	CPB.BillAmountDenied,
	CPB.BillNumber,
	
	CASE
		WHEN dbo.fnGetParamValue(Param, 'ProviderAttorney') = 'Yes' THEN 'Y'
		ELSE 'N'
	END AS ProviderAttorney,  

	CL.CompanyCode,
	-- TODO: Need to verify that this is the correct date to use (it is in turn used to build WHERE CLAUSE)
	dbo.fnDateValue(C.RptFinalizedDate) AS FilterDate

 FROM 
	tblCasePeerBill AS CPB
		 INNER JOIN tblCase AS C ON CPB.CaseNbr = C.CaseNbr
		 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
		 LEFT OUTER JOIN tblCustomerData AS CD ON CD.TableKey = CPB.CaseNbr AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Progressive PeerReview'
		 LEFT OUTER JOIN tblCustomerMapping AS CM ON CM.TableType = 'tblZipCode' AND CAST(CM.TableKey AS VARCHAR) = CPB.ProviderZip AND CM.EntityType='PC' AND CM.EntityID=39
WHERE 
	1=1
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
PRINT N'Creating [dbo].[proc_Info_Progressive_MgtRpt_QueryData]...';

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'proc_Info_Progressive_MgtRpt_QueryData')
DROP PROCEDURE proc_Info_Progressive_MgtRpt_QueryData
GO

GO
CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Executing main query ...';

WITH OtherDetailCTE AS (
  SELECT C.CaseNbr, AD.LongDesc
    FROM tblCase as C
		inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
		inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
		inner join tblProduct as P on P.ProdCode = AD.ProdCode
		inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
		inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
   WHERE ISNULL(EWFC.Mapping5, 'Other') = 'Other'
)
SELECT 
  EWF.DBID,
  EWF.EWFacilityID,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  C.Jurisdiction,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as varchar(15)) as InvoiceNbr,
  convert(datetime, AH.DocumentDate, 101) as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  CO.IntName as Company,
  cast('' as varchar(1)) as Contracted,
  cast('' as varchar(1)) as InNetwork,
  L.City as ExamCity,
  L.State as ExamState,
  BL.Name AS BusinessLine,
  C.ClaimNbr as ClaimNumber,
  C.ClaimNbrExt as "FeatureNumber",
  E.FirstName as ExamineeFirstName,
  E.LastName as ExamineeLastName,
  case 
    when S.ShortDesc = 'EMCR' then 'EMC Peer Review' 
    when S.Description like '%clarification%' then 'Clarification'
    when S.EWServiceTypeID in (2,3,4,5) then 'Peer Review'
    when S.EWServiceTypeID in (8,9) then 'Addendum'
    else ST.Name
  end as ServiceType,
  S.Description as Service,
  case
    when AH.ApptStatusID is null then isnull(CA.SpecialtyCode, C.DoctorSpecialty)
    else AHCA.SpecialtyCode
  end as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  case
    when AH.ApptStatusID is not null then AHAS.Name
    when C.[Status] = 9 then 'Canceled'
    when C.RptSentDate is not null then 'Report Sent'
    when isnull(CA.ApptTime, C.ApptTime) is not null then 'Appt Letter Sent'
    else 'Pending'
  end as [Status],
  case when C.[Status] in (8, 9) then 'Closed' else 'Open' end as OpenClosedStatus,
  case
    when AH.ApptStatusID is null then isnull(CA.DateReceived, C.DateReceived)
    else AHCA.DateReceived
  end as DateReceived,
  case
    when AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
    else convert(datetime, AHCA.ApptTime, 101)
  end as ExamDate,
  case
    when AH.ApptStatusID is null then isnull(C.RptSentDate, AH.Finalized)
    else cast(null as datetime)
  end as RptSentDate,
 C.TATAwaitingScheduling,
 C.TATCalculationGroupID,
 C.TATEnteredToAcknowledged,
 C.TATEnteredToMRRReceived,
 C.TATEnteredToScheduled,
 C.TATExamToClientNotified,
 C.TATExamToRptReceived,
 C.TATQACompleteToRptSent,
 C.TATReport,
 C.TATRptReceivedToQAComplete,
 C.TATRptSentToInvoiced,
 C.TATScheduledToExam,
 C.TATServiceLifeCycle,
 convert(varchar(12), null) as "InjuryToExam",
 convert(varchar(12), null) as "InjuryToReportSent",
 convert(varchar(8), null) as "Hours",
  case S.EWServiceTypeID
    when 2 then C.DateMedsRecd
    when 3 then C.DateMedsRecd
    when 4 then C.DateMedsRecd
    when 5 then C.DateMedsRecd
  end as DateMedsReceived,
  case when C.DefenseAttorneyCode is null and C.PlaintiffAttorneyCode is null then 'No' else 'Yes' end as Attorney,
  case
    when AH.ApptStatusID is null then D.FirstName
    else AHD.FirstName
  end as DoctorFirstName,
  case
    when AH.ApptStatusID is null then D.LastName
    else AHD.LastName
  end as DoctorLastName,
  case 
	when cb.ExtName = 'Attorney' then 'Attorney'
	when (cb.ExtName = 'Examinee' or ca.ApptStatusID = 102) then 'Patient'
	when cb.ExtName = 'Client' then 'Adjuster'
	when cb.ExtName = 'Doctor' then 'Doctor'	
  end as "CanceledBy",
  
  case when AH.DocumentNbr is null then 'No' else 'Yes' end as Invoiced,
  [FeeAmount],
  [No Show],
  [Late Canceled],
  [Interpret],
  [Trans],
  [Diag],
  [BillReview],
  [PeerReview],
  [Addendum],
  [Legal],
  [Processing],
  [Nurse],
  [PhoneConf],
  [MSA],
  [Clinical],
  [Tech],
  [Medicare],
  [OPO],
  [Rehab],
  [AddReview],
  [AdminFee],
  [FacFee],
  [Other],
  stuff((select '; '+LongDesc from OtherDetailCTE
         where OtherDetailCTE.CaseNbr=C.CaseNbr
         for XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as OtherDetail,
  AH.DocumentTotal,
  CL.FirstName as ClientFirstName,
  CL.LastName as ClientLastName,
  Q.StatusDesc as QueueStatus,
  CAS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CONVERT(VARCHAR(4096), NULL) AS SLAExceptions,
  AH.HeaderID,
  CONVERT(DATETIME, NULL) AS "FirstNoShow",
  CONVERT(MONEY, NULL) AS FirstNoShowAmount,
  CONVERT(DATETIME, NULL) AS "SecondNoShow",
  CONVERT(MONEY, NULL) AS SecondNoShowAmount,
  CONVERT(DATETIME, NULL) AS "ThirdNoShow",
  CONVERT(MONEY, NULL) AS ThirdNoShowAmount,
  CONVERT(DATETIME, NULL) AS "ReportRetrievalDate",
 AHCA.DateAdded as ScheduledDate
INTO ##tmpProgessiveMgtRpt
FROM tblCase as C
left outer join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
left outer join
(
  select Pvt.*
  from (
    select
      AD.HeaderID,
      isnull(case when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID in (51,102) then 'Late Canceled'
                  when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID = 101 then 'No Show'
                  else EWFC.Mapping5 end, 'Other') as FeeColumn,
      AD.ExtendedAmount	
    from tblCase as C
    inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
    inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
    inner join tblProduct as P on P.ProdCode = AD.ProdCode
    inner join tblCaseType as CT on C.CaseType = CT.Code
    inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
    inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
    left outer join tblApptStatus as A on A.ApptStatusID = AH.ApptStatusID
  ) as tmp
  pivot
  (
    sum(ExtendedAmount) --aggregrate function that give the value for the columns from FeeColumn
    for FeeColumn in (  --list out the values in FeeColumn that need to be a column
      [FeeAmount],
      [No Show],
      [Late Canceled],
      [Interpret],
      [Trans],
      [Diag],
      [BillReview],
      [PeerReview],
      [Addendum],
      [Legal],
      [Processing],
      [Nurse],
      [PhoneConf],
      [MSA],
      [Clinical],
      [Tech],
      [Medicare],
      [OPO],
      [Rehab],
      [AddReview],
      [AdminFee],
      [FacFee],
      [Other])
  ) as Pvt
) as FT on FT.HeaderID = AH.HeaderID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on C.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode
	left outer join tblCaseAppt as CA on C.CaseApptID = CA.CaseApptID
	left outer join tblApptStatus as CAS on isnull(CA.ApptStatusID, C.ApptStatusID) = CAS.ApptStatusID
	left outer join tblLocation as L on isnull(CA.LocationCode, C.DoctorLocation) = L.LocationCode
	left outer join tblDoctor as D on isnull(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblCaseAppt as AHCA on AH.CaseApptID = AHCA.CaseApptID
	left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
	left outer join tblDoctor as AHD on AHCA.DoctorCode = AHD.DoctorCode
	left outer join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
	left outer join tblEWFacility as EWF on O.EWFacilityID = EWF.EWFacilityID
	left outer join tblEWFacilityGroupSummary as EFGS on O.EWFacilityID = EFGS.EWFacilityID
	left outer join tblQueues as Q on C.Status = Q.StatusCode
	left outer join tblCanceledBy as cb on isnull(ca.CanceledByID, c.CanceledByID) = cb.CanceledByID
WHERE (C.DateAdded >= @startDate and C.DateAdded <= @endDate)
      and (CO.ParentCompanyID = 39)
      and (O.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      and (not (C.[Status] = 9 and AH.HeaderID is null))
      and (not (C.[Status] = 8 and AH.HeaderID is null and D.DoctorCode is null))
      and (not (S.EWServiceTypeID in (6, 999)))
ORDER BY EFGS.BusUnitSeqNo, C.Jurisdiction, S.Description, C.DateAdded, C.CaseNbr,
         CASE
           WHEN AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
           ELSE convert(datetime, AHCA.ApptTime, 101)
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
PRINT N'Creating [dbo].[proc_Info_Progressive_MgtRpt_PatchData]...';

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'proc_Info_Progressive_MgtRpt_PatchData')
DROP PROCEDURE proc_Info_Progressive_MgtRpt_PatchData
GO


GO
ALTER PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_PatchData]
AS

print 'Retrieve the SLA reason'
 UPDATE T SET  
  T.SLAExceptions=(STUFF((SELECT ', ' + RTRIM(StartDate.Descrip) + ' to '+ RTRIM(EndDate.Descrip) + ': ' + CAST(RTRIM(SE.Descrip) + IIF(LEN(CSRD.Explanation) = 0, '', ': ') + RTRIM(ISNULL(CSRD.Explanation,'')) AS VARCHAR(4096))
 FROM tblCaseSLARuleDetail AS CSRD
	 INNER JOIN tblSLAException AS SE ON SE.SLAExceptionID = CSRD.SLAExceptionID
	 INNER JOIN tblSLARuleDetail AS SRD ON SRD.SLARuleDetailID = CSRD.SLARuleDetailID
	 INNER JOIN tblSLARule AS SR ON SR.SLARuleID = SRD.SLARuleID
	 LEFT OUTER JOIN tblTATCalculationMethod AS CalcMeth ON CalcMeth.TATCalculationMethodID = SRD.TATCalculationMethodID
	 LEFT OUTER JOIN tblDataField AS StartDate ON StartDate.DataFieldID = CalcMeth.StartDateFieldID
	 LEFT OUTER JOIN tblDataField AS EndDate ON EndDate.DataFieldID = CalcMeth.EndDateFieldID 
	 LEFT OUTER JOIN tblDataField AS TATDate ON TATDate.DataFieldID = CalcMeth.TATDataFieldID
  WHERE T.CaseNbr = CSRD.CaseNbr
  FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(4096)'),1,2,''))
  FROM ##tmpProgessiveMgtRpt as T


print 'Retrieve the most recent Report Date Viewed from the portal for each case ...'
UPDATE pmr SET pmr.ReportRetrievalDate = docs.DateViewed
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY cd.CaseNbr ORDER BY cd.SeqNo DESC) as ROWNUM, cd.CaseNbr, cd.SeqNo, pow.DateViewed
				FROM tblCaseDocuments as cd
					LEFT OUTER JOIN tblPublishOnWeb as pow on cd.SeqNo = pow.TableKey and pow.TableType = 'tblCaseDocuments'
				WHERE (cd.CaseNbr IN (Select pr.CaseNbr FROM ##tmpProgessiveMgtRpt as pr))
				  AND (cd.Type = 'Report') 
				) as tbl
		WHERE tbl.ROWNUM = 1) AS docs ON pmr.CaseNbr = docs.CaseNbr

print 'Get first no show appt date and time'
UPDATE pmr SET pmr.FirstNoShow = apt.ApptTime, pmr.FirstNoShowAmount = apt.TotalBilled
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
		SELECT SUM(ah.DocumentTotalUS) as TotalBilled, ah.CaseApptID, ApptTime, CaseNbr
				FROM (SELECT ROW_NUMBER() OVER (PARTITION BY ca.CaseNbr ORDER BY ca.CaseApptID ASC) as ROWNUM, ca.ApptTime, ca.CaseApptID
						FROM tblCaseAppt as ca				
						WHERE ca.CaseNbr IN (select CaseNbr from ##tmpProgessiveMgtRpt) and (ca.ApptStatusID = 101)
						) as tbl
				  LEFT OUTER JOIN tblAcctHeader as AH on tbl.CaseApptID = ah.CaseApptID AND AH.DocumentType = 'IN'
				WHERE tbl.ROWNUM = 1
		GROUP BY ah.CaseApptID, ApptTime, CaseNbr) AS apt ON pmr.CaseNbr = apt.CaseNbr


print 'Get second no show appt date and time'
UPDATE pmr SET pmr.SecondNoShow = apt.ApptTime, pmr.SecondNoShowAmount = apt.TotalBilled
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
		SELECT SUM(ah.DocumentTotalUS) as TotalBilled, ah.CaseApptID, ApptTime, CaseNbr
				FROM (SELECT ROW_NUMBER() OVER (PARTITION BY ca.CaseNbr ORDER BY ca.CaseApptID ASC) as ROWNUM, ca.ApptTime, ca.CaseApptID
						FROM tblCaseAppt as ca				
						WHERE ca.CaseNbr IN (select CaseNbr from ##tmpProgessiveMgtRpt) and (ca.ApptStatusID = 101)
						) as tbl
				  LEFT OUTER JOIN tblAcctHeader as AH on tbl.CaseApptID = ah.CaseApptID AND AH.DocumentType = 'IN'
				WHERE tbl.ROWNUM = 2
		GROUP BY ah.CaseApptID, ApptTime, CaseNbr) AS apt ON pmr.CaseNbr = apt.CaseNbr

print 'Get third no show appt date and time'
UPDATE pmr SET pmr.ThirdNoShow = apt.ApptTime, pmr.ThirdNoShowAmount = apt.TotalBilled
    FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
		SELECT SUM(ah.DocumentTotalUS) as TotalBilled, ah.CaseApptID, ApptTime, CaseNbr
				FROM (SELECT ROW_NUMBER() OVER (PARTITION BY ca.CaseNbr ORDER BY ca.CaseApptID ASC) as ROWNUM, ca.ApptTime, ca.CaseApptID
						FROM tblCaseAppt as ca				
						WHERE ca.CaseNbr IN (select CaseNbr from ##tmpProgessiveMgtRpt) and (ca.ApptStatusID = 101)
						) as tbl
				  LEFT OUTER JOIN tblAcctHeader as AH on tbl.CaseApptID = ah.CaseApptID AND AH.DocumentType = 'IN'
				WHERE tbl.ROWNUM = 3
		GROUP BY ah.CaseApptID, ApptTime, CaseNbr) AS apt ON pmr.CaseNbr = apt.CaseNbr


print 'Return final result set'
SELECT *
  FROM ##tmpProgessiveMgtRpt 

print 'clean up'
IF OBJECT_ID('tempdb..##tmpProgessiveMgtRpt') IS NOT NULL DROP TABLE ##tmpProgessiveMgtRpt
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
PRINT N'Creating [dbo].[proc_CreateCustomerFeeSchedule]...';


GO
CREATE PROCEDURE [dbo].[proc_CreateCustomerFeeSchedule]
	@FeeSchedName VARCHAR(30),
	@EntityType VARCHAR(2),
	@EntityID INT, 
	@StartDate DATETIME, 
	@EndDate DATETIME
AS
BEGIN
	
	DECLARE @CustomerFeeHeaderID INT
	
	INSERT INTO tblCustomerFeeHeader (Name, EntityType, EntityID, StartDate, EndDate, UserIDAdded, DateAdded)
	VALUES (@FeeSchedName, @EntityType, @EntityID, @StartDate, @EndDate, '', GETDATE())
	SET @CustomerFeeHeaderID = @@IDENTITY
	PRINT @CustomerFeeHeaderID 
	
	IF @CustomerFeeHeaderID IS NOT NULL AND @CustomerFeeHeaderID > 0
	BEGIN 
		INSERT INTO tblCustomerFeeDetail (CustomerFeeHeaderID, UserIDAdded, DateAdded, ProdCode, EWBusLineID, EWFeeZoneID, EWSpecialtyID, FeeUnit, FeeAmt, LateCancelAmt, CancelDays, NoShowAmt)
			SELECT @CustomerFeeHeaderID, 'Admin', GETDATE(), ProdCode, EWBusLineID, EWFeeZoneID, EWSpecialtyID, FeeUnit, FeeAmt, LateCancelAmt, CancelDays, NoShowAmt
			  FROM [dev3\EW_IME_CENTRIC].[IMECentricMaster].[dbo].[tmpImportCustomerFeeSchedule]
			 WHERE FeeScheduleName = @FeeSchedName
	END
	
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
