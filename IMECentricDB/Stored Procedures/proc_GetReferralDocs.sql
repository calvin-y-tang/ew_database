

CREATE PROCEDURE [proc_GetReferralDocs] 

@CaseID int,
@SortExpression varchar(50) = 'dateadded' 

AS

DECLARE @tmpSQL NVARCHAR(4000)

SET @tmpSQL = 'SELECT DISTINCT tblCaseDocuments.casenbr, tblCaseDocuments.description,  0 as PublishasPDF, '
 + 'tblCaseDocuments.dateadded, tblCaseDocuments.UserIDAdded, tblCaseDocuments.sFileName, tblCaseDocuments.Viewed, tblCaseDocuments.seqno FROM tblCaseDocuments '
 + 'WHERE (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (PublishOnWeb = 1) '
 + 'ORDER BY ' + @SortExpression
 
EXECUTE SP_EXECUTESQL @tmpSQL

