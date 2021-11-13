CREATE TABLE [dbo].[tblWebQueuesV2] (
    [StatusCode]   INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [DisplayOrder] INT          NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblWebQueuesV2] PRIMARY KEY CLUSTERED ([StatusCode] ASC)
);

