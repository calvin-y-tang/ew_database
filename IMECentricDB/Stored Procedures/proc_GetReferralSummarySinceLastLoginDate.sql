CREATE PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDate]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int


    SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.FirstName,
		tblExaminee.LastName,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblServices.description AS Service,
		tblServices.description AS ServiceDesc,
		tblCase.DoctorName AS provider,
		tblCaseType.Description AS CaseType,
		tblWebQueuesV2.Description AS WebQueueStatusDesc,
		CAST(tblCase.DateAdded AS VARCHAR(20)) AS SavedDateTime,
		tblClient.LastName + ', ' + tblClient.FirstName AS ClientName,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
			FROM tblCase
			INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
			INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
			INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
			INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code
			INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
			INNER JOIN tblWebQueuesV2 on tblQueues.WebStatusCodeV2 = tblWebQueuesV2.StatusCode
		WHERE tblPublishOnWeb.tabletype = 'tblCase'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserType = @UserType)
			AND (tblPublishOnWeb.UserCode = @UserCode)
			AND (tblPublishOnWeb.dateadded > @LastLoginDate)

	SET @Err = @@Error

	RETURN @Err
END