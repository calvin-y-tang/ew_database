-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 144

-- IMEC-14208 - data patch to turn on External communication tasks
USE [IMECentricMaster]
UPDATE ISExtIntegration SET Active = 1, LastBatchDate = GETDATE(), Param = 'EntityType="PC";EntityID="9";DBIDs="23";NumDaysTillOld="2";ExportFormat="NewCaseAck";IncludeWebCases="True";IncludeElecRecords="True";EmailBody="  Dear @AdjusterName@,    Thank you for submitting the referral for claim # @ClaimNumber@, claimant @ClaimantName@ to ExamWorks, LLC.  Your referral will now be processed by our team of professionals and you will be notified via email of its status in the near future.    If our team encounters any issues with this referral, you will be notified immediately.    We appreciate your business,  The staff at ExamWorks.  "' 
WHERE Name = 'AmTrust NewCase Notfy'

UPDATE ISExtIntegration SET Active = 1, LastBatchDate = GETDATE(), Param = 'EntityType="PC";EntityID="16";DBIDs="23";NumDaysTillOld="2";ExportFormat="NewCaseAck";IncludeWebCases="False";IncludeElecRecords="True";EmailBody="Dear @AdjusterName@,    Thank you for submitting the referral for claim # @ClaimNumber@, claimant @ClaimantName@ to ExamWorks, LLC.   Your referral will now be processed by our team of professionals and you will be notified via email of its   status in the near future. If our team encounters any issues with this referral, you will be notified immediately.     We appreciate your business,   The staff at ExamWorks. "'  
WHERE Name = 'Chubb New Case Notify'

GO
