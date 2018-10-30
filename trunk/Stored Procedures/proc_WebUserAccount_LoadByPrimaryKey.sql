
CREATE PROCEDURE [proc_WebUserAccount_LoadByPrimaryKey]
(
	@WebUserID int,
	@UserCode int,
	@UserType char(2)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[WebUserID],
		[UserCode],
		[IsUser],
		[DateAdded],
		[IsActive],
		[UserType]
	FROM [tblWebUserAccount]
	WHERE
		([WebUserID] = @WebUserID) AND
		([UserCode] = @UserCode) AND
		([UserType] = @UserType)

	SET @Err = @@Error

	RETURN @Err
END
