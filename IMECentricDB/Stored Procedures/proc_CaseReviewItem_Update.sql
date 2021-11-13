CREATE PROCEDURE [proc_CaseReviewItem_Update]
(
	@CaseReviewItemID int,
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

	UPDATE [tblCaseReviewItem]
	SET
		[CaseNbr] = @CaseNbr,
		[Type] = @Type,
		[CompanyName] = @CompanyName,
		[Address1] = @Address1,
		[Address2] = @Address2,
		[City] = @City,
		[State] = @State,
		[Zip] = @Zip,
		[Phone] = @Phone,
		[PhoneExt] = @PhoneExt,
		[Fax] = @Fax,
		[ContactFirstName] = @ContactFirstName,
		[ContactLastName] = @ContactLastName,
		[Email] = @Email,
		[ActionTaken] = @ActionTaken,
		[DateAdded] = @DateAdded,
		[UserIDAdded] = @UserIDAdded,
		[DateEdited] = @DateEdited,
		[UserIDEdited] = @UserIDEdited
	WHERE
		[CaseReviewItemID] = @CaseReviewItemID


	SET @Err = @@Error


	RETURN @Err
END