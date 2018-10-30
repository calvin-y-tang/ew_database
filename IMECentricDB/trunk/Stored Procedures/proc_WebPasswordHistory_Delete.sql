

CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Delete]
(
 @WebPasswordHistoryID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebPasswordHistory]
 WHERE
  [WebPasswordHistoryID] = @WebPasswordHistoryID
 SET @Err = @@Error

 RETURN @Err
END

