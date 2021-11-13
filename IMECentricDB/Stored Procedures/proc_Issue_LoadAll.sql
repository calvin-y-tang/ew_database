

CREATE PROCEDURE [proc_Issue_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblIssue]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


