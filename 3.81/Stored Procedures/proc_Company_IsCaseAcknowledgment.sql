CREATE PROCEDURE [proc_Company_IsCaseAcknowledgment]

@CompanyCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT CaseAcknowledgment FROM tblCompany WHERE CompanyCode = @CompanyCode


	SET @Err = @@Error

	RETURN @Err
END
GO