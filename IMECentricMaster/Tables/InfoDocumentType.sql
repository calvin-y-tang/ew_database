CREATE TABLE [dbo].[InfoDocumentType] (
    [DocumentTypeID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]           VARCHAR (50) NULL,
    [SeqNo]          INT          NULL,
    [CategoryID]     INT          NULL,
    [FolderID]       INT          NULL,
    [Confidential]   BIT          NULL,
    CONSTRAINT [PK_InfoDocumentType] PRIMARY KEY CLUSTERED ([DocumentTypeID] ASC)
);

