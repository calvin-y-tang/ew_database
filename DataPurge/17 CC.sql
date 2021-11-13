-- **********************************************************************************************************
--
--   Description:
--        process Attorney data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for attorney items we need to keep
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='CC'
        AND ID IN (SELECT DISTINCT PlaintiffAttorneyCode FROM tblCase WHERE PlaintiffAttorneyCode IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='CC'
        AND ID IN (SELECT DISTINCT DefenseAttorneyCode FROM tblCase WHERE DefenseAttorneyCode IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='CC'
        AND ID IN (SELECT DISTINCT DefParaLegal FROM tblCase WHERE DefParaLegal IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='CC'
        AND ID IN (SELECT DISTINCT ccCode FROM tblExamineeCC)

-- clean up the attorney data tables
     DELETE
       FROM tblCCAddress
      WHERE ccCode IN (SELECT ID FROM getID('CC'))
