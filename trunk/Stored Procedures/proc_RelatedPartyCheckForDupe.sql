
CREATE PROCEDURE [proc_RelatedPartyCheckForDupe]

@CompanyName varchar(100) = NULL,
@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

SELECT TOP 1 rpcode FROM tblRelatedParty WHERE rpcode > 0 
 AND CompanyName LIKE '%' + COALESCE(@CompanyName,CompanyName) + '%'
 AND FirstName LIKE '%' +  COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' +  COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone)
 ORDER BY rpcode
 
SET @Err = @@Error
RETURN @Err
 

