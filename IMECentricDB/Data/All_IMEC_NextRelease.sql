-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 130

-- IMEC-14063 - entries into tblConfiguration for EWIS External Document Intake process email additional actions - data driven
  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (25, 'RPA_PROG_UnknwnCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: File with Unknown Case Number Needs Correction";Body="Unknown Case Number for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (26, 'RPA_PROG_CopyFileErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: Failed to Copy Case Document";Body="Copy file error. File already exists or there was an I/O error. File has been moved to the Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (27, 'RPA_PROG_DefaultErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: Error with document";Body="File moved to Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (28, 'RPA_LibiCase_MultiCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Multiple Cases Exist for Internal case Number";Body="Found multiple cases with internal case number for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (29, 'RPA_LibiCase_UnknwnCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: File with Unknown Internal Case Number";Body="Could not find an active case for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (30, 'RPA_LibiCase_CopyFileErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Failed to Copy Case Document";Body="Copy file error. File already exists or there was an I/O error. File has been moved to the Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (31, 'RPA_LibiCase_DefaultErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Error with document";Body="File moved to Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (32, 'RPA_LibiCase_ReprocFirst', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The file has currently been reprocessed 0 times.<br />We will move the file back to the Inbox folder for reprocessing. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (33, 'RPA_LibiCase_ReprocMax', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The max number of retries has been reached. We will no longer attempt to process this file. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (34, 'RPA_LibiCase_ReprocContinued', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="We will move the file back to the Inbox folder for reprocessing. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (35, 'RPA_LibiCase_ReprocNum', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The file has currently been reprocessed @attempts@ times with a max of @maxattempts@. <br />"')

GO

-- IMEC-14047 - Data Patch for new required service workflow variable WC Case Type - set default value to 0
  UPDATE tblServiceWorkflow SET WcCaseTypeRqd = 0
  GO
