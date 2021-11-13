

CREATE PROCEDURE [proc_Queues_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblQueues]


 SET @Err = @@Error

 RETURN @Err
END


