INSERT INTO tblUserFunction VALUES ('AckNewPortalAcct', 'Acknowledge - New Portal Accts Auto Provision', '2019-12-12')
GO

--// IMEC-11382 - adding record into the tblMessageToken for the examinee last name, first name, and middle inital
insert into tblMessageToken (Name, Description)
values ('@ExamineeLastName@',''), ('@ExamineeFirstName@',''), ('@ExamineeMiddleInitial@','')
GO

-- Issue 11433
-- Parent Company = Zurich = 60
-- BusinessLine = Workers Comp = 3
-- ServiceType = IME = 1
-- ServieType = Record Reviews = 3
--
-- attachment option parameter
--	0 = no attachment present
--	1 = attachment present
--	2 = for all email; not dependent on there being an attachment
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 60, 2, 1, 109, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '1', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL),
	 ('PC', 60, 2, 1, 109, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '3', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL),
	 ('PC', 60, 2, 1, 110, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '1', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL),
	 ('PC', 60, 2, 1, 110, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '3', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL),
	 ('PC', 60, 2, 1, 111, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '1', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL),
	 ('PC', 60, 2, 1, 111, '2020-01-20', 'Admin', '2020-01-20', 'Admin', NULL, '3', '3', NULL, '1', 'usz.zurich.claims.documents@zurichna.com', NULL, NULL, NULL)
GO

