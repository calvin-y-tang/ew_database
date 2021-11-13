CREATE PROCEDURE [proc_Service_LoadComboByOfficeCode]

@OfficeCode nvarchar(100),
@ParentCompanyID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @ServiceIncludeExclude bit

	SET @ServiceIncludeExclude = (SELECT ServiceIncludeExclude FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblServices.ServiceCode, tblServices.Description FROM tblServices ' +
	'INNER JOIN tblServiceOffice on tblServices.servicecode = tblServiceOffice.servicecode ' +
	'WHERE tblServices.PublishOnWeb = 1 ' +
	'AND tblServiceOffice.OfficeCode IN(' + @OfficeCode + ') '

	IF (@ServiceIncludeExclude = 1)
		SET @StrSQL = @StrSQL + 'AND tblServices.ServiceCode IN (SELECT ServiceCode FROM tblServiceIncludeExclude WHERE tblServiceIncludeExclude.Type = ''PC'' AND tblServiceIncludeExclude.Code = ' + CAST(@ParentCompanyID AS VARCHAR(40)) + ') '
	ELSE IF (@ServiceIncludeExclude = 0)
		SET @StrSQL = @StrSQL + 'AND tblServices.ServiceCode NOT IN (SELECT ServiceCode FROM tblServiceIncludeExclude WHERE tblServiceIncludeExclude.Type = ''PC'' AND tblServiceIncludeExclude.Code = ' + CAST(@ParentCompanyID AS VARCHAR(40)) + ') '

	SET @StrSQL = @StrSQL + 'ORDER BY Description'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END