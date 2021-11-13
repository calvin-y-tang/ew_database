
CREATE PROCEDURE [proc_ExamineeCheckForDupe]

@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone1 varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int


SELECT TOP 1 chartnbr FROM tblExaminee WHERE chartnbr > 0 
 AND FirstName = COALESCE(@FirstName,FirstName) 
 AND LastName = COALESCE(@LastName,LastName) 
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE( REPLACE( REPLACE( REPLACE( REPLACE(@Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone1) 
 ORDER BY chartnbr
 
SET @Err = @@Error
RETURN @Err

