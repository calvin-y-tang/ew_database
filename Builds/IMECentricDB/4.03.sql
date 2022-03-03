


GO

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
PRINT N'Creating [dbo].[tblConfirmationDoNotCall]...';


GO
CREATE TABLE [dbo].[tblConfirmationDoNotCall] (
    [ConfirmationDoNotCallID] INT           IDENTITY (1, 1) NOT NULL,
    [PhoneNumber]             VARCHAR (15)  NOT NULL,
    [PhoneNumberDashes]       VARCHAR (15)  NOT NULL,
    [PhoneNumberParen]        VARCHAR (15)  NOT NULL,
    [RequestedBy]             VARCHAR (100) NULL,
    [PhoneCall]               BIT           NOT NULL,
    [Fax]                     BIT           NOT NULL,
    [Email]                   BIT           NOT NULL,
    [Text]                    BIT           NOT NULL,
    [ConfirmationCall]        BIT           NOT NULL,
    [DateAdded]               DATETIME      NOT NULL,
    [UserIDAdded]             VARCHAR (15)  NOT NULL,
    [ConfirmationListID]      INT           NULL,
    CONSTRAINT [PK_tblConfirmationDoNotCall] PRIMARY KEY CLUSTERED ([ConfirmationDoNotCallID] ASC)
);


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
PRINT N'Creating [dbo].[tblConfirmationDoNotCall].[IX_tblConfirmationDoNotCall_PhoneNumberFormats]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationDoNotCall_PhoneNumberFormats]
    ON [dbo].[tblConfirmationDoNotCall]([PhoneNumber] ASC, [PhoneNumberDashes] ASC, [PhoneNumberParen] ASC);


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
PRINT N'Creating [dbo].[DF_tblConfirmationDoNotCall_Text]...';


GO
ALTER TABLE [dbo].[tblConfirmationDoNotCall]
    ADD CONSTRAINT [DF_tblConfirmationDoNotCall_Text] DEFAULT ((0)) FOR [Text];


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
PRINT N'Creating [dbo].[DF_tblConfirmationDoNotCall_Fax]...';


GO
ALTER TABLE [dbo].[tblConfirmationDoNotCall]
    ADD CONSTRAINT [DF_tblConfirmationDoNotCall_Fax] DEFAULT ((0)) FOR [Fax];


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
PRINT N'Creating [dbo].[DF_tblConfirmationDoNotCall_ConfirmationCall]...';


GO
ALTER TABLE [dbo].[tblConfirmationDoNotCall]
    ADD CONSTRAINT [DF_tblConfirmationDoNotCall_ConfirmationCall] DEFAULT ((0)) FOR [ConfirmationCall];


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
PRINT N'Creating [dbo].[DF_tblConfirmationDoNotCall_PhoneCall]...';


GO
ALTER TABLE [dbo].[tblConfirmationDoNotCall]
    ADD CONSTRAINT [DF_tblConfirmationDoNotCall_PhoneCall] DEFAULT ((0)) FOR [PhoneCall];


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
PRINT N'Creating [dbo].[DF_tblConfirmationDoNotCall_Email]...';


GO
ALTER TABLE [dbo].[tblConfirmationDoNotCall]
    ADD CONSTRAINT [DF_tblConfirmationDoNotCall_Email] DEFAULT ((0)) FOR [Email];


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
-- IMEC-12561 - add new status for Confirmation Calls
INSERT INTO tblConfirmationStatus(ConfirmationStatusID, Name)
VALUES(113, 'Skipped Do Not Call')
GO


-- IMEC-12559 - need to add the "OptOut" option to Confirmation Results
INSERT INTO tblConfirmationResult (ResultCode, Description, IsSuccessful, HandleMethod, ConfirmationSystemID)
VALUES('OptOut', 'Add phone to Do Not Call List', 0, 3, 1)
GO

-- IMEC-12570 - new security tokens for Confirmation Do Not Call form.
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('ConfirmationDoNotCallAdd', 'Confirmtion - Do Not Call Add/Edit', GETDATE()), 
      ('ConfirmationDoNotCallDel', 'Confirmtion - Do Not Call Delete', GETDATE())
GO


-- IMEC-12587 - code clean-up removing this setting since it is no longer being used
  DELETE FROM tblSetting WHERE NAME = 'UseOldAttachExternalCaseDoc'

