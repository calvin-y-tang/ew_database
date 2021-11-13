CREATE TABLE [dbo].[tblProviderType] (
    [ProvTypeCode] INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (20) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (20) NULL,
    [PublishOnWeb] BIT          NULL,
    [WebSynchDate] DATETIME     NULL,
    [WebID]        INT          NULL,
    CONSTRAINT [PK_tblProviderType] PRIMARY KEY CLUSTERED ([ProvTypeCode] ASC)
);

