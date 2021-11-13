
CREATE VIEW [dbo].[vwFileManagerAttachedDocument]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       --ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
	   CASE WHEN ISNULL(DR.LastName,'') <> '' THEN DR.LastName + ', ' + ISNULL(DR.FirstName, '') ELSE '' END AS DoctorName,
       C.ApptDate,
	   C.ApptTime,
	   C.CaseApptID,
	   CD.SeqNo,
	   SE.[Description] AS ServiceDesc,
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
	   C.ServiceCode,
	   CD.Description AS DocDescrip,
	   CD.UserIDAdded,
	   CD.DateAdded AS DateAttached,
	   CD.Source,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   Q.StatusDesc,
	   CDT.Description AS DocType,
	   ST.Name As ServiceTypDesc,
	   SE.EWServiceTypeID
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseDocuments AS CD ON CD.CaseNbr = C.CaseNbr
 INNER JOIN tblCaseDocType AS CDT On CDT.CaseDocTypeID = CD.CaseDocTypeID
 INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
 WHERE CD.Source='FileMgr'
GO



