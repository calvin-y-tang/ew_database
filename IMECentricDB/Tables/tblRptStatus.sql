CREATE TABLE [dbo].[tblRptStatus] (
    [rptCode]      INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (30) NULL,
    [OnWeb]        BIT          NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (25) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblRptStatus] PRIMARY KEY CLUSTERED ([rptCode] ASC)
);

