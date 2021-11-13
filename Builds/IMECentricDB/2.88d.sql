--Ok to run on test systems multiple times

INSERT  INTO tblUserFunction (FunctionCode, FunctionDesc)
SELECT 'ServiceWorkflowAddEdit', 'Services Workflow - Add/Edit'
WHERE NOT EXISTS (SELECT FunctionCode FROM tblUserFunction WHERE FunctionCode='ServiceWorkflowAddEdit')
GO

INSERT  INTO tblUserFunction (FunctionCode, FunctionDesc)
SELECT 'ServiceWorkflowDocumentSet', 'Services Workflow - Document Set'
WHERE NOT EXISTS (SELECT FunctionCode FROM tblUserFunction WHERE FunctionCode='ServiceWorkflowDocumentSet')
GO


UPDATE tblFeeHeader SET FeeCalcMethod=1
 FROM tblFeeHeader INNER JOIN tblControl ON DBID<>6
 WHERE FeeCalcMethod IS NULL
UPDATE tblFeeHeader SET FeeCalcMethod=2
 FROM tblFeeHeader INNER JOIN tblControl ON DBID=6
 WHERE FeeCalcMethod IS NULL
GO


TRUNCATE TABLE tblServiceWorkflow
TRUNCATE TABLE tblServiceWorkflowQueue
TRUNCATE TABLE tblServiceWorkflowQueueDocument
DELETE FROM tblPublishOnWeb WHERE TableType='tblServiceWorkflowQueueDocument'
GO
DELETE tblPublishOnWeb
 FROM tblPublishOnWeb AS POW
 LEFT OUTER JOIN tblQueueDocuments AS SQD ON SQD.SeqNo=POW.TableKey
 WHERE TableType='tblQueueDocuments'
 AND SQD.SeqNo IS NULL
GO

INSERT INTO tblServiceWorkflow
        (
         OfficeCode,
         CaseType,
         ServiceCode,
         UserIDAdded,
         DateAdded,
         UserIDEdited,
         DateEdited,
         ExamineeAddrReqd,
         ExamineeSSNReqd,
         AttorneyReqd,
         DOIRqd,
         ClaimNbrRqd,
         JurisdictionRqd,
         EmployerRqd,
         TreatingPhysicianRqd
        )

SELECT
       CTS.OfficeCode,
	   CTS.CaseType,
       CTS.ServiceCode,

       CTS.UserIDAdded,
       CTS.DateAdded,
       CTS.UserIDEdited,
       CTS.DateEdited,

       ISNULL(CTS.ExamineeAddrReqd, 0),
       ISNULL(CTS.ExamineeSSNReqd, 0),
       ISNULL(CTS.AttorneyReqd, 0),
       ISNULL(CTS.DOIRqd, 0),
       ISNULL(CTS.ClaimNbrRqd, 0),
       ISNULL(CTS.JurisdictionRqd, 0),
       ISNULL(CTS.EmployerRqd, 0),
       ISNULL(CTS.TreatingPhysicianRqd, 0)
	   FROM tblCaseTypeService AS CTS
GO

INSERT INTO tblServiceWorkflowQueue
        (
         ServiceWorkflowID,
         DateAdded,
         DateEdited,
         UserIDAdded,
         UserIDEdited,
         QueueOrder,
         StatusCode,
         NextStatus,
         CreateVoucher,
         CreateInvoice
        )
SELECT
	   WF.ServiceWorkflowID,
       SQ.DateAdded,
       SQ.DateEdited,
       SQ.UserIDAdded,
       SQ.UserIDEdited,
       SQ.QueueOrder,
       SQ.StatusCode,
       SQ.NextStatus,
       ISNULL(SQ.CreateVoucher, 0) AS CreateVoucher,
       ISNULL(SQ.CreateInvoice, 0) AS CreateInvoice
 FROM tblServiceWorkflow AS WF INNER JOIN tblServiceQueues AS SQ ON SQ.ServiceCode = WF.ServiceCode
 WHERE SQ.NextStatus IS NOT NULL
GO

UPDATE WF SET WF.CalcFrom=FC.CalcFrom, WF.DaysToForecastDate=FC.DaysToForecastDate, WF.DaysToInternalDueDate=FC.DaysToInternalDueDate, WF.DaysToExternalDueDate=FC.DaysToExternalDueDate
 FROM tblServiceWorkflow AS WF
 INNER JOIN tblFRForecast AS FC ON FC.ServiceCode = WF.ServiceCode AND FC.CaseType=-1
UPDATE WF SET WF.CalcFrom=FC.CalcFrom, WF.DaysToForecastDate=FC.DaysToForecastDate, WF.DaysToInternalDueDate=FC.DaysToInternalDueDate, WF.DaysToExternalDueDate=FC.DaysToExternalDueDate
 FROM tblServiceWorkflow AS WF
 INNER JOIN tblFRForecast AS FC ON FC.ServiceCode = WF.ServiceCode AND FC.CaseType=WF.CaseType
GO


ALTER TABLE tblServiceWorkflowQueueDocument
 ADD tmpQDKey INT
GO
INSERT INTO tblServiceWorkflowQueueDocument
        (
         ServiceWorkflowQueueID,
         DateAdded,
         UserIDAdded,
         DateEdited,
         UserIDEdited,
         Document,
         Attachment,
         ProcessOrder,
         PrintCopies,
         EmailDoctor,
         EmailAttorney,
         EmailClient,
         FaxDoctor,
         FaxAttorney,
         FaxClient,
         PublishOnWeb,
         PublishedTo,
		 tmpQDKey
        )
SELECT 
	   WFQ.ServiceWorkflowQueueID,
       QD.DateAdded,
       QD.UserIDAdded,
       QD.DateEdited,
       QD.UserIDEdited,
       Document,
       Attachment,
       ProcessOrder,
       PrintCopies,
       EmailDoctor,
       EmailAttorney,
       EmailClient,
       FaxDoctor,
       FaxAttorney,
       FaxClient,
       PublishOnWeb,
       PublishedTo,
	   QD.SeqNo
	   FROM tblServiceWorkflow AS WF
	   INNER JOIN tblServiceWorkflowQueue AS WFQ ON WFQ.ServiceWorkflowID = WF.ServiceWorkflowID
	   INNER JOIN tblQueueDocuments AS QD ON QD.CaseType = WF.CaseType AND QD.OfficeCode = WF.OfficeCode AND QD.ServiceCode = WF.ServiceCode AND QD.Status=WFQ.StatusCode
GO

INSERT INTO tblPublishOnWeb
        (
         TableType,
         TableKey,
         UserID,
         UserType,
         UserCode,
         PublishOnWeb,
         Notify,
         PublishAsPDF,
         DateAdded,
         UserIDAdded,
         DateEdited,
         UserIDEdited
        )
SELECT 
       'tblServiceWorkflowQueueDocument',
       SQD.ServiceWorkflowQueueDocumentID,
       POW.UserID,
       POW.UserType,
       POW.UserCode,
       POW.PublishOnWeb,
       POW.Notify,
       POW.PublishAsPDF,
       POW.DateAdded,
       POW.UserIDAdded,
       POW.DateEdited,
       POW.UserIDEdited
 FROM tblPublishOnWeb AS POW
 INNER JOIN tblServiceWorkflowQueueDocument AS SQD ON tmpQDKey=POW.TableKey
GO
ALTER TABLE tblServiceWorkflowQueueDocument
 DROP COLUMN tmpQDKey
GO

