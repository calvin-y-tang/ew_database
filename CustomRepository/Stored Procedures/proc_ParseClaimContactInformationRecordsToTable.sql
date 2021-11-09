
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseClaimContactInformationRecordsToTable]  
AS
BEGIN
INSERT INTO SedgwickClaimContactInformationRecord 
     (
     ClientNumber, 
     ClaimNumber, 
     ShortVendorId, 
     CMSProcessingOffice, 
     ClaimUniqueId, 
     ClaimSystemId, 
     TransactionType, 
     NameType, 
     Facility, 
     Title, 
     FirstName, 
     LastName, 
     Speciality, 
     Address1, 
     Address2, 
     City, 
     State, 
     Zip, 
     Country, 
     Phone1, 
     PhoneExt1, 
     Phone2, 
     PhoneExt2, 
     FaxNumber, 
     BestContactDate, 
     BestContractTime, 
     FederalTaxID, 
     FederalTaxIDSub, 
     Comment, 
     Authorize, 
     AuthorizationBeginDate, 
     AuthorizationEndDate, 
     AddressRecordInternalUniqueID, 
     EmailAddress, 
     ClaimRecordId     
     )
     SELECT DISTINCT 
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,4,4)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,4,4)) 
               ELSE '0000' 
               END,                     
          RTRIM(SUBSTRING(RecDetail,8,18)), 
          RTRIM(SUBSTRING(RecDetail,26,2)),                     
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,28,3)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,28,3)) 
               ELSE '000' 
               END,                     
          RTRIM(SUBSTRING(RecDetail,31,30)), 
          RTRIM(SUBSTRING(RecDetail,61,30)), 
          RTRIM(SUBSTRING(RecDetail,91,3)), 
          RTRIM(SUBSTRING(RecDetail,94,1)), 
          RTRIM(SUBSTRING(RecDetail,95,30)), 
          RTRIM(SUBSTRING(RecDetail,125,10)), 
          RTRIM(SUBSTRING(RecDetail,135,20)), 
          RTRIM(SUBSTRING(RecDetail,155,25)), 
          RTRIM(SUBSTRING(RecDetail,180,30)), 
          RTRIM(SUBSTRING(RecDetail,210,30)), 
          RTRIM(SUBSTRING(RecDetail,240,30)), 
          RTRIM(SUBSTRING(RecDetail,270,20)), 
          RTRIM(SUBSTRING(RecDetail,290,2)), 
          RTRIM(SUBSTRING(RecDetail,292,9)), 
          RTRIM(SUBSTRING(RecDetail,301,3)), 
          RTRIM(SUBSTRING(RecDetail,304,18)),                
          NULL,                                              
          RTRIM(SUBSTRING(RecDetail,329,18)),                
          NULL,                
          RTRIM(SUBSTRING(RecDetail,354,18)),                                    
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,432,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,432,8),112) 
               ELSE NULL
               END,                          
          CASE 
               WHEN ISDATE(TroubleTime) = 1 
               THEN CONVERT(DATETIME, TroubleTime ,108) 
               ELSE NULL 
               END,                     
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,444,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,444,9)) 
               ELSE '000000000' 
               END,                      
          RTRIM(SUBSTRING(RecDetail,453,3)), 
          RTRIM(SUBSTRING(RecDetail,456,50)), 
          RTRIM(SUBSTRING(RecDetail,506,1)),                      
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,507,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,507,8),112) 
               ELSE NULL
               END,                      
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,515,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,515,8),112) 
               ELSE NULL
               END,                      
          RTRIM(SUBSTRING(RecDetail,523,20)), 
          RTRIM(SUBSTRING(RecDetail,543,320)),
          0
     FROM SedgwickClaimDataImport
     WHERE RecType = 'CCI' 
     AND IsRecordLoaded = 1
END
