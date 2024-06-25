

CREATE PROCEDURE [proc_Examinee_LoadByPrimaryKey]
(
 @chartnbr int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [vwtblExaminee]
 WHERE
  ([chartnbr] = @chartnbr)

 SET @Err = @@Error

 RETURN @Err
END


