
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimProcessingUnitRecordsInsert]  
AS
BEGIN
  UPDATE SedgwickClaimDataImport 
  SET UpdateInsert = 'I' 
  WHERE 
  RecType = 'PRO'  and UpdateInsert = 'X' 
    AND CONVERT(INT, ClientIDorOtherID) NOT IN 
    (select OfficeNumber from SedgwickProcessingUnitRecord)
END
