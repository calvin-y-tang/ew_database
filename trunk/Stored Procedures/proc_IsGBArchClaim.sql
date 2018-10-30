CREATE PROCEDURE [proc_IsGBArchClaim]
(
	@PPSClaimNumber varchar(75),
	@IsArchClaim bit output
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @CarrierNum char(6)

	SET @CarrierNum = (SELECT CarrierNumber FROM vwGBClaimRecords WHERE ppsClaimNumber = @PPSClaimNumber)

	IF @CarrierNum IN ('105000', '105001', '105002', '105003') 
		SET @IsArchClaim = 1
	ELSE
		SET @IsArchClaim = 0

	SET @Err = @@Error

	RETURN @Err
END
GO