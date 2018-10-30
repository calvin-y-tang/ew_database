CREATE PROCEDURE [proc_GetCaseDocTypeComboItems]

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseDocType WHERE PublishOnWeb = 1

	ORDER BY Description

	SET @Err = @@Error

	RETURN @Err
END
GO