-- **********************************************************************************************************
--
--   Description:
--        process Client data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for client items that we want to keep
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Client'
        AND (
                   ID IN (SELECT ClientCode FROM tblCase)
                OR ID IN (SELECT BillClientCode FROM tblCase)
                OR ID IN (SELECT ClientCode FROM tblAcctHeader)
            )

-- Clean up the Client data tables
     DELETE
       FROM tblClientDefDocument
      WHERE ClientCode IN (SELECT ID FROM getID('Client'))

     DELETE tblEWClient
       FROM tblEWClient
               INNER JOIN tblClient ON tblClient.EWClientID = tblEWClient.EWClientID
      WHERE ClientCode IN (SELECT ID FROM getID('Client'))

     DELETE
       FROM tblClient
      WHERE ClientCode IN (SELECT ID FROM getID('Client'))

     DELETE
       FROM tblDrDoNotUse
      WHERE Type='CL'
        AND Code NOT IN (SELECT ClientCode FROM tblClient)
