-- **********************************************************************************************************
--
--   Description:
--        process Doctor data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- Look for Doctor items that we don't want to delete and clean up their schedule data
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Doctor'
        AND (
                  ID IN (SELECT DoctorCode FROM tblCase)
               OR ID IN (SELECT DrOpCode FROM tblAcctHeader)
               OR ID IN (SELECT DISTINCT ISNULL(CAP.DoctorCode, CA.DoctorCode)
                           FROM tblCaseAppt AS CA
                                    LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = CA.CaseApptID)
               OR ID IN (SELECT DISTINCT CP.DoctorCode
                           FROM tblCasePanel AS CP
                                    INNER JOIN tblCase AS C ON C.PanelNbr = CP.PanelNbr)
            )

     -- ??? TODO: these updates are part of the "Data Check" script but are commented out. Would it make
     --           sense to consolidate this logic into just one location?
     UPDATE tblDoctorSchedule
        SET CaseNbr1=NULL, CaseNbr1desc=NULL
      WHERE CaseNbr1 IN (SELECT ID FROM getID('Case'))

     -- ??? TODO: these updates are part of the "Data Check" script but are commented out. Would it make
     --           sense to consolidate this logic into just one location?
     UPDATE tblDoctorSchedule
        SET CaseNbr2=NULL, CaseNbr2desc=NULL
      WHERE CaseNbr2 IN (SELECT ID FROM getID('Case'))

     -- ??? TODO: these updates are part of the "Data Check" script but are commented out. Would it make
     --           sense to consolidate this logic into just one location?
     UPDATE tblDoctorSchedule
        SET CaseNbr3=NULL, CaseNbr3desc=NULL
      WHERE CaseNbr3 IN (SELECT ID FROM getID('Case'))

     UPDATE tblDoctorSchedule
        SET Status='Open'
      WHERE CaseNbr1 IS NULL  AND CaseNbr2 IS NULL AND CaseNbr3 IS NULL AND Status='Scheduled'

-- clean up the doctor tables
     DELETE
       FROM tblDoctorSchedule
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorAccreditation
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorBusLine
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorDocuments
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorFeeSchedule
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorKeyWord
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorLocation
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorNetwork
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     -- ??? TODO: Are these 2 separate delete statements for the same table what we really want to do?
     --           It just seems as if it is not.
     DELETE
       FROM tblDoctorOffice
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))
     DELETE
       FROM tblDoctorOffice
      WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

     DELETE
       FROM tblDoctorSpecialty
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorTemplate
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctorAuthor
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDoctor
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))

     DELETE
       FROM tblDrDoNotUse
      WHERE DoctorCode NOT IN (SELECT DoctorCode FROM tblDoctor)
