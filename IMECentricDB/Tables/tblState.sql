CREATE TABLE [dbo].[tblState] (
    [StateCode]    VARCHAR (2)  NOT NULL,
    [StateName]    VARCHAR (50) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    [Country]      VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    CONSTRAINT [PK_tblState] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

