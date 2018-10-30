
CREATE PROCEDURE [proc_CaseRelatedParty_Insert]
(
 @CaseRPID int = NULL output,
 @CaseNbr int,
 @RPCode int,
 @CompanyCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseRelatedParty]
 (
  [CaseNbr], 
  [RPCode], 
  [CompanyCode]
 )
 VALUES
 (
  @CaseNbr, 
  @RPCode, 
  @CompanyCode
 )

 SET @Err = @@Error

 SELECT @CaseRPID = SCOPE_IDENTITY()

 RETURN @Err
END
