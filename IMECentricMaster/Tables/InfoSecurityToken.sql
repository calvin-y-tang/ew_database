CREATE TABLE [dbo].[InfoSecurityToken] (
    [SecurityTokenID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]            VARCHAR (60) NOT NULL,
    [SeqNo]           INT          NULL,
    [TokenType]       INT          NULL,
    [ReferenceID]     INT          NULL,
    CONSTRAINT [PK_InfoSecurityToken] PRIMARY KEY NONCLUSTERED ([SecurityTokenID] ASC) WITH (FILLFACTOR = 90)
);

