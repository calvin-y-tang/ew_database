

CREATE PROCEDURE [proc_CaseHistory_LoadByPrimaryKey]
(
 @id int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]
 WHERE
  ([id] = @id)

 SET @Err = @@Error

 RETURN @Err
END


