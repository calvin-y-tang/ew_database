
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_ParseClaimRecordsToTable]  
AS
BEGIN
INSERT INTO SedgwickClaimRecord 
     (
     ClientNumber, 
     ClaimNumber, 
     ShortVendorId, 
     CMSProcessingOffice, 
     ClaimUniqueId, 
     ClaimSystemId, 
     ShellClaimNumber, 
     DateOfInjury, 
     CompensabilityStatus, 
     ClaimStatus, 
     LastUpdated, 
     ReportedDate, 
     ClaimantFirstName, 
     ClaimantLastName, 
     ClaimantMiddleName, 
     ClaimantSSN, 
     ClaimantClientEEId, 
     ClaimantStateEEId, 
     ClaimantAddress1, 
     ClaimantAddress2, 
     ClaimantCity, 
     ClaimantState, 
     ClaimantZip, 
     ClaimantCounty, 
     ClaimantCountry, 
     ClaimantDayPhone, 
     ClaimantEveningPhone, 
     ClaimantDOB, 
     ClaimantDateOfDeath, 
     ClaimantGender, 
     ClaimantMaritalStatus, 
     ClientAccount, 
     ClientUnit, 
     DescriptionOfInjury, 
     PartOfBody1, 
     PartOfBody2, 
     CauseOfInjury, 
     NatureOfInjury, 
     DescriptionOfOccupation, 
     ClaimantJobClassCode, 
     ClaimantJobIntensity, 
     ClaimantHireDate, 
     ClaimantTerminationDate, 
     EmploymentStatus, 
     AverageWeeklyWage, 
     TTDWage, 
     TDInterval, 
     DisabilityDate, 
     DateLastWorked, 
     SideOfBodyInjured1, 
     SideOfBodyInjured2, 
     PartOfBody, 
     Adjuster, 
     SettlementDate, 
     DenialDate, 
     RTWDate, 
     ModifiedDutyAvailable, 
     AttorneyLegalIndicator, 
     MHMEligibility, 
     DateMHMEligible, 
     ClaimType, 
     StateOfJurisdiction, 
     DMEOnly, 
     Nonsubscriber, 
     LineOfBusiness, 
     CarriersNCCI, 
     CarriersFEIN, 
     CarriersName, 
     CarriersAddress, 
     CarriersCity, 
     CarriersState, 
     CarriersZip, 
     CarriersInsuredIDNumber, 
     ContactName, 
     AccountName, 
     UnitName, 
     EmployerName, 
     EmployerFEIN, 
     EmployerAddress1, 
     EmployerAddress2, 
     EmployerCity, 
     EmployerState, 
     EmployerZip, 
     EmployerCountry, 
     EmployerUniqueID, 
     DiagICD9, 
     DrAnticipatedRestrictedRTWDate, 
     ActualRestrictedRTWDate, 
     DrAnticipatedFullRTWDate, 
     StateClaimNumber, 
     ClaimExaminersOfficeNumber, 
     MLSURClaimIndicator, 
     EventAlertDescription, 
     ClaimantAlertDescription, 
     ClaimAlertDescription, 
     CustomFields, 
     ClaimantEmail, 
     SecondaryDiagICD9, 
     BillManagementCode, 
     BillManagementComments, 
     AppointmentFlag, 
     AppointmentSetDate, 
     AppointmentPercent, 
     CertifiedActivityFlag1, 
     CertifiedNetworkName1, 
     CertifiedNetworkEligibleBegin1, 
     CertifiedNetworkEligibleEnd1, 
     CertifiedNetworkActiveFlag2, 
     CertifiedNetworkName2, 
     CertifiedNetworkEligibleBegin2, 
     CertifiedNetworkEligibleEnd2, 
     PharmacyNetworkActiveFlag1, 
     PharmacyNetworkName1, 
     PharmacyNetworkEligibleBegin1, 
     PharmacyNetworkEligibleEnd1, 
     PharmacyNetworkActiveFlag2, 
     PharmacyNetworkName2, 
     PharmacyNetworkEligibleBegin2, 
     PharmacyNetworkEligibleEnd2, 
     ClaimSubTypeCode, 
     SubrogationFlag, 
     HeaderRecordId,
	 AdminClaimNumber    
     )
     SELECT  
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,4,4)) = 1 
               THEN CONVERT(INT, RTRIM(SUBSTRING(RecDetail,4,4))) 
               ELSE  0
               END,                    
          RTRIM(SUBSTRING(RecDetail,8,18)), 
          RTRIM(SUBSTRING(RecDetail,26,2)),                    
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,28,3)) = 1  
               THEN RTRIM(SUBSTRING(RecDetail,28,3)) 
               ELSE '000' 
               END,             
          RTRIM(SUBSTRING(RecDetail,31,30)), 
          RTRIM(SUBSTRING(RecDetail,61,30)), 
          RTRIM(SUBSTRING(RecDetail,91,20)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,111,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,111,8),112) 
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,119,3)), 
          RTRIM(SUBSTRING(RecDetail,122,3)),             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,125,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,125,8),112) 
               ELSE NULL
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,133,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,133,8),112)  
               ELSE NULL
               END,             
          RTRIM(SUBSTRING(RecDetail,141,20)), 
          RTRIM(SUBSTRING(RecDetail,161,25)), 
          RTRIM(SUBSTRING(RecDetail,186,1)), 
          RTRIM(SUBSTRING(RecDetail,187,11)), 
          RTRIM(SUBSTRING(RecDetail,198,25)), 
          RTRIM(SUBSTRING(RecDetail,223,25)), 
          RTRIM(SUBSTRING(RecDetail,248,30)), 
          RTRIM(SUBSTRING(RecDetail,278,30)), 
          RTRIM(SUBSTRING(RecDetail,308,30)), 
          RTRIM(SUBSTRING(RecDetail,338,2)), 
          RTRIM(SUBSTRING(RecDetail,340,9)), 
          RTRIM(SUBSTRING(RecDetail,349,20)), 
          RTRIM(SUBSTRING(RecDetail,369,3)), 
          RTRIM(SUBSTRING(RecDetail,372,18)), 
          RTRIM(SUBSTRING(RecDetail,390,18)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,468,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,468,8),112) 
               ELSE NULL
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,476,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,476,8),112)  
               ELSE NULL
               END,             
          RTRIM(SUBSTRING(RecDetail,484,1)), 
          RTRIM(SUBSTRING(RecDetail,485,1)),             
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,486,8)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,486,8)) 
               ELSE '00000000' 
               END,             
          RTRIM(SUBSTRING(RecDetail,494,6)), 
          RTRIM(SUBSTRING(RecDetail,500,80)), 
          RTRIM(SUBSTRING(RecDetail,580,4)), 
          RTRIM(SUBSTRING(RecDetail,584,4)), 
          RTRIM(SUBSTRING(RecDetail,588,4)), 
          RTRIM(SUBSTRING(RecDetail,592,4)), 
          RTRIM(SUBSTRING(RecDetail,596,65)),             
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,661,4)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,661,4)) 
               ELSE '0000' 
               END,             
          RTRIM(SUBSTRING(RecDetail,665,1)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,666,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,666,8),112) 
               ELSE NULL 
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,674,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,674,8),112)  
               ELSE NULL
               END,             
          RTRIM(SUBSTRING(RecDetail,682,1)),             
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,683,15)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,683,15)) 
               ELSE '000000000000.00' 
               END,             
          CASE 
               WHEN ISNUMERIC(SUBSTRING(RecDetail,698,15)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,698,15)) 
               ELSE '000000000000.00' 
               END,             
          RTRIM(SUBSTRING(RecDetail,713,5)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,718,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,718,8),112) 
               ELSE NULL
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,726,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,726,8),112)  
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,734,5)), 
          RTRIM(SUBSTRING(RecDetail,739,5)), 
          RTRIM(SUBSTRING(RecDetail,744,130)), 
          RTRIM(SUBSTRING(RecDetail,874,30)),             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,904,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,904,8),112)  
               ELSE NULL 
               END,             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,912,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,912,8),112)  
               ELSE NULL 
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,920,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,920,8),112)  
               ELSE NULL
               END,             
          RTRIM(SUBSTRING(RecDetail,928,1)), 
          RTRIM(SUBSTRING(RecDetail,929,1)), 
          RTRIM(SUBSTRING(RecDetail,930,1)),             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,931,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,931,8),112)
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,939,4)), 
          RTRIM(SUBSTRING(RecDetail,943,2)), 
          RTRIM(SUBSTRING(RecDetail,945,1)), 
          RTRIM(SUBSTRING(RecDetail,946,1)), 
          RTRIM(SUBSTRING(RecDetail,947,4)),             
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,951,5)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,951,5)) 
               ELSE '00000' 
               END,             
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,956,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,956,9)) 
               ELSE '000000000' 
               END,             
          RTRIM(SUBSTRING(RecDetail,965,40)), 
          RTRIM(SUBSTRING(RecDetail,1005,30)), 
          RTRIM(SUBSTRING(RecDetail,1035,25)), 
          RTRIM(SUBSTRING(RecDetail,1060,2)), 
          RTRIM(SUBSTRING(RecDetail,1062,15)), 
          RTRIM(SUBSTRING(RecDetail,1077,30)), 
          RTRIM(SUBSTRING(RecDetail,1107,100)), 
          RTRIM(SUBSTRING(RecDetail,1207,100)), 
          RTRIM(SUBSTRING(RecDetail,1307,100)), 
          RTRIM(SUBSTRING(RecDetail,1407,30)),             
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,1507,9)) = 1  
               THEN RTRIM(SUBSTRING(RecDetail,1507,9)) 
               ELSE '000000000' 
               END,             
          RTRIM(SUBSTRING(RecDetail,1516,30)), 
          RTRIM(SUBSTRING(RecDetail,1546,30)), 
          RTRIM(SUBSTRING(RecDetail,1576,20)), 
          RTRIM(SUBSTRING(RecDetail,1596,2)),             
          CASE
               WHEN ISNUMERIC(SUBSTRING(RecDetail,1598,9)) = 1 
               THEN RTRIM(SUBSTRING(RecDetail,1598,9)) 
               ELSE '000000000' 
               END,            
          RTRIM(SUBSTRING(RecDetail,1607,3)), 
          RTRIM(SUBSTRING(RecDetail,1610,18)), 
          RTRIM(SUBSTRING(RecDetail,1628,12)), 
          RTRIM(SUBSTRING(RecDetail,1640,8)), 
          RTRIM(SUBSTRING(RecDetail,1648,8)), 
          RTRIM(SUBSTRING(RecDetail,1656,8)), 
          RTRIM(SUBSTRING(RecDetail,1664,30)), 
          RTRIM(SUBSTRING(RecDetail,1694,3)), 
          RTRIM(SUBSTRING(RecDetail,1697,3)), 
          RTRIM(SUBSTRING(RecDetail,1700,50)), 
          RTRIM(SUBSTRING(RecDetail,1750,50)), 
          RTRIM(SUBSTRING(RecDetail,1800,50)), 
          RTRIM(SUBSTRING(RecDetail,1850,3)), 
          RTRIM(SUBSTRING(RecDetail,1853,320)), 
          RTRIM(SUBSTRING(RecDetail,2253,12)), 
          RTRIM(SUBSTRING(RecDetail,2265,1)), 
          RTRIM(SUBSTRING(RecDetail,2266,500)), 
          RTRIM(SUBSTRING(RecDetail,2766,1)),           
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,2767,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2767,8),112) 
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,2775,3)), 
          RTRIM(SUBSTRING(RecDetail,2778,1)), 
          RTRIM(SUBSTRING(RecDetail,2779,60)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,2839,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2839,8),112)  
               ELSE NULL 
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,2847,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2847,8),112)  
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,2855,1)), 
          RTRIM(SUBSTRING(RecDetail,2856,60)),             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,2916,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2916,8),112)  
               ELSE NULL 
               END,             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,2924,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2924,8),112)  
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,2932,1)), 
          RTRIM(SUBSTRING(RecDetail,2933,60)),             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,2993,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,2993,8),112) 
               ELSE NULL 
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,3001,8)) = 1 
               THEN CONVERT(DATETIME,SUBSTRING(RecDetail,3001,8),112)  
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,3009,1)), 
          RTRIM(SUBSTRING(RecDetail,3010,60)),             
          CASE
               WHEN ISDATE(SUBSTRING(RecDetail,3070,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,3070,8),112)  
               ELSE NULL 
               END,             
          CASE 
               WHEN ISDATE(SUBSTRING(RecDetail,3078,8)) = 1 
               THEN CONVERT(DATETIME, SUBSTRING(RecDetail,3078,8),112) 
               ELSE NULL 
               END,             
          RTRIM(SUBSTRING(RecDetail,3086,2)), 
          RTRIM(SUBSTRING(RecDetail,3088,1)),
          HeaderRecordID,
		  RTRIM(SUBSTRING(RecDetail,3089,25))
     FROM SedgwickClaimDataImport
     WHERE RecType = 'CLM' 
     AND IsRecordLoaded = 1
     AND UpdateInsert = 'Q'
END
