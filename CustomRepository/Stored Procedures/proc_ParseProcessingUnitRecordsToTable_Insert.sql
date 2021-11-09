
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseProcessingUnitRecordsToTable_Insert]  
AS
BEGIN
INSERT INTO SedgwickProcessingUnitRecord 
     (
     OfficeNumber, 
     OfficeName, 
     ShippingAddress1, 
     ShippingAddress2, 
     City, 
     State, 
     Country, 
     PostalCode, 
     Phone, 
     Fax, 
     Manager, 
     Coordinator, 
     OfficeEmail
     )
     SELECT 
		   RTRIM(SUBSTRING(RecDetail,4,3)), 
           RTRIM(SUBSTRING(RecDetail,7,50)), 
           RTRIM(SUBSTRING(RecDetail,57,30)), 
           RTRIM(SUBSTRING(RecDetail,87,30)), 
           RTRIM(SUBSTRING(RecDetail,117,20)), 
           RTRIM(SUBSTRING(RecDetail,137,2)), 
           RTRIM(SUBSTRING(RecDetail,139,3)), 
           RTRIM(SUBSTRING(RecDetail,142,15)), 
           RTRIM(SUBSTRING(RecDetail,157,18)), 
           RTRIM(SUBSTRING(RecDetail,175,18)), 
           RTRIM(SUBSTRING(RecDetail,193,55)), 
           RTRIM(SUBSTRING(RecDetail,248,100)), 
           RTRIM(SUBSTRING(RecDetail,348,320)) 
     FROM SedgwickClaimDataImport 
     WHERE RecType = 'PRO' 
          AND IsRecordLoaded = 1 
          AND UpdateInsert = 'I'
END
