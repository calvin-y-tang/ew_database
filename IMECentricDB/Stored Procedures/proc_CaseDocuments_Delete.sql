

CREATE PROCEDURE [proc_CaseDocuments_Delete]
(
 @seqno int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCaseDocuments]
 WHERE
  [seqno] = @seqno
 SET @Err = @@Error

 RETURN @Err
END


