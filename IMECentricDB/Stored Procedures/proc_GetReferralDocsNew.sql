

CREATE PROCEDURE [proc_GetReferralDocsNew] 

@CaseID int,
@WebUserID int,
@SortExpression varchar(50) = 'dateadded' 

AS

DECLARE @tmpSQL NVARCHAR(4000)

SET @tmpSQL = 'SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF FROM tblCaseDocuments '
 + 'INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
 + 'WHERE tblCaseDocuments.seqno IN '
 + '(SELECT DISTINCT TableKey FROM tblPublishOnWeb '

  IF @WebUserID <> 999999
   BEGIN
    SET @tmpSQL = @tmpSQL + 'WHERE (tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.PublishOnWeb = 1 '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.UserCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = ' + CAST(@WebUserID AS VARCHAR(20)) + ' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))) ' 
    SET @tmpSQL = @tmpSQL + 'AND (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (tblCaseDocuments.PublishOnWeb = 1) '
    SET @tmpSQL = @tmpSQL + 'ORDER BY tblCaseDocuments.' + @SortExpression
   END
  ELSE
   BEGIN
    SET @tmpSQL = @tmpSQL + 'WHERE tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.PublishOnWeb = 1 '
    SET @tmpSQL = @tmpSQL + ') ' 
    SET @tmpSQL = @tmpSQL + 'AND (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (tblCaseDocuments.PublishOnWeb = 1) '
    SET @tmpSQL = @tmpSQL + 'ORDER BY tblCaseDocuments.' + @SortExpression
   END
 
EXECUTE SP_EXECUTESQL @tmpSQL

