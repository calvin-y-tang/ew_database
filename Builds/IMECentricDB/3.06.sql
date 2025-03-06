--Drop DPS tables and views. Then re-create them
PRINT N'Dropping [dbo].[tblDoctorDPSSortModel]...';


GO
DROP TABLE [dbo].[tblDoctorDPSSortModel];


GO
PRINT N'Dropping [dbo].[tblDPSSortModel]...';


GO
DROP TABLE [dbo].[tblDPSSortModel];


GO
PRINT N'Dropping [dbo].[tblOfficeDPSSortModel]...';


GO
DROP TABLE [dbo].[tblOfficeDPSSortModel];


GO
PRINT N'Dropping [dbo].[vwDPSCases]...';


GO
DROP VIEW [dbo].[vwDPSCases];


GO
PRINT N'Dropping [dbo].[tblDPSBundle]...';


GO
DROP TABLE [dbo].[tblDPSBundle];


GO
PRINT N'Dropping [dbo].[tblDPSBundleCaseDocument]...';


GO
DROP TABLE [dbo].[tblDPSBundleCaseDocument];


GO














PRINT N'Creating [dbo].[tblDoctorDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblDoctorDPSSortModel] (
    [DPSDoctorSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModelID]          INT          NOT NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorDPSSortModel] PRIMARY KEY CLUSTERED ([DPSDoctorSortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSBundle]...';


GO
CREATE TABLE [dbo].[tblDPSBundle] (
    [DPSBundleID]         INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT           NOT NULL,
    [DPSStatusID]         INT           NOT NULL,
    [ExtWorkBundleID]     VARCHAR (20)  NULL,
    [ResultFileName]      VARCHAR (100) NULL,
    [FolderID]            INT           NOT NULL,
    [SubFolder]           VARCHAR (32)  NULL,
    [CombinedDPSBundleID] INT           NULL,
    [UserIDAdded]         VARCHAR (15)  NULL,
    [LastWSCall]          VARCHAR (20)  NULL,
    [LastWSDate]          DATETIME      NULL,
    [LastWSResult]        VARCHAR (20)  NULL,
    [DateAdded]           DATETIME      NULL,
    [UserIDEdited]        VARCHAR (15)  NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDSubmitted]     VARCHAR (15)  NULL,
    [DateSubmitted]       DATETIME      NULL,
    [DateSentToDPS]       DATETIME      NULL,
    [DateCompleted]       DATETIME      NULL,
    [DateCanceled]        DATETIME      NULL,
    [SortModelID]         INT           NULL,
    [Priority]            INT           NULL,
    [DueDate]             DATETIME      NULL,
    [SpecialInstructions] VARCHAR (500) NULL,
    [ContactName]         VARCHAR (100) NULL,
    [ContactPhone]        VARCHAR (15)  NULL,
    [ContactEmail]        VARCHAR (70)  NULL,
    [NotifyWhenComplete]  BIT           NULL,
    [Selected]            BIT           NOT NULL,
    [DateAcknowledged]    DATETIME      NULL,
    CONSTRAINT [PK_tblDPSBundle] PRIMARY KEY CLUSTERED ([DPSBundleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSBundleCaseDocument]...';


GO
CREATE TABLE [dbo].[tblDPSBundleCaseDocument] (
    [DPSBundleID] INT NOT NULL,
    [CaseDocID]   INT NOT NULL,
    CONSTRAINT [PK_tblDPSBundleCaseDocument] PRIMARY KEY CLUSTERED ([CaseDocID] ASC, [DPSBundleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblDPSSortModel] (
    [SortModelID]      INT          IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (50) NULL,
    [ExtSortModelCode] VARCHAR (20) NULL,
    CONSTRAINT [PK_tblDPSSortModel] PRIMARY KEY CLUSTERED ([SortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSStatus]...';


GO
CREATE TABLE [dbo].[tblDPSStatus] (
    [DPSStatusID] INT          NOT NULL,
    [Name]        VARCHAR (20) NULL,
    CONSTRAINT [PK_tblDPSStatus] PRIMARY KEY CLUSTERED ([DPSStatusID] ASC)
);


GO
PRINT N'Creating [dbo].[tblOfficeDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblOfficeDPSSortModel] (
    [DPSOfficeSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [Officecode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModelID]          INT          NOT NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblOfficeDPSSortModel] PRIMARY KEY CLUSTERED ([DPSOfficeSortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblDPSBundle_DPSStatusID]...';


GO
ALTER TABLE [dbo].[tblDPSBundle]
    ADD CONSTRAINT [DF_tblDPSBundle_DPSStatusID] DEFAULT ((0)) FOR [DPSStatusID];


GO
PRINT N'Creating [dbo].[DF_tblDPSBundle_Selected]...';


GO
ALTER TABLE [dbo].[tblDPSBundle]
    ADD CONSTRAINT [DF_tblDPSBundle_Selected] DEFAULT ((0)) FOR [Selected];


GO
PRINT N'Creating [dbo].[vwDPSCases]...';


GO
CREATE VIEW dbo.vwDPSCases
AS
    SELECT DISTINCT
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
        B.Selected,
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
        E.ChartNbr
    FROM
        tblDPSBundle AS B
    LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
    LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
    LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
    LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
    LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode
GO











UPDATE tblControl SET DBVersion='3.06'
GO
