CREATE TABLE [dbo].[EWCompanyCoverLetter] (
    [EWCompanyCoverLetterID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWCompanyID]            INT          NOT NULL,
    [EWCoverLetterID]        INT          NOT NULL,
    [UserIDAdded]            VARCHAR (30) NULL,
    [DateAdded]              DATETIME     NULL,
    CONSTRAINT [PK_EWCompanyCoverLetter] PRIMARY KEY CLUSTERED ([EWCompanyCoverLetterID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWCompanyCoverLetter_EWCompanyIDEWCoverLetterID]
    ON [dbo].[EWCompanyCoverLetter]([EWCompanyID] ASC, [EWCoverLetterID] ASC);

