
CREATE PROCEDURE [proc_ICD_GetDescByCode]
(
	@ICDCode varchar(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT Description FROM tblICDCode WHERE Code = @ICDCode

	SET @Err = @@Error

	RETURN @Err
END
