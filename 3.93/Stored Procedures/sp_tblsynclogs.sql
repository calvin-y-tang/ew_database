CREATE PROCEDURE dbo.sp_tblsynclogs
AS
    SELECT
        SyncLogID,
        Log_DateAdded,
        Log_Severity,
        Log_RelatedID,
        Log_Message,
        Log_Resolved,
        Log_ResolvedUserID,
        Log_ResolvedDate
    FROM
        dbo.tblSyncLogs
    WHERE
        (
         Log_Severity=4 OR
         Log_Severity=5
        ) AND
        (Log_Resolved=0)
    ORDER BY
        Log_DateAdded DESC
