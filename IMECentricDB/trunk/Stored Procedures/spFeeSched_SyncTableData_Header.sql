CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_Header]
     @iSetupID INTEGER, 
	@iHeaderID INTEGER OUTPUT
AS
BEGIN
	
	-- FSHeaderSetup variables 
	DECLARE @iGroupID INTEGER 
	DECLARE @sFSName VARCHAR(30)
	DECLARE @sDocType VARCHAR(2)
	DECLARE @dStartDate DATETIME
	DECLARE @dEndDate DATETIME 
	DECLARE @dDateAdded DATETIME 
	DECLARE @sUserIDAdded VARCHAR(30)
	DECLARE @dDateEdit DATETIME 
	DECLARE @sUserIDEdit VARCHAR(30)
	DECLARE @sEntityType CHAR(2)

	-- initialize our HeaderID to NULL to protect against "bad stuff"
	SET @iHeaderID = NULL 
	
	-- get HeaderSetup Details
	SELECT @iGroupID = FSGroupID, @iHeaderID = FSHeaderID, @sFSName = FeeScheduleName, 
	       @sDocType = DocumentType, @dStartDate = StartDate, @dEndDate = EndDate, 
		  @dDateAdded = DateAdded, @sUserIDAdded = UserIDAdded, 
		  @dDateEdit = DateEdited, @sUserIDEdit = UserIDEdited, @sEntityType = EntityType
	  FROM tblFSHeaderSetup
	 WHERE FSHeaderSetupID = @iSetupID
	
	-- Check StartDate when NULL do nothing and exit
	IF @dStartDate IS NULL
	BEGIN 
		RAISERROR ('Draft Fee Schedule details have been saved but cannot be synced.', 11, 1);
		RETURN 
	END 
	
	-- Check FSGroupID when NULL create new entry in tblFSGroup and set value back into column
	IF @iGroupID IS NULL 
	BEGIN 
		-- need to create new tblFSGroup item
		INSERT INTO tblFSGroup (FeeScheduleName, DocumentType, DateAdded, UserIDAdded, EntityType)
		VALUES(@sFSName, @sDocType, @dDateAdded, @sUserIDAdded, @sEntityType)
		SET @iGroupID = @@IDENTITY
		IF @iGroupID IS NOT NULL AND @iGroupID > 0
		BEGIN 
			-- save GroupID back to tblFSHeaderSetup
			UPDATE tblFSHeaderSetup
			   SET FSGroupID = @iGroupID 
			 WHERE FSHeaderSetupID = @iSetupID
		END
		ELSE
		BEGIN 
			-- no GroupID; Unable to continue
			RAISERROR ('Unable to create new tblFSGroup entry (FSGroupID is not valid).', 16, 1);
			RETURN 
		END 
	END 
	ELSE
	BEGIN 
		-- need to update existing tblFSGroup entry
		UPDATE tblFSGroup 
		   SET FeeScheduleName = @sFSName, 
			  DocumentType = @sDocType, 
			  DateEdited = @dDateEdit,
			  UserIDEdited = @sUserIDEdit,
			  EntityType = @sEntityType
		 WHERE FSGroupID = @iGroupID 
	END
	-- ensure that Fee Sched Name is the same for all entries belonging to same group.
	UPDATE tblFSHeaderSetup
	   SET FeeScheduleName = @sFSName
	 WHERE FSGroupID = @iGroupID
	
	-- Check FSHeaderID when NULL create new entry in tblFSHeader and set value back into column
	IF @iHeaderID IS NULL 
	BEGIN 
		-- need to create new tblFSHeader item
		INSERT INTO tblFSHeader(FSGroupID, StartDate, EndDate, DateAdded, UserIDAdded)
		VALUES(@iGroupID, @dStartDate, @dEndDate, @dDateAdded, @sUserIDAdded)
		SET @iHeaderID = @@IDENTITY
		IF @iHeaderID IS NOT NULL AND @iHeaderID > 0 
		BEGIN 
			-- save HeaderID back to tblFSHeaderSetup
			UPDATE tblFSHeaderSetup 
			   SET FSHeaderID = @iHeaderID 
			 WHERE FSHeaderSetupID = @iSetupID
		END 
		ELSE 
		BEGIN 
			-- no HeaderID; Unable to continue 
			RAISERROR ('Unable to create new tblFSHeader entry (FSHeaderID is not valid).', 16, 1);
			RETURN 
		END
	END 
	ELSE
	BEGIN 
		-- need to update existing tblFSHeader entry 
		UPDATE tblFSHeader 
		   SET StartDate = @dStartDate, 
		       EndDate = @dEndDate, 
			  DateEdited = @dDateEdit,
			  UserIDEdited = @sUserIDEdit
		 WHERE FSHeaderID = @iHeaderID 
	END 
	
END
