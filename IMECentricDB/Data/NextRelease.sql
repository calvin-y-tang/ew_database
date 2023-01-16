-- Sprint 102

-- IMEC-13314 - update/modify business rule for Gallagher Basset Employer names
    -- delete duplicate business rule
     DELETE FROM tblBusinessRule WHERE BusinessRuleID = 108
     GO
     -- upate existing business rules
     UPDATE tblBusinessRule 
        SET Param4Desc = 'EmployerNameMsg'
      WHERE BusinessRuleID = 104
     GO
     UPDATE tblBusinessRuleCondition
        SET Param4 = CASE 
                         WHEN Param3 = '525' THEN 'Sodexo'
                         WHEN Param3 = '39223' THEN 'Elite Staffing LLC'
                         ELSE Param3
                    END
      WHERE BusinessRuleID = 104
      GO
     -- add new business rules
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     VALUES (104, 'PC', 25, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, '002456', NULL, '55453, 59557', 'First Transit or First Student', NULL, 0, NULL)
     GO


