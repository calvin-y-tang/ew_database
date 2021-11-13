
CREATE PROCEDURE [dbo].[proc_CaseSpecialty_LoadByPrimaryKey]
(
	@casenbr int,
	@Specialtycode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		*
	FROM [tblCaseSpecialty]
	WHERE
		([casenbr] = @casenbr) AND
		([Specialtycode] = @Specialtycode)

	SET @Err = @@Error

	RETURN @Err
END
