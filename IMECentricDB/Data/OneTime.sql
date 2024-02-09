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


-- IMEC-14033 - Track Liberty iCase referrals and resubmit files in Exception folder to Inbox folder
-- created a new task to run to do this

USE IMECentricMaster 
GO
INSERT INTO ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate, Param, GroupNo, SeqNo)
VALUES ('ExcptnDocReprocess - Liberty', 'ExcptnDocReprocessing', 'H', 2, '1111111', '1900-01-01 01:00:00', '2024-02-01 00:00:00', 
'InboxFolderID=341;MaxRetries=3;RetryMinutes=120;SearchPattern="*LibertyiCase*.PDF"',
570, 1)
GO


USE IMECentricMaster 
GO
CREATE TABLE [dbo].[ISExcptnDocReprocessingLog](
	[ReprocessingLogID] INT             IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
	[MaxTimesRetry]     INT             NULL,
	[AttemptNumber]     INT             NULL,
	[AttemptTime]       SMALLDATETIME   NULL,
	[FileName]          VARCHAR (200)   NULL,
	[ExceptionFolder]   VARCHAR (300)   NULL,
	[InboxFolder]       VARCHAR (300)   NULL,
	[InboxFolderID]     INT             NULL,
    CONSTRAINT [PK_ISExcptnDocReprocessingLog] PRIMARY KEY CLUSTERED ([ReprocessingLogID] ASC) WITH (FILLFACTOR = 90)
);

GO

CREATE INDEX [IX_ISExcptnDocReprocessingLog_FileName_InboxFolderID] ON [dbo].[ISExcptnDocReprocessingLog] ([FileName], [InboxFolderID])

GO

