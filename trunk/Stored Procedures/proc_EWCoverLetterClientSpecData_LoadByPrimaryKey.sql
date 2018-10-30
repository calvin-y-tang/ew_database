
CREATE PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByPrimaryKey]

@EWCoverLetterClientSpecDataID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterClientSpecData]
	WHERE
		([EWCoverLetterClientSpecDataID] = @EWCoverLetterClientSpecDataID)

	SET @Err = @@Error

	RETURN @Err
END
