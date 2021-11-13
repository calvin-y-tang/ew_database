CREATE PROCEDURE [proc_GetOfficeFacilityInfo]
(
	@Officecode int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblOffice 
		INNER JOIN tblEWFacility ON tblOffice.EwFacilityID = tblEWFacility.EWFacilityID 
		WHERE OfficeCode = @Officecode

	SET @Err = @@Error

	RETURN @Err
END
GO