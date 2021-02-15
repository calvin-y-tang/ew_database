CREATE TABLE [dbo].[tblMergeLog] (
    [MergeLogID]      INT          IDENTITY (1, 1) NOT NULL,
    [MergeID]         INT          NOT NULL,
    [Action]          VARCHAR (50) NULL,
    [TableName]       VARCHAR (50) NULL,
    [PrimaryKeyName]  VARCHAR (75) NULL,
    [PrimaryKeyValue] VARCHAR (75) NULL,
    [Details]         TEXT         NULL,
    CONSTRAINT [PK_tblMergeLog] PRIMARY KEY CLUSTERED ([MergeLogID] ASC)
);

