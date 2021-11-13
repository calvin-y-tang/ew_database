IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS


	SELECT DISTINCT tblCaseHistory.CaseNbr, tblCaseHistory.EventDate, tblCaseHistory.EventDesc, tblCaseHistory.DateAdded,
	tblCaseHistory.UserID, tblCaseHistory.OtherInfo, tblCaseHistory.ID, tblCaseHistory.[Type], tblPublishOnWeb.PublishID,
	tblPublishOnWeb.TableType, tblPublishOnWeb.TableKey, tblPublishOnWeb.UserID, tblPublishOnWeb.UserType, tblPublishOnWeb.UserCode,
	tblPublishOnWeb.PublishOnWeb, tblPublishOnWeb.PublishAsPDF, ISNULL(tblPublishOnWeb.Viewed, 0) Viewed, tblPublishOnWeb.CaseNbr, tblPublishOnWeb.UseWidget,
	tblPublishOnWeb.DateViewed
	FROM tblCaseHistory 
		INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode IN 
			(SELECT UserCode 
				FROM tblWebUserAccount 
				WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
				AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
		AND (tblCaseHistory.casenbr = @CaseNbr)
		ORDER BY tblCaseHistory.DateAdded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByCaseNbrProgressive]...';


GO
ALTER PROCEDURE [proc_CaseHistory_LoadByCaseNbrProgressive]

@CaseNbr int,
@WebUserID int = NULL

AS

	SELECT DISTINCT tblCaseHistory.CaseNbr, tblCaseHistory.EventDate, tblCaseHistory.EventDesc, tblCaseHistory.DateAdded, 
	tblCaseHistory.UserID, tblCaseHistory.OtherInfo, tblCaseHistory.ID, tblCaseHistory.[Type], tblPublishOnWeb.PublishID,
	tblPublishOnWeb.TableType, tblPublishOnWeb.TableKey, tblPublishOnWeb.UserID, tblPublishOnWeb.UserType, tblPublishOnWeb.UserCode,
	tblPublishOnWeb.PublishOnWeb, tblPublishOnWeb.PublishAsPDF, ISNULL(tblPublishOnWeb.Viewed, 0) Viewed, tblPublishOnWeb.CaseNbr, tblPublishOnWeb.UseWidget,
	tblPublishOnWeb.DateViewed
	FROM tblCaseHistory 
		INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey 
			AND (tblPublishOnWeb.TableType = 'tblCaseHistory')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserType = 'CL')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			WHERE (tblCaseHistory.casenbr = @CaseNbr)
		ORDER BY tblCaseHistory.DateAdded DESC
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]...';


GO
ALTER PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseHistory.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewedCount]...';


GO
ALTER PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewedCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT COUNT(tblCaseHistory.id)
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory'
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_GetReferralSummaryNewProgressive]...';


GO

ALTER PROCEDURE [dbo].[proc_GetReferralSummaryNewProgressive]

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
		tblCase.doctorspecialty,
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
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_Insert]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_Insert]
(
	@PublishID int = NULL output,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit,
	@Notify bit,
	@PublishasPDF bit,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@Viewed bit,
	@CaseNbr int = NULL,
	@DateViewed datetime = NULL,
	@UseWidget bit = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblPublishOnWeb]
	(
		[TableType],
		[TableKey],
		[UserID],
		[UserType],
		[UserCode],
		[PublishOnWeb],
		[Notify],
		[PublishasPDF],
		[DateAdded],
		[UseridAdded],
		[DateEdited],
		[UseridEdited],
		[Viewed],
		[CaseNbr],
		[DateViewed],
		[UseWidget]
	)
	VALUES
	(
		@TableType,
		@TableKey,
		@UserID,
		@UserType,
		@UserCode,
		@PublishOnWeb,
		@Notify,
		@PublishasPDF,
		@DateAdded,
		@UseridAdded,
		@DateEdited,
		@UseridEdited,
		@Viewed,
		@CaseNbr,
		@DateViewed,
		@UseWidget
	)

	SET @Err = @@Error

	SELECT @PublishID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_LoadByTableKeyTableType]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_LoadByTableKeyTableType]
(
	@TableKey int,
	@UserCode int,
	@TableType varchar(50),
	@UserType varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblPublishOnWeb]
	WHERE
		([TableKey] = @TableKey)
	AND
		([UserCode] = @UserCode)
	AND 
		([TableType] = @TableType)
	AND 
		([UserType] = @UserType)

	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_Update]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_Update]
(
	@PublishID int,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit,
	@Notify bit,
	@PublishasPDF bit,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@Viewed bit = NULL,
	@CaseNbr int = NULL,
	@DateViewed datetime = NULL,
	@UseWidget bit = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblPublishOnWeb]
	SET
		[TableType] = @TableType,
		[TableKey] = @TableKey,
		[UserID] = @UserID,
		[UserType] = @UserType,
		[UserCode] = @UserCode,
		[PublishOnWeb] = @PublishOnWeb,
		[Notify] = @Notify,
		[PublishasPDF] = @PublishasPDF,
		[DateAdded] = @DateAdded,
		[UseridAdded] = @UseridAdded,
		[DateEdited] = @DateEdited,
		[UseridEdited] = @UseridEdited,
		[Viewed] = @Viewed,
		[CaseNbr] = @CaseNbr,
		[DateViewed] = @DateViewed,
		[UseWidget] = @UseWidget
	WHERE
		[PublishID] = @PublishID


	SET @Err = @@Error


	RETURN @Err
END
GO

UPDATE tblControl SET DBVersion='3.38'
GO


IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO

