CREATE PROCEDURE [proc_CheckForWebEventOverride]

@IMECentricCode int,
@UserType varchar(50),
@Description varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) FROM tblWebEventsOverride
		WHERE IMECentricCode = @IMECentricCode AND Description = @Description AND NotifyTo LIKE '%' + @UserType + '%'

	SET @Err = @@Error

	RETURN @Err
END
GO