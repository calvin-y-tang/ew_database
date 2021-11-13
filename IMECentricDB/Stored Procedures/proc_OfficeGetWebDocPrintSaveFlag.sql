CREATE PROCEDURE [proc_OfficeGetWebDocPrintSaveFlag]

@CompanyCode int,
@OfficeCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 SuppressWeb FROM tblCompanyOffice WHERE CompanyCode = @CompanyCode AND OfficeCode = @OfficeCode

	SET @Err = @@Error

	RETURN @Err
END
GO