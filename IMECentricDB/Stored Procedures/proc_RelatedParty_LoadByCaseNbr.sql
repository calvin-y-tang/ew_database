CREATE PROCEDURE [proc_RelatedParty_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 RpCode FROM tblCaseRelatedParty WHERE CaseNbr = @CaseNbr

	SET @Err = @@Error

	RETURN @Err
END
GO
