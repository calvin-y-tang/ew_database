

CREATE PROCEDURE [proc_Company_LoadByPrimaryKey]
(
 @companycode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCompany]
 WHERE
  ([companycode] = @companycode)

 SET @Err = @@Error

 RETURN @Err
END


