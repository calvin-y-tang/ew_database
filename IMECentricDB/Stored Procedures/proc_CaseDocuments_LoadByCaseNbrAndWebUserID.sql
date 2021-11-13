CREATE PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, ISNULL(tblPublishOnWeb.Viewed, 0) DocViewed, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID
		AND (tblPublishOnWeb.casenbr = @CaseNbr)

ORDER BY tblCaseDocuments.DateAdded DESC
