CREATE PROCEDURE [proc_CasePeerBill_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCasePeerBill]
	WHERE
		([CaseNbr] = @CaseNbr)

	SET @Err = @@Error

	RETURN @Err
END