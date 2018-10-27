-- **********************************************************************************************************
--
--   Description:
--        process user data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for User items that we want to keep
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='User'
        AND ID IN (SELECT U.SeqNo
                     FROM tblUser AS U
                              INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
                    WHERE UO.OfficeCode NOT IN (SELECT ID FROM getID('Office')))

     -- Keep the users that have links to case client and company records that we are keeping
     UPDATE tmpDelete
        SET OkToDelete = 0
      WHERE Type = 'User'
        AND ID IN (SELECT DISTINCT(SeqNo)
                     FROM tblUser
                    WHERE UserID IN (SELECT DISTINCT(MarketerCode)
                                       FROM tblCase
                                      WHERE CaseNbr NOT IN (SELECT ID FROM getID('Case'))
                                     UNION
                                     SELECT DISTINCT(QARep)
                                       FROM tblCase
                                      WHERE CaseNbr NOT IN (SELECT ID FROM getID('Case'))
                                     UNION
                                     SELECT DISTINCT(SchedulerCode)
                                       FROM tblCase
                                      WHERE CaseNbr NOT IN (SELECT ID FROM getID('Case'))
                                     UNION
                                     SELECT DISTINCT(MarketerCode)
                                       FROM tblClient
                                      WHERE ClientCode NOT IN (SELECT ID FROM getID('Client'))
                                     UNION
                                     SELECT DISTINCT(QARep)
                                       FROM tblClient
                                      WHERE ClientCode NOT IN (SELECT ID FROM getID('Client'))
                                     UNION
                                     SELECT DISTINCT(MarketerCode)
                                       FROM tblCompany
                                      WHERE CompanyCode NOT IN (SELECT ID FROM getID('Company'))
                                     UNION
                                     SELECT DISTINCT(QARep)
                                       FROM tblCompany
                                      WHERE CompanyCode NOT IN (SELECT ID FROM getID('Company'))
                                     )
                  )

-- Clean up the auxilary user data tables
     DELETE
       FROM tblUserOffice
      WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

     DELETE
       FROM tblUserOfficeFunction
      WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

     DELETE
       FROM tblUserOfficeFunction
      WHERE UserID IN (SELECT UserID FROM tblUser WHERE SeqNo IN (SELECT ID FROM getID('User')))

     DELETE
       FROM tblUserSecurity
      WHERE UserID IN (SELECT UserID FROM tblUser WHERE SeqNo IN (SELECT ID FROM getID('User')))

     DELETE
       FROM tblUserSecurity
      WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

-- clean up the user table
     DELETE
       FROM tblUser
      WHERE SeqNo IN (SELECT ID FROM getID('User'))
