-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 143
-- IMEC-14485 - email documents for Chubb
USE [IMECentricEW]
GO

INSERT INTO tblBusinessRuleCondition (
    EntityType,         -- Type of entity (e.g., 'CO', 'PC', 'SW')
    EntityID,           -- The unique ID of the entity; Foreign Key to tblCompany
    BillingEntity,      -- Case Client or Company Client and we are looking for both
    ProcessOrder,       -- The priority
    BusinessRuleID,     -- Business Rule ID (foreign key to the tblBusinessRule)
    DateAdded,          -- Date and time when the record was added (using GETDATE())
    UserIDAdded,        -- User who added the record ('Admin' in this case)
    DateEdited,         -- Date and time when the record was last edited (using GETDATE())
    UserIDEdited,       -- User who last edited the record ('Admin' in this case)
    Param1,             -- SET to 2 for all kinds of emal with or without attachments
    Param2,             -- An additional parameter (email in this case)
    Param4,              -- Indicating documentype in this case
    Skip                -- A flag (0 means no skip)
)
VALUES   
    ('CO',4121,2,1,109,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0),
	('CO',4121,2,1,110,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0),
	('CO',4121,2,1,111,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0)
GO

-- IMEC-14578 - security token and Biz Rules for Doctor Discipline Status validation when scheduling case
-- need new security token
USE [IMECentricEW]
GO
    INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
    VALUES('LibertySchedulingOverride', 'Appointments - Liberty Schedule Doctor Override', GETDATE())
    GO

-- need new bizRules
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (139, 'ApplyDoctorDiscipline', 'Appointment', 'Apply Doctor Discipline Status Criteria when scheduling', 1, 1101, 0, 'tblSettingStartDate', 'CriteriaNotMetMsg', 'PerformActionDesc', NULL, 'SecOverrideToken', 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
    VALUES (139, 'PC', 31, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'LibertyGuardrailsStartDate', 'The selected doctor doesn''t meet Liberty''s credentialing requirements for discipline for Case Nbr @CaseNbr@.', NULL, NULL, 'LibertySchedulingOverride', 0, NULL, 0), 
           (139, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'LibertyGuardrailsStartDate', 'The selected doctor doesn''t meet Liberty''s credentialing requirements for discipline for Case Nbr @CaseNbr@.', 'SKIP', NULL, 'LibertySchedulingOverride', 0, NULL, 0),
           (139, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'TX', 'LibertyGuardrailsStartDate', 'The selected doctor doesn''t meet Liberty''s credentialing requirements for discipline for Case Nbr @CaseNbr@.', 'SKIP', NULL, 'LibertySchedulingOverride', 0, NULL, 0)
    GO

    -- just create the rule; we will deploy with no doctors being exempt and them as the need arises
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (123, 'ExemptDoctorDiscipline', 'Appointment', 'Exempt from Doctor Discipline Status Criteria when scheduling', 1, 1101, 0, 'DoctorCode', NULL, NULL, NULL, NULL, 0, NULL)
    GO

USE [IMECentricEW]
GO

-- IMEC-14645 - Liberty quote guardrails - business rule for med rec page calculations - Exclude WA workers comp
  --   (18) Service Fee > 500 - ProdCode = 3030; exclude WA for workers comp - no service fee
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 3, 'WA', '3030')
GO

-- IMEC-14646 - Liberty quote guardrails - business rule for med rec page calculations - add Record review
--   (19) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 1, 3, 'T1', '250', '385', '0.2', '250')
GO

--   (20) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 5, 3, 'T1', '250', '385', '0.2', '250')
GO

--   (21) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 3, 'CA', 'T1', '385', '0.35', '250')
GO

--   (22) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 3, 'WA', 'T1', '385', '0.35', '250')
GO

--   (23) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 3, 'CA', 'T1', '385', '0.35', '250')
GO

--   (24) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 3, 'WA', 'T1', '385', '0.35', '250')
GO

--   (25) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Record review; Jurisdiction 'MI'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 2, 3, 'MI', 'T1', '385')
GO

-----IMEC-14415, IMEC-14188 Data Patch to add data for new fields added to tblDoctor and tblDoctorSpecialty------------
USE [IMECentricEW]
GO
WITH CTE_Update AS (
    SELECT 
		  d.DoctorCode AS EWDoctorCode,
		  d.DoctorDisciplineStatus AS EWDoctorDisciplineStatus,
          d.LastSurgeryDate As EWLastSurgeryDate,
          d.LicenseNotRequired As EWLicenseNotRequired, 
		  d.ActiveSurgery As EWActiveSurgery,
          r.Active AS doctorActive,
          mr.masterreviewerid AS masterreviewerid,
          r.LastSurgeryDate AS CRNLastSurgeryDate,
          mr.LicenseNotRequired As CRNLicenseNotRequired,
		  r.PerformingSurgeryID As CRNActiveSurgery
    FROM tblDoctor d with (nolock)
    INNER JOIN [crn].[crn_production].[dbo].reviewer r with (nolock) ON d.DoctorCode = r.localsystemid
                inner join [crn].[crn_production].[dbo].master_reviewer mr with (nolock) on mr.masterreviewerid = r.masterid         
                where r.Active = 1 and d.Status='Active' and r.localsystemname = 'EW-IMEC'  
)
-- Perform the update using the CTE
UPDATE CTE_Update
SET 
    EWDoctorDisciplineStatus = CASE 
                 WHEN (select top 1 da.masterreviewerid from [crn].[crn_production].[dbo].Master_Reviewer_Disciplinary_Action_XREF da where da.masterreviewerid = CTE_Update.masterreviewerid
                and da.disciplinaryActionID in (8, 16)) is null then 0 else 1                 
              END,
    EWLastSurgeryDate = CRNLastSurgeryDate,
    EWLicenseNotRequired = CRNLicenseNotRequired,
	EWActiveSurgery = CASE
						WHEN CRNActiveSurgery in (0,2, NULL) then 0 else 1
    END

USE [IMECentricEW]
GO
WITH CTE_Update AS (
    SELECT 
		  ds.DoctorCode AS EWDoctorCode,		
		  ds.SpecialtyCode As EWSpecialtyCode,
		  ds.CertificationStatus As EWCertificationStatus,
		  ds.CertificationStatusID As EWCertificationStatusID,
		  ds.ExpirationDate As EWExpirationDate,
		  ds.MasterReviewerSpecialtyID As EWMasterReviewerSpecialtyID,
		  mrs.specialtyid As CRNSpecialtyID,
		  mrs.specialtytypeid As CRNSpecialtyTypeID,
		  cs.Name As CRNSpecialtyStatus,
		  mrs.specialtycertificationstatusid As CRNCertificationStatusID,
		  mrs.ExpirationDate As CRNExpirationDate,
		  mrs.SpecialtyID As CRNMasterReviewerSpecialtyID,
          r.Active AS doctorActive            
    FROM tblDoctorSpecialty ds with (nolock)
    INNER JOIN [crn].[crn_production].[dbo].reviewer r with (nolock) ON ds.DoctorCode = r.localsystemid
	inner join [crn].[crn_production].[dbo].master_reviewer mr with (nolock) on mr.masterreviewerid = r.masterid
                inner join [crn].[crn_production].[dbo].Master_Reviewer_Specialty mrs with (nolock) on mrs.masterreviewerid = mr.masterreviewerid
                inner join [crn].[crn_production].[dbo].Specialty_Certification_Status cs with (nolock) on cs.specialtycertificationstatusid = mrs.specialtycertificationstatusid
                where r.Active = 1 and r.localsystemname = 'EW-IMEC' and ds.SpecialtyCode NOT Like '% - %' 				
)
-- Perform the update using the CTE
UPDATE CTE_Update
SET 
   EWCertificationStatus = CRNSpecialtyStatus,
   EWCertificationStatusID = CRNCertificationStatusID,
   EWExpirationDate = CRNExpirationDate,
   EWMasterReviewerSpecialtyID = CRNSpecialtyID

USE [IMECentricEW]
GO
WITH CTE_Update AS (
    SELECT 
		  ds.DoctorCode AS EWDoctorCode,		
		  ds.SpecialtyCode As EWSpecialtyCode,
		  ds.CertificationStatus As EWCertificationStatus,
		  ds.CertificationStatusID As EWCertificationStatusID,
		  ds.ExpirationDate As EWExpirationDate,
		  ds.MasterReviewerSpecialtyID As EWMasterReviewerSpecialtyID,
		  mrs.specialtyid As CRNSpecialtyID,
		  mrs.specialtytypeid As CRNSpecialtyTypeID,
		  cs.Name As CRNSpecialtyStatus,
		  mrs.specialtycertificationstatusid As CRNCertificationStatusID,
		  mrs.ExpirationDate As CRNExpirationDate,
		  mrs.SpecialtyID As CRNMasterReviewerSpecialtyID,
		  mrs.specialtydictionaryid As CRNSpecialtyDictionaryID,
		  mrs.masterreviewerid As CRNMasterReviewerID,
          r.Active AS doctorActive            
    FROM tblDoctorSpecialty ds with (nolock)
    INNER JOIN [crn].[crn_production].[dbo].reviewer r with (nolock) ON ds.DoctorCode = r.localsystemid
	inner join [crn].[crn_production].[dbo].master_reviewer mr with (nolock) on mr.masterreviewerid = r.masterid
                inner join [crn].[crn_production].[dbo].Master_Reviewer_Specialty mrs with (nolock) on mrs.masterreviewerid = mr.masterreviewerid
                inner join [crn].[crn_production].[dbo].Specialty_Certification_Status cs with (nolock) on cs.specialtycertificationstatusid = mrs.specialtycertificationstatusid
                where r.Active = 1 and r.localsystemname = 'EW-IMEC' and ds.SpecialtyCode Like '% - %'				
)
-- Perform the update using the CTE
UPDATE CTE_Update
SET 
  EWCertificationStatus = CASE
						WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded'
						then  'Boarded'
						WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '')
						then  'Not Boarded'
						WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
						then  'Boarded'
							WHEN ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '') AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
						then  'Not Boarded'
						
							WHEN ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '') AND ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '')
						then  'Not Boarded'
						
WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
						then  'N/A'
						END,
EWCertificationStatusID = CRNCertificationStatusID,
 EWExpirationDate = CASE
   --- Boarded and Boarded 1-------------
             WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded'
               THEN CASE
			   WHEN (SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) > (SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)    
                THEN 
				(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
  ELSE
  (SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
				END           

-----------Boarded and Not Boarded Or Blank ---------------
			 	
				WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '')
               THEN 
				(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
				
------------Boarded and N/A -----------
  WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
			THEN
			(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
   
   ----------NOt Boarded,Blank and N/A-------------
  WHEN ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '') AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
  THEN
  		(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
   
------Not Boarded, Blank and Not Boarded, Blank----------
	WHEN ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '') AND ((SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' OR (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = '')
 THEN CASE
			   WHEN (SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) > (SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)    
                THEN 
				(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) 
ELSE
(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) 
				END             
------------------N/A and N/A------------------
WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'N/A'
     THEN
	 CRNExpirationDate
----------------Not Boarded, Boarded -------------------
 WHEN (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Not Boarded' AND (SELECT cs.Name from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=1 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID) = 'Boarded'
			THEN
			(SELECT msr.ExpirationDate from [crn].[crn_production].[dbo].Master_Reviewer_Specialty msr
INNER JOIN [crn].[crn_production].[dbo].Specialty_Certification_Status cs ON msr.SpecialtyCertificationStatusID = cs.SpecialtyCertificationStatusID
where msr.SpecialtyTypeID=2 and msr.masterreviewerid = CTE_Update.CRNMasterReviewerID)
END,
EWMasterReviewerSpecialtyID = CRNSpecialtyID



