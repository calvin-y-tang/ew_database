CREATE VIEW [dbo].[vwQuoteApproval]
AS
SELECT AQ.AcctQuoteID,
       AQ.CaseNbr,
       AQ.QuoteType,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(CL.FirstName, '') + ' ' + ISNULL(CL.LastName, '') AS ClientName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       CT.ShortDesc AS CaseTypeDesc,
       S.ShortDesc AS ServiceDesc,
       C.ApptDate,
       QS.Description AS QuoteStatus,
       DATEDIFF(DAY, AQ.QuoteDate, GETDATE()) AS DaysOutstanding,
       QS.IsClosed,
       C.DoctorLocation,
       C.ClientCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
       C.Status,
       C.DoctorCode,
       C.DateAdded,
       CL.CompanyCode,
       C.OfficeCode,
       C.CaseType,
       C.ServiceCode,
       ISNULL(BCO.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID
 FROM tblAcctQuote AS AQ
 INNER JOIN tblQuoteStatus AS QS ON QS.QuoteStatusID = AQ.QuoteStatusID
 INNER JOIN tblCase AS C ON C.CaseNbr = AQ.CaseNbr
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = AQ.DoctorCode
 WHERE QS.IsClosed=0