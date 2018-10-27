PRINT N'Dropping [dbo].[DF_tblavaildoctor_selected]...';


GO
ALTER TABLE [dbo].[tblAvailDoctor] DROP CONSTRAINT [DF_tblavaildoctor_selected];


GO
PRINT N'Dropping [dbo].[vwAvailableDoctorsWithNotes]...';


GO
DROP VIEW [dbo].[vwAvailableDoctorsWithNotes];


GO
PRINT N'Dropping [dbo].[vwAvailablePanelDrsWithNotes]...';


GO
DROP VIEW [dbo].[vwAvailablePanelDrsWithNotes];


GO
PRINT N'Dropping [dbo].[vwDoctorSchedule]...';


GO
DROP VIEW [dbo].[vwDoctorSchedule];


GO
PRINT N'Dropping [dbo].[vwDoctorScheduleMEI]...';


GO
DROP VIEW [dbo].[vwDoctorScheduleMEI];


GO
PRINT N'Dropping [dbo].[tblAvailDoctor]...';


GO
DROP TABLE [dbo].[tblAvailDoctor];


GO
PRINT N'Dropping [dbo].[spAvailableDoctors]...';


GO
DROP PROCEDURE [dbo].[spAvailableDoctors];


GO
PRINT N'Dropping [dbo].[stpGetAllDocLocation]...';


GO
DROP PROCEDURE [dbo].[stpGetAllDocLocation];


GO
PRINT N'Dropping [dbo].[stpGetDocLocation]...';


GO
DROP PROCEDURE [dbo].[stpGetDocLocation];


GO
PRINT N'Dropping [dbo].[stpGetZipDistanceKilometers]...';


GO
DROP PROCEDURE [dbo].[stpGetZipDistanceKilometers];


GO
PRINT N'Dropping [dbo].[stpGetZipDistanceMiles]...';


GO
DROP PROCEDURE [dbo].[stpGetZipDistanceMiles];


GO
PRINT N'Dropping [dbo].[stpGetLatLon]...';


GO
DROP PROCEDURE [dbo].[stpGetLatLon];


GO