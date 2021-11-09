
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_Pass2SedgwickClaimProcessingUnitRecordsQualify]  
AS
BEGIN
   Update SedgwickClaimDataImport 
    set UpdateInsert  = 'X' 
    where RecType = 'PRO' AND  Id in (
    select max(id) from SedgwickClaimDataImport 
    Where RecType = 'PRO' 
    group by ClientIDorOtherID)
END
