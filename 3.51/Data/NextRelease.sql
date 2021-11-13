INSERT INTO [dbo].[tblQueueForms] VALUES ('frmStatusReqDr', ' Form with Requested Doctor')
GO

INSERT INTO tblQuoteHandling(Description, DateAdded, UserIDAdded)
VALUES('Fee Quote', GetDate(), 'Admin'),
      ('Fee Approval', GetDate(), 'Admin')
GO
INSERT INTO tblQuoteFeeConfig(FeeValueName, QuoteType, DisplayOrder, DateAdded, UserIDAdded)
VALUES('Diagnostic Study', NULL, 20, GetDate(), 'Admin'), 
      ('Record Review', NULL, 50, GetDate(), 'Admin'), 
	  ('Report Prep', NULL, 60, GetDate(), 'Admin'), 
	  ('Travel', NULL, 70, GetDate(), 'Admin'), 
	  ('Consultation', NULL, 10, GetDate(), 'Admin'), 
	  ('Exam Room Rental', NULL, 30, GetDate(), 'Admin'), 
	  ('Indexing Chart Prep', NULL, 40, GetDate(), 'Admin')
GO

-- tblQuoteStatus (Data Patch)
UPDATE tblQuoteStatus 
   SET QuoteHandlingID = 1 
 WHERE QuoteStatusID IN (1, 2, 3, 6)
 GO
UPDATE tblQuoteStatus 
   SET QuoteHandlingID = 1 
 WHERE QuoteStatusID IN (4, 5)
GO



-- New Tokens for IN/VO Quotes
INSERT INTO tblMessageToken (Name)
VALUES('@ClientAddr1@'), 
      ('@ClientAddr2@'),
	  ('@ClientAddr3@'), 
	  ('@ClientCity@'),
	  ('@ClientState@'),
	  ('@ClientZip@'),
	  ('@QuoteFeeRange@'),
	  ('@QuoteDiagnosticStudyFee@'),
	  ('@QuoteRecordReviewFee@'),
	  ('@QuoteReportPrepFee@'),
	  ('@QuoteTravelFee@'),
	  ('@QuoteConsultationFee@'),
	  ('@QuoteExamRoomRentalFee@'),
	  ('@QuoteIndexingChartPrepFee@'),
	  ('@QuoteAdditionalFees@'),
	  ('@QuoteDiagnosticStudyUnit@'),
	  ('@QuoteRecordReviewUnit@'),
	  ('@QuoteReportPrepUnit@'),
	  ('@QuoteTravelUnit@'),
	  ('@QuoteConsultationUnit@'),
	  ('@QuoteExamRoomRentalUnit@'),
	  ('@QuoteIndexingChartPrepUnit@')
GO

INSERT INTO tblMessageToken (Name)
VALUES('@EmailLinkExpDate@')
GO




DELETE FROM tblCodes WHERE Category='WorkCompCaseType' AND SubCategory='CA'
GO
INSERT INTO tblCodes(Category, SubCategory, Value) VALUES 
('WorkCompCaseType', 'CA', 'AME'), 
('WorkCompCaseType', 'CA', 'AME-R'), 
('WorkCompCaseType', 'CA', 'AME-S'), 
('WorkCompCaseType', 'CA', 'A-QME'), 
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
('WorkCompCaseType', 'CA', 'P/U-QME-R'), 
('WorkCompCaseType', 'CA', 'P/U-QME-S'), 
('WorkCompCaseType', 'CA', 'R-PQME'), 
('WorkCompCaseType', 'CA', 'R-PQME-R'), 
('WorkCompCaseType', 'CA', 'R-PQME-S'),
('WorkCompCaseType', 'CA', 'RR'), 
('WorkCompCaseType', 'CA', 'RR-S')
GO


-- Issue 8067 - new entry in tblSetting to control feature rollout
-- default is to deploy with feature turned off
INSERT INTO tblSetting (Name, Value)
VALUES('AllowDistDocToEnvelope', '')
GO	



INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES('DistDocDefaultOtherEmail', 'Case', 'Set Default Email for Other Party when distributing document', 1, 1202, 0, 'OtherEmail', 0)

INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES('DistRptDefaultOtherEmail', 'Report', 'Set Default Email for Other Party when distributing report', 1, 1320, 0, 'OtherEmail', 0)
	
GO

UPDATE tblDoctor SET DICOMHandlingPreference=2 WHERE ViewDICOMOnWebPortal=1
GO
