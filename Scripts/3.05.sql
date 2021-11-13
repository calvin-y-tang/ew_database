PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [AwaitingScheduling]    DATETIME NULL,
        [TATAwaitingScheduling] INT      NULL;


GO
PRINT N'Altering [dbo].[tblCaseSLARuleDetail]...';


GO
ALTER TABLE [dbo].[tblCaseSLARuleDetail]
    ADD [SLAExceptionID] INT           NULL,
        [Explanation]    VARCHAR (120) NULL;


GO
PRINT N'Altering [dbo].[tblCompanyOffice]...';


GO
ALTER TABLE [dbo].[tblCompanyOffice]
    ADD [SuppressWeb] BIT CONSTRAINT [DF_tblCompanyOffice_SuppressWEb] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DPSUserID]   VARCHAR (50) NULL,
        [DPSPassword] VARCHAR (50) NULL;


GO
PRINT N'Altering [dbo].[tblEWBulkBilling]...';


GO
ALTER TABLE [dbo].[tblEWBulkBilling]
    ADD [EDITransmitNote] BIT NULL;


GO
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [LongDesc] VARCHAR (250) NULL;


GO
PRINT N'Creating [dbo].[tblEvent]...';


GO
CREATE TABLE [dbo].[tblEvent] (
    [EventID]  INT           NOT NULL,
    [Descrip]  VARCHAR (100) NULL,
    [Category] VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblEvent] PRIMARY KEY CLUSTERED ([EventID] ASC)
);


GO
PRINT N'Creating [dbo].[tblExternalCommunications]...';


GO
CREATE TABLE [dbo].[tblExternalCommunications] (
    [CommunicationID]   INT            IDENTITY (1, 1) NOT NULL,
    [DateAdded]         DATETIME       NOT NULL,
    [EventDate]         DATETIME       NOT NULL,
    [CaseNbr]           INT            NULL,
    [ChartNbr]          INT            NULL,
    [CaseHistoryID]     INT            NULL,
    [UserID]            VARCHAR (15)   NULL,
    [DoctorCode]        INT            NULL,
    [DoctorSpecialty]   VARCHAR (50)   NULL,
    [ApptDateTime]      DATETIME       NULL,
    [DateCanceled]      DATETIME       NULL,
    [CaseHistoryType]   VARCHAR (20)   NULL,
    [EWBusLineID]       INT            NULL,
    [EWServiceTypeID]   INT            NULL,
    [OfficeCode]        INT            NULL,
    [ApptLocationCode]  INT            NULL,
    [ClaimNbr]          VARCHAR (50)   NULL,
    [EWFacilityID]      INT            NULL,
    [BusUnitGroupID]    INT            NULL,
    [CommunicationSent] DATETIME       NULL,
    [CommunicationAck]  DATETIME       NULL,
    [LastError]         VARCHAR (1024) NULL,
    [Overridden]        BIT            NULL,
    [TransmitFileName]  VARCHAR (256)  NULL,
    [AckFileName]       VARCHAR (256)  NULL,
    CONSTRAINT [PK_tblExternalCommunications] PRIMARY KEY CLUSTERED ([CommunicationID] ASC)
);


GO
PRINT N'Creating [dbo].[tblSLAException]...';


GO
CREATE TABLE [dbo].[tblSLAException] (
    [SLAExceptionID]      INT           IDENTITY (1, 1) NOT NULL,
    [SLAExceptionGroupID] INT           NOT NULL,
    [Descrip]             VARCHAR (150) NULL,
    [Active]              BIT           NOT NULL,
    [DateAdded]           DATETIME      NULL,
    [UserIDAdded]         VARCHAR (15)  NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDEdited]        VARCHAR (15)  NULL,
    [ExternalCode]        VARCHAR (10)  NULL,
    [RequireExplanation]  BIT           NOT NULL,
    CONSTRAINT [PK_tblSLAException] PRIMARY KEY CLUSTERED ([SLAExceptionID] ASC)
);


GO
PRINT N'Creating [dbo].[tblSLAExceptionGroup]...';


GO
CREATE TABLE [dbo].[tblSLAExceptionGroup] (
    [SLAExceptionGroupID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]        INT          NOT NULL,
    [Active]              BIT          NOT NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [ParentCompanyID]     INT          NULL,
    CONSTRAINT [PK_tblSLAExceptionGroup] PRIMARY KEY CLUSTERED ([SLAExceptionGroupID] ASC)
);


GO
PRINT N'Creating [dbo].[tblTATCalculationMethodEvent]...';


GO
CREATE TABLE [dbo].[tblTATCalculationMethodEvent] (
    [TATCalculationMethodID] INT NOT NULL,
    [EventID]                INT NOT NULL,
    CONSTRAINT [PK_tblTATCalculationMethodEvent] PRIMARY KEY CLUSTERED ([TATCalculationMethodID] ASC, [EventID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblSLAException_Active]...';


GO
ALTER TABLE [dbo].[tblSLAException]
    ADD CONSTRAINT [DF_tblSLAException_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating [dbo].[DF_tblSLAException_RequireExplanation]...';


GO
ALTER TABLE [dbo].[tblSLAException]
    ADD CONSTRAINT [DF_tblSLAException_RequireExplanation] DEFAULT ((0)) FOR [RequireExplanation];


GO
PRINT N'Creating [dbo].[DF_tblSLAExceptionGroup_Active]...';


GO
ALTER TABLE [dbo].[tblSLAExceptionGroup]
    ADD CONSTRAINT [DF_tblSLAExceptionGroup_Active] DEFAULT ((1)) FOR [Active];


GO








PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DPSFolderID] INT NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [ServiceIncludeExclude] BIT NULL;


GO
PRINT N'Altering [dbo].[tblSLARule]...';


GO
ALTER TABLE [dbo].[tblSLARule]
    ADD [UseException] BIT CONSTRAINT [DF_tblSLARule_UseException] DEFAULT ((0)) NOT NULL;


GO
























UPDATE tblControl SET DBVersion='3.05'
GO
