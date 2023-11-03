-- Sprint 121

-- IMEC-13804 - Add new tokens to tblMessageToken
USE IMECentricEW
GO
  INSERT INTO tblMessageToken (Name) 
  VALUES ('@DAttorneyName@'),
         ('@DAttorneyCompany@'),
         ('@DAttorneyAddr1@'),
         ('@DAttorneyAddr2@'),
         ('@DAttorneyAddr3@'),
         ('@DAttorneyPhone@'),
         ('@PAttorneyName@'),
         ('@PAttorneyCompany@'),
         ('@PAttorneyAddr1@'),
         ('@PAttorneyAddr2@'),
         ('@PAttorneyAddr3@'),
         ('@PAttorneyPhone@')

GO

USE IMECentricMaster
GO

INSERT INTO ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate, Param)
VALUES ('DeleteDPSFilesCancelledFolder', 'DeleteFiles', 'W', 0, '1111111', '1900-01-01 22:00:00', '2023-10-01 00:00:00', 'SrcPath="\\imecdocs5.ew.domain.local\ISIntegrations\DPS\mi-Clinic\IMEC\Cancelled\";Filename=*.*;DeleteType=1')

GO

