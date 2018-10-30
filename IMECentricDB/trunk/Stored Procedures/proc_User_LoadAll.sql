

CREATE PROCEDURE [proc_User_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblUser]


 SET @Err = @@Error

 RETURN @Err
END


