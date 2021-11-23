
-- Issue 12422 - added new integration for Liberty referrals with a required NY MCMC office

INSERT INTO IMECentricMaster.dbo.ISExtIntegration
 (ExtIntegrationID, Name, Type, Active, SrcPath, DestPath, Param)
VALUES (3020,'LibertyXML NY-MCMC', 'LibertyXML', 1, '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\XMLInput_MCMC',
 '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\New\',
 'DBID=23;UnknownClientCode=791347;ParentCompanyID=31;DefaultOfficeCode=28;Tags=UseMCMCOffice')

 GO


