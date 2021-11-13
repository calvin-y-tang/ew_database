
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
	   C.ExternalDueDate,
	   C.DateMedsRecd,
	   C.DrMedRecsDueDate,
	   C.InternalDueDate,
	   C.DrChartSelect,
	   C.DateDrChart,
	   C.DateEdited,
       C.UserIDEdited,
	   C.LastStatusChg,
       DATEDIFF(DAY, GETDATE(), C.DrMedRecsDueDate) AS DaysTillDue,
       DATEDIFF(day, C.LastStatuschg, GETDATE()) AS IQ ,
       DATEDIFF(DAY, c.DateEdited, GETDATE()) AS DSE ,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   Q.StatusDesc,
	   Q.FunctionCode,
	   ST.Name As ServiceTypDesc,
	   SE.EWServiceTypeID
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
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
GO
