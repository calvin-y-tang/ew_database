

CREATE PROCEDURE [proc_CaseProblem_Update]
(
 @casenbr int,
 @problemcode int,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcaseproblem]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded
 WHERE
  [casenbr] = @casenbr
 AND [problemcode] = @problemcode


 SET @Err = @@Error


 RETURN @Err
END


