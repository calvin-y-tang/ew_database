CREATE PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDateCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

    SELECT COUNT(tblCase.casenbr) FROM tblCase
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
		WHERE (tblPublishOnWeb.tabletype = 'tblCase')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserType = @userType)
			AND (tblPublishOnWeb.UserCode = @userCode)
			AND (tblPublishOnWeb.dateadded > @LastLoginDate)

	SET @Err = @@Error

	RETURN @Err
END