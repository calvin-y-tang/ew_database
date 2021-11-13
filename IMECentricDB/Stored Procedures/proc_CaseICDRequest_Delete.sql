
CREATE PROCEDURE [proc_CaseICDRequest_Delete]
(
	@casenbr int,
	@ICDCode varchar(10)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	DELETE
	FROM [tblCaseICDRequest]
	WHERE
		[casenbr] = @casenbr AND
		[ICDCode] = @ICDCode
	SET @Err = @@Error

	RETURN @Err
END
