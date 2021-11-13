
CREATE PROCEDURE [proc_CaseICDRequest_LoadAll]

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseICDRequest]


	SET @Err = @@Error

	RETURN @Err
END
