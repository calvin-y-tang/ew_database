
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc2_SedgwickClaimMasterStoredProcedure]  
AS
BEGIN
     DECLARE @HeaderRecordID int
     DECLARE @ClaimPKEYID INT

--=====================================================================
-- Perform additional passes to update the SedgwickClaimDataImport table with more information
--=====================================================================
      EXEC proc_Pass2SedgwickClaimClientInfoRecordsQualify 
      EXEC proc_Pass2SedgwickClaimClientInfoRecordsInsert
      EXEC proc_Pass2SedgwickClaimClientInfoRecordsUpdate

      EXEC proc_Pass2SedgwickClaimProcessingUnitRecordsQualify
      EXEC proc_Pass2SedgwickClaimProcessingUnitRecordsInsert
      EXEC proc_Pass2SedgwickClaimProcessingUnitRecordsUpdate
            
      EXEC proc_Pass2SedgwickClaimRecordsQualify
      
--=====================================================================
-- Begin loading information into the individual tables
--=====================================================================
-- Header ******
      EXEC proc_ParseHeaderRecordsToTable @HeaderRecordID OUTPUT
      EXEC proc_AddHeaderIDToTables @HeaderRecordID

-- CLI ****** 
      EXEC proc_ParseClientInformationRecordsToTable_Insert
      EXEC proc_ParseClientInformationRecordsToTable_Update

-- PRO ****** 
      EXEC proc_ParseProcessingUnitRecordsToTable_Insert
      EXEC proc_ParseProcessingUnitRecordsToTable_Update

-- Claim ****** 
      EXEC proc_Pass2SedgwickClaimRecordsCLICheck
      EXEC proc_Pass2SedgwickClaimRecordsPROCheck

      EXEC proc_DeleteClaimInformation
      EXEC proc_DeleteClientContactInfoInformation
      EXEC proc_ParseClaimRecordsToTable

-- CCI ****** 
      EXEC proc_Pass2SedgwickClaimContactInfoRecords

      EXEC proc_ParseClaimContactInformationRecordsToTable

-- TRL ****** 
      EXEC proc_ParseTrailerRecordsToTable
      
-- ACK ******
      EXEC proc_WriteAcknowledgementRecords
      EXEC proc_WriteAcknowledgementRecordsSetDefaultError
      EXEC proc_WriteAcknowledgementRecordsPack3to2
      EXEC proc_WriteAcknowledgementRecordsPack2to1
END
