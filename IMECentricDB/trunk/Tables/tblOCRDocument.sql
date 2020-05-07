CREATE TABLE [dbo].[tblOCRDocument] (
    [OCRDocumentID]       INT           IDENTITY (1, 1) NOT NULL,
    [OCRSystemID]         INT           NULL,
    [CaseDocID]           INT           NOT NULL,
    [OCRStatusID]         INT           NOT NULL,
    [ExtOCRDocumentID]    VARCHAR (50)  NULL,
    [DateAdded]           DATETIME      NOT NULL,
    [UserIDAdded]         VARCHAR (20)  NOT NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDEdited]        VARCHAR (20)  NULL,
    [DateDue]             DATETIME      NULL,
    [DateCompleted]       DATETIME      NULL,
    [OriginalFileName]    VARCHAR (200) NULL,
    [OriginalFileDateUtc] DATETIME      NULL,
    [OriginalFileSizeKB]  BIGINT        NULL,
    [OCRServer]           VARCHAR (15)  NULL,
    [Priority]            INT           NULL,
    [Source]              VARCHAR (20)  NULL,
    [DateReadyOCR]		  DATETIME      NULL, 
    [DateSent]            DATETIME      NULL, 
    [DateReceived]        DATETIME      NULL, 
    CONSTRAINT [PK_tblOCRDocument] PRIMARY KEY CLUSTERED ([OCRDocumentID] ASC)
);



