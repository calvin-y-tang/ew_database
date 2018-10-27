
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimRecordsQualify]  
AS
BEGIN
    UPDATE SedgwickClaimDataImport 
		SET UpdateInsert  = 'Q' 
		WHERE RecType = 'CLM' AND Id in (SELECT MAX(Id) FROM SedgwickClaimDataImport WHERE RecType = 'CLM' 
												GROUP BY ClaimID)
END
