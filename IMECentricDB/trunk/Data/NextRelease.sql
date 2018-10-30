-- Issue 7708 - delete previous values from tblSettings that are no longer used and create a new generic setting
DELETE FROM tblSetting WHERE Name = 'EnableMultEEAddrDocs'
GO
DELETE FROM tblSetting WHERE Name = 'MultEEAddrDocsOffices'
GO 
-- TODO: fill in a semi-colon delimited list of office codes that you want to enable new gen docs for
INSERT INTO tblSetting (Name, Value)
VALUES('UseNewGenDocFormOffices', ';;')
GO 