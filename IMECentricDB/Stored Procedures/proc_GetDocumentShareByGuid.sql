CREATE PROCEDURE [proc_GetDocumentShareByGuid]

@Guid varchar(36)

AS

SELECT tblCaseDocuments.CaseNbr, tblCaseDocuments.sFileName, tblCaseDocuments.Description, tblWebActionLink.UserType, 
	tblWebActionLink.UserCode, ISNULL(tblPublishOnWeb.Viewed, 0) Viewed, tblCaseDocuments.SeqNo, tblWebActionLink.Param,
	ISNULL(tblPublishOnWeb.PublishAsPDF, 0) PublishAsPDF, tblCaseDocuments.Type, tblCaseDocType.Description DocTypeDesc, 
	tblCaseDocuments.DateAdded, tblWebActionLink.ExpirationDate
	FROM tblWebActionLink
		INNER JOIN tblWebActionLinkItem ON tblWebActionLink.WebActionLinkID = tblWebActionLinkItem.WebActionLinkID
		INNER JOIN tblCaseDocuments ON tblWebActionLinkItem.ActionKey = tblCaseDocuments.SeqNo
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.SeqNo = tblPublishOnWeb.TableKey
		INNER JOIN tblCaseDocType ON tblCaseDocuments.CaseDocTypeId = tblCaseDocType.CaseDocTypeId
		WHERE tblPublishOnWeb.TableType = 'tblCaseDocuments'
		AND tblPublishOnWeb.UserCode = tblWebActionLink.UserCode
		AND tblWebActionLink.UniqueKey = @Guid

