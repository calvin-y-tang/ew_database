

CREATE PROCEDURE [proc_Issue_LoadByPrimaryKey]
(
 @issuecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblIssue]
 WHERE
  ([issuecode] = @issuecode)

 SET @Err = @@Error

 RETURN @Err
END


