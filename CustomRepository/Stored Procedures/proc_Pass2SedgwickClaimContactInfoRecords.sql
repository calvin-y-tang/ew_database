
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimContactInfoRecords]  
AS
BEGIN
  UPDATE SedgwickClaimDataImport 
  Set	SedgwickClaimDataImport.FailureReasonCode2 = '00007', 
		SedgwickClaimDataImport.FailureReasonDescription2 = 'Claim Number Missing', 
		SedgwickClaimDataImport.IsRecordLoaded = 0 
  WHERE SedgwickClaimDataImport.RecType = 'CCI'
    AND SedgwickClaimDataImport.ClaimID NOT IN (SELECT ClaimID from SedgwickClaimRecord)

END
