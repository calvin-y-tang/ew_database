
CREATE PROCEDURE [proc_Client_IsPhotoRqd]
(
	@clientcode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ISNULL(dbo.tblClient.PhotoRqd, dbo.tblCompany.PhotoRqd) AS photoRqd
		FROM tblClient INNER JOIN dbo.tblCompany ON dbo.tblClient.CompanyCode = dbo.tblCompany.CompanyCode
        WHERE tblClient.ClientCode = @clientcode

	SET @Err = @@Error

	RETURN @Err
END
