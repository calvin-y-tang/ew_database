CREATE TABLE [dbo].[tblSession] (
    [PrimaryKey]      INT          IDENTITY (1, 1) NOT NULL,
    [SessionID]       VARCHAR (50) NOT NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (50) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (50) NULL,
    [AppName]         VARCHAR (30) NULL,
    [WorkstationName] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSession] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_U_tblSession_SessionID]
    ON [dbo].[tblSession]([SessionID] ASC);

