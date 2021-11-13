CREATE PROCEDURE [proc_Client_LoadByParentCompany]
(
	@ParentCompanyId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ClientCode, LastName + ', ' + FirstName Name

	FROM tblClient
		WHERE CompanyCode in (SELECT CompanyCode FROM tblCompany WHERE ParentCompanyID = @ParentCompanyId)
		AND Status = 'Active' ORDER BY LastName

	SET @Err = @@Error

	RETURN @Err
END
GO
