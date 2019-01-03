

CREATE PROCEDURE [proc_Client_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]


 SET @Err = @@Error

 RETURN @Err
END


