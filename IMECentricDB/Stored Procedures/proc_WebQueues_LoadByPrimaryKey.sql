

CREATE PROCEDURE [proc_WebQueues_LoadByPrimaryKey]
(
 @statuscode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebQueues]
 WHERE
  ([statuscode] = @statuscode)

 SET @Err = @@Error

 RETURN @Err
END


