CREATE VIEW vwRptProgressiveClosedCaseSummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,
 
 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, PA.Company, '') AS AttorneyCompany,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, RTRIM(LTRIM(ISNULL(PA.FirstName,'') + ' ' + ISNULL(PA.LastName,''))), '') AS AttorneyName,
 ISNULL(C.DoctorName, (ISNULL(D.FirstName,'') + ' ' + ISNULL(D.MiddleInitial,'') + ' ' + ISNULL(D.LastName,''))) AS DoctorName,
 C.DoctorSpecialty,
 L.County,
 L.State,

 C.DateReceived,
 C.DateOfInjury,
 C.OrigApptTime,
 C.DateCanceled,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS InvoiceAmt,
 IIF(C.NeedFurtherTreatment=1,'Positive','Negative') AS Result,
 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],

 A.ApptCount, A.ExamineeCanceled, A.ClientCanceled, A.NoShow,

 CL.CompanyCode,
 dbo.fnDateValue(C.DateCanceled) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 LEFT OUTER JOIN tblCCAddress AS PA ON C.PlaintiffAttorneyCode = PA.ccCode
 LEFT OUTER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 LEFT OUTER JOIN 
  (SELECT * FROM (SELECT CaseApptID, CaseNbr, DoctorCode,
   RANK() OVER(PARTITION BY CaseNbr ORDER BY CaseApptID DESC) AS MaxCaseApptID
  FROM tblCaseAppt) AS CA3 WHERE CA3.MaxCaseApptID = 1)
  AS CA2 ON C.CaseNbr = CA2.CaseNbr
 LEFT OUTER JOIN tblDoctor AS D ON CA2.DoctorCode = D.DoctorCode
 LEFT OUTER JOIN
 (SELECT CA.CaseNbr,
  COUNT(CA.CaseApptID) AS ApptCount,
  SUM(IIF(CA.ApptStatusID IN (50,51) AND CA.CanceledByID IN (3,5), 1, 0)) AS ExamineeCanceled,
  SUM(IIF(CA.ApptStatusID IN (50,51) AND CA.CanceledByID IN (2), 1, 0)) AS ClientCanceled,
  SUM(IIF(CA.ApptStatusID IN (101), 1, 0)) AS NoShow
  FROM tblCaseAppt AS CA
  GROUP BY CA.CaseNbr
 ) AS A ON A.CaseNbr = C.CaseNbr
 WHERE 1=1
 AND S.EWServiceTypeID=1