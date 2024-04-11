-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 133

-- IMEC-14048 - add timeout to allow time for Helper to resize the image, save the file, and write to tblTempData
INSERT INTO tblSetting ([Name], [Value]) VALUES ('TimeOutResizeImage', '9000')

