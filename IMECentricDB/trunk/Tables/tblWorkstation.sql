CREATE TABLE [dbo].[tblWorkstation] (
    [WorkstationID]         INT           IDENTITY (1, 1) NOT NULL,
    [WorkstationName]       VARCHAR (250) NOT NULL,
    [Domain]                VARCHAR (25)  NULL,
    [IP]                    VARCHAR (15)  NULL,
    [DateEdited]            DATETIME      NULL,
    [DateLastLogin]         DATETIME      NULL,
    [LastWindowsUsername]   VARCHAR (100) NULL,
    [LastApp]               VARCHAR (100) NULL,
    [LoginCount]            INT           CONSTRAINT [DF_tblWorkstation_LoginCount] DEFAULT ((0)) NOT NULL,
    [OS]                    VARCHAR (100) NULL,
    [AvailFrameworkVersion] VARCHAR (20)  NULL,
    [Browser]               VARCHAR (100) NULL,
    [TotalPhysicalMB]       BIGINT        NULL,
    [AvailPhysicalMB]       BIGINT        NULL,
    [MonitorCount]          INT           NULL,
    [HorzRes]               INT           NULL,
    [VertRes]               INT           NULL,
    [ColorDepth]            INT           NULL,
    [FontSize]              INT           NULL,
    CONSTRAINT [PK_tblWorkstation] PRIMARY KEY CLUSTERED ([WorkstationID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblWorkstation_WorkstationName]
    ON [dbo].[tblWorkstation]([WorkstationName] ASC);

