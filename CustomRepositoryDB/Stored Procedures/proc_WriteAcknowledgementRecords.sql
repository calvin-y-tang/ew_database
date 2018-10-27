
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_WriteAcknowledgementRecords]  
AS
BEGIN
INSERT INTO SedgwickMCCAcknowledgement 
     (
     ReferencedRecordType, 
     ClientNumber, 
     ClaimNumber, 
     ShortVendorId,      
     CMSProcessingOffice,      
     ClaimUniqueId,      
     ClaimSystemId,         
     IsRecordLoaded, 
     FailureReasonCode1, 
     FailureReasonDescription1, 
     FailureReasonCode2, 
     FailureReasonDescription2, 
     FailureReasonCode3, 
     FailureReasonDescription3,          
     FailureReasonCode4, 
     FailureReasonDescription4, 
     FailureReasonCode5, 
     FailureReasonDescription5,      
     MiscFailureReasonCode,      
     MiscFailureDescription,     
     SWFileHeaderRecordID, 
     ErrorHasBeenReviewed
     )
     SELECT
          RecType, 
          CONVERT(INT, ClientIDorOtherID),  
          ClaimNumber, 
          ShortVendorID, 
          CONVERT(INT, ProcessingUnitRecordID),          
          ClaimUniqueID,           
          SystemID,           
          CASE
          WHEN IsRecordLoaded = 1
          THEN
              'Y'
          ELSE
              'N'
          END, 
          CASE 
          WHEN FailureReasonCode1 = 0 
          THEN '00000' 
          END, 
          CASE 
          WHEN FailureReasonDescription1 = ''  
          THEN 'No errors reported' 
          END, 
          CASE 
          WHEN FailureReasonCode2 = 0 
          THEN '00000' 
          END, 
          CASE 
          WHEN FailureReasonDescription2 = '' 
          THEN 'No errors reported' 
          END, 
          CASE 
          WHEN FailureReasonCode3 = 0 
          THEN '00000' 
          END, 
          CASE 
          WHEN FailureReasonDescription3 = ''         
          THEN 'No errors reported' 
          END,
          
          '00000',
          'No errors reported',
          '00000',
          'No errors reported',          
          '00000',
          'No errors reported',          
          HeaderRecordID, 
          0               
     FROM SedgwickClaimDataImport
END
