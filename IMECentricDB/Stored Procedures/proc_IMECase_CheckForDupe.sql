CREATE PROCEDURE [proc_IMECase_CheckForDupe]
(
	@CaseType int,
	@ServiceCode int,
	@Jurisdiction varchar(5),
	@ClaimNbr varchar(50),
	@DateOfInjury datetime,
	@CheckDate datetime,
	@FirstName varchar(50),
	@LastName varchar(50),
	@ClientCode int,
	@SReqSpecialty varchar(500)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 CaseNbr
	FROM tblCase
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			WHERE caseType = @CaseType
			AND ServiceCode =  @ServiceCode
			AND Jurisdiction = @Jurisdiction
			AND ClaimNbr = @ClaimNbr
			AND tblCase.SReqSpecialty = @SReqSpecialty
			AND DateOfInjury = @DateofInjury
			AND tblCase.ClientCode = @ClientCode
			AND tblCase.DateAdded >= @CheckDate
			AND tblExaminee.FirstName = @Firstname
			AND tblExaminee.LastName = @Lastname

	SET @Err = @@Error

	RETURN @Err
END
GO