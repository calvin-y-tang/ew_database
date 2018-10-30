CREATE TABLE [dbo].[tblRecordActions] (
    [ActionID]     INT           IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (100) NULL,
    [Type]         VARCHAR (20)  NULL,
    [INProdCode]   INT           NULL,
    [VOProdCode]   INT           NULL,
    [Status]       VARCHAR (50)  CONSTRAINT [DF_tblRecordActions_Status] DEFAULT ('Active') NULL,
    [DateEdited]   DATETIME      NULL,
    [UserIDEdited] VARCHAR (50)  NULL,
    [DateAdded]    DATETIME      NULL,
    [UserIDAdded]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblRecordActions] PRIMARY KEY CLUSTERED ([ActionID] ASC)
);

