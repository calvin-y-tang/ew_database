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
