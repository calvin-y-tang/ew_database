PRINT N'Altering [dbo].[tblConfirmationSetup]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup]
    ADD [EWTimeZoneID] INT NULL;


GO
PRINT N'Creating [dbo].[fnGetOfficeDateTime]...';


GO
CREATE FUNCTION dbo.fnGetOfficeDateTime()
RETURNS @retOfficeDateTime TABLE 
(
    OfficeCode int PRIMARY KEY NOT NULL, 
    OfficeDateTime DateTime NULL,
    OfficeDate Date NULL
)
AS 
BEGIN
    BEGIN
        INSERT @retOfficeDateTime
        SELECT O.OfficeCode, DATEADD(HOUR, dbo.fnGetUTCOffset(O.EWTimeZoneID, GETUTCDATE()), GETUTCDATE()) AS OfficeDateTime, CONVERT(DATE, DATEADD(HOUR, dbo.fnGetUTCOffset(O.EWTimeZoneID, GETUTCDATE()), GETUTCDATE())) AS OfficeDate
              FROM tblOffice AS O;
    END;
    RETURN;
END
GO
PRINT N'Altering [dbo].[vwAvailableDoctorsWithNotes]...';


GO
ALTER VIEW vwAvailableDoctorsWithNotes
AS
    SELECT  tblDoctor.notes ,
            tblDoctor.usdmoney1 ,
            tblDoctor.usdmoney2 ,
            tblAvailDoctor.RecID ,
            tblAvailDoctor.UserID ,
            tblAvailDoctor.DoctorCode ,
            tblAvailDoctor.LocationCode ,
            tblAvailDoctor.FirstAvail ,
            tblAvailDoctor.Doctorname ,
            tblAvailDoctor.Location ,
            tblAvailDoctor.City ,
            tblAvailDoctor.State ,
            tblAvailDoctor.County ,
            tblAvailDoctor.Prepaid ,
            tblAvailDoctor.vicinity ,
            tblAvailDoctor.Phone ,
            tblAvailDoctor.Specialty ,
            tblAvailDoctor.proximity ,
            tblAvailDoctor.SchedulePriority ,
            tblAvailDoctor.degree ,
            tblAvailDoctor.StartTime ,
            tblAvailDoctor.selected ,
            tblAvailDoctor.SortDate ,
            tblAvailDoctor.SortProximity, 
			tblDoctor.Status 
    FROM    tblavaildoctor
            INNER JOIN tblDoctor ON tblavaildoctor.doctorcode = tblDoctor.doctorcode
GO
PRINT N'Altering [dbo].[vwAvailablePanelDrsWithNotes]...';


GO
ALTER VIEW vwAvailablePanelDrsWithNotes
AS
    SELECT  tblDoctor.notes ,
            tblAvailDoctor.RecID ,
            tblAvailDoctor.UserID ,
            tblAvailDoctor.DoctorCode ,
            tblAvailDoctor.LocationCode ,
            tblAvailDoctor.FirstAvail ,
            tblAvailDoctor.Doctorname ,
            tblAvailDoctor.Location ,
            tblAvailDoctor.City ,
            tblAvailDoctor.State ,
            tblAvailDoctor.County ,
            tblAvailDoctor.Prepaid ,
            tblAvailDoctor.vicinity ,
            tblAvailDoctor.Phone ,
            tblAvailDoctor.Specialty ,
            tblAvailDoctor.proximity ,
            tblAvailDoctor.SchedulePriority ,
            tblAvailDoctor.degree ,
            tblAvailDoctor.StartTime ,
            tblAvailDoctor.selected ,
            tblAvailDoctor.SortDate ,
            tblAvailDoctor.SortProximity, 
			tblDoctor.Status
    FROM    tblAvailDoctor
            INNER JOIN tblDoctor ON tblAvailDoctor.DoctorCode = tblDoctor.DoctorCode
GO

insert into tblSetting 
values ('CheckForCaseScheduled','True')
Go




UPDATE tblControl SET DBVersion='3.11'
GO
