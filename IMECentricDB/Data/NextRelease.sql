-- IMEC-12561 - add new status for Confirmation Calls
INSERT INTO tblConfirmationStatus(ConfirmationStatusID, Name)
VALUES(113, 'Skipped Do Not Call')
GO


-- IMEC-12559 - need to add the "OptOut" option to Confirmation Results
INSERT INTO tblConfirmationResult (ResultCode, Description, IsSuccessful, HandleMethod, ConfirmationSystemID)
VALUES('OptOut', 'Add phone to Do Not Call List', 0, 3, 1)
GO

-- IMEC-12570 - new security tokens for Confirmation Do Not Call form.
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('ConfirmationDoNotCallAdd', 'Confirmtion - Do Not Call Add/Edit', GETDATE()), 
      ('ConfirmationDoNotCallDel', 'Confirmtion - Do Not Call Delete', GETDATE())
GO


-- IMEC-12587 - code clean-up removing this setting since it is no longer being used
  DELETE FROM tblSetting WHERE NAME = 'UseOldAttachExternalCaseDoc'

