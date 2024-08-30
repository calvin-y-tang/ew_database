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
VALUES ('CO', 76626, 2, 1, 172, GETDATE(), 'Admin', '*WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('CO', 76626, 2, 1, 173, GETDATE(), 'Admin', 'WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

