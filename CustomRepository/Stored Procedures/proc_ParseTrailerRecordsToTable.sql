
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseTrailerRecordsToTable]  
AS
BEGIN
INSERT INTO SedgwickFileTrailerRecord  
     (
     ClaimDataRecordCount, 
     ClaimContactInformationRecordCount, 
     ClientInformationRecord, 
     ProcessingUnitRecord, 
     TotalRecordCount, 
     HeaderRecordId
     )
     SELECT
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,4,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,4,9)) 
               ELSE '000000000' 
               END,           
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,13,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,13,9)) 
               ELSE '000000000' 
               END,           
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,22,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,22,9)) 
               ELSE '000000000' 
               END, 		
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,31,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,31,9)) 
               ELSE '000000000' 
               END,           
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,40,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,40,9)) 
               ELSE '000000000' 
               END,           
               HeaderRecordID
     FROM SedgwickClaimDataImport
     WHERE RecType = 'TRL' 
     AND IsRecordLoaded = 1
END
