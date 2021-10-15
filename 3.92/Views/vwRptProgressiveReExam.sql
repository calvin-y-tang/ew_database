CREATE VIEW vwRptProgressiveReExam
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
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