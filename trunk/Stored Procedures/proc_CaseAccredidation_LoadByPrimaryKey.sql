
CREATE PROCEDURE [proc_CaseAccredidation_LoadByPrimaryKey]
(
	@casenbr int,
	@EWAccreditationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		*
	FROM [tblCaseAccredidation]
	WHERE
		([casenbr] = @casenbr) AND
		([EWAccreditationID] = @EWAccreditationID)

	SET @Err = @@Error

	RETURN @Err
END
