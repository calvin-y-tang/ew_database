CREATE PROCEDURE [proc_PublishOnWeb_LoadByTableKeyTableType]
(
	@TableKey int,
	@UserCode int,
	@TableType varchar(50),
	@UserType varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblPublishOnWeb]
	WHERE
		([TableKey] = @TableKey)
	AND
		([UserCode] = @UserCode)
	AND 
		([TableType] = @TableType)
	AND 
		([UserType] = @UserType)

	SET @Err = @@Error

	RETURN @Err
END
GO
