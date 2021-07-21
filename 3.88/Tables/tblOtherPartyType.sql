CREATE TABLE [dbo].[tblOtherPartyType] (
    [Type]         VARCHAR (15) NOT NULL,
    [Description]  VARCHAR (30) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (25) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblOtherPartyType] PRIMARY KEY CLUSTERED ([Type] ASC)
);

