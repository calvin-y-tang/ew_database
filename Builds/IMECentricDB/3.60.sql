
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
PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient]
    ADD [CRMPrimaryEmail] VARCHAR (255) NULL;


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
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [IsCommissionable] BIT NULL;


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
PRINT N'Altering [dbo].[proc_GetReferralSummarySinceLastLoginDate]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDate]

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
PRINT N'Update complete.';


GO
