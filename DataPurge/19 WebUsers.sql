-- **********************************************************************************************************
--
--   Description:
--        process webUser/PublishOnWeb data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for webuser items that we want to keep
     UPDATE tmp
        SET OkToDelete=0
       FROM tmpDelete AS tmp
               INNER JOIN tblWebUser AS WU ON WU.WebUserID=tmp.ID AND tmp.Type='WebUser'
      WHERE (WU.UserType='CL'
        AND WU.IMECentricCode IN (SELECT ClientCode FROM tblClient))

     UPDATE tmp
        SET OkToDelete=0
       FROM tmpDelete AS tmp
               INNER JOIN tblWebUser AS WU ON WU.WebUserID=tmp.ID AND tmp.Type='WebUser'
      WHERE (WU.UserType='DR'
        AND WU.IMECentricCode IN (SELECT DoctorCode FROM tblDoctor))

     UPDATE tmp
        SET OkToDelete=0
       FROM tmpDelete AS tmp
               INNER JOIN tblWebUser AS WU ON WU.WebUserID=tmp.ID AND tmp.Type='WebUser'
      WHERE (WU.UserType='OP'
        AND WU.IMECentricCode IN (SELECT DoctorCode FROM tblDoctor))

     UPDATE tmp
        SET OkToDelete=0
       FROM tmpDelete AS tmp
               INNER JOIN tblWebUser AS WU ON WU.WebUserID=tmp.ID AND tmp.Type='WebUser'
      WHERE (WU.UserType='AT'
        AND WU.IMECentricCode IN (SELECT ccCode FROM tblCCAddress))

-- clean up WebUser data tables for WebUserID
     DELETE
       FROM tblWebPasswordHistory
      WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))

     DELETE
       FROM tblWebActivation
      WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))

     DELETE
       FROM tblWebUserAccount
      WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))

-- clean up WebUser data tables for the various UserTypes (CL, DR, AT
     DELETE
       FROM tblWebUserAccount
      WHERE UserType='CL'
        AND UserCode IN (SELECT ID FROM getID('Client'))

     DELETE
       FROM tblWebUserAccount
      WHERE UserType='DR'
        AND UserCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblWebUserAccount
      WHERE UserType='AT'
        AND UserCode IN (SELECT ID FROM getID('CC'))

     DELETE
       FROM tblWebEventsOverride
      WHERE UserType='CL'
        AND IMECentricCode IN (SELECT ID FROM getID('Client'))

     DELETE
       FROM tblWebEventsOverride
      WHERE UserType='DR'
        AND IMECentricCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblWebEventsOverride
      WHERE UserType='AT'
        AND IMECentricCode IN (SELECT ID FROM getID('CC'))

     DELETE
       FROM tblEWWebUserAccount
      WHERE UserType='CL'
        AND EWEntityID NOT IN (SELECT EWClientID FROM tblEWClient)

-- Additional cleanup for WebUser data
     DELETE
       FROM tblEWWebUserAccount
      WHERE EWWebUserID IN
            (
                SELECT EWU.EWWebUserID
                  FROM tblEWWebUser AS EWU
                         INNER JOIN tblWebUser AS WU ON WU.EWWebUserID = EWU.EWWebUserID
                 WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))
            )

     DELETE EWU
       FROM tblEWWebUser AS EWU
               INNER JOIN tblWebUser AS WU ON WU.EWWebUserID = EWU.EWWebUserID
      WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))

     DELETE
       FROM tblWebUser
      WHERE WebUserID IN (SELECT ID FROM getID('WebUser'))

-- Clean up the PublichOnWeb data
     -- ??? TODO: commented because they are optional??? or because the commands following these
     --           accomplish the same with a different technique?
     --DELETE FROM tblPublishOnWeb
     -- WHERE UserType='CL' AND UserCode IN (SELECT ID FROM getID('Client'))
     --DELETE FROM tblPublishOnWeb
     -- WHERE UserType='DR' AND UserCode IN (SELECT ID FROM getID('Doctor'))
     --DELETE FROM tblPublishOnWeb
     -- WHERE UserType='AT' AND UserCode IN (SELECT ID FROM getID('CC'))

     DELETE
       FROM tblPublishOnWeb
      WHERE UserType='CL'
        AND UserCode NOT IN (SELECT ClientCode FROM tblClient)

     DELETE
       FROM tblPublishOnWeb
      WHERE UserType='DR'
        AND UserCode NOT IN (SELECT DoctorCode FROM tblDoctor)

     DELETE
       FROM tblPublishOnWeb
      WHERE UserType='AT'
        AND UserCode NOT IN (SELECT ccCode FROM tblCCAddress)

     DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblCase'
        AND TableKey NOT IN (SELECT CaseNbr FROM tblCase)

     DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblCaseDocuments'
        AND TableKey NOT IN (SELECT SeqNo FROM tblCaseDocuments)

     DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblCaseHistory'
        AND TableKey NOT IN (SELECT ID FROM tblCaseHistory)

     DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblWebEventsOverride'
        AND TableKey NOT IN (SELECT SeqNo FROM tblWebEventsOverride)
