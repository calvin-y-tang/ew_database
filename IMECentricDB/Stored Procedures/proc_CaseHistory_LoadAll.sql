

CREATE PROCEDURE [proc_CaseHistory_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]


 SET @Err = @@Error

 RETURN @Err
END


