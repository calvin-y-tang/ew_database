-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 142

-- IMEC-14445 - Changes to Implement Liberty QA Questions Feature for Finalize Report
USE IMECentricEW
GO 
-- Populate Question tables
     SET IDENTITY_INSERT tblQuestion ON 
     GO
          INSERT INTO tblQuestion(QuestionID, QuestionText, DateAdded, UserIDAdded)
               VALUES (1, 'The date of injury is documented in the report and claim number is listed.', GETDATE(), 'System'),
                      (2, 'Doctor-patient relationship statement is contained in report or file contains a signed attestation. (attestation available in IMEC)', GETDATE(), 'System'),
                      (3, 'Report is void of spelling and grammatical errors.', GETDATE(), 'System'),
                      (4, 'Key issues/referral questions are addressed. All questions in the cover letter from Liberty are acknowledged and answered in the report.', GETDATE(), 'System'),
                      (5, 'IME provider has listed the records reviewed including treating provider/facility name by date of service or date of service range.', GETDATE(), 'System'),
                      (6, 'Report contains a comprehensive summary of past medical history and/or comorbidities.', GETDATE(), 'System'),
                      (7, 'IME provider documented and supported their impression. All abilities and restrictions have timeframes associated.', GETDATE(), 'System'),
                      (8, 'Claimant proof of identification is included in file or signed attestation present in case. (attestation available in IMEC)', GETDATE(), 'System'),
                      (9, 'The date of injury is documented in the report.', GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestion OFF
     GO
     --
     SET IDENTITY_INSERT tblQuestionSet ON 
     GO
          INSERT INTO tblQuestionSet(QuestionSetID, ProcessOrder, ParentCompanyID, CompanyCode, CaseType, Jurisdiction, EWServiceTYpeID, ServiceCode, OfficeCode, Active, DateAdded, UserIDAdded)
               VALUES(1, 1, 31, NULL, NULL, NULL, 2, NULL, NULL, 1, GETDATE(), 'System'),
                     (2, 2, 31, NULL, NULL, NULL, 1, NULL, NULL, 1, GETDATE(), 'System'),
                     (3, 3, 31, NULL, NULL, NULL, 3, NULL, NULL, 1, GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestionSet OFF
     GO
     --
     SET IDENTITY_INSERT tblQuestionSetDetail ON 
     GO
          INSERT INTO tblQuestionSetDetail(QuestionSetDetailID, QuestionSetID, DisplayOrder, QuestionID, DateAdded, UserIDAdded)
               VALUES(1, 1, 1, 1, GETDATE(), 'System'),
                     (2, 1, 2, 2, GETDATE(), 'System'),
                     (3, 1, 3, 3, GETDATE(), 'System'),
                     (4, 1, 4, 4, GETDATE(), 'System'),
                     (5, 1, 5, 5, GETDATE(), 'System'),
                     (6, 1, 6, 6, GETDATE(), 'System'),
                     (7, 1, 7, 7, GETDATE(), 'System'),
                     (8, 2, 1, 8, GETDATE(), 'System'),
                     (9, 2, 2, 9, GETDATE(), 'System'),
                     (10, 2, 3, 2, GETDATE(), 'System'),
                     (11, 2, 4, 3, GETDATE(), 'System'),
                     (12, 2, 5, 4, GETDATE(), 'System'),
                     (13, 2, 6, 5, GETDATE(), 'System'),
                     (14, 2, 7, 6, GETDATE(), 'System'),
                     (15, 2, 8, 7, GETDATE(), 'System'), 
                     (16, 3, 1, 1, GETDATE(), 'System'),
                     (17, 3, 2, 2, GETDATE(), 'System'),
                     (18, 3, 3, 3, GETDATE(), 'System'),
                     (19, 3, 4, 4, GETDATE(), 'System'),
                     (20, 3, 5, 5, GETDATE(), 'System'),
                     (21, 3, 6, 6, GETDATE(), 'System'),
                     (22, 3, 7, 7, GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestionSetDetail OFF
     GO


