
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimClientInfoRecordsInsert]  
AS
BEGIN
    UPDATE SedgwickClaimDataImport 
    SET UpdateInsert  = 'I' 
    WHERE
    RecType = 'CLI' and UpdateInsert = 'X' 
    AND ClientIDorOtherID NOT IN 
    (select SCMSClientId from SedgwickClientInformationRecord)
END
