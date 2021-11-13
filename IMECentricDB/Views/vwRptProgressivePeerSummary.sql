CREATE VIEW vwRptProgressivePeerSummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 C.DoctorSpecialty,
 L.County,

 C.DateReceived,
 C.DateOfInjury,
 C.RptFinalizedDate,
 C.RptSentDate,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS PeerFee,

 PB.BillAmount,
 PB.BillAmountApproved,

 CL.CompanyCode,
 dbo.fnDateValue(C.RptSentDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 LEFT OUTER JOIN
 (SELECT CPB.CaseNbr, SUM(CPB.BillAmount) AS BillAmount, SUM(CPB.BillAmountApproved) AS BillAmountApproved FROM tblCasePeerBill AS CPB GROUP BY CPB.CaseNbr) AS PB ON PB.CaseNbr = C.CaseNbr
 WHERE 1=1
 AND (S.EWServiceTypeID=2 OR S.ServiceCode=520)