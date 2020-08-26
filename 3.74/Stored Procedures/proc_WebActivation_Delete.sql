

CREATE PROCEDURE [dbo].[proc_WebActivation_Delete]
(
 @ActivationID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebActivation]
 WHERE
  [ActivationID] = @ActivationID
 SET @Err = @@Error

 RETURN @Err
END

