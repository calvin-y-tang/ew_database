
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseHeaderRecordsToTable]  
@HeaderID INT OUTPUT
AS
BEGIN
INSERT INTO SedgwickFileHeaderRecord 
     (
     FileVersionNumber, 
     VendorFileName, 
     FileReferenceNumber, 
     VendorCode, 
     DateCreated, 
     TimeCreated, 
     BeginDate, 
     BeginTime, 
     EndingDate, 
     EndingTime
      )
      SELECT 
	       RTRIM(SUBSTRING(RecDetail,4,5)), 
           RTRIM(SUBSTRING(RecDetail,9,100)), 
           RTRIM(SUBSTRING(RecDetail,109,3)), 
           RTRIM(SUBSTRING(RecDetail,112,3)), 
          
		      CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,115,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,115,8),112) 
               ELSE NULL
               END, 
          
		      CASE
               WHEN ISDATE(SUBSTRING(RecDetail,123,2) + ':' + SUBSTRING(RecDetail,125,2) + ':' + SUBSTRING(RecDetail,127,2)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,123,2) + ':' + SUBSTRING(RecDetail,125,2) + ':' + SUBSTRING(RecDetail,127,2),108)  
               ELSE NULL 
               END, 
          
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,129,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,129,8),112)  
               ELSE NULL
               END, 
		
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,137,2) + ':' + SUBSTRING(RecDetail,139,2) + ':' + SUBSTRING(RecDetail,141,2)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,137,2) + ':' + SUBSTRING(RecDetail,139,2) + ':' + SUBSTRING(RecDetail,141,2),108)  
               ELSE NULL
               END, 
          
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,143,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,143,8),112) 
               ELSE NULL 
               END, 
          
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,151,2) + ':' + SUBSTRING(RecDetail,153,2) + ':' + SUBSTRING(RecDetail,155,2)) = 1 
               then convert(datetime,SUBSTRING(RecDetail,151,2) + ':' + SUBSTRING(RecDetail,153,2) + ':' + SUBSTRING(RecDetail,155,2),108) 
               ELSE NULL 
               END 
    FROM SedgwickClaimDataImport
    WHERE RecType = 'HDR' 
    AND IsRecordLoaded = 1
    
    SET @HeaderID = @@IDENTITY
END
