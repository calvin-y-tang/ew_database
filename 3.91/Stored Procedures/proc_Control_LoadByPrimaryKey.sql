CREATE PROCEDURE [proc_Control_LoadByPrimaryKey]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblControl


	SET @Err = @@Error

	RETURN @Err
END
GO