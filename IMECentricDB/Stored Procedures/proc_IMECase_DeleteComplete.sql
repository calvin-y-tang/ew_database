
CREATE PROCEDURE [proc_IMECase_DeleteComplete]
(
 @casenbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

  --Delete publishonweb records
  DELETE FROM tblPublishOnWeb WHERE TableKey = @CaseNbr
  DELETE FROM tblPublishOnWeb WHERE TableKey IN (SELECT id FROM tblCaseHistory WHERE CaseNbr = @CaseNbr)
  DELETE FROM tblPublishOnWeb WHERE TableKey IN (SELECT seqno FROM tblCaseDocuments WHERE CaseNbr = @CaseNbr)

  --Delete casehistory records
  DELETE FROM tblCaseHistory WHERE CaseNbr = @CaseNbr

  --Delete casedocument records
  DELETE FROM tblCaseDocuments WHERE CaseNbr = @CaseNbr

  --Delete CaseIssue records
  DELETE FROM tblCaseIssue WHERE CaseNbr = @CaseNbr

  --Delete CaseProblem records
  DELETE FROM tblCaseProblem WHERE CaseNbr = @CaseNbr

  --Delete case record
  DELETE FROM tblCase WHERE CaseNbr = @CaseNbr

 SET @Err = @@Error

 RETURN @Err
END
