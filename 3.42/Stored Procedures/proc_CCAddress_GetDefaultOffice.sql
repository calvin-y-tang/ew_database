CREATE PROCEDURE [proc_CCAddress_GetDefaultOffice]
(
	@cccode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblCCAddressOffice TCO
            WHERE  TCO.cccode=TC.cccode
            ORDER BY cccode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblCCAddressOffice TC
	Where cccode = @cccode
	GROUP BY TC.cccode

	SET @Err = @@Error

	RETURN @Err
END
GO
