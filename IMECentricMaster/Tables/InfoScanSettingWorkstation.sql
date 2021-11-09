CREATE TABLE [dbo].[InfoScanSettingWorkstation] (
    [WorkstationName] VARCHAR (50) NOT NULL,
    [ScanSettingID]   INT          NOT NULL,
    CONSTRAINT [PK_InfoScanSettingWorkstation] PRIMARY KEY CLUSTERED ([WorkstationName] ASC, [ScanSettingID] ASC)
);

