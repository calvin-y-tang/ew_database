CREATE TABLE [dbo].[tblCompanyCertifiedMail]
(
    [CompanyCertifiedMailID] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyCode]            INT          NOT NULL,
    [CaseTypeCode]           INT          NOT NULL,
    [CertMailActivityID]     INT          NOT NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDAdded]            VARCHAR (15) NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDEdited]           VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCompanyCertifiedMail] PRIMARY KEY CLUSTERED ([CompanyCertifiedMailID] ASC)
)

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCompanyCertifiedMail_CompanyCodeCaseTypeCodeCertMailActivityID]
    ON [dbo].[tblCompanyCertifiedMail]([CompanyCode] ASC, [CaseTypeCode] ASC, [CertMailActivityID] ASC);
