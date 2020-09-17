
CREATE PROCEDURE [proc_GetSpecialtyByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseSpecialty 
		INNER JOIN tblSpecialty ON tblCaseSpecialty.specialtyCode = tblSpecialty.specialtyCode 
		WHERE caseNbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
