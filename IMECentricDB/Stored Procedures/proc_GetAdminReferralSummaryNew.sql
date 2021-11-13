CREATE PROCEDURE [dbo].[proc_GetAdminReferralSummaryNew]

@WebStatus varchar(50)

AS

SET NOCOUNT OFF
DECLARE @Err int

		SELECT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr,
		tblClient.clientcode
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.Casenbr IN
			(SELECT DISTINCT TableKey FROM tblPublishOnWeb
			WHERE tblPublishOnWeb.TableType = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1 AND TableKey > 0))
		AND (tblCase.status <> 0)

SET @Err = @@Error
RETURN @Err
