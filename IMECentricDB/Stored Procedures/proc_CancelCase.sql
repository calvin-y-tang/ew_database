CREATE PROCEDURE [proc_CancelCase]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE tblCase SET STATUS = 9 WHERE CaseNbr = @CaseNbr

	SET @Err = @@Error

	RETURN @Err
END
GO
