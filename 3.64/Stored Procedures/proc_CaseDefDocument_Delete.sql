

CREATE PROCEDURE [proc_CaseDefDocument_Delete]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcasedefdocument]
 WHERE
  [casenbr] = @casenbr AND
  [documentcode] = @documentcode AND
  [documentqueue] = @documentqueue
 SET @Err = @@Error

 RETURN @Err
END


