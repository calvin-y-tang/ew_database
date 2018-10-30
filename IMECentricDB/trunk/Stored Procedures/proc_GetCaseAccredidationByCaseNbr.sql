
CREATE PROCEDURE [dbo].[proc_GetCaseAccredidationByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseAccredidation 
		INNER JOIN tblEWAccreditation ON tblCaseAccredidation.EWAccreditationID = tblEWAccreditation.EWAccreditationID 
		WHERE caseNbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
