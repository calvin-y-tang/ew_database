CREATE PROCEDURE [proc_Client_GetDefaultOffice]
(
	@clientcode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblClientOffice TCO
            WHERE  TCO.clientcode=TC.clientcode
            ORDER BY clientcode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblClientOffice TC
	Where clientcode = @clientcode
	GROUP BY TC.clientcode

	SET @Err = @@Error

	RETURN @Err
END
GO
