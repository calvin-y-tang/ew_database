CREATE VIEW vwApptHoldRpt
AS
    SELECT
        tblDoctorSchedule.date,
        tblDoctorSchedule.StartTime,
        tblDoctorSchedule.Status,
        tblDoctorSchedule.Duration,
        tblDoctorSchedule.CaseNbr1desc,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctor,
        tblLocation.Location,
        tblDoctorSchedule.UserIDEdited,
        tblDoctorOffice.OfficeCode
    FROM
        tblDoctorSchedule
    INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode=tblLocation.LocationCode
    INNER JOIN tblDoctorOffice ON tblDoctorSchedule.DoctorCode=tblDoctorOffice.DoctorCode
    WHERE
        (tblDoctorSchedule.Status='Hold')
