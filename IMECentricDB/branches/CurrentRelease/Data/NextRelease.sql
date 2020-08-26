UPDATE tblExceptionDefinition
   SET BillingEntity = 2 -- Billing client
 WHERE UseBillingEntity = 1
GO
-- set to service client where origi column = 0 and entity is CO, CL, PC
UPDATE tblExceptionDefinition
   SET BillingEntity = 1 -- service client
 WHERE UseBillingEntity = 0 and Entity in ('CO', 'CL', 'PC')
-- all other entries default to None or 0
GO

-- Issue 11737 - Allstats VAT Changes - add business rule to change company name on correspondence
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(113, 'AllstatePolicyCompanyName', 'Case', 'Use the Company Name from tblCustomerData based on Allstate referral PolicyCompanyCode', 1, 1201, 0, NULL, NULL, NULL, NULL, NULL, 0)
GO

-- Issue 11742 - create some new Exception Triggers
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, Type)
VALUES(32, 'Create Invoice Quote', 'Active', GetDate(), 'Admin', 'Case'),
      (33, 'Create Voucher Quote', 'Active', GetDate(), 'Admin', 'Case')
GO

-- Issue 11716 - Add DPS Sort models for offices - all sort models for all offices CaseType = 10
  INSERT INTO tblOfficeDPSSortModel (Officecode, SortModelID, UserIDAdded, DateAdded) 
  SELECT O.OfficeCode, D.SortModelID, 'Admin', GetDate()
  FROM tblDPSSortModel AS D
  LEFT JOIN tblOffice AS O On 1=1
GO