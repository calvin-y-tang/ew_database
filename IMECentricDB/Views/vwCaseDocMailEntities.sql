CREATE VIEW [dbo].[vwCaseDocMailEntities]
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
