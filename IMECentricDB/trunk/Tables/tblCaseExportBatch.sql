CREATE TABLE [dbo].[tblCaseExportBatch] (
    [PrimaryKey]             INT             IDENTITY (1, 1) NOT NULL,
	[ProcessName]            VARCHAR(50)     NULL,
    [BatchNbr]               INT             NOT NULL,
    [DateAdded]              DATETIME        NULL,
    [UserIDAdded]            VARCHAR (50)    NULL,
    [DateProcessed]          DATETIME        NULL,
    [BatchStatus]            VARCHAR (50)    NULL,
    CONSTRAINT [PK_tblCaseExportBatch] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


