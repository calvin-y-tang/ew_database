

CREATE PROCEDURE [proc_Examinee_Delete]
(
 @chartnbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblExaminee]
 WHERE
  [chartnbr] = @chartnbr
 SET @Err = @@Error

 RETURN @Err
END


