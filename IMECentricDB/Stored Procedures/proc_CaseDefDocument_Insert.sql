CREATE PROCEDURE [proc_CaseDefDocument_Insert]
(
	@casenbr int,
	@documentcode varchar(15),
	@documentqueue int,
	@dateadded datetime = NULL,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(20) = NULL,
	@DocumentToReplace varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblcasedefdocument]
	(
		[casenbr],
		[documentcode],
		[documentqueue],
		[dateadded],
		[useridadded],
		[dateedited],
		[useridedited],
		[DocumentToReplace]
	)
	VALUES
	(
		@casenbr,
		@documentcode,
		@documentqueue,
		@dateadded,
		@useridadded,
		@dateedited,
		@useridedited,
		@DocumentToReplace
	)

	SET @Err = @@Error

	RETURN @Err
END
GO
