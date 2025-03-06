

--New table to store National Entity Supervisor relationship
CREATE TABLE [tblEWWebUserAccount] (
  [EWWebUserID] INTEGER NOT NULL,
  [EWEntityID] INTEGER NOT NULL,
  [UserType] CHAR(2) NOT NULL,
  [IsUser] BIT NOT NULL,
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblEWWebUserAccount] PRIMARY KEY CLUSTERED ([EWWebUserID],[EWEntityID],[UserType])
)
GO

-- fix the case of all system entities in the table (per Kevin)
UPDATE [dbo].[tblQueues] 
   SET [Type] = UPPER(LEFT([Type], 1)) + LOWER(SUBSTRING([Type], 2, LEN([Type]) - 1))
 WHERE [Type] like 'system'
GO

-- Change the existing EDI queue to be BrickStreet specific
UPDATE [tblQueues] 
   SET [StatusDesc] = 'Invoices Awaiting Brickstreet Export', 
       [ShortDesc] = 'BrickExp' 
 WHERE [StatusCode] = 22
GO 

-- New Queues for Washington L&I

-- enable ability to add value to StatusCode
SET IDENTITY_INSERT dbo.tblQueues ON
-- WALI EDI Export Queue 
INSERT INTO tblQueues (StatusCode, StatusDesc, [Type], ShortDesc, DisplayOrder, 
                       FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, [Status], 
                       SubType, FunctionCode, WebStatusCode, WebGUID, NotifyScheduler, NotifyQARep, NotifyIMECompany)
  VALUES (23, 'Invoices Awaiting Washington L&I Export', 'System', 'WALIExp', 450, 'frmStatusEDIExport', 
          GETDATE(), GETDATE(), 'admin', 'admin', 'Active', 'Accting', 'EDIExport', NULL, NULL, 0, 0, 0)        
-- WALI EDI Acknowledgement Queue          
INSERT INTO tblQueues (StatusCode, StatusDesc, [Type], ShortDesc, DisplayOrder, 
                       FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, [Status], 
                       SubType, FunctionCode, WebStatusCode, WebGUID, NotifyScheduler, NotifyQARep, NotifyIMECompany)
  VALUES (24, 'Invoices Awaiting Washington L&I Acknowledgement', 'System', 'WALIExp', 451, 'frmStatusEDISubmit', 
          GETDATE(), GETDATE(), 'admin', 'admin', 'Active', 'Accting', 'EDIExport', NULL, NULL, 0, 0, 0)         
-- WALI EDI Error Queue          
INSERT INTO tblQueues (StatusCode, StatusDesc, [Type], ShortDesc, DisplayOrder, 
                       FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, [Status], 
                       SubType, FunctionCode, WebStatusCode, WebGUID, NotifyScheduler, NotifyQARep, NotifyIMECompany)
  VALUES (25, 'Invoices with Washington L&I Errors', 'System', 'WALIExp', 452, 'frmStatusEDIError', 
          GETDATE(), GETDATE(), 'admin', 'admin', 'Active', 'Accting', 'EDIExport', NULL, NULL, 0, 0, 0)          
-- disable ability to add value to StatusCode
SET IDENTITY_INSERT dbo.tblQueues OFF
GO

-- add new tblAcctHeader EDI columns
ALTER TABLE [dbo].[tblAcctHeader] ADD [EDILastStatusChg] DATETIME NULL
GO
ALTER TABLE [dbo].[tblAcctHeader] ADD [EDIStatus] VARCHAR(16) NULL
GO
ALTER TABLE [dbo].[tblAcctHeader] ADD [EDIRejectedMsg] VARCHAR(256) NULL
GO

--
-- Alter view vwExportSummaryWithSecurity to include new EDI columns
-- 
ALTER VIEW [dbo].[vwExportSummaryWithSecurity]
AS
SELECT TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblAcctHeader.documenttype, dbo.tblAcctHeader.documentnbr, dbo.tblAcctingTrans.statuscode, 
			                  dbo.tblAcctHeader.EDIBatchNbr, dbo.tblAcctHeader.EDIStatus, dbo.tblAcctHeader.EDILastStatusChg, dbo.tblAcctHeader.EDIRejectedMsg,
                        dbo.tblQueues.statusdesc, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblAcctingTrans.DrOpType, 
                        CASE ISNULL(dbo.tblcase.panelnbr, 0) WHEN 0 THEN CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tbldoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tbldoctor.firstname, '') WHEN '' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + ISNULL(dbo.tbldoctor.firstname, '') 
                        WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') 
                        WHEN 'OP' THEN dbo.tbldoctor.companyname END ELSE CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tblcase.doctorname, '') 
                        WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') WHEN 'OP' THEN dbo.tbldoctor.companyname END END AS doctorname, 
                        dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, 
                        dbo.tblCase.ApptDate, dbo.tblCase.dateadded, dbo.tblCase.claimnbr, dbo.tblCase.doctorlocation, dbo.tblCase.Appttime, dbo.tblCase.dateedited, 
                        dbo.tblCase.useridedited, dbo.tblClient.email AS adjusteremail, dbo.tblClient.fax AS adjusterfax, dbo.tblCase.marketercode, dbo.tblCase.useridadded, 
                        dbo.tblAcctHeader.documentdate, dbo.tblAcctHeader.INBatchSelect, dbo.tblAcctHeader.VOBatchSelect, dbo.tblAcctHeader.taxcode, 
                        dbo.tblAcctHeader.taxtotal, dbo.tblAcctHeader.documenttotal, dbo.tblAcctHeader.documentstatus, dbo.tblCase.clientcode, dbo.tblCase.doctorcode, 
                        dbo.tblAcctHeader.batchnbr, dbo.tblCase.officecode, dbo.tblCase.schedulercode, dbo.tblClient.companycode, dbo.tblCase.QARep, 
                        dbo.tblCase.PanelNbr, DATEDIFF(day, dbo.tblAcctingTrans.laststatuschg, GETDATE()) AS IQ, dbo.tblCase.mastersubcase, 
                        tblqueues_1.statusdesc AS CaseStatus, dbo.tblUserOfficeFunction.userid, dbo.tblQueues.functioncode, dbo.tblServices.shortdesc AS service, 
                        dbo.tblCase.servicecode, dbo.tblCase.casetype
FROM          dbo.tblAcctHeader INNER JOIN
                        dbo.tblAcctingTrans ON dbo.tblAcctHeader.seqno = dbo.tblAcctingTrans.SeqNO INNER JOIN
                        dbo.tblCase ON dbo.tblAcctHeader.casenbr = dbo.tblCase.casenbr LEFT OUTER JOIN
                        dbo.tblCompany ON dbo.tblAcctHeader.CompanyCode = dbo.tblCompany.companycode LEFT OUTER JOIN
                        dbo.tblClient ON dbo.tblAcctHeader.ClientCode = dbo.tblClient.clientcode INNER JOIN
                        dbo.tblQueues ON dbo.tblAcctingTrans.statuscode = dbo.tblQueues.statuscode INNER JOIN
                        dbo.tblQueues tblqueues_1 ON dbo.tblCase.status = tblqueues_1.statuscode LEFT OUTER JOIN
                        dbo.tblDoctor ON dbo.tblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                        dbo.tblServices ON dbo.tblServices.servicecode = dbo.tblCase.servicecode INNER JOIN
                        dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode INNER JOIN
                        dbo.tblUserOfficeFunction ON dbo.tblUserOffice.userid = dbo.tblUserOfficeFunction.userid AND 
                        dbo.tblUserOfficeFunction.officecode = dbo.tblCase.officecode AND dbo.tblQueues.functioncode = dbo.tblUserOfficeFunction.functioncode
WHERE      (dbo.tblAcctingTrans.statuscode <> 20) AND (dbo.tblAcctHeader.batchnbr IS NULL) AND (dbo.tblAcctHeader.documentstatus = 'Final')
ORDER BY dbo.tblAcctHeader.documentdate, dbo.tblCase.priority, dbo.tblCase.ApptDate
GO


--Remove unused column
ALTER TABLE tblTranscriptionJob
 DROP COLUMN ReportTemplateFile
GO


UPDATE tblControl SET DBVersion='1.75'
GO

