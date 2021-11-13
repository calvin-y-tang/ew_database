-- **********************************************************************************************************
--
--   Description:
--        ??? TODO: description will be need to filled in after all the TODOs have been figured out
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************


USE IMECentricRoseland
GO

-- ??? TODO: Not sure but it looks like we are looking for users that are missing a default office setting
--           and then setting it to a default of 1
SELECT *
--UPDATE UO SET DefaultOffice=1
 FROM tblUserOffice AS UO
 INNER JOIN (
               SELECT UserID, MIN(OfficeCode) AS FirstOfficeCode
                 FROM tblUserOffice
                WHERE UserID NOT IN (SELECT UserID FROM tblUserOffice WHERE DefaultOffice=1)
                GROUP BY UserID
            ) AS DO ON DO.UserID = UO.UserID AND UO.OfficeCode=DO.FirstOfficeCode


------------------------------------------------
-- ??? TODO:  seems to be setting up some default values for the specified database
USE IMECentricNewYork
GO
UPDATE tblControl SET FacilityID='250'
GO
UPDATE tblUserOffice SET DefaultOffice=1
GO

SELECT *
--DELETE
 FROM tblTranscriptionJob WHERE CaseNbr IS NULL

SELECT *
--DELETE
 FROM tblDoctorAuthor

------------------------------------------------
-- ??? TODO: seems to be setting something for the web portal data
USE IMECentricNationalPortal
GO
UPDATE tblWebAssignment SET DBID=22 WHERE EWFGBusUnitID=28
GO

------------------------------------------------
-- ??? TODO: confiure IMECentricMaster so that the "new" dbs are active and can be used.
USE IMECentricMaster
GO
UPDATE DB SET Active=1 WHERE DBID=22
UPDATE DB SET Active=1 WHERE DBID=1
UPDATE DB SET Descrip='EW-New Jersey' WHERE DBID=1
GO
UPDATE EWFacility SET DBID=22 WHERE EWFacilityID=2
--Run Sync after
GO
--Manually run?
--UPDATE ISIntegration SET Active=1 WHERE IntegrationID=251
GO

-- ??? TODO: ????
UPDATE InfoLauncher
   SET AppName='EW-New Jersey', AppSubDir='EW-NewJersey'
 WHERE LauncherID=1

DELETE
  FROM InfoLauncherBusUnit
 WHERE LauncherID=1 AND BusUnitID=28

INSERT INTO InfoLauncherBusUnit
        ( LauncherID, BusUnitID )
VALUES  ( 22, -- LauncherID - int
          28  -- BusUnitID - int
          )
