

CREATE PROCEDURE [proc_tblSyncLogsUpdate]
(
 @SyncLogID int,
 @Log_DateAdded datetime,
 @Log_Severity int,
 @Log_RelatedID int = NULL,
 @Log_Message text,
 @Log_Resolved bit,
 @log_ResolvedUserid varchar(50) = NULL,
 @log_ResolvedDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblSyncLogs]
 SET
  [Log_DateAdded] = @Log_DateAdded,
  [Log_Severity] = @Log_Severity,
  [Log_RelatedID] = @Log_RelatedID,
  [Log_Message] = @Log_Message,
  [Log_Resolved] = @Log_Resolved,
  [log_ResolvedUserid] = @log_ResolvedUserid,
  [log_ResolvedDate] = @log_ResolvedDate
 WHERE
  [SyncLogID] = @SyncLogID


 SET @Err = @@Error


 RETURN @Err
END


