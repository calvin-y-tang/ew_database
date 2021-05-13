CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_Detail]
     @iHdrSetupID INTEGER,
	 @iHeaderID INTEGER 
AS
BEGIN
	
	DECLARE @iDtlSetupID INTEGER 
	DECLARE @iDetailID INTEGER 
	
	-- DEV NOTE: this process will completely rebuild all items in FSDetailCondition for the Detail items
	--		that are present; therefore, before we do anything we are going dump all Condition items
	--		that are attached to the detail items for the Header we are processing.
	DELETE 
	  FROM tblFSDetailCondition 
	 WHERE FSDetailID IN (SELECT FSDetailID FROM tblFSDetail WHERE FSHeaderID = @iHeaderID)

	-- get a list of Detail Items that make up this Header and process them
	DECLARE curDetailSetup CURSOR FOR
		SELECT FSDetailSetupID, FSDetailID
		  FROM tblFSDetailSetup 
		 WHERE FSHeaderSetupID = @iHdrSetupID
	OPEN curDetailSetup
	FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- update or insert item? 
		IF @iDetailID IS NULL
		BEGIN 
			INSERT INTO tblFSDetail(FSHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, InchesIncluded, DateAdded, UserIDAdded)
				SELECT @iHeaderID, ProcessOrder, FeeUnit, ISNULL(FeeAmt, 0), NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, InchesIncluded, DateAdded, UserIDAdded
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
				  FeeAmt = ISNULL(ui.FeeAmt, 0), 
				  NSFeeAmt1 = ui.NSFeeAmt1,
				  NSFeeAmt2 = ui.NSFeeAmt2, 
				  NSFeeAmt3 = ui.NSFeeAmt3, 
				  LateCancelAmt = ui.LateCancelAmt, 
				  CancelDays = ui.CancelDays, 
				  InchesIncluded = ui.InchesIncluded, 
				  DateEdited = ui.DateEdited, 
				  UserIDEdited = ui.UserIDEdited
			  FROM tblFSDetail AS calc
					INNER JOIN tblFSDetailSetup AS ui ON ui.FSDetailID = calc.FSDetailID
			 WHERE calc.FSDetailID = @iDetailID
		END 

		-- process next row
		FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID
	END
	CLOSE curDetailSetup
	DEALLOCATE curDetailSetup
	
	-- Process Detail Condition selections
	INSERT INTO tblFSDetailCondition(FSDetailID, ConditionTable, ConditionKey, ConditionValue)
		SELECT  FSDetailID, 'tblEWBusLine', BL.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(BusLine, ',') AS BL
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND BL.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblEWServiceType', ST.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ServiceType, ',') AS ST
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND ST.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblServices', S.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Service, ',') AS S
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND S.value <> -1

		UNION 
		
		SELECT  FSDetailID, 'tblProduct', P.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Product, ',') AS P
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND P.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblEWFeeZone', FZ.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(FeeZone, ',') AS FZ
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND FZ.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblSpecialty', SP.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Specialty, ',') AS SP
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND SP.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblDoctor', D.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Doctor, ',') AS D
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND D.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblLocation', L.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocation, ',') AS L
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND L.value <> -1

		UNION 

		SELECT FSDetailID, 'tblLocation', NULL, TRIM(C.value)  
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocationCity, ',') AS C
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND C.value IS NOT NULL
	
	-- cleanup Detail table for items no longer part of setup table
	DELETE tblFSDetail
	  FROM tblfsDetail 
			LEFT OUTER JOIN tblFSDetailSetup ON tblFSDetailSetup.FSDetailID = tblFSDetail.FSDetailID
	 WHERE FSHeaderID = @iHeaderID 
	   AND tblFSDetailSetup.FSDetailID IS NULL
	
	RETURN

END
