CREATE PROCEDURE [proc_CaseReviewItem_Insert]
(
	@CaseReviewItemID int = NULL output,
	@CaseNbr int = NULL,
	@Type varchar(10) = NULL,
	@CompanyName varchar(70) = NULL,
	@Address1 varchar(50) = NULL,
	@Address2 varchar(50) = NULL,
	@City varchar(50) = NULL,
	@State varchar(2) = NULL,
	@Zip varchar(10) = NULL,
	@Phone varchar(15) = NULL,
	@PhoneExt varchar(10) = NULL,
	@Fax varchar(15) = NULL,
	@ContactFirstName varchar(50) = NULL,
	@ContactLastName varchar(50) = NULL,
	@Email varchar(70) = NULL,
	@ActionTaken int = NULL,
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
	INTO [tblCaseReviewItem]
	(
		[CaseNbr],
		[Type],
		[CompanyName],
		[Address1],
		[Address2],
		[City],
		[State],
		[Zip],
		[Phone],
		[PhoneExt],
		[Fax],
		[ContactFirstName],
		[ContactLastName],
		[Email],
		[ActionTaken],
		[DateAdded],
		[UserIDAdded],
		[DateEdited],
		[UserIDEdited]
	)
	VALUES
	(
		@CaseNbr,
		@Type,
		@CompanyName,
		@Address1,
		@Address2,
		@City,
		@State,
		@Zip,
		@Phone,
		@PhoneExt,
		@Fax,
		@ContactFirstName,
		@ContactLastName,
		@Email,
		@ActionTaken,
		@DateAdded,
		@UserIDAdded,
		@DateEdited,
		@UserIDEdited
	)

	SET @Err = @@Error

	SELECT @CaseReviewItemID = SCOPE_IDENTITY()

	RETURN @Err
END