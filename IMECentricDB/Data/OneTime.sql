-- Sprint 97

-- IMEC-13185 - attach provided list of approved attornies for Allstate to tblCCAddress entries.
USE IMECentricEW
INSERT INTO tblCCAddressEntity(ccCode, EntityType, EntityID, DateAdded, UserIDAdded)
	SELECT attyList.ccCode, 'PC',  4, GETDATE(), 'DataImport'
	  FROM dba.dbo._dht_Allstate_Attorneys AS attyList
				LEFT OUTER JOIN tblCCAddressEntity AS ccEntity ON ccEntity.ccCode = attyList.ccCode
	 WHERE ccEntity.ccCode IS NULL
GO

