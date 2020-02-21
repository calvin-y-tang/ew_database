CREATE PROCEDURE [proc_GetMostUsedOffice]

@UserType char(2),
@UserCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @sqlString nvarchar(2000)

	IF (@UserType = 'CL')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.ClientCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'TR')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.TransCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'DR')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.DoctorCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'AT')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where (tblCase.DefenseAttorneyCode = ' + CAST(@usercode AS varchar(20)) + ' OR tblCase.PlaintiffAttorneyCode = ' + CAST(@usercode AS varchar(20)) + ' OR tblCase.DefParaLegal = ' + CAST(@usercode AS varchar(20)) + ') group by OfficeCode order by OfficeCount desc'
	END

	Execute SP_ExecuteSQL  @sqlString

	SET @Err = @@Error

	RETURN @Err
END