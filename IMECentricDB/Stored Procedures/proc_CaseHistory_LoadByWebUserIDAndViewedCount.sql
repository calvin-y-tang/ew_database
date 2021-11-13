CREATE PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewedCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT COUNT(tblCaseHistory.id)
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory'
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
