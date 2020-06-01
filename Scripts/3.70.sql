
PRINT N'Update complete.';


GO
-- Issue 11595 Data Patch for Making Portal Fields Reqd/Optional by Web Users
  UPDATE tblCompany Set AllowMedIndex = 0, AllowScheduling = 0, ShowFinancialInfo = 1
  UPDATE tblWebUser Set AllowMedIndex = 0
  UPDATE tblEWParentCompany Set AllowMedIndex = 0, AllowScheduling = 0, ShowFinancialInfo = 1




UPDATE U SET U.OCRPriority=P.RowNbr
FROM tblDPSPriority AS U
INNER JOIN
(SELECT ROW_NUMBER() OVER (ORDER BY DueDateHours) AS RowNbr, DPSPriorityID, Name FROM tblDPSPriority) AS P ON P.DPSPriorityID = U.DPSPriorityID
GO


-- Issue 11566 - patch data for OCR priority
UPDATE tblOCRDocument SET Priority = NULL WHERE  Priority = 0 AND OCRStatusID IN (10, 20, 30, 35)
GO

-- Issue 11606 - ESIS to require Employer field
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(130, 'CaseRequiredFields', 'Case', 'Define required fields on case form', 1, 1016, 0, 'FieldName1', 'FieldName2', 'FieldName3', 'FieldName4', 'FieldName5', 0)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 1, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 1, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 2, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 2, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 8, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 8, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 1, 10, NULL, 'cboEmployer', NULL, NULL, NULL, NULL),
      ('PC', 2, 2, 1, 130, GetDate(), 'Admin', NULL, NULL, NULL, 5, 10, NULL, 'cboEmployer', NULL, NULL, NULL, NULL)

GO

