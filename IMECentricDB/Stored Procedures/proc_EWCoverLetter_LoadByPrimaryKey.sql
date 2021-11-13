
CREATE PROCEDURE [proc_EWCoverLetter_LoadByPrimaryKey]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetter]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
