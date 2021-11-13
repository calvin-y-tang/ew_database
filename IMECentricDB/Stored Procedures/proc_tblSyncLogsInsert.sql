CREATE PROCEDURE [dbo].[proc_tblSyncLogsInsert]
(
	@SyncLogID int = NULL output,
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

	INSERT
	INTO [tblSyncLogs]
	(
		[Log_DateAdded],
		[Log_Severity],
		[Log_RelatedID],
		[Log_Message],
		[Log_Resolved],
		[log_ResolvedUserid],
		[log_ResolvedDate]
	)
	VALUES
	(
		@Log_DateAdded,
		@Log_Severity,
		@Log_RelatedID,
		@Log_Message,
		@Log_Resolved,
		@log_ResolvedUserid,
		@log_ResolvedDate
	)

	SET @Err = @@Error

	SELECT @SyncLogID = SCOPE_IDENTITY()

	RETURN @Err
END
