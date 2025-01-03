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
GO

-- IMEC-14692 - updates to QA IME report questions
USE [IMECentricEW]
GO
declare @question nvarchar(max) = 'IME provider documented and supported their impression, functional abilities and/or restrictions and timeframes are outlined.'
declare @questionId int = (select QuestionId from tblQuestion where QuestionText = @question)

if @questionId is null
begin
	print 'Create question: ' +  @question
	INSERT INTO tblQuestion (QuestionText, DateAdded, UserIDAdded)
	VALUES (@question, GETDATE(), 'System')
	set  @questionId = (select QuestionId from tblQuestion where QuestionText = @question)
	print 'Created question with Id: ' +  @questionId
end

declare @questionSetId int = (
  select QuestionSetID
  from
    tblQuestionSet  with (nolock)
  WHERE ProcessOrder = 2
    and ParentCompanyID = 31
    and EWServiceTypeID = 1
    and Active = 1
)

declare @questionSetDetailId int
declare @currentQuestionId int
select @questionSetDetailId = QuestionSetDetailID,
	@currentQuestionId = QuestionID
from tblQuestionSetDetail
WHERE QuestionSetID = @questionSetId
  and DisplayOrder = 8

if @questionSetDetailId is not null and @currentQuestionId <> @questionId
begin
	print 'Updating QuestionSetDetailID: ' +  @questionSetDetailId + ' [QuestionID] to: ' + @questionId
	UPDATE tblQuestionSetDetail
	SET QuestionID = @questionId
	where QuestionSetDetailID = @questionSetDetailId
end
GO

-- IMEC14540 - changes to acknowledge DPS Bundle for RPA
USE [IMECentricEW]
GO
    -- new event
    INSERT INTO tblEvent(EventID, Descrip, Category)
    VALUES(1150, 'DPS Bundle Acknowledged', 'Case')
    GO
    -- new business rule
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (124, 'AutoAckDPSBundle', 'Case', 'In EWIS, Auto Acknowledge a returned DPS Bundle and move Case to next Status', 1, 1150, 0, 'DelimitedCurCaseStat', NULL, NULL, NULL, NULL, 0, 'DelimitedServiceCode')
    GO
    -- business rule conditions are specific for IMECentricEW; Param1 which is tied to tblQueues is setup for 
    -- the database and aside from some basic/common entries are different in each DB.
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 26, NULL, 1, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';2070;3290;4121;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 28, NULL, 1, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';2070;3290;4121;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 44, NULL, 1, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';2070;3290;4121;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 17, NULL, 1, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';2070;3290;4121;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 26, NULL, 10, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';4133;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 28, NULL, 10, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';4133;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 44, NULL, 10, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';4133;', 0), 
            (124, 'SW', -1, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 17, NULL, 10, NULL, ';1131;', NULL, NULL, NULL, NULL, 0, ';4133;', 0)
     
     GO


-- IMEC-14657 - database changes for Liberty guardrails additonal fees
USE [IMECentricEW]
GO

  -- insert 'Med Recs' product into quote fee table
declare @prodcode int = 3060
declare @QuoteFeeConfigID int = (select QuoteFeeConfigID from tblQuoteFeeConfig where ProdCode = @prodcode)

if @QuoteFeeConfigID is null
begin
  print 'Create product code in tblQuoteFeeConfig: ' + @prodcode
  INSERT INTO tblQuoteFeeConfig (FeeValueName, DisplayOrder, DateAdded, UserIDAdded, ProdCode)
  VALUES('Med Recs', 46, GETDATE(), 'Admin', @prodcode)
  set @QuoteFeeConfigID = (select QuoteFeeConfigID from tblQuoteFeeConfig where ProdCode = @prodcode)
  print 'Created product code in tblQuoteFeeConfig with ID: ' + @QuoteFeeConfigID
end
declare @QuoteFeeConfigID_str varchar(5) = convert (varchar(5), @QuoteFeeConfigID)

  -- ****** run in the order below - delete the current BR conditions and then add the changed ones back in
UPDATE tblBusinessRule SET Param2Desc = 'DoctorTier', Param3Desc = 'DoctorReason', Param4Desc = 'tblSettingStartDate' WHERE BusinessRuleID = 192

DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = 192

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', ';T1;', 'LibertyGuardrailsStartDate')

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
VALUES ('PC', 31, 2, 2, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', 'EW Selected', 'LibertyGuardrailsStartDate')

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('SW', 2, 3, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8')

print 'Adding new business rules with new ID: ' + @QuoteFeeConfigID_str
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,' + @QuoteFeeConfigID_str, ';T2;', 'LibertyGuardrailsStartDate')

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
VALUES ('PC', 31, 2, 2, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,' + @QuoteFeeConfigID_str, 'Client Selected', 'LibertyGuardrailsStartDate')
print 'Added new business rules with new ID: ' + @QuoteFeeConfigID_str

GO


-- IMEC-14653 - database changes for adding Case History Notes for iCase popup acknowledgement
USE [IMECentricEW]
GO

UPDATE tblBusinessRule Set Param1Desc='CaseHistoryNotes' Where BusinessRuleID =193
GO
UPDATE tblBusinessRuleCondition Set Param1='iCase Cancelling Pop-up acknowledged' Where BusinessRuleConditionID=1892
GO

UPDATE tblBusinessRule Set Param5Desc='CaseHistoryNotes' Where BusinessRuleID =190
GO
UPDATE tblBusinessRuleCondition Set Param5='iCase Status Change Pop-up acknowledged' Where BusinessRuleConditionID=1889
GO

UPDATE tblBusinessRule Set Param3Desc='CaseHistoryNotes' Where BusinessRuleID =194
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1893
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1894
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1895
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1907
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1908
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Review Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1909
GO

UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1910
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1911
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1912
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1913
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1914
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase P/R Rvw No Apprv Quote Pop-up acknowledged' Where BusinessRuleConditionID=1915
GO

UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1916
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1917
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1918
GO

UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1919
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1920
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T1 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1921
GO

UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1922
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1923
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1924
GO

UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1925
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1926
GO
UPDATE tblBusinessRuleCondition Set Param3='iCase IME T2 No Approval Quote Pop-up acknowledged' Where BusinessRuleConditionID=1927
GO

UPDATE tblBusinessRule Set Param1Desc='CaseHistoryNotes' Where BusinessRuleID =202
GO
UPDATE tblBusinessRuleCondition Set Param1='iCase Cancelling Pop-up acknowledged' Where BusinessRuleConditionID=1965
GO

-- IMEC-14668 - Modify Liberty iCase Popups to Use Doctor Address instead
update tblBusinessRuleCondition
set Param6 = replace(Param6, '@ExamLocation@', ' @DoctorAddr1@ @DoctorAddr2@')
where BusinessRuleID  in (
	select BusinessRuleID
	from tblBusinessRule
	where name in ('ScheduleAppointmentMsgs', 'ApptStatusChangeMsgs', 'InvoiceQuotetMsgs', 'ScheduleApptMsgsPanelExam')
)
