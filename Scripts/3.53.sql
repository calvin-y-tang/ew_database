
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


INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(103, 'DistAsZipToClient', 'Case', 'Distribute doc/rpt to client as a password protected zip file', 1, 1202, 0, 'Password', NULL, NULL, NULL, NULL, 0)
GO 

