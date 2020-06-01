
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

