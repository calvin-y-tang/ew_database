
CREATE PROCEDURE [dbo].[proc_WebUser_LoadByEWWebUserID]
(
	@EWWebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebUser]
	WHERE
		([EWWebUserID] = @EWWebUserID)

	SET @Err = @@Error

	RETURN @Err
END
