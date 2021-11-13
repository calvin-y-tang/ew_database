

CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_LoadByPrimaryKey]
(
 @WebPasswordHistoryID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebPasswordHistory]
 WHERE
  ([WebPasswordHistoryID] = @WebPasswordHistoryID)

 SET @Err = @@Error

 RETURN @Err
END

