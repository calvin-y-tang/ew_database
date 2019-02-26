-- Issue 8200 - New Business Rules for Require Coversheet 
DECLARE @iBusRuleID INTEGER
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistDocReqCoverSheet', 'Case', 'Coversheet Required when distributing document', 1, 1202, 0, 0)
SELECT @iBusRuleID = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('CO', 76626, 2, 1, @iBusRuleID, GetDate(), 'Admin', GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistRepReqCoverSheet', 'Report', 'Coversheet Required when distributing report', 1, 1320, 0, 0)
SELECT @iBusRuleID = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('CO', 76626, 2, 1, @iBusRuleID, GetDate(), 'Admin', GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

-- Issue 7995 - add new entries to tblCodes to source the PreAuth & WorkCompCaseType combo boxes on case form
INSERT INTO tblCodes(Category, SubCategory, Value)
VALUES ('PreAuthorization', 'CA', '1st Attempt'), 
	   ('PreAuthorization', 'CA', '2nd Attempt'),
	   ('PreAuthorization', 'CA', '3rd Attempt'),
	   ('PreAuthorization', 'CA', 'No Response'),
	   ('PreAuthorization', 'CA', 'Authorized'),
	   ('PreAuthorization', 'CA', 'Denied'),
	   ('PreAuthorization', 'CA', 'Acknowledged')
GO
INSERT INTO tblCodes(Category, SubCategory, Value)
VALUES ('WorkCompCaseType', 'CA', 'D-QME'), 
       ('WorkCompCaseType', 'CA', 'A-QME'), 
	   ('WorkCompCaseType', 'CA', 'PU-QME'), 
	   ('WorkCompCaseType', 'CA', 'RP-QME'), 
	   ('WorkCompCaseType', 'CA', 'ADR')
GO

-- Issue 7109 - copies CaseType and ServiceCode values to child tables
  INSERT INTO [dbo].tblExceptionDefCaseType (ExceptionDefID, CaseTypeCode)
	SELECT ExceptionDefID, CaseTypeCode FROM [dbo].tblExceptionDefinition
	WHERE CaseTypeCode <> -1

  INSERT INTO [dbo].tblExceptionDefService (ExceptionDefID, ServiceCode)
	SELECT ExceptionDefID, ServiceCode FROM [dbo].tblExceptionDefinition
	WHERE ServiceCode <> -1


