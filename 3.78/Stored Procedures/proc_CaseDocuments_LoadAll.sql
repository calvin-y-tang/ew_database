

CREATE PROCEDURE [proc_CaseDocuments_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDocuments]


 SET @Err = @@Error

 RETURN @Err
END


