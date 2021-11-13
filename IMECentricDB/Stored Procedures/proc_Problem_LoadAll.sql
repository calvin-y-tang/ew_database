

CREATE PROCEDURE [proc_Problem_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblProblem]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


