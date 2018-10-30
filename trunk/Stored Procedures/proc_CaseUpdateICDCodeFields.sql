CREATE PROCEDURE [proc_CaseUpdateICDCodeFields]
(
	@CaseNbr int,
	@ICDCodeField varchar(40),
	@ICDCodeVal varchar(40)
)
AS

DECLARE @string NCHAR(500)

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SET @string = 'update tblCase set ' + RTRIM(@ICDCodeField) + ' = ''' + RTRIM(@ICDCodeVal) + ''' where CaseNbr = ' + CAST(@CaseNbr as VARCHAR(20))
	EXEC sp_executesql @string

	SET @Err = @@Error

	RETURN @Err
END
GO
