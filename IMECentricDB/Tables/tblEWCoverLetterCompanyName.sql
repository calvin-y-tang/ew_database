CREATE TABLE [dbo].[tblEWCoverLetterCompanyName] (
    [EWCoverLetterCompanyNameID] INT          NOT NULL,
    [EWCoverLetterID]            INT          NOT NULL,
    [CompanyName]                VARCHAR (80) NULL,
    [UserIDAdded]                VARCHAR (30) NULL,
    [DateAdded]                  DATETIME     NULL,
    [UserIDEdited]               VARCHAR (30) NULL,
    [DateEdited]                 DATETIME     NULL,
    CONSTRAINT [PK_tblEWCoverLetterCompanyName] PRIMARY KEY CLUSTERED ([EWCoverLetterCompanyNameID] ASC)
);

