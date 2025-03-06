PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient] DROP COLUMN [DefOfficeCode];


GO
PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument] DROP COLUMN [OfficeCode];


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
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
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
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
from tblDoctorSchedule 
	inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
	inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
	left outer join tblCase
		inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
		inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
		inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
		inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
		inner join tblCaseType on tblCase.CaseType = tblCaseType.Code
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
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
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
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
    FROM    tblDoctorSchedule 
				inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				inner join tblCasePanel on tblDoctorSchedule.SchedCode = tblCasePanel.SchedCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code					
				on tblCasePanel.PanelNbr = tblCase.PanelNbr
    WHERE   tblCase.PanelNbr IS NOT NULL
GO
PRINT N'Creating [dbo].[vwFeeScheduleRpt]...';


GO
CREATE VIEW [dbo].[vwFeeScheduleRpt]
AS
SELECT  tblFeeHeader.FeeCode ,
        tblFeeHeader.FeeType ,
        tblFeeHeader.Feedesc ,
        tblFeeHeader.Begin_Date ,
        tblFeeHeader.End_Date ,
        tblFeeDetail.ProdCode ,
        tblFeeDetail.Fee ,
        tblFeeDetail.LateCancelFee ,
        tblFeeDetail.NoShowFee ,
        tblProduct.Description ,
        tblDoctor.LastName + ', ' + tblDoctor.FirstName + ' '
        + ISNULL(tblDoctor.Credentials, '') AS Doctorname ,
        tblLocation.Location ,
        tblFeeDetail.CancelDays ,
        tblFeeDetail.DrFee ,
        tblFeeDetail.DrLateCancelFee ,
        tblFeeDetail.DrNoShowFee ,
        tblFeeDetail.CancelDays2 ,
        tblFeeDetail.CancelDays3 ,
        tblFeeDetail.LateCancelFee2 ,
        tblFeeDetail.LateCancelFee3 ,
        tblFeeDetail.DrLateCancelFee2 ,
        tblFeeDetail.DrLateCancelFee3
FROM    tblFeeHeader
        INNER JOIN tblFeeDetail ON tblFeeHeader.FeeCode = tblFeeDetail.FeeCode
        INNER JOIN tblProduct ON tblFeeDetail.ProdCode = tblProduct.ProdCode
        LEFT OUTER JOIN tblLocation ON tblFeeHeader.DoctorLocation = tblLocation.LocationCode
        LEFT OUTER JOIN tblDoctor ON tblFeeHeader.DoctorCode = tblDoctor.DoctorCode
GO


UPDATE tblControl SET DBVersion='2.77'
GO