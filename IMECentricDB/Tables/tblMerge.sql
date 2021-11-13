CREATE TABLE [dbo].[tblMerge] (
    [MergeID]     INT           IDENTITY (1, 1) NOT NULL,
    [MergeDate]   DATETIME      NOT NULL,
    [MergeByUser] VARCHAR (25)  NULL,
    [EntityType]  VARCHAR (15)  NULL,
    [MergeFromID] INT           NOT NULL,
    [MergeToID]   INT           NOT NULL,
    [Descrip]     VARCHAR (100) NULL,
    CONSTRAINT [PK_tblMerge] PRIMARY KEY CLUSTERED ([MergeID] ASC)
);

