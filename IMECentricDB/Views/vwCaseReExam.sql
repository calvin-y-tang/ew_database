CREATE VIEW vwCaseReExam
AS
SELECT  C.CaseNbr ,
        C.DoctorName ,
        C.ApptDate ,
        C.ClaimNbr ,

		C.DoctorCode ,
		C.SchedulerCode ,
		C.OfficeCode ,
		C.MarketerCode ,
		CL.CompanyCode ,
		C.ClientCode ,
		C.DoctorLocation ,
		C.QARep ,
		C.CaseType ,
		C.ServiceCode , 
		C.ExtCaseNbr , 
		
		C.Priority,
		C.MasterSubCase,
		c.PanelNbr,

        EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
        CL.LastName + ', ' + CL.FirstName AS ClientName ,
        COM.IntName AS CompanyName ,
        L.Location ,

        S.ShortDesc AS Service ,
        Q.ShortDesc AS Status ,

		C.ReExam ,
		C.ReExamDate ,
		C.ReExamProcessed,
		CASE WHEN C.ContactClientForReExam IS NULL THEN '' WHEN C.ContactClientForReExam=1 THEN 'Y' ELSE 'N' END AS ContactClientForReExam,
		IIF(C.ReExamNoticePrinted=1, 'Y', 'N') AS ReExamNoticePrinted,
		
		(SELECT COUNT(AC.CaseNbr) FROM tblCase AS AC INNER JOIN tblServices AS S ON AC.ServiceCode=S.ServiceCode
		 WHERE C.MasterCaseNbr=AC.MasterCaseNbr AND C.DoctorSpecialty=AC.DoctorSpecialty AND S.IsReExam=1) AS NbrReExam,

		ISNULL(BillCompany.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
		LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
		LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
WHERE ReExam = 1