

CREATE PROCEDURE [proc_Office_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblOffice]
 WHERE ISNULL(Status,'') = 'Active'
 
 ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


