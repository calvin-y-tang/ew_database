
CREATE PROCEDURE [proc_EWCoverLetterQuestion_LoadByPrimaryKey]

@EWCoverLetterQuestionID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterQuestion]
	WHERE
		([EWCoverLetterQuestionID] = @EWCoverLetterQuestionID)

	SET @Err = @@Error

	RETURN @Err
END
