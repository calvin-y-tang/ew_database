-- Sprint 99

-- IMEC-13248 - Add new items for Travelers to Out of Network Reason and 
-- business rules to set selection list based on parent company. 
-- ********** Changes need to be applied to only IMECentricEW and IMECentricFCE **********
USE IMECentricEW 
GO
    -- add new items to tblOutOfNetworkReason
    SET IDENTITY_INSERT dbo.tblOutOfNetworkReason ON
    GO 
    INSERT INTO tblOutOfNetworkReason (OutOfNetworkReasonID, Description, DateAdded, UserIDAdded, Status)
    VALUES(12, 'Rural Area', GETDATE(), 'Admin', 'Active'),
          (13, 'Date/Time Consideration', GETDATE(), 'Admin', 'Active'),
          (14, 'Conflict of Interest', GETDATE(), 'Admin', 'Active'),
          (15, 'No In-Network Option', GETDATE(), 'Admin', 'Active'),
          (16, 'Special Request', GETDATE(), 'Admin', 'Active'),
          (17, 'Expertise', GETDATE(), 'Admin', 'Active'), 
          (18, 'Mult. Body Parts', GETDATE(), 'Admin', 'Active'),
          (19, 'Mult. Diagnoses', GETDATE(), 'Admin', 'Active')
    GO 
    SET IDENTITY_INSERT dbo.tblOutOfNetworkReason OFF
    GO
    -- add new business rule to set Out of Network Reason list for Quotes
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (148, 'SetOutOfNetworkReasonChoicesQuote', 'Case', 'Set list of available choices for Out of Network Reason', 1, 1061, 0, 'AllowedSelections', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (148, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,3,12,13,14,15,16,17,18,19', NULL, NULL, NULL, NULL, 0, NULL), 
           (148, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5,6,7,10,11', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    -- add new business rule to set Out of Network Reason list for invoice
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (149, 'SetOutOfNetworkReasonChoicesInv', 'Accounting', 'Set list of available choices for Out of Network Reason', 1, 1811, 0, 'AllowedSelections', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (149, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,3,12,13,14,15,16,17,18,19', NULL, NULL, NULL, NULL, 0, NULL), 
           (149, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5,6,7,10,11', NULL, NULL, NULL, NULL, 0, NULL)
    GO

USE IMECentricFCE
GO
    -- add new items to tblOutOfNetworkReason
    SET IDENTITY_INSERT dbo.tblOutOfNetworkReason ON
    GO 
    INSERT INTO tblOutOfNetworkReason (OutOfNetworkReasonID, Description, DateAdded, UserIDAdded, Status)
    VALUES(12, 'Rural Area', GETDATE(), 'Admin', 'Active'),
          (13, 'Date/Time Consideration', GETDATE(), 'Admin', 'Active'),
          (14, 'Conflict of Interest', GETDATE(), 'Admin', 'Active'),
          (15, 'No In-Network Option', GETDATE(), 'Admin', 'Active'),
          (16, 'Special Request', GETDATE(), 'Admin', 'Active'),
          (17, 'Expertise', GETDATE(), 'Admin', 'Active'), 
          (18, 'Mult. Body Parts', GETDATE(), 'Admin', 'Active'),
          (19, 'Mult. Diagnoses', GETDATE(), 'Admin', 'Active'),
          (20, 'Client Selected Physician', GETDATE(), 'Admin', 'Active'),
          (21, 'Non-Contracted Specialty', GETDATE(), 'Admin', 'Active')
      
    GO 
    SET IDENTITY_INSERT dbo.tblOutOfNetworkReason OFF
    GO
    -- add new business rule to set Out of Network Reason list for Quotes
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (148, 'SetOutOfNetworkReasonChoicesQuote', 'Case', 'Set list of available choices for Out of Network Reason', 1, 1061, 0, 'AllowedSelections', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (148, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '12,13,14,15,16,17,18,19,20,21', NULL, NULL, NULL, NULL, 0, NULL), 
           (148, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    -- add new business rule to set Out of Network Reason list for invoice
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (149, 'SetOutOfNetworkReasonChoicesInv', 'Accounting', 'Set list of available choices for Out of Network Reason', 1, 1811, 0, 'AllowedSelections', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (149, 'PC', 52, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '12,13,14,15,16,17,18,19,20,21', NULL, NULL, NULL, NULL, 0, NULL), 
           (149, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '1,2,3,4,5', NULL, NULL, NULL, NULL, 0, NULL)
    GO
