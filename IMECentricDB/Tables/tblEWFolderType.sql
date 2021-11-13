CREATE TABLE [dbo].[tblEWFolderType] (
    [FolderType]          INT          NOT NULL,
    [Descrip]             VARCHAR (50) NULL,
    [SeqNo]               INT          NULL,
    [FileManager]         BIT          NULL,
    [DocumentStorage]     BIT          NULL,
    [FunctionCodePrefix]  VARCHAR (10) NULL,
    [FunctionDescPrefix]  VARCHAR (15) NULL,
    [FileManagerNational] BIT          NULL,
    [SecurityType]        INT          NULL,
    CONSTRAINT [PK_tblEWFolderType] PRIMARY KEY CLUSTERED ([FolderType] ASC)
);

