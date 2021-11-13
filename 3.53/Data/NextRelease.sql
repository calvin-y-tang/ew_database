
-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES('SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

-- Issue 10048 - no longer using field ExceptionAlert.  Replacing with AlertType.  Set the values
-- For all Case History with Follow up date is not null AND the Office of the case is set to use 
--    ShowFollowUpOnCaseOpen (= true), KEEP the follow up date and set the AlertType=1
UPDATE H
   SET AlertType = 1
  FROM tblCaseHistory AS H
			INNER JOIN tblCase AS C ON H.CaseNbr = C.CaseNbr
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
 WHERE FollowUpDate IS NOT NULL 
   AND O.ShowFollowUpOnCaseOpen = 1
GO
-- For all Case History created by ERP (UserID = ERP) and the FollowUpDate is not null, Clear the follow up date and set AlertType=1
UPDATE tblCaseHistory 
   SET AlertType = 1, 
       FollowUpDate = NULL 
 WHERE UserID = 'ERP' 
   AND FollowUpDate IS NOT NULL
GO

-- Issue 10006 - new event ID and Business Rule to provide Bulk Billing Format override
INSERT INTO tblEvent(EventID, Descrip, Category)
VALUES(1811, 'Finalize Invoice', 'Accounting')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(100, 'BulkBillingOverride', 'Accounting', 'Allow Bulk Billing Format Override based on case details', 1, 1811, 0, 'BulkBillingID', NULL, NULL, NULL, NULL, 0)
GO
-- Issue 10006 - patch tblAcctHeader.BulkBillingId column 
UPDATE ah 
   SET ah.BulkBillingID = co.bulkbillingid
  FROM tblAcctHeader ah
			INNER JOIN tblclient AS cl ON ah.clientcode = cl.ClientCode
			INNER JOIN tblCompany AS co ON cl.CompanyCode = co.CompanyCode
WHERE ah.DocumentType = 'IN'
GO 


--Issue 11044 (subtask of 11008) Zurich IMECentric and Bulk Billing Changes - data patch
 INSERT INTO tblCustomerData ([Version], TableType, TableKey, [Param], CustomerName)
  SELECT 
    1, 
	'tblCase', 
    C.CaseNbr, 
	CASE
	  WHEN CT.EWBusLineID = 3 AND S.EWServiceTypeID IN (2,3) THEN 'PayKind="37PCS";'
	  WHEN CT.EWBusLineID = 3 THEN 'PayKind="30IME";'
	  ELSE 'PayKind="37IME";'
	END AS [Param],
    'Zurich'
  FROM tblCase AS C
  INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
  INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
  INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
  LEFT JOIN tblClient AS CLB ON C.BillClientCode = CLB.ClientCode
  INNER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
  LEFT JOIN tblCompany AS CO2 ON CLB.CompanyCode = CO2.CompanyCode
  INNER JOIN tblEWParentCompany AS COP ON CO.ParentCompanyID = COP.ParentCompanyID
  LEFT JOIN tblEWParentCompany AS COP2 ON CO2.ParentCompanyID = COP2.ParentCompanyID
  WHERE 
    CO.ParentCompanyID = 60 
	OR CO2.ParentCompanyID = 60
    AND (C.Status NOT IN (8,9) 
	     OR (C.Status IN (8,9) 
		     AND ([DateCompleted] >= '2018-01-01' 
			      OR [DateCanceled] >= '2018-01-01')))
GO 

-- Issue 11046 - add new business rule to set visibility of amt fields for an invoice
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(101, 'ShowInvoiceAmtFields', 'Accounting', 'Set Invoice Amt Field visibility', 1, 1801, 0, 'ShowRetailAmt', 'ShowDiscountAmt', NULL, NULL, NULL, 0)
GO 

-- Issue 11046 - add new business rule to calculate retail amount value
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(102, 'CalcInvRetailAmt', 'Accounting', 'Caculate Retail Amount for Invoice Line Item', 1, 1801, 0, 'MarkupAmt', NULL, NULL, NULL, NULL, 0)
GO 



DELETE FROM tblCodes WHERE Category='WorkCompCaseType' AND SubCategory='CA'
GO
INSERT INTO tblCodes(Category, SubCategory, Value) VALUES 
('WorkCompCaseType', 'CA', 'AME'), 
('WorkCompCaseType', 'CA', 'AME-R'), 
('WorkCompCaseType', 'CA', 'AME-S'), 
('WorkCompCaseType', 'CA', 'A-QME'), 
('WorkCompCaseType', 'CA', 'CONSULT'), 
('WorkCompCaseType', 'CA', 'DCD'), 
('WorkCompCaseType', 'CA', 'D-QME'), 
('WorkCompCaseType', 'CA', 'FCE'), 
('WorkCompCaseType', 'CA', 'IME'), 
('WorkCompCaseType', 'CA', 'IME-S'), 
('WorkCompCaseType', 'CA', 'IME-ADR'), 
('WorkCompCaseType', 'CA', 'IME-LSH'), 
('WorkCompCaseType', 'CA', 'IME-SIBTF'), 
('WorkCompCaseType', 'CA', 'IME-SIBTF-S'), 
('WorkCompCaseType', 'CA', 'QME'), 
('WorkCompCaseType', 'CA', 'QME-R'), 
('WorkCompCaseType', 'CA', 'QME-S'), 
('WorkCompCaseType', 'CA', 'P/U-QME'), 
('WorkCompCaseType', 'CA', 'P/U-QME-R'), 
('WorkCompCaseType', 'CA', 'P/U-QME-S'), 
('WorkCompCaseType', 'CA', 'R-PQME'), 
('WorkCompCaseType', 'CA', 'R-PQME-R'), 
('WorkCompCaseType', 'CA', 'R-PQME-S'),
('WorkCompCaseType', 'CA', 'RR'), 
('WorkCompCaseType', 'CA', 'RR-S')
GO


-- Issue 11045 - business rules per comments on the issue.  ii will like Jose above, comment these out until ready
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(120, 'DetermineInvFormat', 'Accounting', 'Zurich Bulk Billing Invoice Format', 1, 1806, 0, 'Invoice Format Key', NULL, NULL, NULL, NULL, 0)
GO
