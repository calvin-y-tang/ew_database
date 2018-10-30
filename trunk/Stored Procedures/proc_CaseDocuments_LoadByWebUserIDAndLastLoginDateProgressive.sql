CREATE PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseDocuments.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description AS doctypedesc, tblCase.DoctorSpecialty, tblCase.DoctorName
	FROM tblCaseDocuments
		INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		LEFT JOIN tblCaseDocType on tblCaseDocuments.CaseDocTypeID = tblCaseDocType.CaseDocTypeID
	WHERE (tblPublishOnWeb.TableType = 'tblCaseDocuments')
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
