CREATE PROCEDURE [dbo].[proc_CreateCustomerFeeSchedule]
	@FeeSchedName VARCHAR(30),
	@EntityType VARCHAR(2),
	@EntityID INT, 
	@StartDate DATETIME, 
	@EndDate DATETIME
AS
BEGIN
	
	DECLARE @CustomerFeeHeaderID INT
	
	INSERT INTO tblCustomerFeeHeader (Name, EntityType, EntityID, StartDate, EndDate, UserIDAdded, DateAdded)
	VALUES (@FeeSchedName, @EntityType, @EntityID, @StartDate, @EndDate, '', GETDATE())
	SET @CustomerFeeHeaderID = @@IDENTITY
	PRINT @CustomerFeeHeaderID 
	
	IF @CustomerFeeHeaderID IS NOT NULL AND @CustomerFeeHeaderID > 0
	BEGIN 
		INSERT INTO tblCustomerFeeDetail (CustomerFeeHeaderID, UserIDAdded, DateAdded, ProdCode, EWBusLineID, EWFeeZoneID, EWSpecialtyID, FeeUnit, FeeAmt, LateCancelAmt, CancelDays, NoShowAmt)
			SELECT @CustomerFeeHeaderID, 'Admin', GETDATE(), ProdCode, EWBusLineID, EWFeeZoneID, EWSpecialtyID, FeeUnit, FeeAmt, LateCancelAmt, CancelDays, NoShowAmt
			  FROM [dev3\EW_IME_CENTRIC].[IMECentricMaster].[dbo].[tmpImportCustomerFeeSchedule]
			 WHERE FeeScheduleName = @FeeSchedName
	END
	
END 
