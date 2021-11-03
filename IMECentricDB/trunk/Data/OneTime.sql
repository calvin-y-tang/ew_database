
-- IMEC-12255 - patch new column for Require DOB
UPDATE tblEWParentCompany SET RequireExamineeDOB = 0 
GO


-- IMEC-12367 - make sure all offices are set to use the OCR process
UPDATE tblOffice SET OCRSystemID = 1
GO


-- ******************** FOR IMECentricMASTER DB **********************
ALTER TABLE EWParentCompany ADD [RequireExamineeDOB] BIT CONSTRAINT [DF_EWParentCompany_RequireExamineeDOB] DEFAULT (0)
GO
UPDATE EWParentCompany SET RequireExamineeDOB = 0 
GO

