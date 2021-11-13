
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimRecordsPROCheck]  
AS
BEGIN
  UPDATE SedgwickClaimDataImport 
  Set 
  FailureReasonCode3 = '00015', 
  FailureReasonDescription3 = 'Unit Not Eligible', 
  IsRecordLoaded = 0 
  WHERE RecType = 'CLM' 
  AND 
  CONVERT(INT, ProcessingUnitRecordID) NOT IN (select OfficeNumber
  FROM SedgwickProcessingUnitRecord)
END
