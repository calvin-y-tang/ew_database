--One time data patch
--UPDATE tblCase SET ReExam=0, IsReExam=0, NeedFurtherTreatment=0, ReExamNoticePrinted=0, ReExamProcessed=0
--GO


CREATE INDEX [IdxtblCaseHistory_BY_FollowUpDate] ON [tblCaseHistory]([FollowUpDate])
GO

ALTER TABLE [tblControl]
  ADD [UsePeerBill] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE tblControl
 ALTER COLUMN SecureDocsURL VARCHAR(100)
GO

INSERT INTO tblUserFunction
        ( FunctionCode, FunctionDesc )
VALUES  ( 'CaseReExam', -- FunctionCode - varchar(30)
          'Case - ReExam'  -- FunctionDesc - varchar(50)
          )
GO


DROP VIEW vwcasetypeservicedocument
GO
CREATE VIEW vwCaseTypeServiceDocument
AS
    SELECT  tblQueueDocuments.CaseType ,
            tblQueueDocuments.ServiceCode ,
            tblQueueDocuments.Status ,
            tblQueueDocuments.Document ,
            tblQueueDocuments.Attachment ,
            tblQueueDocuments.ProcessOrder ,
            tblQueueDocuments.PrintCopies ,
            tblQueueDocuments.EmailDoctor ,
            tblQueueDocuments.EmailAttorney ,
            tblQueueDocuments.EmailClient ,
            tblQueueDocuments.FaxDoctor ,
            tblQueueDocuments.FaxAttorney ,
            tblQueueDocuments.FaxClient ,
            tblQueueDocuments.DateAdded ,
            tblQueueDocuments.UserIDAdded ,
            tblQueueDocuments.DateEdited ,
            tblQueueDocuments.UserIDEdited ,
            tblQueueDocuments.OfficeCode ,
            tblCaseType.Description AS CaseTypeDesc ,
            tblServices.Description AS ServiceDesc ,
            tblQueues.StatusDesc ,
            tblCaseTypeService.ExamineeAddrReqd ,
            tblCaseTypeService.ExamineeSSNReqd ,
            tblCaseTypeService.AttorneyReqd ,
            tblCaseTypeService.DOIRqd ,
            tblCaseTypeService.ClaimNbrRqd ,
            tblDocument.Description ,
            tblDocument.sFilename ,
            tblDocument.Type
    FROM    tblQueueDocuments
            INNER JOIN tblServices ON tblQueueDocuments.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblCaseType ON tblQueueDocuments.CaseType = tblCaseType.Code
            INNER JOIN tblDocument ON tblQueueDocuments.Document = tblDocument.Document
            INNER JOIN tblServiceOffice ON tblQueueDocuments.ServiceCode = tblServiceOffice.ServiceCode
                                               AND tblQueueDocuments.OfficeCode = tblServiceOffice.OfficeCode
            INNER JOIN tblQueues ON tblQueueDocuments.Status = tblQueues.StatusCode
            INNER JOIN tblCaseTypeService ON tblQueueDocuments.CaseType = tblCaseTypeService.CaseType
                                                 AND tblQueueDocuments.ServiceCode = tblCaseTypeService.ServiceCode
                                                 AND tblQueueDocuments.OfficeCode = tblCaseTypeService.OfficeCode


GO

DROP VIEW vwCase
GO

CREATE VIEW vwCase
AS
    SELECT  CaseNbr ,
            DoctorLocation ,
            C.ClientCode ,
            C.MarketerCode ,
            SchedulerCode ,
            C.Status ,
            DoctorCode ,
            C.DateAdded ,
            ApptDate ,
            CL.CompanyCode ,
            OfficeCode ,
            C.QARep AS QARepCode ,
			C.CaseType ,
			C.ServiceCode ,
			C.ReExam ,
			C.ReExamProcessed ,
			C.ReExamDate
    FROM    tblCase AS C
            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
GO

DROP VIEW vwCaseSummaryWithSecurity
GO
CREATE VIEW vwCaseSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.MiscSelect ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.VoucherAmt ,
            tblCase.VoucherDate ,
            tblCase.OfficeCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            tblCase.PanelNbr ,
            tblCase.CommitDate ,
            tblCase.MasterSubCase ,
            tblCase.MasterCaseNbr ,
            tblCase.CertMailNbr ,
            tblCase.WebNotifyEmail ,
            tblCase.PublishOnWeb ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS DoctorName ,
            tblCase.DateMedsRecd ,
            tblCase.SInternalCaseNbr ,
            tblCase.DoctorSpecialty ,
            tblCase.USDDate1 ,
            tblQueues.FunctionCode ,
            tblUserOfficeFunction.UserID ,
            tblCase.CaseType ,
            tblCase.ForecastDate ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
			tblCase.ReExam ,
			tblCase.ReExamDate ,
			tblCase.ReExamProcessed,
			tblCase.ReExamNoticePrinted
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID
                                                AND tblUserOffice.OfficeCode = tblUserOfficeFunction.OfficeCode
                                                AND tblQueues.FunctionCode = tblUserOfficeFunction.FunctionCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
GO

UPDATE tblControl SET DBVersion='2.49'
GO
