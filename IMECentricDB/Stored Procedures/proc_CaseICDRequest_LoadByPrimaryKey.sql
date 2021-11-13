
CREATE PROCEDURE [proc_CaseICDRequest_LoadByPrimaryKey]
(
	@casenbr int,
	@ICDCode varchar(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseICDRequest]
	WHERE
		([casenbr] = @casenbr) AND
		([ICDCode] = @ICDCode)

	SET @Err = @@Error

	RETURN @Err
END
