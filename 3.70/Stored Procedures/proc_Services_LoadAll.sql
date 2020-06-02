

CREATE PROCEDURE [proc_Services_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblServices]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


