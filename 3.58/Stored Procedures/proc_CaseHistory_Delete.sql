

CREATE PROCEDURE [proc_CaseHistory_Delete]
(
 @id int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCaseHistory]
 WHERE
  [id] = @id
 SET @Err = @@Error

 RETURN @Err
END


