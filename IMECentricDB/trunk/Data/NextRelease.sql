
-- Issue 11211 - add new Security Token to allow use of unallowed Employer
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('ClaimEmployerOverride', 'Case - Claim Nbr Employer Override', '2019-08-12')
GO
-- Issue 11211 - add new business rule to enforce specific Employer when a specified Claim Nbr format is used
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(104, 'MatchClaimNbrToEmployer', 'Case', 'Ensure that selected Employer is Valid for Claim Nbr', 1, 1016, 0, 'ClaimNbrStartsWith', 'ClaimNbrEndsWith', 'AllowedEmployerID', NULL, 'OverrideToken', 0)
GO
-- DEV NOTE: this business rule condition will need to adjusted for the target deployment DB
--INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('CO', 6741, 2, 1, 104, '2019-08-12', 'Admin', '2019-08-12', 'Admin', NULL, NULL, NULL, NULL, '000808', NULL, '525', NULL, 'ClaimEmployerOverride')
--GO
