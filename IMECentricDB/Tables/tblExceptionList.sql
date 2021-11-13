CREATE TABLE [dbo].[tblExceptionList] (
    [ExceptionID]  INT           NOT NULL,
    [Description]  VARCHAR (100) NOT NULL,
    [Status]       VARCHAR (10)  CONSTRAINT [DF_tblExceptionList_Status] DEFAULT ('Active') NULL,
    [DateAdded]    DATETIME      NULL,
    [UserIDAdded]  VARCHAR (50)  NULL,
    [DateEdited]   DATETIME      NULL,
    [UserIDEdited] VARCHAR (50)  NULL,
    [Type]         VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblExceptionList] PRIMARY KEY CLUSTERED ([ExceptionID] ASC)
);

