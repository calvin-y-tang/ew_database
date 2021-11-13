CREATE TABLE [dbo].[NDBUser] (
    [UserID]                INT          NOT NULL,
    [Version]               VARCHAR (15) NULL,
    [DateLastLogin]         DATETIME     NULL,
    [LoginCount]            INT          CONSTRAINT [DF_NDBUser_LoginCount] DEFAULT ((0)) NOT NULL,
    [LastComputerName]      VARCHAR (30) NULL,
    [HorzRes]               INT          CONSTRAINT [DF_NDBUser_HorzRes] DEFAULT ((0)) NOT NULL,
    [VertRes]               INT          CONSTRAINT [DF_NDBUser_VertRes] DEFAULT ((0)) NOT NULL,
    [MonitorCount]          INT          CONSTRAINT [DF_NDBUser_MonitorCount] DEFAULT ((0)) NOT NULL,
    [TotalPhysicalMB]       BIGINT       CONSTRAINT [DF_NDBUser_TotalPhysicalMB] DEFAULT ((0)) NOT NULL,
    [AvailPhysicalMB]       BIGINT       CONSTRAINT [DF_NDBUser_AvailPhysicalMB] DEFAULT ((0)) NOT NULL,
    [Domain]                VARCHAR (25) NULL,
    [OSVersion]             VARCHAR (50) NULL,
    [AvailFrameworkVersion] VARCHAR (20) NULL,
    CONSTRAINT [PK_NDBUser] PRIMARY KEY CLUSTERED ([UserID] ASC) WITH (FILLFACTOR = 90)
);

