CREATE PROCEDURE [proc_ProblemArea_LoadByProblemCode]
(
	@ProblemCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblProblemArea.ProblemAreaCode, tblProblemArea.Description FROM tblProblem 
	INNER JOIN tblProblemDetail on tblProblem.ProblemCode = tblProblemDetail.ProblemCode
	INNER JOIN tblProblemArea on tblProblemDetail.ProblemAreaCode = tblProblemArea.ProblemAreaCode
	WHERE tblProblem.PublishOnWeb = 1
	AND tblProblem.Status = 'Active'
	AND tblProblem.ProblemCode = @ProblemCode

	SET @Err = @@Error

	RETURN @Err
END
GO