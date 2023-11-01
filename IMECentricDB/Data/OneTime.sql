-- Sprint 122

-- IMEC-13926 - configure new RunSQL process to Clear the RPA Processing Queue
USE IMECentricMaster 

DECLARE @schedID as INT
INSERT INTO IMECentricMaster.dbo.ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate, Param)
VALUES('Clear RPA Processing Queue', 'RunSQL', 'D', 1, '1111111', '1900-01-01 00:01:00', '2023-11-01 00:00:00', 'DBIDs="23;25";SQLFile="E:\EWIntegrationServer\SQLScripts\ClearRPAProcessingQueuesql.sql";EmailAlways=false')

SET @schedID = @@IDENTITY

INSERT INTO IMECentricMaster.dbo.ISQueue (ScheduleID, Name, Task, RunDateTime, Param)
Values(@schedID, 'RunSQL - Clear RPA Processing', 'RunSQL', '2023-11-01 00:01:00', 'DBIDs="23;25";SQLFile="E:\EWIntegrationServer\SQLScripts\ClearRPAProcessingQueuesql.sql";EmailAlways=false')
GO

-- IMEC-13937 - add new report type on Reports tab of case
USE IMECentricEW

INSERT INTO tblCaseDocType (ShortDesc, Description, TypeCategory, PublishOnWeb, FilterKey)
Values ('Draft Report', 'Draft Report', 'Report', 1, 'Report')

GO

