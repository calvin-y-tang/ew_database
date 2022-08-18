
-- Sprint 91

-- IMEC-12917
-- set the RequirePDF value back to true (1) for First Choice
--
USE [IMECentricFCE]
GO
UPDATE tblControl SET RequirePDF = 1
GO

USE [IMECentricMaster]
GO
ALTER TABLE EWDoctorDocument ADD
	[EffectiveDate]            DATETIME NULL,
    [MasterReviewerDocumentID] INT      NULL
GO

-- UPDATE APPLIED TO TEST SYSTEMS ONLY (so that regression testing works correctly)
-- IMEC-12913 - configuration to access CRN system (TEST SYSTEM ONLY)
INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
VALUES(11, 'CRN', 1, 'CRN', GETDATE(), 'JPais', 'BU=EW;URLView=https://crn-alpha-develop-staff.examworks.com/master-reviewer-detail/<MasterReviewerID>;URLAdd=https://crn-alpha-develop-staff.examworks.com/new-external-request?sn=<BUCode>')
GO
