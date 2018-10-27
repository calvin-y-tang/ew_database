-- **********************************************************************************************************
--
--   Description:
--        process Case data tables. Items that have been marked for deletion will be removed
--        from the tables.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- First cleanup all the tables that have "auxilary" case data
     DELETE
       FROM tblAcctingTrans
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblDoctorCheckRequest
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseTrans
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseAccredidation
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE tblCaseApptPanel
       FROM tblCaseApptPanel
               INNER JOIN tblCaseAppt ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseAppt
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseDefDocument
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseDocuments
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseHistory
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseICDRequest
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseIssue
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseOtherParty
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseOtherTreatingDoctor
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE tblCasePanel
       FROM tblCasePanel
               INNER JOIN tblCase ON tblCase.PanelNbr = tblCasePanel.PanelNbr
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCasePeerBill
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseProblem
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseRelatedParty
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCaseUnknownClient
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblCustomerData
      WHERE TableType='tblCase' AND TableKey IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblRecordHistory
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE tblRecordsObtainmentDetail
       FROM tblRecordsObtainmentDetail
               INNER JOIN tblRecordsObtainment ON tblRecordsObtainment.RecordsID = tblRecordsObtainmentDetail.RecordsID
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblRecordsObtainment
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

     DELETE
       FROM tblTranscriptionJob
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

-- Lastly clean out the case table
     DELETE
       FROM tblCase
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))
