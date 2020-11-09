CREATE VIEW vwExportSummary
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime , 
			tblCase.ExtCaseNbr, 
			tblCompany.ParentCompanyID,
			tblEWServiceType.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
