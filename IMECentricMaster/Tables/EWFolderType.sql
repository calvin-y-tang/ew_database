CREATE TABLE [dbo].[EWFolderType] (
    [FolderType]          INT          NOT NULL,
    [Descrip]             VARCHAR (50) NULL,
    [SeqNo]               INT          NULL,
    [FileManager]         BIT          NULL,
    [DocumentStorage]     BIT          NULL,
    [SecurityType]        INT          NULL,
    [FunctionCodePrefix]  VARCHAR (10) NULL,
    [FunctionDescPrefix]  VARCHAR (15) NULL,
    [FileManagerNational] BIT          NULL,
    CONSTRAINT [PK_EWFolderType] PRIMARY KEY CLUSTERED ([FolderType] ASC)
);

