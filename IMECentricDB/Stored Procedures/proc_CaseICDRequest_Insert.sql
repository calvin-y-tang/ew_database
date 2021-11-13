
CREATE PROCEDURE [proc_CaseICDRequest_Insert]
(
	@seqno int = NULL output,
	@casenbr int,
	@ICDCode varchar(10) = NULL,
	@Status varchar(50) = NULL,
	@Description varchar(200) = NULL,
	@DateAdded datetime = NULL,
	@UserIDAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseICDRequest]
	(
		[casenbr],	
		[ICDCode],	
		[Status],
		[Description],	
		[DateAdded],	
		[UserIDAdded],	
		[DateEdited],	
		[UserIDEdited]
	)
	VALUES
	(
		@casenbr,	
		@ICDCode,	
		@Status,
		@Description,	
		@DateAdded,	
		@UserIDAdded,	
		@DateEdited,	
		@UserIDEdited
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
