

CREATE PROCEDURE proc_GetNewBatchNbr
(
  @BatchType VARCHAR(2),
  @UserIDAdded VARCHAR(20),
  @BatchNbr INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @error INT

    DECLARE @installID INT
	DECLARE @offsetHours INT

	SELECT TOP 1 @offsetHours = OffsetHours FROM tblControl ORDER BY InstallID

    BEGIN TRAN
		SELECT TOP 1 @BatchNbr = NextBatchNbr, @installID = InstallID
		 FROM tblControl (UPDLOCK)
		 ORDER BY InstallID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		UPDATE tblControl SET NextBatchNbr=@BatchNbr+1
		 WHERE InstallID=@installID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		INSERT INTO tblbatch (BatchNbr, Type, DateAdded, UserIDAdded) VALUES
		(
			@BatchNbr,
			@BatchType,
			DATEADD(hh, @offsetHours, GETDATE()),
			@UserIDAdded
		)
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		--Commit transaction
	COMMIT TRAN
 
        Done:
        IF @error <> 0 
            SET @BatchNbr = NULL
        IF @BatchNbr IS NULL 
            ROLLBACK TRAN

        SET NOCOUNT OFF
        RETURN @error
END
