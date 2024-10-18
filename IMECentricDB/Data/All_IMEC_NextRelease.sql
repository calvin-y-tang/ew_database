-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 141
-- IMEC-14483 - Update tblSetting for CaseDocTypeMedsIncoming_True to include only CaseDocType 'Med Records' (7) and do not include 'San Med Records' (21)
   UPDATE tblSetting Set Value = ';7;' where Name = 'CaseDocTypeMedsIncoming_True'
