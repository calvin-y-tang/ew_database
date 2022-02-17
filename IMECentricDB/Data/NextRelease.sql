
-- IMEC-12442 add Conflict of interest business rule and security token
INSERT INTO tblUserFunction 
VALUES('ConflictOfInterestOverride', 'Appointments - Conflict of Interest Override', GetDate())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (163, 'ApptConflictOfInterest', 'Case', 'Scheduling a case check for a conflict of interest', 1, 1101, 1, 'IncludeServiceTypeID', 'SubFormToDisplay', NULL, NULL, 'Override Sec Token', 0, NULL)
GO
-- ONLY FOR INECentricEW Database
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL)
GO
