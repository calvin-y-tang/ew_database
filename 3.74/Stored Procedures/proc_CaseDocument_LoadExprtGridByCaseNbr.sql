CREATE PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT tblCaseDocuments.UserIDAdded as 'User', tblPublishOnWeb.PublishAsPDF, tblCaseDocuments.DateAdded as 'Date Added', sfilename as 'File Name', Description
		FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
			AND (tblCaseDocuments.casenbr = @CaseNbr)
			AND (tblCaseDocuments.PublishOnWeb = 1)

	SET @Err = @@Error

	RETURN @Err
END
GO