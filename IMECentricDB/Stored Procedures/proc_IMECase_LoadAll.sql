

CREATE PROCEDURE [proc_IMECase_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCase]


 SET @Err = @@Error

 RETURN @Err
END


