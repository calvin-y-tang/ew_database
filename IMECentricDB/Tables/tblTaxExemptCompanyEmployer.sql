CREATE TABLE [dbo].[tblTaxExemptCompanyEmployer]
(
    [TaxExemptCompanyEmployerID] INT IDENTITY (1, 1) NOT NULL,
    [ParentCompanyID]            INT                 NOT NULL,
    [EWParentEmployerID]         INT                 NOT NULL, 
    [StateCode]                  VARCHAR(2)          NULL,
    [DateAdded]                  DATETIME            NOT NULL,
    [UserIDAdded]                VARCHAR (15)        NOT NULL,
    CONSTRAINT [PK_tblTaxExemptCompanyEmployer] PRIMARY KEY CLUSTERED ([TaxExemptCompanyEmployerID] ASC)
)
GO

CREATE UNIQUE INDEX [IX_U_tblTaxExemptCompanyEmployer_ParentCompanyID_EWParentEmployerID_StateCode] 
	ON [dbo].[tblTaxExemptCompanyEmployer] ([ParentCompanyID], [EWParentEmployerID], [StateCode])
GO
