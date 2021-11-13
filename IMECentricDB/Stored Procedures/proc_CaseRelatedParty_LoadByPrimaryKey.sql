
CREATE PROCEDURE [proc_CaseRelatedParty_LoadByPrimaryKey]
(
 @CaseNbr int,
 @RPCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseRelatedParty]
 WHERE
  ([CaseNbr] = @CaseNbr)
 AND
  ([RPCode] = @RPCode)

 SET @Err = @@Error

 RETURN @Err
END
