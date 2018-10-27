
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseProcessingUnitRecordsToTable_Update]  
AS
BEGIN
UPDATE SedgwickProcessingUnitRecord 
      SET 
          OfficeName = RTRIM(SUBSTRING(RecDetail,7,50)), 
          ShippingAddress1 = RTRIM(SUBSTRING(RecDetail,57,30)), 
          ShippingAddress2 = RTRIM(SUBSTRING(RecDetail,87,30)), 
          City = RTRIM(SUBSTRING(RecDetail,117,20)), 
          State = RTRIM(SUBSTRING(RecDetail,137,2)), 
          Country = RTRIM(SUBSTRING(RecDetail,139,3)), 
          PostalCode = RTRIM(SUBSTRING(RecDetail,142,15)), 
          Phone = RTRIM(SUBSTRING(RecDetail,157,18)), 
          Fax = RTRIM(SUBSTRING(RecDetail,175,18)), 
          Manager = RTRIM(SUBSTRING(RecDetail,193,55)), 
          Coordinator = RTRIM(SUBSTRING(RecDetail,248,100)), 
          OfficeEmail = RTRIM(SUBSTRING(RecDetail,348,320)) 
     FROM SedgwickClaimDataImport
     WHERE SedgwickClaimDataImport.RecType = 'PRO' 
          AND SedgwickClaimDataImport.IsRecordLoaded = 1 
          AND SedgwickClaimDataImport.UpdateInsert = 'U'
    		  AND SedgwickClaimDataImport.ClientIDorOtherID = SedgwickProcessingUnitRecord.OfficeNumber           
END
