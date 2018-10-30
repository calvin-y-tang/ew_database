CREATE PROCEDURE [proc_Doctor_GetDefaultOffice]
(
	@DoctorCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblDoctorOffice TCO
            WHERE  TCO.DoctorCode=TC.DoctorCode
            ORDER BY DoctorCode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblDoctorOffice TC
	Where DoctorCode = @DoctorCode
	GROUP BY TC.DoctorCode

	SET @Err = @@Error

	RETURN @Err
END
GO