CREATE TABLE [dbo].[tblLocation] (
    [LocationCode]        INT               IDENTITY (1, 1) NOT NULL,
    [Location]            VARCHAR (50)      NULL,
    [Addr1]               VARCHAR (50)      NULL,
    [Addr2]               VARCHAR (50)      NULL,
    [City]                VARCHAR (50)      NULL,
    [State]               VARCHAR (2)       NULL,
    [Zip]                 VARCHAR (15)      NULL,
    [Phone]               VARCHAR (15)      NULL,
    [Fax]                 VARCHAR (15)      NULL,
    [Email]               VARCHAR (70)      NULL,
    [InsideDr]      BIT           CONSTRAINT [DF_tblLocation_InsideDr] DEFAULT ((0)) NULL,
    [FaxdrSchedule] BIT           CONSTRAINT [DF_tblLocation_FaxdrSchedule] DEFAULT ((0)) NULL,
    [DirectionFile]       VARCHAR (100)     NULL,
    [Status]              VARCHAR (10)      CONSTRAINT [DF_tblLocation_Status] DEFAULT ('Active') NULL,
    [DrLetter]      BIT           CONSTRAINT [DF_tblLocation_DrLetter] DEFAULT ((0)) NULL,
    [MedRcdLetter]  BIT           CONSTRAINT [DF_tblLocation_MedRcdLetter] DEFAULT ((0)) NULL,
    [DateAdded]           DATETIME          NULL,
    [UserIDAdded]         VARCHAR (15)      NULL,
    [DateEdited]          DATETIME          NULL,
    [UserIDEdited]        VARCHAR (15)      NULL,
    [County]              VARCHAR (50)      NULL,
    [Vicinity]            VARCHAR (50)      NULL,
    [Notes]               TEXT              NULL,
    [ContactPrefix]       VARCHAR (5)       NULL,
    [ContactFirst]        VARCHAR (25)      NULL,
    [ContactLast]         VARCHAR (50)      NULL,
    [Country]             VARCHAR (50)      NULL,
    [ExtName]             VARCHAR (50)      NULL,
    [OldKey]              INT               NULL,
    [ExamRooms]           INT               NULL,
	[UseConfirmation] BIT		  CONSTRAINT [DF_tblLocation_UseConfirmation] DEFAULT (0) NOT NULL,
    [AddressInstructions] VARCHAR (250)     NULL,
    [GeoData]             [sys].[geography] NULL,
    CONSTRAINT [PK_tblLocation] PRIMARY KEY CLUSTERED ([LocationCode] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblLocation_LocationCode]
    ON [dbo].[tblLocation]([LocationCode] ASC)
    INCLUDE([Location], [Phone], [Fax]);


GO
CREATE SPATIAL INDEX [IX_tblLocation_GeoData]
    ON [dbo].[tblLocation] ([GeoData]);


GO
CREATE TRIGGER tblLocation_AfterUpdate_TRG 
  ON tblLocation
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	DECLARE @LocationCode INT
	SELECT @LocationCode=Inserted.LocationCode FROM Inserted

	IF UPDATE(Zip)
	BEGIN
		UPDATE tblLocation SET GeoData=
		(SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
		FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
		FROM Inserted
		WHERE tblLocation.LocationCode = @LocationCode
	END
END
GO
CREATE TRIGGER tblLocation_AfterInsert_TRG 
  ON tblLocation
AFTER INSERT
AS
  UPDATE tblLocation SET GeoData=
  (SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
   FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
   FROM Inserted
   WHERE tblLocation.LocationCode = Inserted.LocationCode
GO