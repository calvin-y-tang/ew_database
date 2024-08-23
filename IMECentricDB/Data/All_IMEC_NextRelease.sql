-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 139


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

