CREATE PROCEDURE [proc_WebUser_Update]
(
	@WebUserID int,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@LastLoginDate datetime = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@UseridEdited varchar(50) = NULL,
	@DisplayClient bit,
	@ProviderSearch bit,
	@IMECentricCode int,
	@UserType varchar(2),
	@AutoPublishNewCases bit,
	@IsClientAdmin bit,
	@UpdateFlag bit,
	@LastPasswordChangeDate datetime = NULL,
	@StatusID int = NULL,
	@FailedLoginAttempts int = NULL,
	@LockoutDate datetime = NULL,
	@ShowThirdPartyBilling bit
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblWebUser]
	SET
		[UserID] = @UserID,
		[Password] = @Password,
		[LastLoginDate] = @LastLoginDate,
		[DateAdded] = @DateAdded,
		[DateEdited] = @DateEdited,
		[UseridAdded] = @UseridAdded,
		[UseridEdited] = @UseridEdited,
		[DisplayClient] = @DisplayClient,
		[ProviderSearch] = @ProviderSearch,
		[IMECentricCode] = @IMECentricCode,
		[UserType] = @UserType,
		[AutoPublishNewCases] = @AutoPublishNewCases,
		[IsClientAdmin] = @IsClientAdmin,
		[UpdateFlag] = @UpdateFlag,
		[LastPasswordChangeDate] = @LastPasswordChangeDate,
		[StatusID] = @StatusID,
		[FailedLoginAttempts] = @FailedLoginAttempts,
		[LockoutDate] = @LockoutDate,
		[ShowThirdPartyBilling] = @ShowThirdPartyBilling
	WHERE
		[WebUserID] = @WebUserID


	SET @Err = @@Error


	RETURN @Err
END