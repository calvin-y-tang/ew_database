
CREATE VIEW [dbo].[vwSedgwickClaimRecords] AS
SELECT	Id,
		ClientNumber,
		ClaimNumber,
		ShortVendorId,
		CMSProcessingOffice,
		ClaimUniqueId,
		ClaimSystemId,
		ShellClaimNumber,
		StateClaimNumber,
		CASE ClaimStatus
			WHEN 'O' THEN 'Open'
			WHEN 'R' THEN 'Re-Opened'
			WHEN 'C' THEN 'Closed'
			WHEN 'L' THEN 'Deleted'
		END AS ClaimStatus,
		LastUPdated,
		ClaimType,
		LineOfBusiness,
		DateOfInjury,
		StateOfJurisdiction,
		ClaimantFirstName,
		ClaimantLastName,
		ClaimantSSN,
		ClaimantDOB,
		ClaimantAddress1,
		ClaimantAddress2,
		ClaimantCity,
		ClaimantState,
		ClaimantZip,
		ClaimantDayPhone,
		ClaimantEveningPhone,
		DisabilityDate,
		DescriptionOfINjury,
		BP1.CodeDescription AS BodyPart1,
		BP2.CodeDescription AS BodyPart2, 
		CoI.CodeDescription AS CauseOfInjury, 
		NoI.CodeDescription AS NatureOfInjury,
		DescriptionOfOccupation,
		SideOfBodyInjured1,
		SideOfBodyInjured2,
		PartOfBody
  FROM [CustomRepository].[dbo].[SedgwickClaimRecord]
  		LEFT OUTER JOIN [CustomRepository].[dbo].[SedgwickCodes] AS BP1
			ON BP1.CodeID = PartOfBody1 AND BP1.CodeType = 'BodyPart'
		LEFT OUTER JOIN [CustomRepository].[dbo].[SedgwickCodes] AS BP2
			ON BP2.CodeID = PartOfBody2 AND BP2.CodeType = 'BodyPart'
		LEFT OUTER JOIN [CustomRepository].[dbo].[SedgwickCodes] AS CoI
			ON CoI.CodeID = CauseOfInjury AND CoI.CodeType = 'InjuryCause'
		LEFT OUTER JOIN [CustomRepository].[dbo].[SedgwickCodes] AS NoI
			ON NoI.CodeID = NatureOfInjury AND NoI.CodeType = 'InjuryNature'