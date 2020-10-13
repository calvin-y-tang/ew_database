

CREATE PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndType]
(
 @casenbr int,
 @histType varchar(20)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]
 WHERE
  ([casenbr] = @casenbr)
 AND
  ([type] = @histType)

 SET @Err = @@Error

 RETURN @Err
END


