-- Sprint 125


-- IMEC-13883 - Allow multiple transcriptionist - setting to set subform visibility
INSERT INTO tblSetting (Name, Value)
VALUES ('ShowTranscriptionists', 'False')
GO

-- IMEC-13883 - Data patch to copy trans companies to transcriptionist
SET IDENTITY_INSERT tblTranscriptionist ON
INSERT INTO tblTranscriptionist (TranscriptionistID, FirstName, LastName, Email, Status, DateAdded, UserIDAdded, TransCode, WebUserID)
SELECT TransCode, '.', TransCompany, email, Status, GETDATE(), 'Admin', TransCode,  T.WebUserID 
FROM tblTranscription AS T 
LEFT JOIN tblWebUser AS W ON T.WebUserID = W.WebUserID
SET IDENTITY_INSERT tblTranscriptionist OFF
GO

