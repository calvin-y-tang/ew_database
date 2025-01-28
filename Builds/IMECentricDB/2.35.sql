ALTER TABLE tblDocument
 ADD Status VARCHAR(10)
GO

ALTER TABLE [tblEWClient]
  ADD [UseNotificationOverrides] BIT
GO

ALTER TABLE [tblEWCompany]
  ADD [UseNotification] BIT
GO

CREATE TABLE tblEWInputSource
(
[InputSourceID] [int] NOT NULL,
[Name] [varchar] (20) NULL,
[Mapping1] [varchar] (40) NULL,
[Note1] [varchar] (70) NULL,
[Mapping2] [varchar] (40) NULL,
[Note2] [varchar] (70) NULL
) ON [PRIMARY]
GO
ALTER TABLE tblEWInputSource ADD CONSTRAINT [PK_tblEWInputSource] PRIMARY KEY CLUSTERED  ([InputSourceID]) ON [PRIMARY]
GO


ALTER TABLE tblEWFacilityGroup
 ADD Brand VARCHAR(5)
GO


--Patch
UPDATE tblEWClient SET UseNotificationOverrides=0 WHERE UseNotificationOverrides IS NULL
GO
UPDATE tblEWCompany SET UseNotification=0 WHERE UseNotification IS NULL
GO


DELETE FROM tblWebEventsOverride
 WHERE UserType='CL'
 AND IMECentricCode IN (SELECT IMECentricCode FROM tblWebUser WHERE ISNULL(EWWebUserID,0)<>0)
GO

UPDATE tblWebEventsOverride SET WebEventsCode=E.Code
 FROM tblWebEventsOverride AS EO
 INNER JOIN tblWebEvents AS E ON E.Type = EO.Type
 WHERE E.Code<>EO.WebEventsCode
GO

DELETE FROM tblWebEvents WHERE Type='Reschedule'
DELETE FROM tblWebEventsOverride WHERE Type='Reschedule'
GO

UPDATE tblWebEvents SET PublishOnWeb=0, PublishedTo='', NotifyTo=''
 WHERE Type='Cancelled'
UPDATE tblWebEventsOverride SET PublishOnWeb=0, PublishedTo='', NotifyTo=''
 WHERE Type='Cancelled'

GO

UPDATE tblWebUser SET WebCompanyID = NULL WHERE EWWebUserID IS NOT NULL AND WebCompanyID IS NOT NULL
GO


UPDATE tblControl SET DBVersion='2.35'
GO
