

CREATE PROCEDURE [proc_CaseDefDocument_LoadByPrimaryKey]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblcasedefdocument]
 WHERE
  ([casenbr] = @casenbr) AND
  ([documentcode] = @documentcode) AND
  ([documentqueue] = @documentqueue)

 SET @Err = @@Error

 RETURN @Err
END


