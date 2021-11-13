

CREATE PROCEDURE [dbo].[proc_EWSecurityProfile_LoadByPrimaryKey]
(
 @SecurityProfileID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblEWSecurityProfile]
 WHERE
  ([SecurityProfileID] = @SecurityProfileID)

 SET @Err = @@Error

 RETURN @Err
END

