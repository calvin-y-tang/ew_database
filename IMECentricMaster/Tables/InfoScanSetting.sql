CREATE TABLE [dbo].[InfoScanSetting] (
    [ScanSettingID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DisplayName]            VARCHAR (50) NULL,
    [DataSource]             VARCHAR (50) NULL,
    [DeviceUI]               BIT          NULL,
    [DeviceProgress]         BIT          NULL,
    [PixelType]              INT          NULL,
    [Resolution]             INT          NULL,
    [AutoFeed]               BIT          NULL,
    [AutoScan]               BIT          NULL,
    [Duplex]                 BIT          NULL,
    [AutoDiscardBlankPages]  INT          NULL,
    [CustomRemoveBlankPages] FLOAT (53)   NULL,
    [JpegQuality]            INT          NULL,
    CONSTRAINT [PK_InfoScanSetting] PRIMARY KEY CLUSTERED ([ScanSettingID] ASC)
);

