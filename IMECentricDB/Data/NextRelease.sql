-- Sprint 98

-- IMEC-13207 - new biz rules for Sentry WC Peer Reviews and WC Record Reviews
-- Wokers Comp Peer Review
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), UserIDAdded, GETDATE(), UserIDEdited, OfficeCode, EWBusLineID, 2, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
       FROM tblBusinessRuleCondition 
       WHERE BusinessRuleID IN (109,110) 
         AND EntityType = 'PC' 
         AND EntityID = 46
         AND EWBusLineID = 3 
         AND EWServiceTypeID = 1
         AND Param2 = 'WCClaimTechStPtEast@sentry.com'
GO
-- Workers Comp Record Review
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), UserIDAdded, GETDATE(), UserIDEdited, OfficeCode, EWBusLineID, 3, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
       FROM tblBusinessRuleCondition 
       WHERE BusinessRuleID IN (109,110) 
         AND EntityType = 'PC' 
         AND EntityID = 46
         AND EWBusLineID = 3 
         AND EWServiceTypeID = 1
         AND Param2 = 'WCClaimTechStPtEast@sentry.com'
GO