-- Issue 11211 - add new Security Token to allow use of unallowed Employer
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('ClaimEmployerOverride', 'Case - Claim Nbr Employer Override', '2019-08-12'), 
	-- Issue 11206 - add new security token to allow user to modify claim number after it has been matched/validated.
	('AllowClaimNbrChange', 'Case - Allow Change for Matched Claim Nbr', '2019-08-20')
GO

-- Issue 11211 - add new business rule to enforce specific Employer when a specified Claim Nbr format is used
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(104, 'MatchClaimNbrToEmployer', 'Case', 'Ensure that selected Employer is Valid for Claim Nbr', 1, 1016, 0, 'ClaimNbrStartsWith', 'ClaimNbrEndsWith', 'AllowedEmployerID', NULL, 'OverrideToken', 0)
GO

--Add a setting to tblSetting - a value to turn on the portal web version rule – UseWebPortalVersionRules
INSERT INTO tblSetting (Name, Value) VALUES ('UseWebPortalVersionRules', 'True')

-- Issue 11243 data patch
  UPDATE tblDPSBundle SET DPSBundleTypeID = 1
  UPDATE tblDPSBundle SET CombinedDPSBundleID = DPSBundleID

-- Issue 11208 - New evemt for Send Email for case
INSERT INTO tblEvent(EventID, Descrip, Category)
VALUES(1050, 'Send Email (Case)', 'Case')
GO
-- Issue 11208 - add new business rules to allow for an override of the client email address
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(105, 'CaseSendEmailClientEmail', 'Case', 'Use alternate email address when emailing client', 1, 1050, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0),
      (106, 'DistRptClientEmail', 'Case', 'Use alternate email address for client correspondence', 1, 1320, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0),
	  (107, 'GenDocClientEmail', 'Case', 'Use alternate email address for client correspondence', 1, 1201, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0)
GO
