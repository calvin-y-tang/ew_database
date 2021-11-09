CREATE TABLE [dbo].[InfoDocumentCategory] (
    [CategoryID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]       VARCHAR (30) NULL,
    [Dept]       VARCHAR (10) NULL,
    [SeqNo]      INT          NULL,
    CONSTRAINT [PK_InfoDocumentCategory] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

