
CREATE PROCEDURE [proc_EWFolderDef_LoadByPrimaryKey]

@FolderID int

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblEWFolderDef WHERE FolderID = @FolderID

	SET @Err = @@Error

	RETURN @Err
END
