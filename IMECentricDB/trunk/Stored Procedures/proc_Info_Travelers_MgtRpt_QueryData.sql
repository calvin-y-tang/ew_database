CREATE PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt_QueryData]
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
	BL.Name as LineOfBusiness,
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
	C.OrigApptTime as OrigAppt,
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
	CONVERT(INT, NULL) ReferralToScheduledBusDays,
	CONVERT(INT, NULL) AS ReferralToMedRecsRecvdCalDays,
	TATScheduledToExam as ScheduledToApptCalDays,
	TATAwaitingSchedulingToRptSent as ApptToReportSentCalDays, 
	CONVERT(DATETIME, NULL) as ReportDateViewed,
    CONVERT(INT, NULL) AS ReferralReportReceviedCalDays
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
