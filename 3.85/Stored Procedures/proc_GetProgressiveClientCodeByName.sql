CREATE PROCEDURE [proc_GetProgressiveClientCodeByName]
(
	@LastName varchar(50),
	@FirstName varchar(50),
	@CompanyCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ClientCode

	FROM [tblClient]
	WHERE
		([LastName] = @LastName)
		AND
		([FirstName] = @FirstName)
		AND 
		([CompanyCode] = @CompanyCode)

	SET @Err = @@Error

	RETURN @Err
END
GO
