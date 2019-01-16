CREATE PROCEDURE spLock_Create
(
	@tableType VARCHAR(50),
	@tableKey INT,
	@userID varchar(50),
	@sessionID varchar(50),
	@moduleName varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO tblLock
	(
		TableType,
		TableKey,
		DateLocked,
		DateAdded,
		UserID,
		SessionID,
		ModuleName
	)
	SELECT @tableType,
		   @tableKey,
		   GETDATE(),
		   GETDATE(),
		   @userID,
		   @sessionID,
		   @moduleName
	WHERE NOT EXISTS
	(
		SELECT L.LockID
		  FROM tblLock AS L INNER JOIN tblControl AS C ON C.InstallID=1
		WHERE L.TableType=@tableType AND L.TableKey=@tableKey
		  AND DATEADD(SECOND, C.LockTimeoutSec, L.DateLocked)>GETDATE()
	)


	IF @@ROWCOUNT<>1
		SELECT CAST(0 AS BIT) AS Locked, L.LockID, L.UserID FROM tblLock AS L WHERE L.TableType=@tableType AND L.TableKey=@tableKey
	ELSE
		SELECT CAST(1 AS BIT) AS Locked, L.LockID, L.UserID FROM tblLock AS L WHERE L.LockID=SCOPE_IDENTITY()

END