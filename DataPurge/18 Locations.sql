-- **********************************************************************************************************
--
--   Description:
--        process Location data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for location items that we need to keep
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Location'
        AND ID IN (SELECT DISTINCT DoctorLocation FROM tblCase WHERE DoctorLocation IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Location'
        AND ID IN (SELECT DISTINCT LocationCode FROM tblDoctorLocation WHERE LocationCode IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Location'
        AND ID IN (SELECT DISTINCT LocationCode FROM tblCaseAppt WHERE LocationCode IS NOT NULL)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Location'
        AND ID IN (SELECT DISTINCT LocationCode FROM tblDoctorTemplate)

     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Location'
        AND ID IN (SELECT DISTINCT LocationCode FROM tblDoctorSchedule)

-- clean up the location tables
     DELETE
       FROM tblLocation
      WHERE LocationCode IN (SELECT ID FROM getID('Location'))
