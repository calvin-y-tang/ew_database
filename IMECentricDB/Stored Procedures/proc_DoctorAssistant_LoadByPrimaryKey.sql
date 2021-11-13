CREATE PROCEDURE [proc_DoctorAssistant_LoadByPrimaryKey]
(
	@DrAssistantId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblDrAssistant]
	WHERE
		([DrAssistantId] = @DrAssistantId)

	SET @Err = @@Error

	RETURN @Err
END
GO
