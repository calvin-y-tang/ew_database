
-- Sprint 83

-- IMEC-12703 security tokens and business rules for Hartford Qualified Doctor. 
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('ScheduleNonQualifiedDoctor','Appointments - Non-Qualified Doctor Override', GetDate()),
       ('SchedUnknownQualifiedDoctor','Appointments - Unknown Qual Doctor Override', GetDate())      
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (142, 'ScheduleQualifiedDoctor', 'Case', 'Schedule Qualified Doctor', 1, 1101, 1, 'CustomerName', 'SubFormToDisplay', NULL, NULL, 'Override Sec Token', 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 13, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 14, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 15, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 16, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 38, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 40, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 1, NULL),
       (142, 'PC', 30, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, 'ScheduleNonQualifiedDoctor', 0, NULL)
GO

