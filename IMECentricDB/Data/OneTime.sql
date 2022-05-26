
-- Sprint 85

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : EWFlashCategory 
-- Issue   : IMEC-12527 - Add milege to Hartford Mgt. Report

USE [IMECentricMaster]
GO

UPDATE EWFlashCategory SET Mapping5 = 'Mileage' WHERE EWFlashCategoryID = 290 and Category = 'Mileage';
GO

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricFCE
-- Table   : tblSetting 
-- Issue   : IMEC-12760 - use Helper to do PDFMerge (remove MergePDFMethod from tblSetting)
USE [IMECentricFCE]
GO

DELETE FROM tblSetting WHERE Name = 'MergePDFMethod'
GO
