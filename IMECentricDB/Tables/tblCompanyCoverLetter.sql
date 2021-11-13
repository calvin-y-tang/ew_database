CREATE TABLE [dbo].[tblCompanyCoverLetter] (
    [CompanyCoverLetterID] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyCode]          INT          NOT NULL,
    [EWCoverLetterID]      INT          NOT NULL,
    [UserIDAdded]          VARCHAR (30) NULL,
    [DateAdded]            DATETIME     NULL,
    CONSTRAINT [PK_tblCompanyCoverLetter] PRIMARY KEY CLUSTERED ([CompanyCoverLetterID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCompanyCoverLetter_CompanyCodeEWCoverLetterID]
    ON [dbo].[tblCompanyCoverLetter]([CompanyCode] ASC, [EWCoverLetterID] ASC);

