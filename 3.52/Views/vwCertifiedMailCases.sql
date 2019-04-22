CREATE VIEW [dbo].[vwCertifiedMailCases]
AS 
	SELECT 
			MAX(IIF(CaseEnv.AddressedToEntity='EE', CaseEnv.CaseEnvelopeID, 0)) AS EECaseEnvelopeID,
			MAX(IIF(CaseEnv.AddressedToEntity='AT', CaseEnv.CaseEnvelopeID, 0)) AS ATCaseEnvelopeID, 
			CaseEnv.CaseNbr AS CaseNbr, 
			tblCase.CertMailNbr AS ExamineeCertMailNbr, 
			tblCase.CertMailNbr2 AS AttorneyCertMailNbr,
			CaseEnv.DateAcknowledged AS DateAcknowledged, 
			-- columns needed for dynamic WHERE clause that is created in client code
			tblCase.OfficeCode AS OfficeCode, 
			tblCase.CaseType AS CaseType, 
			tblCompany.CompanyCode AS CompanyCode,
			tblCase.DoctorCode AS DoctorCode,
			tblCase.DoctorLocation AS DoctorLocation,
			tblCase.MarketerCode AS MarketerCode, 
			tblCompany.ParentCompanyID AS ParentCompanyID, 
			tblCase.QARep AS QARep,
			tblCase.SchedulerCode AS SchedulerCode, 
			tblCase.ServiceCode AS ServiceCode,
			CaseEnv.DateImported
	  FROM tblCaseEnvelope AS CaseEnv
				LEFT OUTER JOIN tblCase ON tblCase.CaseNbr = CaseEnv.CaseNbr 
				LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
				LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
	WHERE CaseEnv.IsCertifiedMail = 1 AND CaseEnv.DateImported IS NOT NULL  AND ([AddressedToEntity] = 'EE' OR [AddressedToEntity] = 'AT')
	GROUP BY CaseEnv.CaseNbr, tblCase.CertMailNbr, tblCase.CertMailNbr2, CaseEnv.DateAcknowledged, 
		tblCase.OfficeCode, tblCase.CaseType, tblCompany.CompanyCode, tblCase.DoctorCode, 
		tblCase.DoctorLocation, tblCase.MarketerCode, tblCompany.ParentCompanyID, tblCase.QARep, 
		tblCase.SchedulerCode, tblCase.ServiceCode, CaseEnv.DateImported

