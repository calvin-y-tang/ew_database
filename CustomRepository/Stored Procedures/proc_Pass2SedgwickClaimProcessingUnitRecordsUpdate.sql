
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimProcessingUnitRecordsUpdate]  
AS
BEGIN
  UPDATE SedgwickClaimDataImport 
  SET UpdateInsert = 'U' 
  WHERE 
  RecType = 'PRO'  and UpdateInsert = 'X' 
    AND CONVERT(INT, ClientIDorOtherID) IN 
    (select OfficeNumber from SedgwickProcessingUnitRecord)
END
