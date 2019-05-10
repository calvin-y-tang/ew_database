CREATE TABLE [dbo].[tblCaseTypeOffice] (
    [CaseType]    INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_tblCaseTypeOffice] PRIMARY KEY CLUSTERED ([CaseType] ASC, [OfficeCode] ASC)
);

