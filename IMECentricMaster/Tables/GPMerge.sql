CREATE TABLE [dbo].[GPMerge] (
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProcessedFlag]  BIT           CONSTRAINT [DF_GPMerge_ProcessedFlag] DEFAULT ((0)) NOT NULL,
    [MergeDate]      DATETIME      NOT NULL,
    [MergeByUser]    VARCHAR (25)  NULL,
    [EntityType]     VARCHAR (15)  NULL,
    [GPEntityPrefix] VARCHAR (3)   NULL,
    [MergeFromID]    INT           NOT NULL,
    [MergeToID]      INT           NOT NULL,
    [Descrip]        VARCHAR (100) NULL,
    [MergeFromGPID]  VARCHAR (15)  NULL,
    [MergeToGPID]    VARCHAR (15)  NULL,
    CONSTRAINT [PK_GPMerge] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

