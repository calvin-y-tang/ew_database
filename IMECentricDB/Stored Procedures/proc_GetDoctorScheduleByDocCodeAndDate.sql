CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleByDocCodeAndDate]

@DoctorCode int,
@ApptDateStart smalldatetime,
@ApptDateEnd smalldatetime,
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.ApptTime,
		tblCase.ExtCaseNbr,
		tblCase.claimnbr,
		tblLocation.Location,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT JOIN tblDoctor tblDoctor1 ON tblCase.doctorcode = tblDoctor1.doctorcode
		LEFT JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr
		LEFT JOIN tblDoctor tblDoctor2 ON tblCasePanel.DoctorCode = tblDoctor2.DoctorCode
		INNER JOIN tblLocation on tblCase.DoctorLocation = tblLocation.LocationCode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.DoctorCode = @DoctorCode OR tblCasePanel.DoctorCode = @DoctorCode)
		AND (tblCase.ApptDate >= @ApptDateStart)
		AND (tblCase.ApptDate <= @ApptDateEnd)
		AND (tblCase.status <> 9)
		AND (tblCase.ApptStatusID IN (10, 100))
		ORDER BY tblLocation.Location, ApptTime

	SET @Err = @@Error

	RETURN @Err
END