CREATE VIEW vwServiceWorkflowQueueDocument
AS
    SELECT
        WFQD.ServiceWorkflowQueueDocumentID,
        WFQ.ServiceWorkflowQueueID,
        WF.ServiceWorkflowID,
        WF.ServiceCode,
        WF.CaseType,
        WF.OfficeCode,
        WFQ.StatusCode,
        WFQD.Document,
        WFQD.Attachment,
        WFQD.ProcessOrder,
        WFQD.PrintCopies,
        WFQD.EmailDoctor,
        WFQD.EmailAttorney,
        WFQD.EmailClient,
        WFQD.FaxDoctor,
        WFQD.FaxAttorney,
        WFQD.FaxClient,
		WFQD.EnvelopeAOrder, 
		WFQD.EnvelopeBOrder, 
		WFQD.EnvelopeCOrder, 
		WFQD.EnvelopeDOrder, 
		WFQD.CombineDocs 
    FROM
        tblServiceWorkflowQueueDocument AS WFQD
    INNER JOIN tblServiceWorkflowQueue AS WFQ ON WFQ.ServiceWorkflowQueueID=WFQD.ServiceWorkflowQueueID
    INNER JOIN tblServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID