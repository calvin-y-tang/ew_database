
CREATE PROCEDURE [proc_tblHCAIBatch_Insert]
(
	@HCAIBatchNumber int = NULL output,
	@dateadded datetime,
	@useridadded varchar(50)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblHCAIBatch]
	(
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error

	SELECT @HCAIBatchNumber = SCOPE_IDENTITY()

	RETURN @Err
END
