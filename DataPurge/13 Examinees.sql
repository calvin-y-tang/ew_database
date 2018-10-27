     -- **********************************************************************************************************
     --
     --   Description:
     --        process Examinee data tables. Verify that items marked for deletion are OK to delete, if not then
     --        revise their delete status
     --
     --   Notes:
     --        1. 08/04/15 - Calvin - created
     --        2. 08/20/2015 - JAP - cleanup and documentation
     --
     -- **********************************************************************************************************

-- look for examinee items that we DO NOT WANT TO DELETE
     UPDATE tmpDelete
        SET OkToDelete=0
      WHERE Type='Examinee'
        AND ID IN (SELECT ChartNbr FROM tblCase)

-- cleanup the Examinee tables
     DELETE
       FROM tblExamineeCC
      WHERE ChartNbr IN (SELECT ID FROM getID('Examinee'))

     DELETE
       FROM tblExaminee
      WHERE ChartNbr IN (SELECT ID FROM getID('Examinee'))
