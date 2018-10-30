

CREATE PROCEDURE [proc_Doctor_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblDoctor]


 SET @Err = @@Error

 RETURN @Err
END


