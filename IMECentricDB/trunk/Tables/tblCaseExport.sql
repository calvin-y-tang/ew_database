CREATE TABLE [dbo].[tblCaseExport] (
    [PrimaryKey]             INT             IDENTITY (1, 1) NOT NULL,
	[ProcessName]            VARCHAR(50)     NULL,
    [BatchNbr]               INT             NULL,
	[TableType]              VARCHAR(50)     NULL,
    [TableKey]               INT             NOT NULL,
	[Param]                  VARCHAR(100)    NULL,
    [DateAdded]              DATETIME        NULL,
    [UserIDAdded]            VARCHAR (50)    NULL,
    CONSTRAINT [PK_tblCaseExport] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
