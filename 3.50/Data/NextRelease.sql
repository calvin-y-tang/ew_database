INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistDocReqCoverSheet', 'Case', 'Coversheet Required when distributing document', 1, 1202, 0, 0)
GO
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistRepReqCoverSheet', 'Report', 'Coversheet Required when distributing report', 1, 1320, 0, 0)
GO

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


INSERT INTO [dbo].tblExceptionDefCaseType (ExceptionDefID, CaseTypeCode)
	SELECT ExceptionDefID, CaseTypeCode FROM [dbo].tblExceptionDefinition
	WHERE CaseTypeCode <> -1

INSERT INTO [dbo].tblExceptionDefService (ExceptionDefID, ServiceCode)
	SELECT ExceptionDefID, ServiceCode FROM [dbo].tblExceptionDefinition
	WHERE ServiceCode <> -1
GO

UPDATE tblExceptionDefinition SET AllCaseType=0 WHERE CaseTypeCode<>-1
UPDATE tblExceptionDefinition SET AllService=0 WHERE ServiceCode<>-1
GO

UPDATE tblExceptionDefinition SET CaseTypeCode=0 WHERE CaseTypeCode<>-1
UPDATE tblExceptionDefinition SET ServiceCode=0 WHERE ServiceCode<>-1
GO
