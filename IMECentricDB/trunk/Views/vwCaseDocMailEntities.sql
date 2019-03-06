CREATE VIEW [dbo].[vwCaseDocMailEntities]
AS 
		-- Case Client
		SELECT 
			tblCase.CaseNbr,
			'CL' AS EntityType, tblCase.ClientCode AS EntityID, 
			tblClient.firstName + ' ' + tblClient.lastName AS EntityName, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
	UNION
		-- Case Billing Client
		SELECT 
			tblCase.CaseNbr,
			'BCL' AS EntityType, tblCase.ClientCode AS EntityID, 
			tblClient.firstName + ' ' + tblClient.lastName AS EntityName, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblClient ON tblClient.ClientCode = tblCase.BillClientCode
	UNION
		-- Examinee
		SELECT
			tblCase.CaseNbr, 
			'EE' AS EntityType, tblCase.ChartNbr AS EntityID, 
			tblExaminee.firstName + ' ' + tblExaminee.lastName AS EntityName,
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
	UNION
		-- Doctor
		-- TODOJP: Need to account for panel exam!!!
		SELECT 
			tblCase.CaseNbr,
			'DR' as EntityType, tblCase.DoctorCode AS EntityID, 
			tblDoctor.firstName + ' ' + tblDoctor.lastName AS EntityName,
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblDoctor ON tblDoctor.DoctorCode = tblCase.DoctorCode
	UNION
		-- Plaintiff Attorney
		SELECT 
			tblCase.CaseNbr, 
			'PAT' as EntityType, tblCase.PlaintiffAttorneyCode AS EntityID, 
			ISNULL(Attrny.firstName + ' ' + Attrny.lastName, Attrny.Company) AS EntityName,
			dbo.fnIsAddressComplete(Address1, Address2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCCAddress AS Attrny ON Attrny.ccCode = tblCase.PlaintiffAttorneyCode
	UNION 
		-- Defense Attorney
		SELECT 
			tblCase.CaseNbr, 
			'DAT' as EntityType, tblCase.DefenseAttorneyCode AS EntityID, 
			ISNULL(Attrny.firstName + ' ' + Attrny.lastName, Attrny.Company) AS EntityName,
			dbo.fnIsAddressComplete(Address1, Address2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCCAddress AS Attrny ON Attrny.ccCode = tblCase.DefenseAttorneyCode
	UNION
		-- Treating Physician
		SELECT 
			tblCase.CaseNbr, 
			'TDR' as EntityType, 
			IIF(tblExaminee.TreatingPhysician IS NULL OR LEN(tblExaminee.TreatingPhysician) = 0, NULL, tblCase.ChartNbr) AS EntityID,
			tblExaminee.TreatingPhysician AS EntityName,
			IIF(tblExaminee.TreatingPhysician IS NULL OR LEN(tblExaminee.TreatingPhysician) = 0, 
				'', 
				dbo.fnIsAddressComplete(TreatingPhysicianAddr1, '', TreatingPhysicianCity, TreatingPhysicianState, TreatingPhysicianZip)) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
	UNION
		-- NF-10 Doctors
		SELECT 
			tblCase.CaseNbr, 
			'NFDR' as EntityType, TreatDr.TreatingDoctorID AS EntityID, 
			LTRIM(IIF(LEFT(LTRIM(FirstName), 1) = '-', '', FirstName) + ' ' + LastName) AS EntityName, 
			dbo.fnIsAddressComplete(Addr1, Addr2, City, State, Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblCaseOtherTreatingDoctor AS CaseTreatDr ON CaseTreatDr.CaseNbr = tblCase.CaseNbr
				INNER JOIN tblTreatingDoctor AS TreatDr ON TreatDr.TreatingDoctorID = CaseTreatDr.TreatingDoctorID
	UNION 
		-- CC's
		SELECT 
			tblCase.CaseNbr, 
			'CC' as EntityType, tblCCAddress.ccCode AS EntityID, 
			ISNULL(tblCCAddress.firstName + ' ' + tblCCAddress.lastName, tblCCAddress.Company) AS EntityName,
			dbo.fnIsAddressComplete(tblCCAddress.Address1, tblCCAddress.Address2, tblCCAddress.City, tblCCAddress.State, tblCCAddress.Zip) AS AddrMsg
		FROM tblCase 
				INNER JOIN tblExaminee ON tblExaminee.ChartNbr = tblCase.ChartNbr
				INNER JOIN tblExamineecc ON tblCase.ChartNbr = tblExamineecc.ChartNbr
				INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
