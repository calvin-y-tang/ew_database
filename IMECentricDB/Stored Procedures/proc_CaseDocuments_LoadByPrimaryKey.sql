

CREATE PROCEDURE [proc_CaseDocuments_LoadByPrimaryKey]
(
 @seqno int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDocuments]
 WHERE
  ([seqno] = @seqno)

 SET @Err = @@Error

 RETURN @Err
END


