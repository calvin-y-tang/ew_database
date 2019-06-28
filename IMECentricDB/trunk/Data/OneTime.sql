--S37

-- Issue 11085 - new columns to add to IMECentricMaster for EWParentCompany 
ALTER TABLE EWParentCompany ADD 
	[DateAdded] DATETIME NULL, 
	[UserIDAdded] VARCHAR(15) NULL, 
	[DateEdited] DATETIME NULL, 
	[UserIDEdited] VARCHAR(15) NULL
GO

-- Issue 11085 - set initial value for parent company add columns
UPDATE EWParentCompany 
   SET DateAdded = ISNULL(DateAdded, '2019-01-01'), 
       UserIDAdded = ISNULL(UserIDAdded, 'Admin')
GO 

-- Issue 11093 - new columns to add to IMECentricMaster for EWParentCompany 
ALTER TABLE EWParentCompany ADD 
	[DICOMHandlingPreference] INT NULL
GO




-- Sprint 38
-- Issue 111142 - Convert Allstate tblCustomerFeeHeader to new FeeSchedule tables (tblFS*****)
-- >>>>>>>>>>>>>>>>>> START SCRIPT 111142 <<<<<<<<<<<<<<<<<<<<
DECLARE @iOrigFeeHdrID INT = 1 -- Allstate

-- vars used to process FeeList Cursor
DECLARE @iOrigFeeDetailID INT
DECLARE @mFeeAmt MONEY
DECLARE @cFeeUnit VARCHAR(20)
DECLARE @ProdCode INT
DECLARE @EWBusLineID INT
DECLARE @EWSpecialtyID INT
DECLARE @LateCancelAmt MONEY
DECLARE @LateCancelDays INT
DECLARE @NoShowAmt MONEY
DECLARE @EWFeeZoneID INT

-- vars used to create "GROUP"/"HEADER"
DECLARE @iNewGrpID INT
DECLARE @iNewHdrID INT

-- Other vars used to process a FeeList row
DECLARE @iProcessOrder INT = 0
DECLARE @iFeeDetailID INT

-- create entries in "Header" tables from original CustomerFeeHeader entry 
INSERT INTO tblFSGroup (FeeScheduleName, DocumentType, DateAdded, UserIDAdded)
SELECT Name, 'IN', GETDATE(), 'Admin' FROM tblCustomerFeeHeader WHERE CustomerFeeHeaderID = @iOrigFeeHdrID
SET @iNewGrpID = @@IDENTITY

INSERT INTO tblFSHeader(FSGroupID, StartDate, EndDate, DateAdded, UserIDAdded)
SELECT @iNewGrpID, StartDate, EndDate, GETDATE(), 'Admin' FROM tblCustomerFeeHeader WHERE CustomerFeeHeaderID = @iOrigFeeHdrID
SET @iNewHdrID = @@IDENTITY

INSERT INTO tblFSEntity(FSGroupID, OfficeCode, EntityType, EntityID, DateAdded, UserIDAdded)
SELECT @iNewGrpID, -1, EntityType, EntityID, GETDATE(), 'Admin' FROM tblCustomerFeeHeader WHERE CustomerFeeHeaderID = @iOrigFeeHdrID

DECLARE FeeList CURSOR FOR
	SELECT CustomerFeeDetailID, ProdCode, EWBusLineID, EWFeeZoneID, EWSpecialtyID, FeeUnit, FeeAmt, LateCancelAmt, CancelDays, NoShowAmt
      FROM tblCustomerFeeDetail
     WHERE CustomerFeeHeaderID = @iOrigFeeHdrID
OPEN FeeList
FETCH NEXT FROM FeeList INTO @iOrigFeeDetailID, @ProdCode, @EWBusLineID, @EWFeeZoneID, @EWSpecialtyID, @cFeeUnit, @mFeeAmt, @LateCancelAmt, @LateCancelDays, @NoShowAmt
WHILE @@FETCH_STATUS = 0
BEGIN
	-- Initialization
	SET @iProcessOrder = @iProcessOrder + 1
	-- create new entry in tblFeeScheduleDetail
	INSERT INTO tblFSDetail(FSHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, LateCancelAmt, CancelDays, DateAdded, UserIDAdded)
	VALUES (@iNewHdrID, @iProcessOrder, @cFeeUnit, @mFeeAmt, @NoShowAmt, @LateCancelAmt, @LateCancelDays, GETDATE(), 'Admin')
	SET @iFeeDetailID = @@IDENTITY
	-- Create entries for ProdCode
	INSERT INTO tblFSDetailCondition(FSDetailID, ConditionTable, ConditionKey)
	VALUES(@iFeeDetailID, 'tblProduct', @ProdCode), 
	      (@iFeeDetailID, 'tblEWBusLine', @EWBusLineID), 
		  (@iFeeDetailID, 'tblEWFeeZone', @EWFeeZoneID), 
		  (@iFeeDetailID, 'tblSpecialty', @EWSpecialtyID)
	-- get next item to process
	FETCH NEXT FROM FeeList INTO @iOrigFeeDetailID, @ProdCode, @EWBusLineID, @EWFeeZoneID, @EWSpecialtyID, @cFeeUnit, @mFeeAmt, @LateCancelAmt, @LateCancelDays, @NoShowAmt
END 

CLOSE FeeList
DEALLOCATE FeeList 
-- >>>>>>>>>>>>>>>>>> END SCRIPT 111142 <<<<<<<<<<<<<<<<<<<<

GO

