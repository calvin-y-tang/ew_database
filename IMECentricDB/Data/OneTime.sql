
-- Sprint 91

-- IMEC-12917
-- set the RequirePDF value back to true (1) for First Choice
--
USE [IMECentricFCE]
GO
UPDATE tblControl SET RequirePDF = 1
GO

