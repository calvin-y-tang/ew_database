CREATE PROCEDURE [proc_LoadCaseSearchProgressive] 
(
	@ClaimNbr varchar(50),
	@ClaimNbrExt varchar(50),
	@LastName varchar(50),
	@CompanyCode int
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(2000)
	DECLARE @modulo as NVARCHAR(5) = '%'

    SET @StrSQL = 'SELECT TOP 50 * FROM tblCase INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ' +
		'WHERE (tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE CompanyCode = ' + CAST(@CompanyCode AS VARCHAR(20)) + ')) '

		IF LEN(@ClaimNbr) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbr LIKE ''' + @modulo + @ClaimNbr + @modulo + ''') '
		END 
		
		IF LEN(@ClaimNbrExt) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbrExt LIKE ''' + @modulo + @ClaimNbrExt + @modulo + ''') '
		END 

		IF LEN(@LastName) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblExaminee.LastName LIKE ''' + @modulo + @LastName + @modulo + ''') '
		END 

        SET @StrSQL = @StrSQL + ' ORDER BY tblCase.DateAdded DESC, tblCase.ClaimNbr, tblExaminee.LastName'

		PRINT @StrSQL
		
		BEGIN
			EXEC SP_EXECUTESQL @StrSQL
		END

	SET @Err = @@Error

	RETURN @Err
END
