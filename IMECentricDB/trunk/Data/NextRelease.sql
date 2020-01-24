delete from tblBusinessRule WHERE BusinessRuleID in (109,110,111)
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(109, 'ClientGenDocsToAddtlEmail', 'Case', 'When sending docs to client cc/bcc additional email addresses', 1, 1201, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
      (110, 'ClientDistDocsToAddtlEmail', 'Case', 'When distribute docs to client cc/bcc additional email addresses', 1, 1202, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
	  (111, 'ClientDistRptToAddtlEmail', 'Case', 'When distribute rpts to client cc/bcc additional email addresses', 1, 1320, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0)
GO


INSERT INTO tblUserFunction VALUES ('AckNewPortalAcct', 'Acknowledge - New Portal Accts Auto Provision', '2019-12-12')
GO

insert into tblMessageToken (Name, Description)
values ('@ExamineeLastName@',''), ('@ExamineeFirstName@',''), ('@ExamineeMiddleInitial@','')
GO


-- Issue 11184 (Enhance EDI queue functionality to allow users to remove sent invoices) - adding security token
INSERT INTO tblUserFunction VALUES ('EDIManualAck', 'EDI - Manually Acknowledge Sent Invoices', '2020-01-14')

