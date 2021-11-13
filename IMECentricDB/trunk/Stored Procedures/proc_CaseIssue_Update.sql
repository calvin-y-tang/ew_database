

CREATE PROCEDURE [proc_CaseIssue_Update]
(
 @casenbr int,
 @issuecode int,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcaseissue]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded
 WHERE
  [casenbr] = @casenbr
 AND [issuecode] = @issuecode


 SET @Err = @@Error


 RETURN @Err
END


