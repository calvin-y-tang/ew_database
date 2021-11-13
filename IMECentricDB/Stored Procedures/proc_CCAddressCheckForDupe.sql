

CREATE PROCEDURE [proc_CCAddressCheckForDupe]

@Company varchar(100) = NULL,
@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

SELECT TOP 1 cccode FROM tblCCAddress WHERE cccode > 0 
 AND Company LIKE '%' + COALESCE(@Company,Company) + '%'
 AND FirstName LIKE '%' +  COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' +  COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone)
 ORDER BY cccode
 
SET @Err = @@Error
RETURN @Err
 

