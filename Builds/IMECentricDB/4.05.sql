

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
PRINT N'Altering [dbo].[tblWebCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblWebCompany]
    ADD [TeamMembersURL] VARCHAR (100) NULL;


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
PRINT N'Creating [dbo].[tblTaxExemptCompanyEmployer]...';


GO
CREATE TABLE [dbo].[tblTaxExemptCompanyEmployer] (
    [TaxExemptCompanyEmployerID] INT          IDENTITY (1, 1) NOT NULL,
    [ParentCompanyID]            INT          NOT NULL,
    [EWParentEmployerID]         INT          NOT NULL,
    [StateCode]                  VARCHAR (2)  NULL,
    [DateAdded]                  DATETIME     NOT NULL,
    [UserIDAdded]                VARCHAR (15) NOT NULL,
    CONSTRAINT [PK_tblTaxExemptCompanyEmployer] PRIMARY KEY CLUSTERED ([TaxExemptCompanyEmployerID] ASC)
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
PRINT N'Creating [dbo].[tblTaxExemptCompanyEmployer].[IX_U_tblTaxExemptCompanyEmployer_ParentCompanyID_EWParentEmployerID_StateCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblTaxExemptCompanyEmployer_ParentCompanyID_EWParentEmployerID_StateCode]
    ON [dbo].[tblTaxExemptCompanyEmployer]([ParentCompanyID] ASC, [EWParentEmployerID] ASC, [StateCode] ASC);


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

-- Sprint 82

-- IMEC-11749 - TeamMembers security token and set URL for WebCompany
INSERT INTO tblUserFunction
VALUES('TeamMembers','Web Portal - Maintain Team Members', getDate())
GO
-- IMEC-11749
UPDATE tblWebCompany SET TeamMembersURL = 'https://portaladmin.examworks.com/login/tokenlogin?token=' 
GO
