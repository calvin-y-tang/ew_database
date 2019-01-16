 
 CREATE VIEW vwDoctorScheduleSummary
AS  
   SELECT  tblDoctor.LastName ,
            tblDoctor.FirstName ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblLocation.InsideDr ,
            tblDoctor.DoctorCode ,
            tblDoctorOffice.OfficeCode ,
            tblDoctorSchedule.LocationCode ,
            tblDoctor.Booking ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctorSchedule.CaseNbr4 ,
            tblDoctorSchedule.CaseNbr5 ,
            tblDoctorSchedule.CaseNbr6 ,
            tblDoctorSchedule.StartTime, 
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
            INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode 
			inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )
