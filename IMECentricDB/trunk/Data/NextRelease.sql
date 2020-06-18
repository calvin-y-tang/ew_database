-- Issue 11606 - ESIS to require Employer field
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(130, 'CaseRequiredFields', 'Case', 'Define required fields on case form', 1, 1016, 0, 'FieldName1', 'FieldName2', 'FieldName3', 'FieldName4', 'FieldName5', 0)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 1, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 1, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 2, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 2, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 8, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 8, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 10, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 10, NULL, 'cboEmployer', NULL, NULL, NULL, NULL)

GO


-- Issue 11654 - add new token for claim number extension only
INSERT INTO [dbo].[tblMessageToken] ([Name], [Description]) VALUES ('@ClaimNbrExt@ ', '')
GO


UPDATE U SET U.DisplayOrder=SM.RowNbr
FROM tblDPSSortModel AS U
INNER JOIN
(SELECT SortModelID, Description, ROW_NUMBER() OVER (ORDER BY Description) AS RowNbr
FROM tblDPSSortModel) AS SM ON U.SortModelID = SM.SortModelID
GO

-- Issue 11137 - data patch fot acctquotefee to link in prodcode
     UPDATE AQF
        SET AQF.QuoteFeeConfigID = QFC.QuoteFeeConfigID
     FROM tblAcctQuoteFee AS AQF
               INNER JOIN tblQuoteFeeConfig as QFC ON QFC.FeeValueName = AQF.FeeValueName
GO 

-- Issue 11137 - data patch for Quote Fees Product Codes
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

-- Issue 11137 - patch tblAcctDetail to set existing row to FeeCodeSource where FeeCode is present
UPDATE tblAcctDetail SET FeeCodeSource = 1 WHERE FeeCode IS NOT NULL AND FeeCodeSource IS NULL
GO 

-- Issue 11137 - patch tblAcctHeader to set existing rows to FeeCodeSource where FeeCode is present
UPDATE tblAcctHeader SET FeeCodeSource = 1 WHERE FeeCode IS NOT NULL AND FeeCodeSource IS NULL
GO 

-- Issue 11137 - patch tblAcctQuoteFee to set value for QuoteFeeConfigID
UPDATE AQ
   SET AQ.QuoteFeeConfigID = QF.QuoteFeeConfigID
FROM tblAcctQuoteFee AS AQ
          INNER JOIN tblQuoteFeeConfig AS QF ON QF.FeeValueName = AQ.FeeValueName
WHERE AQ.QuoteFeeConfigID IS NULL
GO
