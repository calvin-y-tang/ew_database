
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
PRINT N'Altering [dbo].[proc_Info_Travelers_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt_PatchData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

  print 'update results with exam and other fee amounts'
  UPDATE TI SET 
		TI.ExamCost = LI.FeeDetailExam, 
		TI.OtherCosts = LI.FeeDetailOther
  FROM ##tmp_TravelersInvoices AS TI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		sum(case when tEWFC.Mapping6 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
		sum(case when tEWFC.Mapping6 = 'Other' or tEWFC.Mapping6 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
	 ) LI on TI.HeaderID = LI.HeaderID

	print 'Retrieve the most recent Report Date Viewed from the portal for each case ...'
	UPDATE ti SET ti.ReportDateViewed = docs.DateViewed
	  FROM ##tmp_TravelersInvoices as ti
		INNER JOIN (
		SELECT *
			FROM (SELECT ROW_NUMBER() OVER (PARTITION BY cd.CaseNbr ORDER BY cd.SeqNo DESC) as ROWNUM, cd.CaseNbr, cd.SeqNo, pow.DateViewed
					FROM tblCaseDocuments as cd
						LEFT OUTER JOIN tblPublishOnWeb as pow on cd.SeqNo = pow.TableKey and pow.TableType = 'tblCaseDocuments'
					WHERE (cd.CaseNbr IN (Select pr.CaseNbr FROM ##tmp_TravelersInvoices as pr))
					AND (cd.Type = 'Report') 
					) as tbl
			WHERE tbl.ROWNUM = 1) AS docs ON ti.CaseNbr = docs.CaseNbr	 

	print 'calculate all Turn-Around-Time Values'
	UPDATE ti SET ti.ReferralToScheduledBusDays = [dbo].[fnGetBusinessDays](ti.ReferralDate, ti.ScheduledDate, 1)
	  FROM ##tmp_TravelersInvoices as ti  

	UPDATE ti SET 
				ti.ReferralToMedRecsRecvdCalDays = DATEDIFF(DAY, ti.ReferralDate, ti.MedicalRecordsReceived),
				ti.ScheduledToApptCalDays = DATEDIFF(DAY, ti.ScheduledDate, ti.ApptDate),
				ti.ApptToReportSentCalDays = DATEDIFF(DAY, ti.ApptDate, ti.ReportSent)				
	  FROM ##tmp_TravelersInvoices as ti  
	
	print 'remove scheduled date for NON-IME Services'
	UPDATE ##tmp_TravelersInvoices SET ScheduledDate = NULL WHERE ProductName <> 'IME'	  

    print 'Return results'
    SELECT *
      FROM ##tmp_TravelersInvoices
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
PRINT N'Altering [dbo].[proc_Info_Travelers_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_TravelersInvoices') IS NOT NULL DROP TABLE ##tmp_TravelersInvoices
print 'Gather main data set ...'


DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;

SELECT
    'ExamWorks' as VendorName,
	ah.EWFacilityID,
	ah.HeaderID,
	EWF.DBID as DBID,
	EWF.GPFacility + '-' + CAST(ah.DocumentNbr as varchar(15)) as InvoiceNo,
	ah.DocumentDate as InvoiceDate,
	C.CaseNbr,
	C.ExtCaseNbr,
	CASE WHEN ISNULL(CL.LASTNAME, '') = '' THEN ISNULL(CL.FIRSTNAME, '') ELSE CL.LASTNAME + ', ' + ISNULL(CL.FIRSTNAME, '') END AS ReferralSource,
	CASE BL.EWBusLineID
		WHEN 1 THEN 'Bodily Injury'
		WHEN 2 THEN 'No Fault'
		WHEN 3 THEN 'Workers Compensation'
		WHEN 5 THEN 'Bodily Injury'
		ELSE BL.Name
	END as LineOfBusiness,
	CO.IntName as ClientSite,
	C.ClaimNbr,	
	CASE 
	  WHEN ST.EWServiceTypeID = 1 THEN 'IME'
	  WHEN ST.EWServiceTypeID IN (2,3,4,5,6,8) THEN 'PEER'
	  ELSE ''
	END as ProductName,
	ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) as Specialty,
	ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '') as PhysicianReviewer,
	C.Jurisdiction,
    C.AwaitingScheduling as ReferralDate,
	ISNULL(CA.DateAdded, CA.DateReceived) as ScheduledDate,	
	C.DateMedsRecd as MedicalRecordsReceived,
	CONVERT(DATETIME, NULL) as OrigAppt,
	CONVERT(DATETIME, NULL) AS RescheduledApptDate,
	CA.ApptTime as ApptDate,
	C.RptSentDate as ReportSent,
	CONVERT(MONEY, NULL) AS   ExamCost,
	CONVERT(MONEY, NULL) AS   OtherCosts,
	CASE ST.EWServiceTypeID
		WHEN 8 THEN ST.Name
		ELSE ''
	END AddReExam,
	CASE CA.ApptStatusID
		WHEN 101 THEN 'Yes'
		WHEN 102 THEN 'Yes'
		ELSE 'No'
	END NoShow,
	CASE CA.ApptStatusID
		WHEN 50 THEN 'Yes'
		WHEN 51 THEN 'Yes'
		ELSE 'No'
	END Cancellation,
	CASE 
		WHEN ISNULL(C.RequestedDoc, '') <> '' THEN 'Yes'
		WHEN ISNULL(C.RequestedDoc, '') = '' THEN 'No'
	END DoctorRequested,
	CONVERT(DATETIME, NULL) as ReportDateViewed,
	CONVERT(INT, NULL) ReferralToScheduledBusDays,
	CONVERT(INT, NULL) AS ReferralToMedRecsRecvdCalDays,
	CONVERT(INT, NULL) as ScheduledToApptCalDays,
	CONVERT(INT, NULL) as ApptToReportSentCalDays, 	
    CONVERT(INT, NULL) AS ReferralReportReceviedCalDays,
	ISNULL(e.LastName, '') + ', ' + ISNULL(e.FirstName, '') as ExamineeName,
	c.RptFinalizedDate as ReportFinalizedDate
INTO ##tmp_TravelersInvoices
FROM tblAcctHeader AS AH
	LEFT OUTER JOIN tblCase as C on ah.CaseNbr = C.CaseNbr
	LEFT OUTER JOIN tblEmployer as EM on C.EmployerID = EM.EmployerID
	LEFT OUTER JOIN tblClient as CL on ah.ClientCode = CL.ClientCode
	LEFT OUTER JOIN tblCompany as CO on ah.CompanyCode = CO.CompanyCode
	LEFT OUTER JOIN tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
	LEFT OUTER JOIN tblDoctor as D on ah.DrOpCode = D.DoctorCode
	LEFT OUTER JOIN tblExaminee as E on C.ChartNbr = E.ChartNbr
	LEFT OUTER JOIN tblCaseType as CT on C.CaseType = CT.Code
	LEFT OUTER JOIN tblServices as S on C.ServiceCode = S.ServiceCode
	LEFT OUTER JOIN tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	LEFT OUTER JOIN tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	LEFT OUTER JOIN tblOffice as O on C.OfficeCode = O.OfficeCode
	LEFT OUTER JOIN tblEWFacility as EWF on ah.EWFacilityID = EWF.EWFacilityID
	LEFT OUTER JOIN tblEWFacilityGroupSummary as EFGS on ah.EWFacilityID = EFGS.EWFacilityID
	LEFT OUTER JOIN tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
	LEFT OUTER JOIN tblDocument as DOC on ah.DocumentCode = DOC.Document
	LEFT OUTER JOIN tblUser as M on C.MarketerCode = M.UserID
	LEFT OUTER JOIN tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
	LEFT OUTER JOIN tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
	LEFT OUTER JOIN tblCaseAppt as CA on ISNULL(ah.CaseApptID, C.CaseApptID) = CA.CaseApptID
	LEFT OUTER JOIN tblApptStatus as APS on ISNULL(ah.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	LEFT OUTER JOIN tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
	LEFT OUTER JOIN tblEWFeeZone as FZ on ISNULL(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
	LEFT OUTER JOIN tblLanguage as LANG on C.LanguageID = LANG.LanguageID
	LEFT OUTER JOIN tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
	LEFT OUTER JOIN tblLocation as EL on CA.LocationCode = EL.LocationCode
WHERE (ah.DocumentType='IN')
      AND (ah.DocumentStatus='Final')
	  AND (CO.ParentCompanyID = 52)
      AND (ah.DocumentDate >= @startDate) and (ah.DocumentDate <= @endDate)
      AND (ah.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY EWF.GPFacility, ah.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
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
