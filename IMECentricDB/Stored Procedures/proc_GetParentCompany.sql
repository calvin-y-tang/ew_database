
CREATE PROCEDURE [proc_GetParentCompany]
(
	@ParentCompanyId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblEWParentCompany]
	WHERE
		([ParentCompanyId] = @ParentCompanyId)

	SET @Err = @@Error

	RETURN @Err
END
GO