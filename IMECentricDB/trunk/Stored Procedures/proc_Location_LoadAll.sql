

CREATE PROCEDURE [proc_Location_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblLocation]


 SET @Err = @@Error

 RETURN @Err
END


