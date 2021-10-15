
CREATE VIEW vw30DaySchedule
AS
    SELECT  tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.LocationCode ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctorSchedule.CaseNbr4 ,
            tblDoctorSchedule.CaseNbr5 ,
            tblDoctorSchedule.CaseNbr6 ,
            tblDoctor.Booking
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctorLocation ON tblDoctorSchedule.DoctorCode = tblDoctorLocation.DoctorCode
                                            AND tblDoctorSchedule.LocationCode = tblDoctorLocation.LocationCode
            INNER JOIN tblDoctor ON tblDoctorLocation.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorLocation.LocationCode = tblLocation.LocationCode
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )

