CREATE TABLE [dbo].[tblPriority] (
    [PriorityCode] VARCHAR (50) NOT NULL,
    [Description]  VARCHAR (50) NOT NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (50) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    [Rank]         INT          NULL,
    CONSTRAINT [PK_tblPriority] PRIMARY KEY NONCLUSTERED ([PriorityCode] ASC)
);

