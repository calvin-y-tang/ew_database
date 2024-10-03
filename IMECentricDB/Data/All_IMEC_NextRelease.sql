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


-- IMEC-14417 - Re-work Attorney Add/Edit Security Tokens to use individual tokens instead a single AddEdit token
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('AttorneyAdd', 'Attorney - Add', GetDate()), 
      ('AttorneyEdit', 'Attorney - Edit', GetDate())
GO
INSERT INTO tblGroupFunction (GroupCode, FunctionCode)
     SELECT GroupCode, 'AttorneyAdd'
       FROM tblGroupFunction 
      WHERE FunctionCode = 'AttorneyAddEdit'
GO
INSERT INTO tblGroupFunction (GroupCode, FunctionCode)
     SELECT GroupCode, 'AttorneyEdit'
       FROM tblGroupFunction 
      WHERE FunctionCode = 'AttorneyAddEdit'
GO
DELETE FROM tblGroupFunction WHERE FunctionCode = 'AttorneyAddEdit'
GO
DELETE FROM tblUserFunction WHERE FunctionCode = 'AttorneyAddEdit'
GO

-- IMEC-14433 (IMEC-14301) - new business rule that allows us to force MedsIncoming = False when working in the Document Workspace folder.
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (136, 'FileMgrFolderRule', 'Case', 'Specify rule for a folder when using File Manager', 1, 1015, 0, 'FolderID', 'NameOfValueToSet', 'Value', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (136, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '99', 'MedsIncoming', 'False', NULL, NULL, 0, NULL)
GO
