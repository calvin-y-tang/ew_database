
-------------------------------------------------
--Schema changes for Bulk Billing
-------------------------------------------------

CREATE TABLE [tblEWBulkBilling] (
  [BulkBillingID] INTEGER,
  [Descrip] VARCHAR(25),
  [CreateInvDocument] BIT,
  [AutoPrint] BIT,
  CONSTRAINT [PK_tblBulkBilling] PRIMARY KEY ([BulkBillingID])
)
GO


ALTER TABLE [tblCompany]
  ADD [BulkBillingID] INTEGER
GO


update tblControl set DBVersion='1.42'
GO
