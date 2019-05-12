
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [Dir7zip] VARCHAR (70) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[fnIsAddressComplete]...';


GO
ALTER FUNCTION [dbo].[fnIsAddressComplete]
(
	@addr1 VARCHAR(50), 
	@addr2 VARCHAR(50), 
	@city VARCHAR(50),
	@state VARCHAR(2),
	@zip VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @errMsg VARCHAR(100)
	
	-- return empty string when all is good
	SET @errMsg = ''

	-- clean up zip code
	SET @zip = REPLACE(@zip, '-','')

	-- need to have at least 1 address line present
	IF (@addr1 IS NULL OR LEN(@addr1) = 0) AND (@addr2 IS NULL OR LEN(@addr2) = 0) 
		SET @errMsg = 'Address Incomplete'
	ELSE
	BEGIN
		BEGIN
			-- city must be present
			IF @city IS NULL OR LEN(@city) = 0 
				SET @errMsg = 'Missing City'
			ELSE
			BEGIN
				-- state must be present
				IF @state IS NULL OR LEN(@state) = 0 
					SET @errMsg = 'Missing State'
				ELSE
				BEGIN
					-- zip code must be present
					IF @zip IS NULL OR LEN(@zip) = 0
						SET @errMsg = 'Missing Zip Code'
					ELSE
					BEGIN 
						-- validate that US Zip Codes are 5 or 9 digits. if a zip code is NOT
						-- numeric then it is not a US address and validation can be skipped.
						IF ISNUMERIC(@zip) = 1 AND NOT (LEN(@zip) = 5 OR LEN(@zip) = 9)
						BEGIN
							SET @errMsg = 'Invalid Zip Code'
						END 
					END 
				END
			END
		END
	END 

	RETURN @errMsg
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[vwCaseDocMailEntities]...';


GO
ALTER VIEW [dbo].[vwCaseDocMailEntities]
AS 
		-- Case Client
		SELECT 
			tblCase.CaseNbr,
			'CL' AS EntityType, tblCase.ClientCode AS EntityID, 
			tblClient.firstName + ' ' + tblClient.lastName AS EntityName, 
			tblCompany.ExtName AS Company,
			tblClient.Addr1, tblClient.Addr2, tblClient.City, tblClient.State, tblClient.Zip,
			dbo.fnIsAddressComplete(tblClient.Addr1, tblClient.Addr2, tblClient.City, tblClient.State, tblClient.Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
				INNER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
	UNION
		-- Case Billing Client
		SELECT 
			tblCase.CaseNbr,
			'BCL' AS EntityType, tblCase.ClientCode AS EntityID, 
			tblClient.firstName + ' ' + tblClient.lastName AS EntityName, 
			tblCompany.ExtName AS Company,
			tblClient.Addr1, tblClient.Addr2, tblClient.City, tblClient.State, tblClient.Zip,
			dbo.fnIsAddressComplete(tblClient.Addr1, tblClient.Addr2, tblClient.City, tblClient.State, tblClient.Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblClient ON tblClient.ClientCode = tblCase.BillClientCode
				INNER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
	UNION
		-- Examinee (primary/current address)
		SELECT
			tblCase.CaseNbr, 
			'EE' AS EntityType, tblCase.ChartNbr AS EntityID, 
			tblExaminee.firstName + ' ' + tblExaminee.lastName AS EntityName,
			'' AS Company,
			Addr1, Addr2, City, State, Zip, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
	UNION
		-- Secondary Examinee Addresses
		SELECT
			tblCase.CaseNbr, 
			'EEA' AS EntityType, EEAddr.ExamineeAddressID AS EntityID, 
			tblExaminee.firstName + ' ' + tblExaminee.lastName AS EntityName,
			'' AS Company,
			EEAddr.Addr1, EEAddr.Addr2, EEAddr.City, EEAddr.State, EEAddr.Zip, 
			dbo.fnIsAddressComplete(EEAddr.Addr1, EEAddr.Addr2, EEAddr.City, EEAddr.State, EEAddr.Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
				INNER JOIN tblExamineeAddresses AS EEAddr ON EEAddr.ChartNbr = tblCase.ChartNbr
	UNION
		-- Doctor (Normal Appt)
		SELECT 
			tblCase.CaseNbr,
			'DR' as EntityType, tblCase.DoctorCode AS EntityID, 
			tblDoctor.firstName + ' ' + tblDoctor.lastName AS EntityName,
			'' AS Company,
			Addr1, Addr2, City, State, Zip, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblDoctor ON tblDoctor.DoctorCode = tblCase.DoctorCode
	UNION
		-- Doctor(s) (Appt Panel)
		SELECT 
			tblCase.CaseNbr,
			'DR' as EntityType, tblDoctor.DoctorCode AS EntityID, 
			tblDoctor.firstName + ' ' + tblDoctor.lastName AS EntityName,
			'' AS Company,
			Addr1, Addr2, City, State, Zip, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase
				INNER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				INNER JOIN tblDoctor ON tblDoctor.DoctorCode = tblCasePanel.DoctorCode
	UNION
		-- Plaintiff Attorney
		SELECT 
			tblCase.CaseNbr, 
			'PAT' as EntityType, tblCase.PlaintiffAttorneyCode AS EntityID, 
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.firstName + ' ' + Attrny.lastName, Attrny.Company) AS EntityName,
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.Company, '') AS Company,
			Address1, Address2, City, State, Zip,
			dbo.fnIsAddressComplete(Address1, Address2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCCAddress AS Attrny ON Attrny.ccCode = tblCase.PlaintiffAttorneyCode
	UNION 
		-- Defense Attorney
		SELECT 
			tblCase.CaseNbr, 
			'DAT' as EntityType, tblCase.DefenseAttorneyCode AS EntityID, 
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.firstName + ' ' + Attrny.lastName, Attrny.Company) AS EntityName,
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.Company, '') AS Company,
			Address1, Address2, City, State, Zip, 
			dbo.fnIsAddressComplete(Address1, Address2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCCAddress AS Attrny ON Attrny.ccCode = tblCase.DefenseAttorneyCode
	UNION
		-- Paralegal
		SELECT 
			tblCase.CaseNbr, 
			'LAT' as EntityType, tblCase.DefParaLegal AS EntityID, 
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.firstName + ' ' + Attrny.lastName, Attrny.Company) AS EntityName,
			IIF(LEN(RTRIM(LTRIM(Attrny.firstName)) + RTRIM(LTRIM(Attrny.lastName))) > 0, Attrny.Company, '') AS Company,
			Address1, Address2, City, State, Zip, 
			dbo.fnIsAddressComplete(Address1, Address2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCCAddress AS Attrny ON Attrny.ccCode = tblCase.DefParaLegal
	UNION
		-- Treating Physician
		SELECT 
			tblCase.CaseNbr, 
			'TD' as EntityType, 
			IIF(tblExaminee.TreatingPhysician IS NULL OR LEN(tblExaminee.TreatingPhysician) = 0, NULL, tblCase.ChartNbr) AS EntityID,
			tblExaminee.TreatingPhysician AS EntityName,
			'' AS Company,
			TreatingPhysicianAddr1, '', TreatingPhysicianCity, TreatingPhysicianState, TreatingPhysicianZip, 
			IIF(tblExaminee.TreatingPhysician IS NULL OR LEN(tblExaminee.TreatingPhysician) = 0, 
				'', 
				dbo.fnIsAddressComplete(TreatingPhysicianAddr1, '', TreatingPhysicianCity, TreatingPhysicianState, TreatingPhysicianZip)) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
	UNION
		-- NF-10 Doctors
		SELECT 
			tblCase.CaseNbr, 
			'NF' as EntityType, TreatDr.TreatingDoctorID AS EntityID, 
			LTRIM(IIF(LEFT(LTRIM(FirstName), 1) = '-', '', FirstName) + ' ' + LastName) AS EntityName, 
			'' AS Company,
			Addr1, Addr2, City, State, Zip,
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCaseOtherTreatingDoctor AS CaseTreatDr ON CaseTreatDr.CaseNbr = tblCase.CaseNbr
				INNER JOIN tblTreatingDoctor AS TreatDr ON TreatDr.TreatingDoctorID = CaseTreatDr.TreatingDoctorID
	UNION 
		-- CC's
		SELECT 
			tblCase.CaseNbr, 
			'CC' as EntityType, tblCCAddress.ccCode AS EntityID, 
			IIF(LEN(RTRIM(LTRIM(tblCCAddress.firstName)) + RTRIM(LTRIM(tblCCAddress.lastName))) > 0, tblCCAddress.firstName + ' ' + tblCCAddress.lastName, tblCCAddress.Company) AS EntityName,
			IIF(LEN(RTRIM(LTRIM(tblCCAddress.firstName)) + RTRIM(LTRIM(tblCCAddress.lastName))) > 0, tblCCAddress.Company, '') AS Company,
			tblCCAddress.Address1, tblCCAddress.Address2, tblCCAddress.City, tblCCAddress.State, tblCCAddress.Zip,
			dbo.fnIsAddressComplete(tblCCAddress.Address1, tblCCAddress.Address2, tblCCAddress.City, tblCCAddress.State, tblCCAddress.Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
				INNER JOIN tblExamineecc ON tblCase.ChartNbr = tblExamineecc.ChartNbr
				INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO

-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES(31, 'SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

-- Issue 10048 - no longer using field ExceptionAlert.  Replacing with AlertType.  Set the values
-- For all Case History with Follow up date is not null AND the Office of the case is set to use 
--    ShowFollowUpOnCaseOpen (= true), KEEP the follow up date and set the AlertType=1
UPDATE H
   SET AlertType = 1
  FROM tblCaseHistory AS H
			INNER JOIN tblCase AS C ON H.CaseNbr = C.CaseNbr
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
 WHERE FollowUpDate IS NOT NULL 
   AND O.ShowFollowUpOnCaseOpen = 1
GO

-- For all Case History created by ERP (UserID = ERP) and the FollowUpDate is not null, Clear the follow up date and set AlertType=1
UPDATE tblCaseHistory 
   SET AlertType = 1, 
       FollowUpDate = NULL 
 WHERE UserID = 'ERP' 
   AND FollowUpDate IS NOT NULL
GO


-- Issue 10006 - new event ID and Business Rule to provide Bulk Billing Format override
INSERT INTO tblEvent(EventID, Descrip, Category)
VALUES(1811, 'Finalize Invoice', 'Accounting')
GO

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(100, 'BulkBillingOverride', 'Accounting', 'Allow Bulk Billing Format Override based on case details', 1, 1811, 0, 'BulkBillingID', NULL, NULL, NULL, NULL, 0)
GO

-- Issue 10006 - patch tblAcctHeader.BulkBillingId column 
UPDATE ah 
   SET ah.BulkBillingID = co.bulkbillingid
  FROM tblAcctHeader ah
			INNER JOIN tblclient AS cl ON ah.clientcode = cl.ClientCode
			INNER JOIN tblCompany AS co ON cl.CompanyCode = co.CompanyCode
WHERE ah.DocumentType = 'IN'
GO 


--Issue 11044 (subtask of 11008) Zurich IMECentric and Bulk Billing Changes - data patch
 INSERT INTO tblCustomerData ([Version], TableType, TableKey, [Param], CustomerName)
  SELECT 
    1, 
	'tblCase', 
    C.CaseNbr, 
	CASE
	  WHEN CT.EWBusLineID = 3 AND S.EWServiceTypeID IN (2,3) THEN 'PayKind="37PCS";'
	  WHEN CT.EWBusLineID = 3 THEN 'PayKind="30IME";'
	  ELSE 'PayKind="37IME";'
	END AS [Param],
    'Zurich'
  FROM tblCase AS C
  INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
  INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
  INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
  LEFT JOIN tblClient AS CLB ON C.BillClientCode = CLB.ClientCode
  INNER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
  LEFT JOIN tblCompany AS CO2 ON CLB.CompanyCode = CO2.CompanyCode
  INNER JOIN tblEWParentCompany AS COP ON CO.ParentCompanyID = COP.ParentCompanyID
  LEFT JOIN tblEWParentCompany AS COP2 ON CO2.ParentCompanyID = COP2.ParentCompanyID
  WHERE 
    CO.ParentCompanyID = 60 
	OR CO2.ParentCompanyID = 60
    AND (C.Status NOT IN (8,9) 
	     OR (C.Status IN (8,9) 
		     AND ([DateCompleted] >= '2018-01-01' 
			      OR [DateCanceled] >= '2018-01-01')))
GO 

-- Issue 11046 - add new business rule to set visibility of amt fields for an invoice
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(101, 'ShowInvoiceAmtFields', 'Accounting', 'Set Invoice Amt Field visibility', 1, 1801, 0, 'ShowRetailAmt', 'ShowDiscountAmt', NULL, NULL, NULL, 0)
GO 

-- Issue 11046 - add new business rule to calculate retail amount value
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(102, 'CalcInvRetailAmt', 'Accounting', 'Caculate Retail Amount for Invoice Line Item', 1, 1801, 0, 'MarkupAmt', NULL, NULL, NULL, NULL, 0)
GO 



DELETE FROM tblCodes WHERE Category='WorkCompCaseType' AND SubCategory='CA'
GO

INSERT INTO tblCodes(Category, SubCategory, Value) VALUES 
('WorkCompCaseType', 'CA', 'AME'), 
('WorkCompCaseType', 'CA', 'AME-R'), 
('WorkCompCaseType', 'CA', 'AME-S'), 
('WorkCompCaseType', 'CA', 'A-QME'), 
('WorkCompCaseType', 'CA', 'CONSULT'), 
('WorkCompCaseType', 'CA', 'DCD'), 
('WorkCompCaseType', 'CA', 'D-QME'), 
('WorkCompCaseType', 'CA', 'FCE'), 
('WorkCompCaseType', 'CA', 'IME'), 
('WorkCompCaseType', 'CA', 'IME-S'), 
('WorkCompCaseType', 'CA', 'IME-ADR'), 
('WorkCompCaseType', 'CA', 'IME-LSH'), 
('WorkCompCaseType', 'CA', 'IME-SIBTF'), 
('WorkCompCaseType', 'CA', 'IME-SIBTF-S'), 
('WorkCompCaseType', 'CA', 'QME'), 
('WorkCompCaseType', 'CA', 'QME-R'), 
('WorkCompCaseType', 'CA', 'QME-S'), 
('WorkCompCaseType', 'CA', 'P/U-QME'), 
('WorkCompCaseType', 'CA', 'P/U-QME-R'), 
('WorkCompCaseType', 'CA', 'P/U-QME-S'), 
('WorkCompCaseType', 'CA', 'R-PQME'), 
('WorkCompCaseType', 'CA', 'R-PQME-R'), 
('WorkCompCaseType', 'CA', 'R-PQME-S'),
('WorkCompCaseType', 'CA', 'RR'), 
('WorkCompCaseType', 'CA', 'RR-S')
GO


-- Issue 11045 - business rules per comments on the issue.  ii will like Jose above, comment these out until ready
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(120, 'DetermineInvFormat', 'Accounting', 'Zurich Bulk Billing Invoice Format', 1, 1806, 0, 'Invoice Format Key', NULL, NULL, NULL, NULL, 0)
GO

