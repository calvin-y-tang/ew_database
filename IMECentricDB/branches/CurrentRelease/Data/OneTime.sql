-- Issue 11137 - data patch for Quote Fees Product Codes
--For IMECentricEW
UPDATE tblQuoteFeeConfig SET ProdCode = 1427 WHERE QuoteFeeConfigID = 5
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 474 WHERE QuoteFeeConfigID = 1
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 722 WHERE QuoteFeeConfigID = 6
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 90 WHERE QuoteFeeConfigID = 7
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 1911 WHERE QuoteFeeConfigID = 2
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 396 WHERE QuoteFeeConfigID = 3
GO 
UPDATE tblQuoteFeeConfig SET ProdCode = 1702 WHERE QuoteFeeConfigID = 4
GO 
