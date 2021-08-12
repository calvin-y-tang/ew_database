

CREATE PROCEDURE [proc_User_LoadByPrimaryKey]
(
 @userid varchar(15)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblUser]
 WHERE
  ([userid] = @userid) 

 SET @Err = @@Error

 RETURN @Err
END


