
CREATE PROCEDURE [proc_Examinee_LoadByName]
(
	@firstName varchar(50),
	@lastName varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblExaminee]
	WHERE
		([firstname] = @firstName)
	AND
		([lastname] = @lastName)

	SET @Err = @@Error

	RETURN @Err
END
