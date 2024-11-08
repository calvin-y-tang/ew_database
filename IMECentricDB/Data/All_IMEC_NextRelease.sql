-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 142
-- IMEC-14425 - No Show Letter template based on number of no show appts for case
     INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
     VALUES (137, 'NoShowTemplateToUse', 'Case', 'Determine No Show Template to use for a case based on the # of no shows', 1, 1107, 0, 'MinNoShowApptCnt', 'MaxNoShowApptCnt', 'NoShowDocument', NULL, NULL, 0, NULL)
     GO

     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (137, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, '1', '1', 'AllState1stNS', NULL, NULL, 0, NULL, 0),
            (137, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, NULL, NULL, 'AllState2ndNS', NULL, NULL, 0, NULL, 0)
    GO
