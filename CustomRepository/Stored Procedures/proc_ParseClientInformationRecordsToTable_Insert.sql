
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseClientInformationRecordsToTable_Insert]  
AS
BEGIN
INSERT INTO SedgwickClientInformationRecord 
     (
          SCMSClientID, 
          SCMSClientAccount, 
          SCMSClientUnitLocation, 
          SCMSDatabaseOffice,  
          ClientName, 
          ClientAddressLine1, 
          ClientAddressLine2, 
          ClientCity, 
          ClientState, 
          ClientCountry, 
          ClientPostalCode, 
          ClientPhoneNumber,  
          PaperFROI, 
          ClientFEIN,  
          ClientSIC, 
          InceptionDate,   
          ExpirationDate,  
          EntityLevel, 
          EntityName, 
          ClientContactStatus 
     )
     SELECT
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,4,4)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,4,4))  
               ELSE '0000' 
               END, 
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,8,8)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,8,8)) 
               ELSE '00000000' 
               END, 
          RTRIM(SUBSTRING(RecDetail,16,6)), 
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,22,3)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,22,3)) 
               ELSE '000' 
               END, 
          RTRIM(SUBSTRING(RecDetail,25,100)), 
          RTRIM(SUBSTRING(RecDetail,125,30)), 
          RTRIM(SUBSTRING(RecDetail,155,30)), 
          RTRIM(SUBSTRING(RecDetail,185,20)), 
          RTRIM(SUBSTRING(RecDetail,205,2)), 
          RTRIM(SUBSTRING(RecDetail,207,3)), 
          RTRIM(SUBSTRING(RecDetail,210,15)), 
          RTRIM(SUBSTRING(RecDetail,225,18)),  
          RTRIM(SUBSTRING(RecDetail,243,1)), 
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,244,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,244,9)) 
               ELSE '000000000' 
               END, 
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,253,4)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,253,4)) 
               ELSE '0000' 
               END, 
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,257,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,257,8),112) 
               ELSE NULL 
               END, 
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,265,8))  = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,265,8),112)  
               ELSE NULL
               END, 
          RTRIM(SUBSTRING(RecDetail,273,1)), 
          RTRIM(SUBSTRING(RecDetail,274,100)), 
          RTRIM(SUBSTRING(RecDetail,374,1))          
     FROM SedgwickClaimDataImport
     WHERE RecType = 'CLI' 
     AND IsRecordLoaded = 1 
     AND UpdateInsert = 'I'
END
