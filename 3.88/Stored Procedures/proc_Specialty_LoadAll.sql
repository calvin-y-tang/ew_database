

CREATE PROCEDURE [proc_Specialty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblSpecialty]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


