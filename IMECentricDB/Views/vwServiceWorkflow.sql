CREATE VIEW [dbo].[vwServiceWorkflow]
AS
    SELECT
        WF.ServiceWorkflowID,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.UserIDAdded,
        WF.DateAdded,
        WF.UserIDEdited,
        WF.DateEdited,
        WF.ExamineeAddrReqd,
        WF.ExamineeSSNReqd,
        WF.AttorneyReqd,
        WF.DOIRqd,
        WF.ClaimNbrRqd,
        WF.JurisdictionRqd,
        WF.EmployerRqd,
        WF.TreatingPhysicianRqd,
        WF.CalcFrom,
        WF.DaysToForecastDate,
        WF.DaysToInternalDueDate,
        WF.DaysToExternalDueDate,
		WF.DaysToDoctorRptDueDate,
		WF.InternalDueDateType,
		WF.ExternalDueDateType,
		WF.DoctorRptDueDateType,
		WF.ForecastDateType,
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus,
		WF.UsePeerBill,
		S.ProdCode, 
		CT.EWBusLineID, 
		S.EWServiceTypeID,
        WF.WcCaseTypeRqd,
        WF.DobRqd
    FROM
        tblServiceWorkflow AS WF
    INNER JOIN tblCaseType AS CT ON WF.CaseType=CT.Code
    INNER JOIN tblServices AS S ON S.ServiceCode=WF.ServiceCode
    INNER JOIN tblOffice AS O ON O.OfficeCode=WF.OfficeCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowID,
                        COUNT(ServiceWorkflowQueueID) AS QueueCount
                     FROM
                        tblServiceWorkflowQueue
                     GROUP BY
                        ServiceWorkflowID
                    ) AS WFQ ON WFQ.ServiceWorkflowID=WF.ServiceWorkflowID
