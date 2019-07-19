CREATE TABLE [dbo].[tblCaseDocumentTransfer]
(
	[CaseDocumentTransferID] INT IDENTITY (1, 1) NOT NULL, 
    [CaseNbr]                INT NOT NULL, 
    [SeqNo]                  INT NOT NULL, 
    [OfficeCode]             INT NOT NULL, 
    [FileName]               VARCHAR(255) NOT NULL, 
    [FolderID]               INT NOT NULL, 
    [SubFolder]              VARCHAR(32) NULL, 
    [DateAdded]              DATETIME NOT NULL, 
    [UserIDAdded]            VARCHAR(15) NOT NULL, 
    [DateEdited]             DATETIME NULL, 
    [UserIDEdited]           VARCHAR(15) NULL, 
    [TransferType]           INT NULL, 
    [TransferDateTime]       DATETIME NULL, 
    [StatusCode]             VARCHAR(12) NULL, 
    [StatusMessage]          VARCHAR(2048) NULL ,
    [TransmitFileName] VARCHAR(255) NULL, 
    [DocumentControlNumber] VARCHAR(128) NULL, 
    CONSTRAINT [PK_tblCaseDocumentTransfer] PRIMARY KEY CLUSTERED ([CaseDocumentTransferID] ASC)
);
