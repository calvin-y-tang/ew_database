CREATE TABLE [dbo].[InfoConfig] (
    [ConfigID]                INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MaintenanceAccessLevel]  INT NULL,
    [SysTimeInterval]         INT NULL,
    [ExitWaitInterval]        INT NULL,
    [IsTestSystem]            BIT NULL,
    [PromptRemoveFromRelease] BIT NULL,
    CONSTRAINT [PK_InfoConfig] PRIMARY KEY CLUSTERED ([ConfigID] ASC)
);

