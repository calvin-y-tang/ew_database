
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimClientInfoRecordsUpdate]  
AS
BEGIN
    UPDATE SedgwickClaimDataImport 
    SET UpdateInsert  = 'U' 
    WHERE
    RecType = 'CLI' and UpdateInsert = 'X' 
    AND ClientIDorOtherID IN 
    (select SCMSClientId from SedgwickClientInformationRecord)
END
