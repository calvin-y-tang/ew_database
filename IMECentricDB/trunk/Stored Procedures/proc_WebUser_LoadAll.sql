

CREATE PROCEDURE [proc_WebUser_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]


 SET @Err = @@Error

 RETURN @Err
END


