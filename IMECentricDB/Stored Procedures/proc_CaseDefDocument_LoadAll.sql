

CREATE PROCEDURE [proc_CaseDefDocument_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDefDocument]


 SET @Err = @@Error

 RETURN @Err
END


