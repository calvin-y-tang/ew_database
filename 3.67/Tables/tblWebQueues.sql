CREATE TABLE [dbo].[tblWebQueues] (
    [StatusCode]   INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [displayorder] INT          NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblWebQueues] PRIMARY KEY CLUSTERED ([StatusCode] ASC)
);

