

CREATE PROCEDURE [proc_CCAddress_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCCAddress]


 SET @Err = @@Error

 RETURN @Err
END


