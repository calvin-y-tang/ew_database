CREATE TABLE [dbo].[tblScanSetting] (
    [ScanSettingID]			INT           IDENTITY (1, 1) NOT NULL,
    [SettingName]			VARCHAR (50)  NULL,
    [DataSource]			VARCHAR (100) NULL,
    [HideUI]				INT           CONSTRAINT [DF_tblScanSetting_HideUI] DEFAULT ((1)) NOT NULL,
    [FileAppend]			INT           CONSTRAINT [DF_tblScanSetting_FileAppend] DEFAULT ((0)) NOT NULL,
    [Feeder]				INT           CONSTRAINT [DF_tblScanSetting_Feeder] DEFAULT ((1)) NOT NULL,
    [PixelType]				INT           CONSTRAINT [DF_tblScanSetting_PixelType] DEFAULT ((0)) NOT NULL,
    [Resolution]			INT           CONSTRAINT [DF_tblScanSetting_Resolution] DEFAULT ((200)) NOT NULL,
    [AutoDeskew]			INT           CONSTRAINT [DF_tblScanSetting_AutoDeskew] DEFAULT ((0)) NOT NULL,
    [BlankPageMode]			INT           CONSTRAINT [DF_tblScanSetting_BlankPageMode] DEFAULT ((0)) NOT NULL,
    [AutoScan]				INT           CONSTRAINT [DF_tblScanSetting_AutoScan] DEFAULT ((1)) NULL,
    [PromptMultiDocument]	BIT			  CONSTRAINT [DF_tblScanSetting_PromptMultiDocument] DEFAULT ((1)) NULL,
	[DuplexSupported]		BIT		      CONSTRAINT [DF_tblScanSetting_DuplexSupported] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblScanSetting] PRIMARY KEY CLUSTERED ([ScanSettingID] ASC)
);

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblScanSetting_SettingName]
    ON [dbo].[tblScanSetting]([SettingName] ASC);

