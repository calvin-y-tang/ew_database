

CREATE PROCEDURE [proc_WebUserAccount_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUserAccount]


 SET @Err = @@Error

 RETURN @Err
END


