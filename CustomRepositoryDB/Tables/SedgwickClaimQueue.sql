CREATE TABLE [dbo].[SedgwickClaimQueue] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [ClaimUniqueId]        VARCHAR (32)  NOT NULL,
    [SerializedClaimData]  VARCHAR (MAX) NOT NULL,
    [DateAdded]            DATETIME      CONSTRAINT [DF_SedgwickClaimQueue_DateAdded] DEFAULT (getdate()) NOT NULL,
    [DateLastProcessed]    DATETIME      CONSTRAINT [DF_SedgwickClaimQueue_DateLastProcessed] DEFAULT (getdate()) NOT NULL,
    [Status]               VARCHAR (16)  CONSTRAINT [DF_SedgwickClaimQueue_Status] DEFAULT ('New') NOT NULL,
    [LastErrorMessage]     VARCHAR (MAX) NULL,
    [TotalProcessAttempts] SMALLINT      CONSTRAINT [DF_SedgwickClaimQueue_TotalProcessAttempts] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SedgwickClaimQueue] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClaimUniqueId]
    ON [dbo].[SedgwickClaimQueue]([ClaimUniqueId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ClaimStatus]
    ON [dbo].[SedgwickClaimQueue]([Status] ASC);

