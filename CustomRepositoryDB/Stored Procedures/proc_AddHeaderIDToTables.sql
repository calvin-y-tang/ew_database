
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_AddHeaderIDToTables]  
@HeaderID INT 
AS
BEGIN
   UPDATE SedgwickClaimDataImport
   SET HeaderRecordID = @HeaderID
END
