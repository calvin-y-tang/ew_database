-- Sprint 123

-- Issue 13942 - adding new column to indicate which method will be used to calculate canadian taxes - company state or
               -- office state.  Svaes Office code for Office State and 0 for company state
USE [IMECentricEW]
GO
ALTER TABLE tblAcctHeader ADD InvTaxCalcMethod INT NULL
GO

ALTER TABLE tblAcctHeader ADD CONSTRAINT DF_tblAcctHeader_InvTaxCalcMethod DEFAULT (0) FOR InvTaxCalcMethod
GO

-- set values in table to default of 0
UPDATE tblAcctHeader SET InvTaxCalcMethod = 0
GO

