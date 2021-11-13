

CREATE PROCEDURE [dbo].[proc_WebActivation_LoadByPrimaryKey]
(
 @ActivationID varchar(40)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebActivation]
 WHERE
  ([ActivationID] = @ActivationID)

 SET @Err = @@Error

 RETURN @Err
END

