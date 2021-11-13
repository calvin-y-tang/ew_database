CREATE PROCEDURE [proc_GetReferralSearchProgressive]

@CompanyCode int

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode,
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.ClaimNbrExt,
		tblCase.ClientCode,
		tblCase.DoctorName AS provider,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty,
		tblServices.shortdesc AS service,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblExaminee.lastname,
		tblExaminee.firstname,
		tblWebQueues.description AS WebStatus,
		tblQueues.WebStatusCode,
		tblWebQueues.statuscode,
		tblCase.claimnbr,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
			AND tblPublishOnWeb.UserType = 'CL'

	WHERE tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE tblClient.CompanyCode = @CompanyCode)

SET @Err = @@Error
RETURN @Err

