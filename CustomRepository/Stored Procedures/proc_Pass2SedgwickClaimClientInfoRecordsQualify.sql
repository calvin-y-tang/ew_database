
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimClientInfoRecordsQualify]  
AS
BEGIN
    Update SedgwickClaimDataImport 
    set UpdateInsert  = 'X' 
    where RecType = 'CLI' AND  Id in (
    select max(id) from SedgwickClaimDataImport 
    Where RecType = 'CLI' 
    group by ClientIDorOtherID)
END
