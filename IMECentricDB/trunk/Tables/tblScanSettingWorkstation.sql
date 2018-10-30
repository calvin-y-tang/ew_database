CREATE TABLE [dbo].[tblScanSettingWorkstation] (
    [WorkstationName] VARCHAR (50) NOT NULL,
    [ScanSettingID]   INT          NOT NULL,
    [EnableLogFile]   BIT          CONSTRAINT [DF_tblScanSettingWorkstation_EnableLogFile] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblScanSettingWorkstation] PRIMARY KEY CLUSTERED ([WorkstationName] ASC, [ScanSettingID] ASC)
);

