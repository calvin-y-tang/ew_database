
ALTER TABLE tblFRForecast
 ADD DaysToInternalDueDate INT
GO
ALTER TABLE tblFRForecast
 ADD DaysToExternalDueDate INT
GO


ALTER TABLE tblCase
 ADD DoctorReason VARCHAR(25)
GO

CREATE TABLE tblDoctorReason (
  DoctorReasonID INTEGER IDENTITY(1,1) NOT NULL,
  Reason VARCHAR(25),
  SeqNo INTEGER,
  CONSTRAINT PK_tblDoctorReason PRIMARY KEY (DoctorReasonID)
)
GO

SET IDENTITY_INSERT tblDoctorReason ON
INSERT INTO tblDoctorReason (DoctorReasonID, Reason, SeqNo) VALUES (1, 'EW Selected', 1)
INSERT INTO tblDoctorReason (DoctorReasonID, Reason, SeqNo) VALUES (2, 'Rural Area', 2)
INSERT INTO tblDoctorReason (DoctorReasonID, Reason, SeqNo) VALUES (3, 'Date/Time Consideration', 3)
INSERT INTO tblDoctorReason (DoctorReasonID, Reason, SeqNo) VALUES (4, 'Client Selected', 4)
INSERT INTO tblDoctorReason (DoctorReasonID, Reason, SeqNo) VALUES (5, 'OSR', 5)
SET IDENTITY_INSERT tblDoctorReason OFF
GO

ALTER TABLE tblCasePanel
 ADD DoctorReason VARCHAR(25)
GO

DROP VIEW vwCasePanel
GO

CREATE VIEW vwCasePanel
AS
    SELECT  tblSpecialty.description AS SpecialtyDesc ,
            tblDoctor.lastName + ', ' + ISNULL(tblDoctor.firstName, '') AS DoctorName ,
            tblDoctor.firstName ,
            tblDoctor.Credentials ,
            tblCasePanel.Panelnbr ,
            tblCasePanel.DoctorCode ,
            tblCasePanel.Panelnote ,
            tblCasePanel.SpecialtyCode ,
            tblCasePanel.SchedCode ,
            tblCasePanel.DateAdded ,
            tblCasePanel.UserIDAdded ,
            tblCasePanel.DateEdited ,
            tblCasePanel.UserIDEdited ,
			tblCasePanel.DoctorReason
    FROM    tblCasePanel
            INNER JOIN tblDoctor ON tblCasePanel.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCasePanel.SpecialtyCode = tblSpecialty.SpecialtyCode

GO

UPDATE tblControl SET DBVersion='2.19'
GO
