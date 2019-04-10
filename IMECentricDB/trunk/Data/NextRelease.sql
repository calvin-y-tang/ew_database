
-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES('SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

-- Issue 10048 - no longer using field ExceptionAlert.  Replacing with AlertType.  Set the values
-- For all Case History with Follow up date is not null AND the Office of the case is set to use 
--    ShowFollowUpOnCaseOpen (= true), KEEP the follow up date and set the AlertType=1
  UPDATE tblCaseHistory SET AlertType = 1
  FROM tblCaseHistory AS H
  INNER JOIN tblCase AS C ON H.CaseNbr = C.CaseNbr
  INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
  WHERE FollowUpDate IS NOT NULL AND O.ShowFollowUpOnCaseOpen = 1

-- For all Case History created by ERP (UserID = ERP) and the FollowUpDate is not null, Clear the follow up date and set AlertType=1
  UPDATE tblCaseHistory SET AlertType = 1, FollowUpDate = NULL WHERE UserID = 'ERP' AND FollowUpDate IS NOT NULL



