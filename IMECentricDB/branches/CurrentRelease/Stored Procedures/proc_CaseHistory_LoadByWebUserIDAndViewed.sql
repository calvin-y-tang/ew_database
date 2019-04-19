CREATE PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseHistory.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename, tblCase.DoctorName, tblCase.DoctorSpecialty
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
