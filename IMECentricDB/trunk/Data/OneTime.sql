
-- Issue 12422 - added new integration for Liberty referrals with a required NY MCMC office

INSERT INTO IMECentricMaster.dbo.ISExtIntegration
 (ExtIntegrationID, Name, Type, Active, SrcPath, DestPath, Param)
VALUES (3020,'LibertyXML NY-MCMC', 'LibertyXML', 1, '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\XMLInput_MCMC',
 '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\New\',
 'DBID=23;UnknownClientCode=791347;ParentCompanyID=31;DefaultOfficeCode=28;Tags=UseMCMCOffice')

 GO

INSERT INTO ISSchedule
 (Name, Task, Type, Interval, Weekdays, Time, StartDate, Param)
VALUES ('LibertyXML NY-MCMC', 'LibertyXML', 'm', 2, '1111111', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 
 'DBID=23;UnknownClientCode=791347;ParentCompanyID=31;DefaultOfficeCode=28;Tags=UseMCMCOffice')

 GO

