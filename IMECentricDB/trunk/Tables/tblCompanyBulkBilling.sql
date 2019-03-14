CREATE TABLE [dbo].[tblCompanyBulkBilling]
(
	[CompanyBulkBillingID] INT IDENTITY (1, 1) NOT NULL, 
    [CompanyCode] INT NOT NULL, 
    [BulkBillingID] INT NOT NULL, 
    [Jurisdiction] CHAR(2) NOT NULL, 
    [PayerId] VARCHAR(16) NULL, 
    [PayerName] VARCHAR(64) NULL, 
    [DateAdded] DATETIME NOT NULL, 
    [UserIDAdded] VARCHAR(15) NOT NULL, 
    [DateEdited] DATETIME NOT NULL, 
    [UserIDEdited] VARCHAR(15) NOT NULL,
	CONSTRAINT [PK_tblCompanyBulkBilling] PRIMARY KEY CLUSTERED ([CompanyBulkBillingID] ASC)
)

GO
CREATE NONCLUSTERED INDEX [IX_tblCompanyBulkBilling_CompanyCode]
    ON [dbo].[tblCompanyBulkBilling]([CompanyCode] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_tblCompanyBulkBilling_Jurisdiction]
    ON [dbo].[tblCompanyBulkBilling]([Jurisdiction] ASC);

