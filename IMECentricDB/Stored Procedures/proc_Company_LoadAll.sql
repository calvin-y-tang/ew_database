

CREATE PROCEDURE [proc_Company_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCompany]
 
 ORDER BY intname


 SET @Err = @@Error

 RETURN @Err
END

