
CREATE PROCEDURE [proc_EWCoverLetterQuestion_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterQuestion]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
