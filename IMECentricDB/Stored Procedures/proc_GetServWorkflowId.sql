CREATE PROCEDURE [proc_GetServWorkflowId]

@ServiceCode int,
@CaseType int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 ServiceWorkflowId FROM tblServiceWorkflow WHERE ServiceCode = @ServiceCode AND CaseType = @CaseType


	SET @Err = @@Error

	RETURN @Err
END
GO