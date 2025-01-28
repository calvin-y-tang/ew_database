
ALTER TABLE tblProduct
 ADD AllowVoNegativeAmount BIT
GO

UPDATE tblProduct SET AllowVoNegativeAmount=0
GO
UPDATE tblProduct SET AllowVoNegativeAmount=1
 WHERE VOGLAcct IN ('50090','50095')
GO


--Changes by Gary
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWTransDept_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWTransDept_LoadByPrimaryKey];
GO

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
GO


UPDATE tblControl SET DBVersion='2.10'
GO
