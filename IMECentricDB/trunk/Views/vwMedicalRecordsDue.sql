
CREATE VIEW [dbo].[vwMedicalRecordsDue]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.LastName, '') + ', ' + ISNULL(EE.FirstName, '') AS ExamineeName,
	   CASE WHEN ISNULL(DR.LastName,'') <> '' THEN DR.LastName + ', ' + ISNULL(DR.FirstName, '') ELSE '' END AS DoctorName,
	   LO.Location,
       C.DoctorLocation,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
       C.ApptDate,
	   SE.[Description] AS ServiceDesc,
       C.ClientCode,
       C.Status,
       C.DoctorCode,
       CL.CompanyCode,
       C.OfficeCode,
	   C.CaseType,
	   C.ServiceCode,
	   C.ForecastDate,
	   C.ExternalDueDate,
	   C.DrMedRecsDueDate,
	   C.InternalDueDate,
       DATEDIFF(DAY, GETDATE(), C.DrMedRecsDueDate) AS DaysTillDue,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   Q.StatusDesc
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 WHERE C.DrMedRecsDueDate IS NOT NULL
GO
