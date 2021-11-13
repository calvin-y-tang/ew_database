

CREATE PROCEDURE [proc_WebQueues_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebQueues]


 SET @Err = @@Error

 RETURN @Err
END


