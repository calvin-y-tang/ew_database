
CREATE PROCEDURE [proc_EWFolderDef_LoadByName]

@Name varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblEWFolderDef WHERE Name = @Name

	SET @Err = @@Error

	RETURN @Err
END
