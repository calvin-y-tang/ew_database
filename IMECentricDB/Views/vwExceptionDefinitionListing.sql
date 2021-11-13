CREATE VIEW vwExceptionDefinitionListing
AS
    SELECT  tblExceptionDefinition.Description ,
            tblExceptionDefinition.Entity ,
            tblExceptionList.Description AS ExceptionDesc ,
            ISNULL(tblCaseType.Description, 'All') AS CaseType ,
            ISNULL(tblServices.Description, 'All') AS Service ,
            ISNULL(tblQueues.StatusDesc, 'All') AS Status ,
            tblExceptionDefinition.StatusCodeValue ,
            tblExceptionDefinition.DisplayMessage ,
            tblExceptionDefinition.RequireComment ,
            tblExceptionDefinition.EmailMessage ,
            tblExceptionDefinition.GenerateDocument ,
            tblExceptionDefinition.Message ,
            tblExceptionDefinition.EditEmail ,
            tblExceptionDefinition.EmailScheduler ,
            tblExceptionDefinition.EmailQA ,
            tblExceptionDefinition.EmailOther ,
            tblExceptionDefinition.EmailSubject ,
            tblExceptionDefinition.EmailText ,
            tblExceptionDefinition.Document1 ,
            tblExceptionDefinition.Document2 ,
            tblExceptionDefinition.Status AS Active ,
            tblExceptionDefinition.DateAdded ,
            tblExceptionDefinition.UserIDAdded ,
            tblExceptionDefinition.DateEdited ,
            tblExceptionDefinition.UserIDEdited ,
            '' AS EntityDescription ,
			ExceptionDefID ,
			AllOffice
    FROM    tblExceptionDefinition
            INNER JOIN tblExceptionList ON tblExceptionDefinition.ExceptionID = tblExceptionList.ExceptionID
            LEFT OUTER JOIN tblQueues ON tblExceptionDefinition.StatusCode = tblQueues.StatusCode
            LEFT OUTER JOIN tblServices ON tblExceptionDefinition.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblCaseType ON tblExceptionDefinition.CaseTypeCode = tblCaseType.Code
