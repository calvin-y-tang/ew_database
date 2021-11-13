
CREATE PROCEDURE [proc_IMECase_UpdateTransCode]
(
	@casenbr int,
	@TransCode int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[TransCode] = @TransCode
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
