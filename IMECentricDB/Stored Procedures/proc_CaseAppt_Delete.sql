
CREATE PROCEDURE [proc_CaseAppt_Delete]
(
	@CaseApptId int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	DELETE
	FROM [tblCaseAppt]
	WHERE
		[CaseApptId] = @CaseApptId
	SET @Err = @@Error

	RETURN @Err
END
