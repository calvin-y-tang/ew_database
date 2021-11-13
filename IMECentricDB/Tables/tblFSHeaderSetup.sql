CREATE TABLE [dbo].[tblFSHeaderSetup] (
    [FSHeaderSetupID] INT          IDENTITY (1, 1) NOT NULL,
    [FSGroupID]       INT          NULL,
    [FSHeaderID]      INT          NULL,
    [FeeScheduleName] VARCHAR (50) NULL,
    [DocumentType]    VARCHAR (2)  NULL,
    [EntityType]      VARCHAR (2)  NULL,
    [StartDate]       DATETIME     NULL,
    [EndDate]         DATETIME     NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (30) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSHeaderSetup] PRIMARY KEY CLUSTERED ([FSHeaderSetupID] ASC)
);

