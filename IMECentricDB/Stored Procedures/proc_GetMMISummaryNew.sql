CREATE PROCEDURE [dbo].[proc_GetMMISummaryNew]

@WebUserID int,
@FromDate datetime,
@ToDate datetime

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		tblCase.claimnbr,
		tblCase.MMIReachedStatus,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr,
		(SELECT TOP 1 ApptTime FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND tblCaseAppt.ApptStatusID = 100 ORDER BY ApptTime DESC) AS ApptDate
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
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.ApptDate >= @FromDate)
		AND (tblCase.ApptDate <= @ToDate)
		AND (tblCase.status <> 0)
		AND (tblCase.ApptDate IS NOT NULL)
		AND (tblCase.MMIReached IS NOT NULL)
		AND (tblCase.MMITreatmentWeeks IS NOT NULL)

	SET @Err = @@Error

	RETURN @Err
END