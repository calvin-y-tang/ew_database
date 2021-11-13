
CREATE PROCEDURE [proc_EWTransDept_LoadByPrimaryKey]

@EWTransDeptID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblEWTransDept
		WHERE EWTransDeptID = @EWTransDeptID

	SET @Err = @@Error

	RETURN @Err
END
