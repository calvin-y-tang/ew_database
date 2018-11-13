CREATE VIEW [dbo].[vwNotaryApproval]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       C.ApptDate,
	   SE.[Description] AS ServiceDesc,
       DATEDIFF(DAY, C.NotaryRequiredCheckedDate, GETDATE()) AS DaysInQueue, -- IQ  days in queue
       C.DoctorLocation,
	   LO.Location,
       C.ClientCode,
       C.Status,
       C.DoctorCode,
       CL.CompanyCode,
       C.OfficeCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
	   C.CaseType,
	   C.ServiceCode ,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   C.NotaryRequired,
	   CASE WHEN C.NotarySent = 1 THEN 'Y' ELSE 'N' END AS NotarySent,
	   C.NotaryRequiredCheckedDate
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 WHERE C.NotaryRequired = 1
