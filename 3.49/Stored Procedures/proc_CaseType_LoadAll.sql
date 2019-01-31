

CREATE PROCEDURE [proc_CaseType_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseType]
 WHERE PublishOnWeb = 1
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


