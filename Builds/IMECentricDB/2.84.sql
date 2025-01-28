PRINT N'Altering [dbo].[proc_Client_GetDefaultOffice]...';


GO
ALTER PROCEDURE [proc_Client_GetDefaultOffice]
(
	@clientcode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblClientOffice TCO
            WHERE  TCO.clientcode=TC.clientcode
            ORDER BY clientcode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblClientOffice TC
	Where clientcode = @clientcode
	GROUP BY TC.clientcode

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetAdminReferralSummaryNew]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [dbo].[proc_GetAdminReferralSummaryNew]

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
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetCaseTypeComboItems]...';


GO
ALTER PROCEDURE [proc_GetCaseTypeComboItems]

@ClientCode int

AS

SELECT DISTINCT [tblCaseType].[code], [tblCaseType].[description] FROM tblClient
	INNER JOIN tblClientOffice ON tblClient.ClientCode = tblClientOffice.ClientCode AND (tblClientOffice.ClientCode = @ClientCode)
	INNER JOIN tblCaseTypeOffice ON tblClientOffice.OfficeCode = tblCaseTypeOffice.OfficeCode
	INNER JOIN tblCaseType ON tblCaseTypeOffice.CaseType = tblCaseType.Code
	WHERE (tblCaseType.PublishOnWeb = 1)
	ORDER BY [tblCaseType].[Description]
GO
PRINT N'Altering [dbo].[proc_GetMMISummaryNew]...';


GO
ALTER PROCEDURE [dbo].[proc_GetMMISummaryNew]

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
		tblCase.MMIReached,
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
GO
PRINT N'Altering [dbo].[proc_GetReferralsByClaimantAndClaim]...';


GO
ALTER PROCEDURE [dbo].[proc_GetReferralsByClaimantAndClaim]

@WebUserID int,
@ClaimNbr varchar(50),
@Chartnbr int,
@CaseNbr int

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
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
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
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		AND (tblCase.ClaimNbr = @ClaimNbr OR tblCase.ChartNbr = @ChartNbr)
		AND (tblCase.CaseNbr <> @CaseNbr)


	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetReferralSearch]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetReferralSearch]

@WebUserID int = 0

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode,
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.DoctorName AS provider,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty,
		tblServices.shortdesc AS service,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblWebQueues.description AS WebStatus,
		tblQueues.WebStatusCode,
		tblWebQueues.statuscode,
		tblCase.claimnbr,
		tblWebUserAccount.WebUserID,
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
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType

	WHERE tblWebUserAccount.WebUserID = COALESCE(@WebUserID,tblWebUserAccount.WebUserID)

SET @Err = @@Error
RETURN @Err
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetReferralSummaryNew]...';


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummaryNew]

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
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblCase.MMIReached,
		tblCase.MMITreatmentWeeks,
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
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status <> 0)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetReferralSummarySinceLastLoginDate]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDate]

@WebUserID int,
@LastLoginDate datetime

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase. ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.dateadded > @LastLoginDate)
		AND (tblCase.status <> 0)

	SET @Err = @@Error

	RETURN @Err
END
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetServiceComboItems]...';


GO
ALTER PROCEDURE [proc_GetServiceComboItems]

@ClientCode int

AS

SELECT DISTINCT [tblServices].[servicecode], [tblServices].[description] FROM tblClient
	INNER JOIN tblClientOffice ON tblClient.ClientCode = tblClientOffice.ClientCode AND (tblClientOffice.ClientCode = @ClientCode)
	INNER JOIN tblServiceOffice ON tblClientOffice.OfficeCode = tblServiceOffice.OfficeCode
	INNER JOIN tblServices ON tblServiceOffice.ServiceCode = tblServices.ServiceCode
	WHERE (tblServices.PublishOnWeb = 1)
	ORDER BY [tblServices].[Description]
GO


UPDATE tblControl SET DBVersion='2.84'
GO