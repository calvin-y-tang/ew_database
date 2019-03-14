-- Issue 8336 - Add Requested Doctor to Misc Select Form  (TL)
----  Created new form frmStatusReqDr which can replace frmStatusMiscSelect.
----  Form needs to be added to the list of queue forms
INSERT INTO [dbo].[tblQueueForms] VALUES ('frmStatusReqDr', ' Form with Requested Doctor')

-- Issue 7857 - populate some new config tables for Quote feature
INSERT INTO tblQuoteHandling(Description, DateAdded, UserIDAdded)
VALUES('Fee Quote', GetDate(), 'Admin'),
      ('Fee Approval', GetDate(), 'Admin')
GO
INSERT INTO tblQuoteFeeConfig(FeeValueName, QuoteType, DisplayOrder, DateAdded, UserIDAdded)
VALUES('Diagnostic Study', NULL, 10, GetDate(), 'Admin'), 
      ('Record Review', NULL, 20, GetDate(), 'Admin'), 
	  ('Report Prep', NULL, 30, GetDate(), 'Admin'), 
	  ('Travel', NULL, 40, GetDate(), 'Admin'), 
	  ('Consultation', NULL, 50, GetDate(), 'Admin'), 
	  ('Exam Room Rental', NULL, 60, GetDate(), 'Admin'), 
	  ('Indexing Chart Prep', NULL, 70, GetDate(), 'Admin')
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

-- set the BulkBillingID in the Account Header table for all invoices. 
-- when a 3rd-party biller is on the case, we use that client/company
-- over client/company assigned to the case
UPDATE AH SET AH.BulkBillingID = CO.BulkBillingID
  FROM tblAcctHeader as AH
	INNER JOIN tblCase as C on AH.CaseNbr = C.CaseNbr
	INNER JOIN tblClient as CL on ISNULL(C.BillClientCode, C.ClientCode) = CL.ClientCode
	INNER JOIN tblCompany as CO on CL.CompanyCode = CO.CompanyCode
WHERE AH.DocumentType = 'IN'

-- Issue 8067 - new entry in tblSetting to control feature rollout
-- default is to deploy with feature turned off
INSERT INTO tblSetting (Name, Value)
VALUES('AllowDistDocToEnvelope', '')
GO	
