-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 140

-- IMEC 14380 - Data patch - sets bits to 0 so checkboxes are blank and then patch the data
UPDATE tblCaseDocuments SET MedsIncoming = 0, MedsToDoctor = 0
UPDATE tblCaseDocuments SET MedsIncoming = 1 WHERE CaseDocTypeID = 7 AND UserIDAdded LIKE '%@%'
GO

-- IMEC-14281 - new business rules and BR conditions for Progressive Albany Plaintiff Attorney emails using external email source
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (172, 'DistDocsExtEmailSys', 'Case', 'Distribute docs from an external email system instead of users email', 1, 1202, 0, 'tblDoc.DocumentName', 'Email From Address', 'Email To Entity', 'Process Name', 0)
GO

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (173, 'GenDocsExtEmailSys', 'Case', 'Generate docs from an external email system instead of users email', 1, 1201, 0, 'tblDoc.Document', 'Email From Address', 'Email To Entity', 'Process Name', 0)
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('CO', 76626, 2, 1, 172, GETDATE(), 'Admin', 'WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('CO', 76626, 2, 1, 173, GETDATE(), 'Admin', 'WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

-- IMEC-14381 - create new tblSetting to determine which CaseDocType items to apply for MedsIncoming
INSERT INTO tblSetting(Name, Value)
VALUES('CaseDocTypeMedsIncoming_True', ';7;21;')
GO

-- IMEC-14383 - new tblSetting to determine which CaseDocType items to apply for MedsToDoctor
INSERT INTO tblSetting(Name, Value)
VALUES('CaseDocTypeMedsToDoctor_True', ';7;21;')
GO

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - business rules and conditions for the security token and service types
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, BrokenRuleAction)
VALUES (178, 'GuardRailForMedRecPagesFinInvoice', 'Case', 'Check that number of medical record pages has been recorded by checking that documents were sent to doctor before finalizing invoice', 1, 1811, 1, 'NumDocsMedsToDr', 'Override Sec Token', 0)


INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 1, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 2, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 3, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 4, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 5, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 6, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 8, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 9, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 10, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 11, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 12, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('SW', 2, 1, 178, GETDATE(), 'Admin', 999, '1', 'MedRecPgsFinInvoiceOverride')
GO

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - business rule for PC or company to opt out - no conditions yet
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES (179, 'OptOutGuardRailMedRecPagesFinInv', 'Case', 'IMEC-14382 - Entities opting out of having a guardrail to ensure medical records were sent to doctors to return a page count', 1, 1811, 0, 0)
GO

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - Security token to override guardrail
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('MedRecPgsFinInvoiceOverride', 'MedRecPgs - Override Guardrail to Finalize Invoice', GETDATE())
GO

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - Reasons users can override guardrail stored in tblCodes
INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('frmAuthorizeOverrideReason', 'cboOverrideReason', 'Service does not require page counts')
GO

INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('frmAuthorizeOverrideReason', 'cboOverrideReason', 'Records sent to doctor by client')
GO
