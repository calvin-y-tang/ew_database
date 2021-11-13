

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
PRINT N'Altering [dbo].[tblDPSPriority]...';


GO
ALTER TABLE [dbo].[tblDPSPriority] ALTER COLUMN [ExtPriorityCode] VARCHAR (25) NULL;


GO
ALTER TABLE [dbo].[tblDPSPriority]
    ADD [DueDateMethod] INT NULL,
        [DueDateHours]  INT NULL;


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
PRINT N'Altering [dbo].[tblDPSSortModel]...';


GO
ALTER TABLE [dbo].[tblDPSSortModel] ALTER COLUMN [ExtSortModelCode] VARCHAR (30) NULL;


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
PRINT N'Altering [dbo].[tblDPSStatus]...';


GO
ALTER TABLE [dbo].[tblDPSStatus] ALTER COLUMN [Name] VARCHAR (30) NULL;


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
PRINT N'Altering [dbo].[vwDPSCases]...';


GO
ALTER VIEW dbo.vwDPSCases
AS
    SELECT 
        C.CaseNbr,
        C.ExtCaseNbr,
        B.DPSBundleID,
        DATEDIFF(d, B.DateEdited, GETDATE()) AS IQ,
        E.FirstName+' '+E.LastName AS ExamineeName,
        Com.IntName AS CompanyName,
        D.FirstName+' '+D.LastName AS DoctorName,
        C.ApptTime,
        B.ContactName,
		B.DateCompleted,
        B.DPSStatusID,       
        B.DateAcknowledged,
        C.OfficeCode,
        C.ServiceCode,
        C.SchedulerCode,
        C.QARep,
        C.MarketerCode,
        Com.ParentCompanyID,
        C.DoctorLocation,
        D.DoctorCode,
        Com.CompanyCode,
        C.CaseType,
        E.ChartNbr,
		S.Name AS Status
    FROM
        tblDPSBundle AS B
	LEFT OUTER JOIN tblDPSStatus AS S ON S.DPSStatusID = B.DPSStatusID
    LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
    LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
    LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
    LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
    LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode
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
PRINT N'Creating [dbo].[proc_CheckForExamineeDupeProgressive]...';


GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'proc_CheckForExamineeDupeProgressive')
DROP PROCEDURE proc_CheckForExamineeDupeProgressive
GO

CREATE PROCEDURE [proc_CheckForExamineeDupeProgressive]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@ClaimNbr varchar(50),
	@FeatureNbr varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 *

	FROM [tblExaminee]
		INNER JOIN tblCase ON tblExaminee.ChartNbr = tblCase.ChartNbr
		WHERE (tblExaminee.FirstName = @firstName)
		AND (tblExaminee.LastName = @lastName)	
		AND (tblCase.ClaimNbr = @ClaimNbr)
		AND (tblCase.ClaimNbrExt = @FeatureNbr)

	ORDER BY tblCase.DateAdded DESC

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
TRUNCATE TABLE tblDPSPriority
TRUNCATE TABLE tblDPSSortModel
TRUNCATE TABLE tblDPSStatus

SET IDENTITY_INSERT [dbo].[tblDPSPriority] ON
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (1, 'Standard (24hr)', 'Standard (24hr)', 2, 24)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (2, 'Rush (4hr)', 'Rush (4hr)', 1, 4)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (3, 'Complex (48hr)', 'Complex (48hr)', 2, 48)
SET IDENTITY_INSERT [dbo].[tblDPSPriority] OFF
GO
SET IDENTITY_INSERT [dbo].[tblDPSSortModel] ON
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (11, 'Chronological Order', 'Chronological Order')
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (12, 'Chart Order', 'Chart Order')
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (13, 'Special Request', 'Special Request')
SET IDENTITY_INSERT [dbo].[tblDPSSortModel] OFF
GO
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (0, 'New')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (10, 'Submitted (Pending)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (20, 'Submitted')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (30, 'Submitted (Preparing)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (40, 'Reviewing')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (70, 'Combined')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (80, 'Complete')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (85, 'Canceled (Pending)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (90, 'Canceled')
GO
