CREATE PROCEDURE [proc_CaseType_LoadComboByOfficeCode]

@OfficeCode nvarchar(100)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblCaseType.Code, tblCaseType.Description FROM tblCaseType ' +
	'INNER JOIN tblCaseTypeOffice on tblCaseType.code = tblCaseTypeOffice.CaseType ' +
	'WHERE tblCaseType.PublishOnWeb = 1 ' +
	'AND tblCaseTypeOffice.OfficeCode IN (' + @OfficeCode + ') ORDER BY tblCaseType.Description'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END
GO