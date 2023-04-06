CREATE TABLE [dbo].[tblIntegrationBatchDetail] (
    [PrimaryKey]             INT             IDENTITY (1, 1) NOT NULL,
	[ProcessName]            VARCHAR(25)     NULL,
    [BatchNbr]               INT             NOT NULL,
	[TableType]              VARCHAR(50)     NULL,
    [TableKey]               INT             NOT NULL,
	[Param]                  VARCHAR(200)    NULL,
    [DateAdded]              DATETIME        NULL,
    [UserIDAdded]            VARCHAR (15)    NULL,
    CONSTRAINT [PK_tblIntegrationBatchDetail] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


