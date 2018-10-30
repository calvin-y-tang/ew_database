

CREATE PROCEDURE [proc_CaseType_LoadByPrimaryKey]
(
 @Code int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseType]
 WHERE
  ([Code] = @Code)

 SET @Err = @@Error

 RETURN @Err
END


