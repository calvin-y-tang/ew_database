CREATE PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT COUNT(tblCaseDocuments.seqno)
	FROM tblCaseDocuments
	INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseDocuments'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (tblPublishOnWeb.DateAdded > @LastLoginDate)