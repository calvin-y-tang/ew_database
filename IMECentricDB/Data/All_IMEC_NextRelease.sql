-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 131

-- IMEC-14081 - data patch for Nationwide cases that sets a date for emails sent for cases that apply so they will not be sent again
UPDATE tblCase SET DateEmailSentForLateReport = '2024-03-01 00:00:00.000' 
WHERE CaseNbr IN
(
select C.CaseNbr
from tblCase AS C
left join tblclient as CL on C.ClientCode = CL.ClientCode
left join tblclient AS CLB on C.BillClientCode = CLB.ClientCode
left join tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
left join tblCompany AS COB on CLB.CompanyCode = COB.CompanyCode
left join tblServices AS S on c.ServiceCode = s.ServiceCode
left join tblEWServiceType AS ST on S.EWServiceTypeID = ST.EWServiceTypeID
where C.casetype = 10 and C.status not in (8,9) and (CO.ParentCompanyID = 34 or COB.ParentCompanyID = 34)  and c.RptSentDate is null
and (C.ApptDate <= '2024-02-29 00:00:00.000' OR C.DateMedsRecd <= '2024-02-29 00:00:00.000')
)

GO

-- IMEC-12294 - data patch for tblExaminee gender
UPDATE tblExaminee SET Sex = 'Male' WHERE Sex = 'M'
UPDATE tblExaminee SET Sex = 'Female' WHERE Sex = 'F'

GO

-- IMEC-14076 - Business Rules to drive new "WCCaseTypeAddressee" bookmark
UPDATE tblBusinessRule
  SET EventID = 1201
WHERE Name = 'DynamicBookmarks'
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (134, 'CAWCCaseType', 'Case', 'Generate Table for WCCaseTypeAddressee bookmark', 1, 1201, 0, 'WCCaseTypeValue', 'PAttyCompStartWith', 'EntitiesCompNoMatch', 'EntitiesCompMatch', 'EntitiesNoComp', 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'AME', 'DEU-;DEU -', 'Client;Plaintiff;Defense;ThirdParty', 'Client;Plaintiff;Examinee;Defense;ThirdParty', NULL, 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'AME-S', 'DEU-;DEU -', 'Client;Plaintiff;Defense;ThirdParty', 'Client;Plaintiff;Examinee;Defense;ThirdParty', NULL, 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'AME-R', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'A-QME', NULL, NULL, NULL, 'Client;Plaintiff', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'DCD', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'D-QME', NULL, NULL, NULL,'Client;Defense', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'IME-ADR', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'IME-LSH', NULL, NULL, NULL, 'Client;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'IME-SIBTF', NULL, NULL, NULL, 'Client;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'IME-SIBTF-S', NULL, NULL, NULL, 'Client;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'P/U-QMEE', 'DEU-;DEU -', 'Client;Examinee;Defense', 'Client;Examinee;Plaintiff;Defense', NULL, 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'P/U-QME-R', 'DEU-;DEU -', 'Client;Examinee;Defense', 'Client;Examinee;Plaintiff;Defense', NULL, 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'P/U-QME-S', 'DEU-;DEU -', 'Client;Examinee;Defense', 'Client;Examinee;Plaintiff;Defense', NULL, 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'R-PQME', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'R-PQME-R', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL),
       (134, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, 'CA', 'R-PQME-S', NULL, NULL, NULL, 'Client;Plaintiff;Defense;ThirdParty', 0, NULL)
GO

-- IMEC-14088 - security token and business rule to be used for DoctorSignature bookmark
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('DrGenerateSigBookmark','Doctor - Generate Signature Bookmarks',GETDATE())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (135, 'GenDocBookmark', 'Case', 'Generate Doc Bookmark validate (Signature)', 1, 1201, 0, 'BookmarkName', 'SecurityToken', 'RequireOfficeMatch', 'SecTokenDesc', 'RqDrDocTypeFileExist', 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (135, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'DoctorSignature', 'DrGenerateSigBookmark', 'True', 'Doctor - Generate Signature Bookmarks', '8;Electronic Signature', 0, NULL)
GO
