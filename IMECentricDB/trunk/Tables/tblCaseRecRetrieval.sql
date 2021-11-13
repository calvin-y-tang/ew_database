CREATE TABLE [dbo].[tblCaseRecRetrieval] (
    [RecRetrievalID]  INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]         INT           NOT NULL,
    [RetrievalExtKey] VARCHAR (100) NULL,
    [DateAdded]       DATETIME      NULL,
    [UserIDAdded]     VARCHAR (15)  NULL,
    [DateEdited]      DATETIME      NULL,
    [UserIDEdited]    VARCHAR (15)  NULL,
    [ConfidenceValue] INT           NULL,
    [FirstName]       VARCHAR (50)  NULL,
    [LastName]        VARCHAR (50)  NULL,
    [FirmName]        VARCHAR (100) NULL,
    [ClaimNbr]        VARCHAR (50)  NULL,
    [DOB]             DATE          NULL,
    CONSTRAINT [PK_tblCaseRecRetrieval] PRIMARY KEY CLUSTERED ([RecRetrievalID] ASC)
);



GO

CREATE INDEX [IX_tblCaseRecRetrieval_CaseNbr] ON [dbo].[tblCaseRecRetrieval] ([CaseNbr])
