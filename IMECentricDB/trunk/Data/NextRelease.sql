
-- Issue 11736 - data patch from UserBillingEntity to BillingEntity column
-- existing UseBillingEntity column
-- 0 = none or case client 
-- 1 = billing client
-- for new BillingEntity column
--   0 = none
--   1 = case service client
--   2 = billing client
--   3 = Both
-- set to Billing Client where orig column = 1
UPDATE tblExceptionDefinition
   SET BillingEntity = 2 -- Billing client
 WHERE UseBillingEntity = 1
GO
-- set to service client where origi column = 0 and entity is CO, CL, PC
UPDATE tblExceptionDefinition
   SET BillingEntity = 1 -- service client
 WHERE UseBillingEntity = 0 and Entity in ('CO', 'CL', 'PC')
-- all other entries default to None or 0
GO

-- Issue 11737 - Allstats VAT Changes - add business rule to change company name on correspondence
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(113, 'AllstatePolicyCompanyName', 'Case', 'Use the Company Name from tblCustomerData based on Allstate referral PolicyCompanyCode', 1, 1201, 0, NULL, NULL, NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 4, 2, 1, 113, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

-- Issue 11742 - create some new Exception Triggers
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, Type)
VALUES(32, 'Create Invoice Quote', 'Active', GetDate(), 'Admin', 'Case'),
      (33, 'Create Voucher Quote', 'Active', GetDate(), 'Admin', 'Case')
GO

-- Issue 11716 - Add DPS Sort models for offices - all sort models for all offices CaseType = 10
  INSERT INTO tblOfficeDPSSortModel (Officecode, SortModelID, UserIDAdded, DateAdded) 
  SELECT O.OfficeCode, D.SortModelID, 'Admin', GetDate()
  FROM tblDPSSortModel AS D
  LEFT JOIN tblOffice AS O On 1=1


-- Issue 11814 - Default Document Filtering
UPDATE tblOffice SET RecRetrievalIncludeFileTypes = 'Records;Attachment'
UPDATE tblOffice SET RecRetrievalExcludeFileTypes = 'Diagnostic Image'

-- Issue 11815 - Order Status Filtering
UPDATE tblOffice SET RecRetrievalOrderStatus = 'ReadyForRetrieval;Retrieving;Retrieved;Failed'


-- Issue 11717 - Quote Approval Tracker Data Patch to remove completed / cancelled cases  (cancels the quote)
UPDATE tblAcctQuote
 SET QuoteStatusID = 3, DateEdited = GetDate(), UserIDEdited = 'Admin'
 WHERE QuoteType = 'VO' AND QuoteStatusID = 1  AND CaseNbr IN
(SELECT CaseNbr FROM tblCase WHERE [Status] IN (8,9))

UPDATE tblAcctQuote
 SET QuoteStatusID = 7, DateEdited = GetDate(), UserIDEdited = 'Admin'
 WHERE QuoteType = 'IN' AND QuoteStatusID IN (4,8) AND CaseNbr IN
(SELECT CaseNbr FROM tblCase WHERE [Status] IN (8,9))


-- Issue 11804  - data patch query for removing completed / cancelled cases from the certified mail, follow-up, and special services queues
-- Follow-up Tracker
UPDATE tblCaseHistory
 SET FollowUpDate = NULL, AlertType=0, DateEdited = GetDate(), UserIDEdited = 'Admin'
 WHERE FollowUpDate IS NOT NULL  AND CaseNbr IN
(SELECT CaseNbr FROM tblCase WHERE [Status] IN (8,9))

 -- Special Services Tracker
UPDATE tblCaseOtherParty 
 SET Status = 'Canceled', DateEdited = GetDate(), UserIDEdited = 'Admin'
 WHERE Status = 'Open' AND CaseNbr IN
(SELECT CaseNbr FROM tblCase WHERE [Status] IN (8,9))

-- Certified Mail tracker
 UPDATE tblCaseEnvelope
 SET DateAcknowledged = GetDate(), UserIDAcknowledged = 'Admin'
 FROM tblCaseEnvelope AS CE 
 LEFT OUTER JOIN tblCase  AS C ON C.CaseNbr = CE.CaseNbr
 WHERE CE.IsCertifiedMail = 1 AND CE.DateAcknowledged IS NULL 
 AND (C.CertMailNbr IS NOT NULL OR C.CertMailNbr2 IS NOT NULL)
 AND CE.DateImported IS NOT NULL  AND (CE.AddressedToEntity = 'EE' OR CE.AddressedToEntity = 'AT')
 AND CE.CaseNbr IN (SELECT CaseNbr FROM tblCase WHERE [Status] IN (8,9))




