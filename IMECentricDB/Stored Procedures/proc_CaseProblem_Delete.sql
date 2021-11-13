

CREATE PROCEDURE [proc_CaseProblem_Delete]
(
 @casenbr int,
 @problemcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcaseproblem]
 WHERE
  [casenbr] = @casenbr AND
  [problemcode] = @problemcode
 SET @Err = @@Error

 RETURN @Err
END


