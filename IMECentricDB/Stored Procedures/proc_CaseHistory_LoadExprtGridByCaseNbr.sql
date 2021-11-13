CREATE PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblCaseHistory.UserID as 'User', tblCaseHistory.DateAdded as 'Date Added', eventdesc as Description, otherinfo as Info 
		FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (tblCaseHistory.casenbr = @CaseNbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
