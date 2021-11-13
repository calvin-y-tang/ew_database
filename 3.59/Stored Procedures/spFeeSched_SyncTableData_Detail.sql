CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_Detail]
     @iHdrSetupID INTEGER,
	@iHeaderID INTEGER 
AS
BEGIN
	
	DECLARE @iDtlSetupID INTEGER 
	DECLARE @iDetailID INTEGER 
	DECLARE @sBusLine VARCHAR(MAX)
	DECLARE @sFeeZone VARCHAR(MAX)
	DECLARE @sProduct VARCHAR(MAX)
	DECLARE @sSpecialty VARCHAR(MAX)
	DECLARE @sSvcType VARCHAR(MAX)
	DECLARE @sService VARCHAR(MAX)
	
	-- get a list of Detail Items that make up this Header and process them
	DECLARE curDetailSetup CURSOR FOR
		SELECT FSDetailSetupID, FSDetailID, 
			  BusLine,  ServiceType, Service, Product, FeeZone, Specialty
		  FROM tblFSDetailSetup 
		 WHERE FSHeaderSetupID = @iHdrSetupID
	OPEN curDetailSetup
	FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- update or insert item? 
		IF @iDetailID IS NULL
		BEGIN 
			INSERT INTO tblFSDetail(FSHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, DateAdded, UserIDAdded)
				SELECT @iHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, DateAdded, UserIDAdded
				  FROM tblFSDetailSetup
				 WHERE FSDetailSetupID = @iDtlSetupID
			SET @iDetailID = @@IDENTITY 
			IF @iDetailID IS NOT NULL AND @iDetailID > 0 
			BEGIN 
				UPDATE tblFSDetailSetup
				   SET FSDetailID = @iDetailID 
				 WHERE FSDetailSetupID = @iDtlSetupID
			END
			ELSE 
			BEGIN 
				-- no DetailID; unable to continue
				RAISERROR ('Unable to create new tblFSDetail entry (FSDetailID is not valid).', 16, 2);
				RETURN 
			END 
		END 
		ELSE 
		BEGIN 
			-- need to update existing tblFSDetail entry
			UPDATE calc
			   SET ProcessOrder = ui.ProcessOrder, 
				  FeeUnit = ui.FeeUnit,
				  FeeAmt = ui.FeeAmt, 
				  NSFeeAmt1 = ui.NSFeeAmt1,
				  NSFeeAmt2 = ui.NSFeeAmt2, 
				  NSFeeAmt3 = ui.NSFeeAmt3, 
				  LateCancelAmt = ui.LateCancelAmt, 
				  CancelDays = ui.CancelDays, 
				  DateEdited = ui.DateEdited, 
				  UserIDEdited = ui.UserIDEdited
			  FROM tblFSDetail AS calc
					INNER JOIN tblFSDetailSetup AS ui ON ui.FSDetailID = calc.FSDetailID
			 WHERE calc.FSDetailID = @iDetailID
		END 
		
		-- Process Detail Condition selections
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWBusLine', 
				@sBusLine
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWServiceType', 
				@sSvcType
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblServices', 
				@sService
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblProduct', 
				@sProduct
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWFeeZone', 
				@sFeeZone
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblSpecialty', 
				@sSpecialty
		
		-- process next row
		FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty
	END
	CLOSE curDetailSetup
	DEALLOCATE curDetailSetup
	
	-- cleanup DetailCondition table for Detail items no longer part of setup table
	DELETE tblFSDetailCondition
	  FROM tblFSDetailCondition
			INNER JOIN tblFSDetail ON tblFSDetail.FSDetailID = tblFSDetailCondition.FSDetailID 
			LEFT OUTER JOIN tblFSDetailSetup ON tblFSDetailSetup.FSDetailID = tblFSDetail.FSDetailID
	 WHERE FSHeaderID = @iHeaderID 
	   AND tblFSDetailSetup.FSDetailSetupID IS NULL
	-- cleanup Detail table for items no longer part of setup table
	DELETE tblFSDetail
	  FROM tblfsDetail 
			LEFT OUTER JOIN tblFSDetailSetup ON tblFSDetailSetup.FSDetailID = tblFSDetail.FSDetailID
	 WHERE FSHeaderID = @iHeaderID 
	   AND tblFSDetailSetup.FSDetailID IS NULL
	
	RETURN

END
