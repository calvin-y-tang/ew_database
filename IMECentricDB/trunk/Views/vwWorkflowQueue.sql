CREATE VIEW vwServiceWorkflowQueue
AS
    SELECT
        WFQ.ServiceWorkflowQueueID,
        WFQ.ServiceWorkflowID,
        WFQ.DateAdded,
        WFQ.DateEdited,
        WFQ.UserIDAdded,
        WFQ.UserIDEdited,
        WFQ.QueueOrder,
        WFQ.StatusCode,
        WFQ.NextStatus,
        WFQ.CreateVoucher,
        WFQ.CreateInvoice,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.CaseTypeDesc,
        WF.CaseTypeStatus,
        WF.ServiceDesc,
        WF.ServiceStatus,
        WF.OfficeDesc,
        WF.OfficeStatus,
        Q.DisplayOrder,
        Q.StatusDesc AS QueueDesc,
        Q.ShortDesc,
        WFQD.DocCount
    FROM
        tblServiceWorkflowQueue AS WFQ
    INNER JOIN vwServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID
    INNER JOIN tblQueues AS Q ON Q.StatusCode=WFQ.StatusCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowQueueID,
                        COUNT(ServiceWorkflowQueueDocumentID) AS DocCount
                     FROM
                        tblServiceWorkflowQueueDocument
                     GROUP BY
                        ServiceWorkflowQueueID
                    ) AS WFQD ON WFQD.ServiceWorkflowQueueID=WFQ.ServiceWorkflowQueueID