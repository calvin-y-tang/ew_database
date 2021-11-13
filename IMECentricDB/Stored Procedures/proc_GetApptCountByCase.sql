CREATE PROCEDURE [proc_GetApptCountByCase]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) 
		FROM tblCaseAppt 
			WHERE CaseNbr = @CaseNbr 
				AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1

	SET @Err = @@Error

	RETURN @Err
END
GO