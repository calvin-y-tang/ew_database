CREATE TABLE [dbo].[tblSetting] (
    [SettingID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (30) NULL,
    [Value]     VARCHAR (1024) NULL,
    CONSTRAINT [PK_tblSetting] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSetting_Name]
    ON [dbo].[tblSetting]([Name] ASC);

