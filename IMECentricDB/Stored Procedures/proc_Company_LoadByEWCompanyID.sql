
CREATE PROCEDURE [proc_Company_LoadByEWCompanyID]
(
	@EWCompanyID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCompany]
	WHERE
		([EWCompanyID] = @EWCompanyID)

	SET @Err = @@Error

	RETURN @Err
END
