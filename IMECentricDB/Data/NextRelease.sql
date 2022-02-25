-- IMEC-12561 - add new status for Confirmation Calls
INSERT INTO tblConfirmationStatus(ConfirmationStatusID, Name)
VALUES(113, 'Skipped Do Not Call')
GO


-- IMEC-12559 - need to add the "OptOut" option to Confirmation Results
INSERT INTO tblConfirmationResult (ResultCode, Description, IsSuccessful, HandleMethod, ConfirmationSystemID)
VALUES('OptOut', 'Add phone to Do Not Call List', 0, 3, 1)
GO


