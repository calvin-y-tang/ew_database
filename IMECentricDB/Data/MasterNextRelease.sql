-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 132

-- IMEC-14127 - adding BCC recipients for the Naitionwide emails for late reports
UPDATE ISExtIntegration SET Param = 'DBID=23;PCID=34;DaysLate=10;CaseType=10;TaskName=NationwideEmailLateReport;EmailToBCC="doug.leveille@examworks.com;kathleen.brock@examworks.com";Subject="Claim number:  %ClaimNbr%, Examworks report delay notification";Body="Claim number:  %ClaimNbr% <br /> Examinee:  %ExamineeName% <br /> <br /> Please be advised that the report is delayed. We have been in touch with the provider and they are working to complete. As soon as the report is available, we will forward it to you. Thanks for your patience in this matter. <br /> <br /> Examworks"'
 WHERE ExtIntegrationID = 6100
GO

