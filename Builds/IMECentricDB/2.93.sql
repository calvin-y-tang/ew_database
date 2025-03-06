PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DbTimeoutSec] INT CONSTRAINT [DF_tblControl_DbTimeoutSec] DEFAULT ((60)) NOT NULL;


GO
PRINT N'Creating [dbo].[tblCaseHistory].[IX_tblCaseHistory_EventDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_EventDate]
    ON [dbo].[tblCaseHistory]([EventDate] ASC);


GO
PRINT N'Altering [dbo].[vwCaseMonitorDetail]...';


GO
ALTER VIEW vwCaseMonitorDetail
AS
    SELECT  C.Status AS StatusCode,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            C.DoctorCode ,
            CL.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType
    FROM    tblCase AS C
            INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
    WHERE   C.Status NOT IN (8, 9, -100)
GO
PRINT N'Altering [dbo].[vwDoctorSchedule]...';


GO
ALTER VIEW vwDoctorSchedule
AS
     select  tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblExaminee.Sex ,
            tblLocation.Location,
			tblLocation.Addr1,
            tblLocation.Addr2,
            tblLocation.City,
            tblLocation.State,
            tblLocation.Zip,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films , 
			tblLocationOffice.OfficeCode as LocationOffice 
from tblDoctorSchedule 
	inner join tblDoctorOffice on tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
	inner join tblDoctor on tblDoctorOffice.DoctorCode = tblDoctor.DoctorCode	
	inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
	inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
	left outer join tblCase
		inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
		inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
		inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
		inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
		inner join tblCaseType on tblCase.CaseType = tblCaseType.Code
		left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID
	on tblDoctorSchedule.SchedCode = tblCase.SchedCode	
    UNION
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblExaminee.Sex ,
            tblLocation.Location ,
			tblLocation.Addr1,
            tblLocation.Addr2,
            tblLocation.City,
            tblLocation.State,
            tblLocation.Zip,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc , 
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode,			
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films , 
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule 
				inner join tblDoctorOffice on tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
				inner join tblDoctor on tblDoctorOffice.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
				inner join tblCasePanel on tblDoctorSchedule.SchedCode = tblCasePanel.SchedCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code		
					left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID			
				on tblCasePanel.PanelNbr = tblCase.PanelNbr
    WHERE   tblCase.PanelNbr IS NOT NULL
GO
PRINT N'Altering [dbo].[vwDoctorScheduleSummary]...';


GO
 
 ALTER VIEW vwDoctorScheduleSummary
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
            tblDoctorSchedule.StartTime, 
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
            INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode 
			inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )
GO
PRINT N'Creating [dbo].[web_GetCaseDocumentPathExisting]...';


GO
CREATE PROCEDURE [dbo].[web_GetCaseDocumentPathExisting]
 @SeqNo int
AS

BEGIN
	DECLARE @docpath varchar(500)
	SET @docpath = dbo.fnGetCaseDocument(@SeqNo)
	SELECT RTRIM(@Docpath) AS DocumentPath
END
GO

SET IDENTITY_INSERT tblQueues ON
INSERT INTO tblQueues
        (StatusCode,
         StatusDesc,
         Type,
         ShortDesc,
         DisplayOrder,
         FormToOpen,
         DateAdded,
         DateEdited,
         UserIDAdded,
         UserIDEdited,
         Status,
         SubType,
         FunctionCode,
         WebStatusCode,
         NotifyScheduler,
         NotifyQARep,
         NotifyIMECompany,
         WebGUID,
         AllowToAwaitingScheduling
        )
VALUES
        (32,
         'Incoming Cases', -- StatusDesc - varchar(50)
         'System', -- Type - varchar(10)
         'Incoming', -- ShortDesc - varchar(10)
         100, -- DisplayOrder - int
         'frmStatusMiscSelect', -- FormToOpen - varchar(30)
         GETDATE(), -- DateAdded - datetime
         GETDATE(), -- DateEdited - datetime
         'System', -- UserIDAdded - varchar(20)
         'System', -- UserIDEdited - varchar(20)
         'Active', -- Status - varchar(10)
         'Case', -- SubType - varchar(10)
         'None', -- FunctionCode - varchar(15)
         2, -- WebStatusCode - int
         0, -- NotifyScheduler - bit
         0, -- NotifyQARep - bit
         1, -- NotifyIMECompany - bit
         NULL, -- WebGUID - uniqueidentifier
         NULL  -- AllowToAwaitingScheduling - bit
        )
SET IDENTITY_INSERT tblQueues OFF



SET IDENTITY_INSERT tblQueues ON
INSERT INTO tblQueues
        (StatusCode,
         StatusDesc,
         Type,
         ShortDesc,
         DisplayOrder,
         FormToOpen,
         DateAdded,
         DateEdited,
         UserIDAdded,
         UserIDEdited,
         Status,
         SubType,
         FunctionCode,
         WebStatusCode,
         NotifyScheduler,
         NotifyQARep,
         NotifyIMECompany,
         WebGUID,
         AllowToAwaitingScheduling
        )
VALUES
        (-100,
         'Pending Referral Assignment', -- StatusDesc - varchar(50)
         'System', -- Type - varchar(10)
         'PendRef', -- ShortDesc - varchar(10)
         500, -- DisplayOrder - int
         'None', -- FormToOpen - varchar(30)
         GETDATE(), -- DateAdded - datetime
         GETDATE(), -- DateEdited - datetime
         'System', -- UserIDAdded - varchar(20)
         'System', -- UserIDEdited - varchar(20)
         'Active', -- Status - varchar(10)
         'Case', -- SubType - varchar(10)
         'None', -- FunctionCode - varchar(15)
         2, -- WebStatusCode - int
         0, -- NotifyScheduler - bit
         0, -- NotifyQARep - bit
         0, -- NotifyIMECompany - bit
         NULL, -- WebGUID - uniqueidentifier
         NULL  -- AllowToAwaitingScheduling - bit
        )
SET IDENTITY_INSERT tblQueues OFF
GO


UPDATE tblControl SET DBVersion='2.93'
GO
