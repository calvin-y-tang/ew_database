
CREATE PROCEDURE [proc_IMECase_UpdateDateEdited]
(
	@casenbr int,
	@dateedited datetime
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[dateedited] = @dateedited
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
