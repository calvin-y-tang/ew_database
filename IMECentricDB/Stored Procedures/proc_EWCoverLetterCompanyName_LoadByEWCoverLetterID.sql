
CREATE PROCEDURE [proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterCompanyName]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
