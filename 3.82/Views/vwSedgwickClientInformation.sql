CREATE VIEW [dbo].[vwSedgwickClientInformation] AS 
SELECT	SCMSClientId,
	    ClientName,
		ClientAddressLine1,
		ClientAddressLine2,
		ClientCity,
		ClientState,
		ClientPostalCode,
		ClientPhoneNumber,
		InceptionDate,
		ExpirationDate,
		CASE ClientContactStatus
			WHEN 'A' THEN 'Active'
			WHEN 'R' THEN 'Run-off'
			WHEN 'D' THEN 'Inactive'
		END AS 'ClientStatus'
  FROM [CustomRepository].[dbo].[SedgwickClientInformationRecord]