-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMCentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 131

-- IMEC-14081 - adding new task to ISExtIntegration and ISSchedule - task to auto send emails for late reports
INSERT INTO ISExtIntegration (ExtIntegrationID, Name, Type, Active, NotifyEmail, Param)
VALUES (6100, 'Nationwide Late Reports', 'AutomatedEmailLateDocs', 1, 'William.Cecil@examworks.com', 
'DBID=23;PCID=34;DaysLate=10;CaseType=10;TaskName=NationwideEmailLateReport;Subject="Claim number:  %ClaimNbr%, Examworks report delay notification";Body="Claim number:  %ClaimNbr% <br /> Examinee:  %ExamineeName% <br /> <br /> Please be advised that the report is delayed. We have been in touch with the provider and they are working to complete. As soon as the report is available, we will forward it to you. Thanks for your patience in this matter. <br /> <br /> Examworks"')

GO

INSERT INTO ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate)
VALUES ('Nationwide Late Reports', 'AutomatedEmailLateDocs', 'm', 60, '0111110', '1900-01-01 06:00:00', GetDate())

GO

