
CREATE PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterClientSpecData]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
