-- Sprint 114

-- IMEC-13638 - Add new items to tblOutOfNetworkReason
USE IMECentricEW 
GO
SET IDENTITY_INSERT tblOutOfNetworkReason ON
GO
INSERT INTO tblOutOfNetworkReason (OutOfNetworkReasonID, Description, DateAdded, UserIDAdded, Status)
VALUES (20, 'Allstate requested out of network physician', GetDate(), 'Admin', 'Active'), 
       (21, 'No contracted doctor in Claimant''s area', GetDate(), 'Admin', 'Active'),
       (22, 'No show fee is out of contract', GetDate(), 'Admin', 'Active'),
       (23, 'Non Contracted Specialty', GetDate(), 'Admin', 'Active'),
       (24, 'Re-exam doctor no longer in contracted rate', GetDate(), 'Admin', 'Active'),
       (25, 'Referral price falls under prior contract', GetDate(), 'Admin', 'Active')
GO
SET IDENTITY_INSERT tblOutOfNetworkReason OFF

-- IMEC-13638 - Updated existing and add new conditions for the Out Of Network Reason list configuration
GO
DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID IN (148, 149)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES (148, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,3,12,13,14,15,16,17,18,19', NULL, NULL, NULL, NULL, 0, NULL, NULL),
       (148, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '20,21,22,23,24,25', NULL, NULL, NULL, NULL, 0, NULL, NULL),
       (148, 'SW', NULL, 2, 10, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5,6,7,10,11', NULL, NULL, NULL, NULL, 0, NULL, NULL),
       (149, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,3,12,13,14,15,16,17,18,19', NULL, NULL, NULL, NULL, 0, NULL, NULL),
       (149, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '20,21,22,23,24,25', NULL, NULL, NULL, NULL, 0, NULL, NULL),
       (149, 'SW', NULL, 2, 10, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5,6,7,10,11', NULL, NULL, NULL, NULL, 0, NULL, NULL)
GO
