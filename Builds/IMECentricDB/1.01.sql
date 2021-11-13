-- Update Database to ver. 1.01. Generated on 4/17/2010
-- ## TargetDB: MSSQL2005; Delimiter: "GO";

ALTER TABLE [tblControl]
  ADD [IsTestSystem] BIT DEFAULT ((0))
GO

DROP VIEW [vwdoctorschedulesummary]
GO


CREATE VIEW [dbo].[vwdoctorschedulesummary]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblLocation.location, dbo.tblDoctorSchedule.date, 
                        COUNT(dbo.tblDoctorSchedule.status) AS [Count], dbo.tblDoctorSchedule.status, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, 
                        dbo.tblDoctorOffice.officecode, dbo.tblDoctorSchedule.locationcode
FROM          dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                        dbo.tblLocation ON dbo.tblDoctorSchedule.locationcode = dbo.tblLocation.locationcode INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblDoctor.doctorcode = dbo.tblDoctorOffice.doctorcode
GROUP BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.status, dbo.tblLocation.location, 
                        dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctorOffice.officecode, dbo.tblDoctorSchedule.locationcode
HAVING       (dbo.tblDoctorSchedule.status <> 'Off')
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctor.lastname, dbo.tblLocation.location

GO

DROP VIEW [vwFeeDetail]
GO


CREATE VIEW dbo.vwFeeDetail
AS
SELECT     TOP 100 PERCENT dbo.tblfeedetail.*, dbo.tblproduct.description
FROM         dbo.tblfeedetail INNER JOIN
                      dbo.tblproduct ON dbo.tblfeedetail.prodcode = dbo.tblproduct.prodcode
ORDER BY dbo.tblproduct.description


GO