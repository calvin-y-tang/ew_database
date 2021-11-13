CREATE VIEW vwOpenDrSchedule
AS
    SELECT
        tblDoctor.Prefix+tblDoctor.LastName+', '+
        tblDoctor.FirstName AS doctorname,
        tblDoctor.DoctorCode,
        tblDoctorLocation.LocationCode,
        tblLocation.Location,
        tblDoctor.SchedulePriority,
        MIN(DISTINCT tblDoctorSchedule.date) AS firstavail,
        tblDoctorSchedule.Description,
        tblDoctor.LastName,
        tblDoctor.FirstName
    FROM
        tblDoctor
    INNER JOIN tblDoctorLocation ON tblDoctor.DoctorCode=tblDoctorLocation.DoctorCode
    INNER JOIN tblLocation ON tblDoctorLocation.LocationCode=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctorSchedule ON tblDoctorLocation.DoctorCode=tblDoctorSchedule.DoctorCode AND
                                             tblDoctorLocation.LocationCode=tblDoctorSchedule.LocationCode
    WHERE
        (tblDoctorSchedule.Status<>'Off') AND
        (tblDoctor.Status='Active') OR
        (tblDoctorSchedule.Status IS NULL)
    GROUP BY
        tblDoctor.DoctorCode,
        tblDoctorLocation.LocationCode,
        tblLocation.Location,
        tblDoctor.SchedulePriority,
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctorSchedule.Description,
        tblDoctor.Prefix+tblDoctor.LastName+', '+
        tblDoctor.FirstName
