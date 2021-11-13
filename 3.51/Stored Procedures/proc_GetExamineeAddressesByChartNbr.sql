CREATE PROCEDURE [proc_GetExamineeAddressesByChartNbr]
(
	@chartnbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT Addr1, Addr2, City, State, Zip, County

	FROM [tblExaminee]
	WHERE
		([chartnbr] = @chartnbr)

	UNION

	SELECT Addr1, Addr2, City, State, Zip, County

	FROM [tblExamineeAddresses]
	WHERE
		([chartnbr] = @chartnbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
