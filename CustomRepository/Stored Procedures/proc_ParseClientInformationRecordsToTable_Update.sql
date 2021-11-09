
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseClientInformationRecordsToTable_Update]  
AS
BEGIN
UPDATE SedgwickClientInformationRecord 
     SET 
          SCMSClientAccount = CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,8,8)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,8,8)) 
               ELSE '00000000' 
               END, 
          SCMSClientUnitLocation = RTRIM(SUBSTRING(RecDetail,16,6)), 
          SCMSDatabaseOffice = CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,22,3)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,22,3)) 
               ELSE '000' 
               END, 
          ClientName = RTRIM(SUBSTRING(RecDetail,25,100)), 
          ClientAddressLine1 = RTRIM(SUBSTRING(RecDetail,125,30)), 
          ClientAddressLine2 = RTRIM(SUBSTRING(RecDetail,155,30)), 
          ClientCity = RTRIM(SUBSTRING(RecDetail,185,20)), 
          ClientState = RTRIM(SUBSTRING(RecDetail,205,2)), 
          ClientCountry = RTRIM(SUBSTRING(RecDetail,207,3)), 
          ClientPostalCode = RTRIM(SUBSTRING(RecDetail,210,15)), 
          ClientPhoneNumber = RTRIM(SUBSTRING(RecDetail,225,18)),  
          PaperFROI = RTRIM(SUBSTRING(RecDetail,243,1)), 
          ClientFEIN = CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,244,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,244,9)) 
               ELSE '000000000' 
               END, 
          ClientSIC = CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,253,4)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,253,4)) 
               ELSE '0000' 
               END, 
          InceptionDate = CASE  
               WHEN ISDATE(SUBSTRING(RecDetail,257,8)) = 1 
               then CONVERT(DATETIME,SUBSTRING(RecDetail,257,8),112) 
               ELSE NULL
               END, 
          ExpirationDate = CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,265,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,265,8),112) 
               ELSE NULL
               END, 
          EntityLevel = RTRIM(SUBSTRING(RecDetail,273,1)), 
          EntityName = RTRIM(SUBSTRING(RecDetail,274,100)), 
          ClientContactStatus = RTRIM(SUBSTRING(RecDetail,374,1))
     FROM SedgwickClaimDataImport
     WHERE RecType = 'CLI' 
     AND IsRecordLoaded = 1 
     AND UpdateInsert = 'U'
     AND SedgwickClaimDataImport.ClientIDorOtherID = SedgwickClientInformationRecord.SCMSClientId      
END
