
CREATE PROCEDURE [proc_HCAIControl_LoadByPrimaryKey]
(
	@DBID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblHCAIControl]
	WHERE
		([DBID] = @DBID)

	SET @Err = @@Error

	RETURN @Err
END
