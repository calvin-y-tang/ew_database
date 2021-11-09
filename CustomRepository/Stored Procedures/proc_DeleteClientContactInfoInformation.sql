
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_DeleteClientContactInfoInformation]  
AS
BEGIN
Delete A
	From SedgwickClaimContactInformationRecord as A
		Inner Join SedgwickClaimDataImport as B on A.ClaimID = B.ClaimID AND B.RecType = 'CCI'
END
