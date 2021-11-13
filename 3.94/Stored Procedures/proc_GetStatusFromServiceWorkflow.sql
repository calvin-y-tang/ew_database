CREATE PROCEDURE [proc_GetStatusFromServiceWorkflow]

@ServiceWorkflowID int,
@StatusCode int,
@Direction char(4)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	IF @Direction = 'Next'
	BEGIN
	SELECT NextStatus FROM tblServiceWorkflowQueue where ServiceWorkFlowID = @ServiceWorkflowID
		AND StatusCode = @StatusCode
	END

	IF @Direction = 'Prev'
	BEGIN
	SELECT StatusCode FROM tblServiceWorkflowQueue where ServiceWorkFlowID = @ServiceWorkflowID
		AND NextStatus = @StatusCode
	END

	SET @Err = @@Error

	RETURN @Err
END
GO