

CREATE PROCEDURE [proc_CaseIssue_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseIssue]


 SET @Err = @@Error

 RETURN @Err
END


