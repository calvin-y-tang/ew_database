
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_DeleteClaimInformation]  
AS
BEGIN
Delete A
	From SedgwickClaimRecord as A
		Inner Join SedgwickClaimDataImport as B on A.ClaimID = B.ClaimID AND B.RecType = 'CLM'
END
