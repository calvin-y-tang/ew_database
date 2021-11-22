
-- Issue 12422 - added new integration for Liberty referrals with a required NY MCMC office

INSERT INTO IMECentricMaster.dbo.ISExtIntegration
 (ExtIntegrationID, Name, Type, Active, SrcPath, DestPath, Param)
VALUES (3020,'LibertyXML NY-MCMC', 'LibertyXML', 1, '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\XMLInput_MCMC',
 '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\New\',
 'DBID=23;UnknownClientCode=791347;ParentCompanyID=31;DefaultOfficeCode=28;Tags=UseMCMCOffice')

 GO

 -- Issue 12418 - Hartford resend quote approvals a 2nd time then approve - adding business rules to add resend date
 INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'CA', '16', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'TX', '16', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 2, 154, GetDate(), 'Admin', NULL, NULL,    NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, NULL, 0)

GO

