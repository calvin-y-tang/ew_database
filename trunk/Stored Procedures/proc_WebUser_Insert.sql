
CREATE PROCEDURE [proc_WebUser_Insert]
(
        @WebUserID int = NULL output,
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
        @LockoutDate datetime = NULL
)
AS
BEGIN

        SET NOCOUNT OFF
        DECLARE @Err int

        INSERT
        INTO [tblWebUser]
        (
                [UserID],
                [Password],
                [LastLoginDate],
                [DateAdded],
                [DateEdited],
                [UseridAdded],
                [UseridEdited],
                [DisplayClient],
                [ProviderSearch],
                [IMECentricCode],
                [UserType],
                [AutoPublishNewCases],
                [IsClientAdmin],
                [UpdateFlag],
                [LastPasswordChangeDate],
                [StatusID],
                [FailedLoginAttempts],
                [LockoutDate]
        )
        VALUES
        (
                @UserID,
                @Password,
                @LastLoginDate,
                @DateAdded,
                @DateEdited,
                @UseridAdded,
                @UseridEdited,
                @DisplayClient,
                @ProviderSearch,
                @IMECentricCode,
                @UserType,
                @AutoPublishNewCases,
                @IsClientAdmin,
                @UpdateFlag,
                @LastPasswordChangeDate,
                @StatusID,
                @FailedLoginAttempts,
                @LockoutDate
        )

        SET @Err = @@Error

        SELECT @WebUserID = SCOPE_IDENTITY()

        RETURN @Err
END
