--Temp and Log data not needed in test databases
TRUNCATE TABLE tblAuditLog
TRUNCATE TABLE tblLogUsage
TRUNCATE TABLE tblUserActivity
TRUNCATE TABLE tblSession
TRUNCATE TABLE tblTempData
GO


/*
--Delete bad tblCase data
DELETE FROM tblCase WHERE ClientCode IS NULL
*/

/*
--Optional to remove orphan case child data
DELETE FROM tblCaseHistory WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseDocuments WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO
*/

--Optional to remove orphan case child data
DELETE FROM tblCaseAppt WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseApptPanel WHERE CaseApptID NOT in (SELECT CaseApptID FROM tblCaseAppt)
DELETE FROM tblCasePanel WHERE PanelNbr NOT in (SELECT PanelNbr FROM tblCase)
GO


UPDATE BTS SET BTS.DoctorBlockTimeSlotStatusID=10, BTS.CaseApptID=NULL
FROM tblDoctorBlockTimeSlot AS BTS
WHERE BTS.CaseApptID NOT IN (SELECT CaseApptID FROM tblCaseAppt)
AND BTS.CaseApptID IS NOT NULL
GO


DELETE FROM tblCaseAccredidation WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseContactRequest WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseDefDocument WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseDocumentsDicom WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseEnvelope WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseICDRequest WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseDocumentTransfer WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO

DELETE FROM tblCaseIssue WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseIssueQuestion WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseProblem WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO

DELETE FROM tblCaseOtherTreatingDoctor WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseOtherParty WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseRelatedParty WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseReviewItem WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCaseUnknownClient WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO

DELETE FROM tblCaseNF10 WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblCasePeerBill WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO


DELETE FROM tblDPSBundle WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblDPSBundleCaseDocument WHERE DPSBundleID NOT in (SELECT DPSBundleID FROM tblDPSBundle)
DELETE FROM tblOCRDocument WHERE CaseDocID NOT in (SELECT SeqNo FROM tblCaseDocuments)

GO



DELETE FROM tblAcctingTrans WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO

DELETE FROM tblAcctHeader WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblAcctDetail WHERE HeaderID NOT in (SELECT HeaderID FROM tblAcctHeader)
GO

DELETE FROM tblCaseTrans WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
GO

DELETE FROM tblAcctQuote WHERE CaseNbr NOT in (SELECT CaseNbr FROM tblCase)
DELETE FROM tblAcctQuoteFee WHERE AcctQuoteID NOT in (SELECT AcctQuoteID FROM tblAcctQuote)
GO


