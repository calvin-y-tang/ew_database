
PRINT N'Update complete.';


GO
-- Sprint 99

-- IMEC-13222 - modify business rule to allow for EWFacility matching and override
UPDATE tblBusinessRule
   SET Param3Desc = 'EWFacIDNormTaxes'
 WHERE BusinessRuleID = 155
 GO
UPDATE tblBusinessRuleCondition
   SET Param3 = ';5;'
 WHERE BusinessRuleID = 155
 GO

 -- IMEC-13241 - add travelers business rule to allow Doctor Reason to be filtered to defined items
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (147, 'SetDoctorReasonChoices', 'Appointment', 'Set list of available choices for Doctor Reason', 1, 1101, 0, 'AllowedSelections', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (147, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,4', NULL, NULL, NULL, NULL, 0, NULL)
GO
