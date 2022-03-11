-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : AcctHeader
-- Issue   : IMEC-12600 Add new column for CaseDocID
--
USE EWDataRepository
ALTER TABLE AcctHeader ADD CaseDocID INT NULL
GO

