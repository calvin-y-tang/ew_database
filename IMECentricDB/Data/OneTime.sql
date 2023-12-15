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
