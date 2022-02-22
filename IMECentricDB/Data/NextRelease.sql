
-- IMEC-12589 - rework business rules for Conflict of Interest
DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = 163
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 1, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 2, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 3, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 4, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 5, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, 10, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),

       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 1, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 2, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 3, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 4, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 5, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, 10, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),

       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 1, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 2, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 3, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 4, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 5, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, 10, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL)
GO
