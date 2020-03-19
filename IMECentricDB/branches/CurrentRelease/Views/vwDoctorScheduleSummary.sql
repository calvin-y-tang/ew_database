 
 CREATE VIEW vwDoctorScheduleSummary
AS
	-- DEV NOTE: the result set of this view needs to match (data type & column names) 
	--		vwDoctorBlockTimeScheduleSummary. These 2 views are conditionally used within the same IMEC code
	--		 and; therefore, need to be in "sync".

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
