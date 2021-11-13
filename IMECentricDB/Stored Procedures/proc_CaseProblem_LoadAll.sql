

CREATE PROCEDURE [proc_CaseProblem_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseProblem]


 SET @Err = @@Error

 RETURN @Err
END


