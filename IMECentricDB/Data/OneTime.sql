
-- IMEC-12509 - add NonWork days for Office Maintenance Screen - setting so that the tab for the nonwork days is only
--  visible for these DBIDs
INSERT INTO tblSetting (Name, Value) VALUES ('DBIDsUseNonWorkDaysOffice', ';10;18;')
GO
