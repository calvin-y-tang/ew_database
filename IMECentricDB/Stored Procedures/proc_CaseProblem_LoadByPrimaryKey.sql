

CREATE PROCEDURE [proc_CaseProblem_LoadByPrimaryKey]
(
 @casenbr int,
 @problemcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [casenbr],
  [problemcode],
  [dateadded],
  [useridadded]
 FROM [tblcaseproblem]
 WHERE
  ([casenbr] = @casenbr) AND
  ([problemcode] = @problemcode)

 SET @Err = @@Error

 RETURN @Err
END


