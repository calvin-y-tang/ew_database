CREATE PROCEDURE [dbo].[proc_EDIDetermination]
(
@CaseNbr INT,
@ChangeProcessEDI BIT OUTPUT 
)
AS
DECLARE @Jurisdiction VARCHAR(2)
DECLARE @ParentCompany INT
BEGIN
	SET @ParentCompany = ( SELECT ParentCompanyID FROM tblCase AS c
		INNER JOIN tblCompany as co on c.CompanyCode = co.CompanyCode
		WHERE c.CaseNbr = @CaseNbr)
	IF(@ParentCompany = 87)
		BEGIN
			SET @ChangeProcessEDI = (SELECT TOP 1 Count(OfficeCode) AS SkipEDI FROM tblCase
							WHERE CaseNbr = @CaseNbr AND OfficeCode In (14))
		END
	ELSE
		BEGIN
			SET @ChangeProcessEDI = 0
		END

    RETURN @ChangeProcessEDI
END
GO