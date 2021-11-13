
CREATE PROCEDURE [proc_CCAddress_LoadByName]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@Company varchar(70)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCCAddress]
	WHERE
		([FirstName] = @FirstName)
	AND
		([LastName] = @LastName)
	AND
		([Company] = @Company)

	SET @Err = @@Error

	RETURN @Err
END
