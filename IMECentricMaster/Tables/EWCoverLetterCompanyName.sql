CREATE TABLE [dbo].[EWCoverLetterCompanyName] (
    [EWCoverLetterCompanyNameID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWCoverLetterID]            INT          NOT NULL,
    [CompanyName]                VARCHAR (80) NULL,
    [UserIDAdded]                VARCHAR (30) NULL,
    [DateAdded]                  DATETIME     NULL,
    [UserIDEdited]               VARCHAR (30) NULL,
    [DateEdited]                 DATETIME     NULL,
    CONSTRAINT [PK_EWCoverLetterCompanyName] PRIMARY KEY CLUSTERED ([EWCoverLetterCompanyNameID] ASC)
);

