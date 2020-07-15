CREATE TABLE [dbo].[tblCaseRecRetrievalDocument] (
    [RecRetrievalDocumentID] INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                INT           NOT NULL,
    [RetrievalDocExtKey]     VARCHAR (100) NULL,
    [DateAdded]              DATETIME      NULL,
    [UserIDAdded]            VARCHAR (15)  NULL,
    [DateEdited]             DATETIME      NULL,
    [UserIDEdited]           VARCHAR (15)  NULL,
    [RetrievalStart]         DATETIME      NULL,
    [RetrievalEnd]           DATETIME      NULL,
    [CaseDocID]              INT           NULL,
    [RetrievalStatusID]      INT           CONSTRAINT [DF_tblCaseRecRetrievalDocument_RetrievalStatusID] DEFAULT ((0)) NOT NULL,
    [Description]            VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([RecRetrievalDocumentID] ASC)
);


