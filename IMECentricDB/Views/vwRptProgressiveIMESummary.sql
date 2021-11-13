CREATE VIEW vwRptProgressiveIMESummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,

 ISNULL(EE.LastName, '') + ', ' + ISNULL(EE.FirstName, '') AS ExamineeName,
 ISNULL(CL.LastName, '') +', ' + ISNULL(CL.FirstName, '') AS ClientName,
 C.DoctorSpecialty,
 L.County,

 C.DateReceived,
 C.DateOfInjury,
 C.OrigApptTime,
 C.RptFinalizedDate,
 C.RptSentDate,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS InvoiceAmt,
 IIF(C.NeedFurtherTreatment = 1, 'Positive', 'Negative') AS Result,
 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],
 
 CL.CompanyCode,
 dbo.fnDateValue(C.RptSentDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
 WHERE 1 = 1
 AND S.EWServiceTypeID = 1