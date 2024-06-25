

CREATE PROCEDURE [proc_Examinee_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [vwtblExaminee]


 SET @Err = @@Error

 RETURN @Err
END


