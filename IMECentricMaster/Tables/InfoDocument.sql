CREATE TABLE [dbo].[InfoDocument] (
    [DocumentID]     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Description]    VARCHAR (70) NULL,
    [Filename]       VARCHAR (75) NULL,
    [FolderID]       INT          NULL,
    [SubFolder]      VARCHAR (25) NULL,
    [DocumentTypeID] INT          NULL,
    [FileSource]     VARCHAR (15) NULL,
    [FileExt]        VARCHAR (5)  NULL,
    [FileSize]       BIGINT       NULL,
    [Pages]          INT          NULL,
    [DateAdded]      DATETIME     NULL,
    [UserAdded]      INT          NULL,
    [DateEdited]     DATETIME     NULL,
    [UserEdited]     INT          NULL,
    [SignatureDate]  DATETIME     NULL,
    CONSTRAINT [PK_InfoDocument] PRIMARY KEY CLUSTERED ([DocumentID] ASC)
);

