-- Sprint 91

-- IMEC-12959 - Add status to tblOutOfNetworkReason, set all existing to active
update tblOutOfNetworkReason set Status = 'Active'

-- IMEC-12913 - new setting that makes CRN Active
INSERT INTO tblSetting
VALUES ('CRNIsActive', 'False')
GO
-- IMEC-12913 - new CRN security settings
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorCRNView','Doctor - View in CRN', GETDATE()), 
      ('DoctorCRNAdd', 'Doctor - Add CRN Reviewer', GETDATE())
GO
-- IMEC-12913 - configuration to access CRN system (TEST SYSTEM ONLY)
INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
VALUES(11, 'CRN', 1, 'CRN', GETDATE(), 'JPais', 'BU=EW;URLView=https://crn-alpha-develop-staff.examworks.com/master-reviewer-detail/<MasterReviewerID>;URLAdd=https://crn-alpha-develop-staff.examworks.com/new-external-request?sn=<BUCode>')
GO
