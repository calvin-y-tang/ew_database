CREATE PROCEDURE [proc_CheckForExamineeDupeProgressive]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@ClaimNbr varchar(50),
	@FeatureNbr varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 *

	FROM [tblExaminee]
		INNER JOIN tblCase ON tblExaminee.ChartNbr = tblCase.ChartNbr
		WHERE (tblExaminee.FirstName = @firstName)
		AND (tblExaminee.LastName = @lastName)	
		AND (tblCase.ClaimNbr = @ClaimNbr)
		AND (tblCase.ClaimNbrExt = @FeatureNbr)

	ORDER BY tblCase.DateAdded DESC

	SET @Err = @@Error

	RETURN @Err
END
GO
