CREATE TABLE [dbo].[ISSetting] (
    [SettingID]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [NewNPEntityNotifyEmail] VARCHAR (140) NULL,
    CONSTRAINT [PK_ISSetting] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);

