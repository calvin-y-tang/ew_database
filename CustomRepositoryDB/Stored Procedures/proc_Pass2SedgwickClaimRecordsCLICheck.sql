
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimRecordsCLICheck]  
AS
BEGIN
  UPDATE SedgwickClaimDataImport 
  Set 
  FailureReasonCode2 = '00013', 
  FailureReasonDescription2 = 'Client Not Eligible', 
  IsRecordLoaded = 0 
  WHERE RecType = 'CLM' 
  AND CLientIDorOtherID NOT IN (select SCMSClientID 
  FROM SedgwickClientInformationRecord)
END
