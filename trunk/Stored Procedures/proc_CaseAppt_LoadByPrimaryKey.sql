
CREATE PROCEDURE [proc_CaseAppt_LoadByPrimaryKey]
(
	@CaseApptId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseAppt]
	WHERE
		([CaseApptId] = @CaseApptId)

	SET @Err = @@Error

	RETURN @Err
END
