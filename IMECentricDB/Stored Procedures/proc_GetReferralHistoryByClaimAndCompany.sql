CREATE PROCEDURE [proc_GetReferralHistoryByClaimAndCompany] 

@CompanyCode varchar(20),
@ClaimNbr varchar(50) = null,
@LastName varchar(50) = null

AS

SET NOCOUNT OFF
DECLARE @Err int

	DECLARE @strSQL nvarchar(2000)
	DECLARE @modulo as NVARCHAR(5) = '%'

    SET @StrSQL = 'SELECT TOP 50 * FROM tblCase '
	SET @StrSql = @StrSQL + 'INNER JOIN vwtblExaminee AS tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr '
	SET @StrSql = @StrSQL + 'WHERE (tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE CompanyCode = ' + @CompanyCode + ')) '

		IF LEN(@ClaimNbr) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbr LIKE ''' + @modulo + @ClaimNbr + @modulo + ''') '
		END 
		
		IF LEN(@LastName) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblExaminee.LastName LIKE ''' + @modulo + @LastName + @modulo + ''') '
		END 

        SET @StrSql = @StrSQL + 'ORDER BY tblCase.DateAdded DESC, tblCase.ClaimNbr, tblExaminee.LastName'

		BEGIN
			EXEC SP_EXECUTESQL @StrSQL
		END

SET @Err = @@Error
RETURN @Err
