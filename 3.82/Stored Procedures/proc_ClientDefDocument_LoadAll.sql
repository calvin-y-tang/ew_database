

CREATE PROCEDURE [proc_ClientDefDocument_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClientDefDocument]


 SET @Err = @@Error

 RETURN @Err
END


