CREATE PROCEDURE [proc_LoadWebEventsByDescription]

@Description varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblWebEvents WHERE Description = @Description

	SET @Err = @@Error

	RETURN @Err
END
GO