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
