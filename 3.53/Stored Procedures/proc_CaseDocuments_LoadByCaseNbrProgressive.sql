CREATE PROCEDURE [proc_CaseDocuments_LoadByCaseNbrProgressive]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, ISNULL(tblPublishOnWeb.Viewed, 0) DocViewed, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey 
			AND (tblPublishOnWeb.TableType = 'tblCaseDocuments')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.CaseNbr = @CaseNbr)
			AND (tblPublishOnWeb.UserType = 'CL')
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID

ORDER BY tblCaseDocuments.DateAdded DESC
GO