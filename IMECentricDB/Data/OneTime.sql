-- Sprint 124

--IMEC-13955 - RPA Update Meds Type when medical records received - adding more mappins for possible file name variations
USE IMECentricMaster

INSERT INTO ISMapping (MappingType, MappingName, SrcValue, SrcDescrip, DstValue, DstDescrip)
VALUES 
  ('ExtDocIntake', 'CaseDocType', 0, 'Med Records', 7, 'Medical Record'),
  ('ExtDocIntake', 'CaseDocType', 0, 'MedRecords', 7, 'Medical Record'),
  ('ExtDocIntake', 'CaseDocType', 0, 'Med Record', 7, 'Medical Record')
GO

--IMEC-13957 - add columns for claimant mobile and work phone numbers
USE CustomRepository
ALTER TABLE SedgwickClaimRecord 
ADD ClaimantWorkPhone VARCHAR(20) NULL, ClaimantMobilePhone VARCHAR(20) NULL
GO

-- IMEC-13966 - enhance CRN Mapping to be DB Specific; include support for EW & FCE DBs
ALTER TABLE IMECentricMaster.dbo.ISMapping add DBID INT NULL
GO
UPDATE IMECentricMaster.dbo.ISMapping 
   SET DBID = 23
 WHERE MappingName <> 'systemid' and MappingType = 'CRN'
GO
INSERT INTO IMECentricMaster.dbo.ISMapping(MappingType, MappingName, SrcValue, SrcDescrip, DstValue, DstDescrip, DBID)
     SELECT MappingType, MappingName, SrcValue, SrcDescrip, DstValue, DstDescrip, 25
       FROM IMECentricMaster.dbo.ISMapping 
      WHERE DBID = 23
 GO