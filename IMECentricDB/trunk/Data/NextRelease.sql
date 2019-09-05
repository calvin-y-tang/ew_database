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
-- DEV NOTE: this business rule condition will need to adjusted for the target deployment DB
--INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('CO', 6741, 2, 1, 104, '2019-08-12', 'Admin', '2019-08-12', 'Admin', NULL, NULL, NULL, NULL, '000808', NULL, '525', NULL, 'ClaimEmployerOverride')
--GO

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
-- DEV NOTE: these business rule conditions will need to adjusted for the target deployment DB. Need to set the EntityCode to the
--		desired CompanyCode Value in the target DB
--INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('CO', 0, 2, 2, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),
--	  ('CO', 0, 2, 2, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),
--	  ('CO', 0, 2, 2, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),

--    ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 32, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 32, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
	   
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL)
--GO 

