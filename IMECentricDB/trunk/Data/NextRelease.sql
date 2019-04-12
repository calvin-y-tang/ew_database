
-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES('SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

-- Issue 10048 - no longer using field ExceptionAlert.  Replacing with AlertType.  Set the values
-- For all Case History with Follow up date is not null AND the Office of the case is set to use 
--    ShowFollowUpOnCaseOpen (= true), KEEP the follow up date and set the AlertType=1
UPDATE H
   SET AlertType = 1
  FROM tblCaseHistory AS H
			INNER JOIN tblCase AS C ON H.CaseNbr = C.CaseNbr
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
 WHERE FollowUpDate IS NOT NULL 
   AND O.ShowFollowUpOnCaseOpen = 1
GO
-- For all Case History created by ERP (UserID = ERP) and the FollowUpDate is not null, Clear the follow up date and set AlertType=1
UPDATE tblCaseHistory 
   SET AlertType = 1, 
       FollowUpDate = NULL 
 WHERE UserID = 'ERP' 
   AND FollowUpDate IS NOT NULL
GO

-- Issue 10006 - new event ID and Business Rule to provide Bulk Billing Format override
INSERT INTO tblEvent(EventID, Descrip, Category)
VALUES(1811, 'Finalize Invoice', 'Accounting')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(100, 'BulkBillingOverride', 'Accounting', 'Allow Bulk Billing Format Override based on case details', 1, 1811, 0, 'BulkBillingID', NULL, NULL, NULL, NULL, 0)
GO
-- Issue 10006 - patch tblAcctHeader.BulkBillingId column 
UPDATE ah 
   SET ah.BulkBillingID = co.bulkbillingid
  FROM tblAcctHeader ah
			INNER JOIN tblclient AS cl ON ah.clientcode = cl.ClientCode
			INNER JOIN tblCompany AS co ON cl.CompanyCode = co.CompanyCode
WHERE ah.DocumentType = 'IN'
GO 

--	DEV NOTE: i am putting this in here but will leave it commented out since we are unsure as to when 
--		this feature needs to be enabled.
-- Issue 11015 - new business rule condition to display Zurich custom tab on Case form
--INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('PC', 60, 2, 1, 7, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Zurich', NULL, NULL, NULL, NULL)
--GO
