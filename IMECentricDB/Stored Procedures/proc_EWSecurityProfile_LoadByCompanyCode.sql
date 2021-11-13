

CREATE PROCEDURE [dbo].[proc_EWSecurityProfile_LoadByCompanyCode]
(
 @CompanyCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblEWSecurityProfile]
  INNER JOIN [tblCompany] ON [tblCompany].SecurityProfileID = [tblEWSecurityProfile].SecurityProfileID
 WHERE
  ([tblCompany].CompanyCode = @CompanyCode)

 SET @Err = @@Error

 RETURN @Err
END

