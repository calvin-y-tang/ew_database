CREATE PROCEDURE [proc_CaseReviewItem_LoadByPrimaryKey]
(
	@CaseReviewItemID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseReviewItem]
	WHERE
		([CaseReviewItemID] = @CaseReviewItemID)

	SET @Err = @@Error

	RETURN @Err
END