-- Sprint 129


-- IMEC-14020 - New business rules for some Chubb insurance companies. 
-- **** DO NOT RUN ON ANY TEST SYSTEM Databases ****
-- ********** Applies to only IMECentricEW. ********** 
USE IMECentricEW 

    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (109, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (109, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (109, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (109, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (109, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (109, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (109, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (109, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),

           (110, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (110, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (110, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (110, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (110, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (110, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (110, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (110, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),

           (111, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (111, 'CO', 1747, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (111, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (111, 'CO', 47813, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (111, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (111, 'CO', 65467, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL),
           (111, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Confirmation', NULL, 0, NULL),
           (111, 'CO', 70428, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'Atlanta_region_WC_Claims@Chubb.com', NULL, 'Appointment Delay', NULL, 0, NULL)

GO
