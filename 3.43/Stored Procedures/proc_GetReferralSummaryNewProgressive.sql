CREATE PROCEDURE [dbo].[proc_GetReferralSummaryNewProgressive]

@WebStatus varchar(50),
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblCase.MMIReachedStatus,
		tblCase.DoctorSpecialty,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		tblQueues.statuscode AS QueueStatusCode,
		tblQueues.StatusDesc,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUser ON tblPublishOnWeb.UserCode = tblWebUser.IMECentricCode
			AND tblPublishOnWeb.UserType = tblWebUser.UserType
			AND tblWebUser.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status NOT IN (8,9))

	SET @Err = @@Error

	RETURN @Err
END

GO