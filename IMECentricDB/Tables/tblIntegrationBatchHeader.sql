CREATE TABLE [dbo].[tblIntegrationBatchHeader] (
    [PrimaryKey]             INT             IDENTITY (1, 1) NOT NULL,
	[ProcessName]            VARCHAR(25)     NULL,
    [BatchNbr]               INT             NULL,
    [BatchStatus]            VARCHAR (15)    NULL,
    [DateProcessed]          DATETIME        NULL,
    [DateAdded]              DATETIME        NULL,
    [UserIDAdded]            VARCHAR (15)    NULL,
    CONSTRAINT [PK_tblIntegrationBatchHeader] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
