

CREATE PROCEDURE [proc_CaseIssue_LoadByPrimaryKey]
(
 @casenbr int,
 @issuecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [casenbr],
  [issuecode],
  [dateadded],
  [useridadded]
 FROM [tblcaseissue]
 WHERE
  ([casenbr] = @casenbr) AND
  ([issuecode] = @issuecode)

 SET @Err = @@Error

 RETURN @Err
END


