




-- Issue 11604 - new queue for Prepay Tracker
SET IDENTITY_INSERT tblQueues ON
GO

  INSERT INTO tblQueues (
       StatusCode, StatusDesc, Type, ShortDesc, DisplayOrder, FormToOpen, DateAdded, 
       Status, SubType, FunctionCode, WebStatusCode, NotifyScheduler, NotifyQARep,
       NotifyIMECompany, WebGUID, AllowToAwaitingScheduling, IsConfirmation, WebStatusCodeV2, AwaitingReptDictation,
       AwaitingReptApproval, DoNotAllowManualChange
 )
  SELECT
       35, 'Rapid Pay Requests for Doctors', Type, 'AutoPP', 250, 'frmStatusAutoPrepay', Getdate(), 
       Status, SubType, FunctionCode, WebStatusCode, NotifyScheduler, NotifyQARep,
       NotifyIMECompany, WebGUID, AllowToAwaitingScheduling, IsConfirmation, WebStatusCodeV2, AwaitingReptDictation,
       AwaitingReptApproval, DoNotAllowManualChange 
  FROM tblQueues WHERE StatusCode = 30

GO
SET IDENTITY_INSERT tblQueues OFF
GO


-- Issue 11604 - new form for new queue Prepay Tracker
  INSERT INTO tblQueueForms VALUES ('frmStatusAutoPrepay', 'Form for Auto Prepay')
  GO


-- Issue 11603 - Data Patch new tblDoctor.Prepayment column
-- if prepaid = true then prepayment = manual (2)
-- if prepaid = false then prepayment = none (1)
UPDATE tblDoctor 
   SET prepayment = IIF(prepaid = 1, 2, 1)
GO

