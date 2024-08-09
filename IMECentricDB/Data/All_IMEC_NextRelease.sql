-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 139


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

-- IMEC-14263 - new Amtrust override security token and Bizrule update 
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('AMTrustInvGuardrailOverride', 'Amtrust - Override Guardrails for Finalize Invoice', GetDate())
GO
UPDATE tblBusinessRule
   SET Param5Desc = 'SecurityTokenOvrRide'
  FROM tblBusinessRule 
 WHERE BusinessRuleID = 151
GO
UPDATE tblBusinessRuleCondition
   SET Param5 = 'AMTrustInvGuardrailOverride'
  FROM tblBusinessRuleCondition
 WHERE BusinessRuleID = 151
   AND EntityType = 'PC' 
   AND EntityID = 9 
GO 


-- IMEC-14276 - 
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('PC', 31, 2, 1, 153, GETDATE(), 'Admin', 'Always')
GO

