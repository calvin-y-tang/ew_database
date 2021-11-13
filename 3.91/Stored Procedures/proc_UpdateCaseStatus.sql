CREATE PROCEDURE [proc_UpdateCaseStatus]
(
	@CaseNbr int,
	@StatusCode int,
	@UpdateTime datetime
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE tblCase SET STATUS = @StatusCode, LastStatusChg = @UpdateTime WHERE CaseNbr = @CaseNbr

	SET @Err = @@Error

	RETURN @Err
END
GO
