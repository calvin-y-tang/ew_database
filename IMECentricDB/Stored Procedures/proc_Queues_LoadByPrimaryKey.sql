

CREATE PROCEDURE [proc_Queues_LoadByPrimaryKey]
(
 @statuscode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblQueues]
 WHERE
  ([statuscode] = @statuscode)

 SET @Err = @@Error

 RETURN @Err
END


