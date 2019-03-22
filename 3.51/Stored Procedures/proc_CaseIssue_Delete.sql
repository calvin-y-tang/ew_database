

CREATE PROCEDURE [proc_CaseIssue_Delete]
(
 @casenbr int,
 @issuecode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcaseissue]
 WHERE
  [casenbr] = @casenbr AND
  [issuecode] = @issuecode
 SET @Err = @@Error

 RETURN @Err
END


