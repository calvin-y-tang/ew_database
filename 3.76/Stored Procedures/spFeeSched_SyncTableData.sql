CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData]
     @iSetupID INTEGER
AS
BEGIN
	
	DECLARE @iErrState INTEGER
	DECLARE @sErrMsg VARCHAR(MAX)
	DECLARE @iErrSeverity INTEGER
	DECLARE @iHeaderID INTEGER
	
	BEGIN TRY
		-- Process "Header" table(s)
		EXEC spFeeSched_SyncTableData_Header
				@iSetupID, 
				@iHeaderID = @iHeaderID OUTPUT 

		-- Process "Detail" table(s)
		EXEC spFeeSched_SyncTableData_Detail
			@iSetupID, 
			@iHeaderID
		
	END TRY
	BEGIN CATCH 
		-- When you specify the message_text, the RAISERROR statement uses message_id 50000 to raise the error message.
		SET @sErrMsg = ERROR_MESSAGE() + ' (Error Number = ' + CAST(ERROR_NUMBER() AS VARCHAR(MAX)) + ')'
		SET @iErrSeverity = ERROR_SEVERITY()
		SET @iErrState = ERROR_STATE() 
		-- this error is what IMECHelper will catch
		RAISERROR(@sErrMsg, @iErrSeverity, @iErrState)
		RETURN -1
	END CATCH 
	
	-- data sync completed with no errors
	RETURN 0
	
END
