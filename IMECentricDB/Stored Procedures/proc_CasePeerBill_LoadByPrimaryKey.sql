CREATE PROCEDURE [proc_CasePeerBill_LoadByPrimaryKey]
(
	@PeerBillID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCasePeerBill]
	WHERE
		([PeerBillID] = @PeerBillID)

	SET @Err = @@Error

	RETURN @Err
END
GO