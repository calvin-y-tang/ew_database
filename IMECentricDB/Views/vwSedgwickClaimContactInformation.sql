CREATE VIEW [dbo].[vwSedgwickClaimContactInformation] AS
SELECT ClaimNumber,
	   ShortVendorId,
	   FirstName,
	   LastName,
	   Speciality,
	   Address1,
	   Address2,
	   City,
	   [State],
	   Zip,
	   Phone1, 
	   PhoneExt1,
	   Phone2,
	   PhoneExt2,
	   FaxNumber,
	   EmailAddress,
	   CASE TransactionType
			WHEN 'PTP' THEN 'Provider (Primary Treating Physician)'
			WHEN 'EXM' THEN 'Sedgwick CMS Examiner'
			WHEN 'CLI' THEN 'Clinic'
			WHEN 'DOC' THEN 'Doctor'
			WHEN 'HOS' THEN 'Hospital'
			WHEN 'IME' THEN 'Independent Medical Exam (IME) Physician'
			WHEN 'OTP' THEN 'Other Treating Provider'
			WHEN 'DAT' THEN 'Defense Attorney'
			WHEN 'PAT' THEN 'Plaintiff Attorney'
			WHEN 'CAR' THEN 'Claimant Address of Record'
			WHEN 'CLT' THEN 'Client Contact'
			WHEN 'LWR' THEN 'Lawyer'
			WHEN 'MCN' THEN 'Managed Care Nurse'
			WHEN 'MCV' THEN 'Managed Care Vendor'
			WHEN 'OHC' THEN 'Occupational Health Clinic'
			WHEN 'OSC' THEN 'Outpatient Surgical Center'
			WHEN 'PRP' THEN 'Peer Review Physician'
			WHEN 'RPM' THEN 'Rehab/Pain Management Center'
			WHEN 'SOR' THEN 'Supervisor of Record'
			WHEN 'STP' THEN 'Secondary Treating Physician'
			WHEN 'SUP' THEN 'Supervisor'
			WHEN 'VRE' THEN 'Vocational Rehab Vendor'
			WHEN 'WKA' THEN 'Work Address'
			WHEN 'ALP' THEN 'Alternate Payee'
			WHEN 'BEN' THEN 'Beneficiary'
			WHEN 'CCE' THEN 'Concurrent Employer Address'
			WHEN 'CFN' THEN 'Claimant Former Name/Address'
			WHEN 'CLR' THEN 'Caller'
			WHEN 'COP' THEN 'Co-Payee'
			WHEN 'EAP' THEN 'Employee Assistance Program'
			WHEN 'HRC' THEN 'Human Resource Contact'
			WHEN 'LLA' THEN 'Loss Location Address'
			WHEN 'RPC' THEN 'Repairer Shop-Claimant'
			WHEN 'RPI' THEN 'Repairer Shop-Insured'
			WHEN 'THP' THEN 'Third Party'
			WHEN 'TND' THEN 'Tendered Vendor'
			WHEN 'WIT' THEN 'Witness'
			WHEN 'SES' THEN 'Sedgwick Examiner Supervisor'
			WHEN 'OTH' THEN 'Other'
		END AS "ContactType"
FROM [CustomRepository].[dbo].[SedgwickClaimContactInformationRecord]