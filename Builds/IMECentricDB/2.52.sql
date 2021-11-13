CREATE TABLE [tblAuditLog] (
  [PrimaryKey] INTEGER IDENTITY(1,1) NOT NULL,
  [LogDate] DATETIME NOT NULL,
  [UserID] VARCHAR(20),
  [Module] VARCHAR(100),
  [Action] INTEGER NOT NULL,
  [MasterEntityType] VARCHAR(50),
  [MasterEntityID] VARCHAR(50),
  [EntityType] VARCHAR(50),
  [EntityID] VARCHAR(50),
  [EntityDescrip] VARCHAR(100),
  [FieldName] VARCHAR(50),
  [OldValue] VARCHAR(100),
  [NewValue] VARCHAR(100),
  CONSTRAINT [PK_tblAuditLog] PRIMARY KEY CLUSTERED ([PrimaryKey])
)
GO

CREATE TABLE [tblEWAuditEntity] (
  [EntityType] VARCHAR(50) NOT NULL,
  [DisplayName] VARCHAR(100),
  CONSTRAINT [PK_tblEWAuditEntity] PRIMARY KEY CLUSTERED ([EntityType])
)
GO

CREATE TABLE [tblDoctorFeeSchedule] (
  [DoctorFeeScheduleID] INTEGER IDENTITY(1,1) NOT NULL,
  [DoctorCode] INTEGER NOT NULL,
  [EWNetworkID] INTEGER,
  [ProdCode] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(15),
  [DateAdded] DATETIME,
  [UserIDEdited] VARCHAR(15),
  [DateEdited] DATETIME,
  [EWBusLineID] INTEGER,
  [EWSpecialtyID] INTEGER,
  [LocationCode] INTEGER,
  [EffDate] DATETIME,
  [Prepay] BIT DEFAULT 0 NOT NULL,
  [FeeAmount] MONEY DEFAULT 0 NOT NULL,
  [CancelDays] INTEGER DEFAULT 0 NOT NULL,
  [LateCancelAmount] MONEY DEFAULT 0 NOT NULL,
  [NoShow1Amount] MONEY DEFAULT 0 NOT NULL,
  [NoShow2Amount] MONEY DEFAULT 0 NOT NULL,
  [NoShow3Amount] MONEY DEFAULT 0 NOT NULL,
  CONSTRAINT [PK_tblDoctorFeeSchedule] PRIMARY KEY ([DoctorFeeScheduleID])
)
GO

CREATE UNIQUE INDEX [IdxtblDoctorFeeSchedule_UNIQUE_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate] ON [tblDoctorFeeSchedule]([DoctorCode],[EWNetworkID],[ProdCode],[EWBusLineID],[EWSpecialtyID],[LocationCode],[EffDate])
GO

CREATE VIEW vwDoctorFeeSchedule
AS
SELECT DISTINCT
 DFS.DoctorFeeScheduleID,
 D.DoctorCode,
 DP.ProdCode,
 DP.Description AS Product,
 BL.EWBusLineID,
 BL.Name AS BusLine,
 S.EWSpecialtyID,
 DS.SpecialtyCode AS Specialty,
 N.EWNetworkID,
 N.Name AS Network,
 N.SeqNo AS NetworkOrder,
 L.LocationCode,
 L.Location,
 DFS.EffDate,
 DFS.FeeAmount,
 DFS.CancelDays,
 DFS.LateCancelAmount,
 DFS.NoShow1Amount,
 DFS.NoShow2Amount,
 DFS.NoShow3Amount
 FROM tblDoctor AS D
 INNER JOIN
 (
   SELECT DISTINCT DF.DoctorCode, P.ProdCode, P.Description FROM tblProduct AS P
    INNER JOIN tblDoctorFeeSchedule AS DF ON P.ProdCode = DF.ProdCode
 ) AS DP ON DP.DoctorCode = D.DoctorCode
 INNER JOIN tblDoctorBusLine AS DBL ON DBL.DoctorCode = D.DoctorCode
 INNER JOIN tblEWBusLine AS BL ON BL.EWBusLineID = DBL.EWBusLineID
 INNER JOIN tblDoctorSpecialty AS DS ON DS.DoctorCode = D.DoctorCode
 INNER JOIN tblSpecialty AS S ON S.SpecialtyCode = DS.SpecialtyCode
 INNER JOIN tblDoctorLocation AS DL ON DL.DoctorCode = D.DoctorCode
 INNER JOIN tblLocation AS L ON L.LocationCode = DL.LocationCode
 LEFT OUTER JOIN tblDoctorNetwork AS DN ON DN.DoctorCode = D.DoctorCode
 LEFT OUTER JOIN tblEWNetwork AS N ON N.EWNetworkID = DN.EWNetworkID OR N.OutOfNetwork=1
 LEFT OUTER JOIN tblDoctorFeeSchedule AS DFS ON DFS.DoctorCode = -1

GO

TRUNCATE TABLE tblDoctorBusLine
GO
INSERT INTO tblDoctorBusLine
        ( DoctorCode ,
          EWBusLineID ,
          UserIDAdded ,
          DateAdded
        )

SELECT DISTINCT ISNULL(CP.DoctorCode, C.DoctorCode) AS DrCode, CT.EWBusLineID, 'Convert', GETDATE()
 FROM tblCase AS C
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 LEFT OUTER JOIN tblCasePanel AS CP ON CP.PanelNbr = C.PanelNbr
 LEFT OUTER JOIN tblDoctor AS D ON ISNULL(CP.DoctorCode, C.DoctorCode)=D.DoctorCode
 WHERE
 ISNULL(CP.DoctorCode, C.DoctorCode) IN (SELECT DoctorCode FROM tblDoctor)
 AND CT.EWBusLineID IS NOT NULL

GO


Insert into tblMessageToken values ('@Employer@','')
GO

UPDATE tblControl SET DBVersion='2.52'
GO
