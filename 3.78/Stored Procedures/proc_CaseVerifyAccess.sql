CREATE PROCEDURE [proc_CaseVerifyAccess]

@CaseNbr int,
@WebUserID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT COUNT(tblCase.casenbr) from tblcase
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase' 
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblCase.casenbr = @CaseNbr
			AND tblWebUserAccount.WebUserID = @WebUserID

	SET @Err = @@Error

	RETURN @Err
END