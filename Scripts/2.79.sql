PRINT N'Altering [dbo].[tblEWBulkBilling]...';


GO
ALTER TABLE [dbo].[tblEWBulkBilling]
    ADD [Param] VARCHAR (1024) NULL;


GO
PRINT N'Altering [dbo].[vwAbetonCompanyFees]...';


GO

ALTER VIEW vwAbetonCompanyFees
AS
    SELECT
        tblFeeHeader.FeeCode,
        tblFeeHeader.Feedesc,
        tblFeeHeader.Begin_Date,
        tblFeeHeader.End_Date,
        tblProduct.Description AS ProductDesc,
        tblFeeDetailAbeton.latecancelfee AS FSLateCancel,
        tblFeeDetailAbeton.noshowfee AS FSNoShow,
        tblFeeDetailAbeton.canceldays AS FSCancelDays,
        tblFeeDetailAbeton.flatfee,
        tblFeeDetailAbeton.OfficeCode,
        tblFeeDetailAbeton.CaseType,
        tblFeeDetailAbeton.ProdCode
    FROM
        tblFeeDetailAbeton
    INNER JOIN tblFeeHeader ON tblFeeDetailAbeton.FeeCode=tblFeeHeader.FeeCode
    INNER JOIN tblProduct ON tblFeeDetailAbeton.ProdCode=tblProduct.ProdCode
GO
PRINT N'Altering [dbo].[vwAbetonProviderFees]...';


GO
ALTER VIEW vwAbetonProviderFees
AS
    SELECT
        tblFeeHeader.FeeCode,
        tblFeeHeader.Feedesc,
        tblFeeHeader.Begin_Date,
        tblFeeHeader.End_Date,
        tblAbetonProviderFees.ProdCode,
        tblAbetonProviderFees.ProviderFee AS DrFee,
        tblAbetonProviderFees.InvoiceAmount AS Fee,
        tblAbetonProviderFees.InvoiceNoShowFee AS NoShowFee,
        tblAbetonProviderFees.VoucherNoShowFee AS DrNoShowFee,
        tblAbetonProviderFees.InvoiceLateCancelFee AS LateCancelFee,
        tblAbetonProviderFees.VoucherLateCancelFee AS DrLateCancelFee,
        tblAbetonProviderFees.LateCancelDays AS CancelDays,
        tblProduct.Description AS ProductDesc,
        tblAbetonProviderFees.DrOpCode,
        tblAbetonProviderFees.OfficeCode,
        tblAbetonProviderFees.CaseType,
        tblFeeDetailAbeton.latecancelfee AS FSLateCancel,
        tblFeeDetailAbeton.noshowfee AS FSNoShow,
        tblFeeDetailAbeton.canceldays AS FSCancelDays,
        tblFeeDetailAbeton.flatfee,
        tblFeeDetailAbeton.feeplus,
        tblFeeDetailAbeton.MinFee,
        tblFeeDetailAbeton.Rounding,
        tblFeeDetailAbeton.RoundOn,
        tblFeeDetailAbeton.Divisor,
        tblFeeDetailAbeton.RevenueAcct,
        tblFeeDetailAbeton.ExpenseAcct,
        tblFeeDetailAbeton.Dept
    FROM
        tblFeeDetailAbeton
    INNER JOIN tblFeeHeader ON tblFeeDetailAbeton.FeeCode=tblFeeHeader.FeeCode
    INNER JOIN tblProduct
    INNER JOIN tblAbetonProviderFees ON tblProduct.ProdCode=tblAbetonProviderFees.ProdCode ON tblFeeDetailAbeton.FeeCode=tblAbetonProviderFees.FeeCode AND
                                                              tblFeeDetailAbeton.OfficeCode=tblAbetonProviderFees.OfficeCode AND
                                                              tblFeeDetailAbeton.CaseType=tblAbetonProviderFees.CaseType AND
                                                              tblFeeDetailAbeton.ProdCode=tblAbetonProviderFees.ProdCode
GO
PRINT N'Altering [dbo].[vwAcctException]...';


GO
ALTER VIEW vwAcctException
AS
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
        tblCompany.IntName AS company,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblCase.VoucherAmt,
        tblCase.VoucherDate,
        tblCase.InvoiceDate,
        tblCase.InvoiceAmt,
        tblCase.OfficeCode,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    WHERE
        (tblCase.Status=8) AND
        (tblCase.VoucherAmt<>0) AND
        (tblCase.InvoiceAmt=0) OR
        (tblCase.Status=8) AND
        (tblCase.VoucherAmt=0) AND
        (tblCase.InvoiceAmt<>0)
GO
PRINT N'Altering [dbo].[vwApptHoldRpt]...';


GO
ALTER VIEW vwApptHoldRpt
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
GO
PRINT N'Altering [dbo].[vwApptLogByAppt]...';


GO
ALTER VIEW vwApptLogByAppt
AS
    SELECT
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS Client,
        tblCompany.IntName AS Company,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS Examinee,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        GETDATE() AS today,
        tblCase.QARep AS QARepcode,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        (
         SELECT TOP 1
            tblCaseAppt.ApptTime
         FROM
            tblCaseAppt
         WHERE
            tblCaseAppt.CaseNbr=tblCase.CaseNbr AND
            tblCaseAppt.CaseApptID<tblCase.CaseApptID
         ORDER BY
            tblCaseAppt.CaseApptID DESC
        ) AS PreviousApptTime,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone AS DoctorPhone,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS DoctorSortName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    LEFT OUTER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
    GROUP BY
        tblCase.ApptDate,
        tblCaseType.ShortDesc,
        tblCase.DoctorName,
        tblClient.FirstName+' '+tblClient.LastName,
        tblCompany.IntName,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, ''),
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
        tblCase.CaseApptID,
        tblCase.ExtCaseNbr
GO
PRINT N'Altering [dbo].[vwApptLogByApptDocs]...';


GO
ALTER VIEW vwApptLogByApptDocs
AS
    SELECT
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS client,
        tblCompany.IntName AS Company,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS Examinee,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        GETDATE() AS today,
        tblCase.QARep AS QARepcode,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        (
         SELECT TOP 1
            tblCaseAppt.ApptTime
         FROM
            tblCaseAppt
         WHERE
            tblCaseAppt.CaseNbr=tblCase.CaseNbr AND
            tblCaseAppt.CaseApptID<tblCase.CaseApptID
         ORDER BY
            tblCaseAppt.CaseApptID DESC
        ) AS PreviousApptTime,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone AS DoctorPhone,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS DoctorSortName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    LEFT OUTER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
    GROUP BY
        tblCase.ApptDate,
        tblCaseType.ShortDesc,
        tblCase.DoctorName,
        tblClient.FirstName+' '+tblClient.LastName,
        tblCompany.IntName,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, ''),
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.CaseApptID
    UNION
    SELECT
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS client,
        tblCompany.IntName AS Company,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS Examinee,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        GETDATE() AS today,
        tblCase.QARep AS QARepcode,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        (
         SELECT TOP 1
            tblCaseAppt.ApptTime
         FROM
            tblCaseAppt
         WHERE
            tblCaseAppt.CaseNbr=tblCase.CaseNbr AND
            tblCaseAppt.CaseApptID<tblCase.CaseApptID
         ORDER BY
            tblCaseAppt.CaseApptID DESC
        ) AS PreviousApptTime,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone AS DoctorPhone,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS DoctorSortName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    INNER JOIN tblCasePanel ON tblCase.PanelNbr=tblCasePanel.PanelNbr
    INNER JOIN tblDoctor ON tblCasePanel.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    LEFT OUTER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    WHERE
        (tblCase.Status<>9)
    GROUP BY
        tblCase.ApptDate,
        tblCaseType.ShortDesc,
        tblCase.DoctorName,
        tblClient.FirstName+' '+tblClient.LastName,
        tblCompany.IntName,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, ''),
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.CaseApptID
GO
PRINT N'Altering [dbo].[vwApptsByMth]...';


GO
ALTER VIEW vwApptsByMth
AS
    SELECT DISTINCT
        tblCase.CaseNbr,
        tblCaseAppt.DoctorCode,
        tblCaseAppt.LocationCode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        CASE WHEN tblCaseAppt.ApptStatusID=101 THEN 'NoShow'
             ELSE 'Show'
        END AS EventDesc,
        ISNULL(tblUser.LastName, '')+
        CASE WHEN ISNULL(tblUser.LastName, '')='' OR
                  ISNULL(tblUser.FirstName, '')='' THEN ''
             ELSE ', '
        END+ISNULL(tblUser.FirstName, '') AS marketer,
        CASE WHEN tblCaseAppt.ApptStatusID=101 THEN 'NoShow'
             ELSE 'Show'
        END AS Type,
        tblCase.ApptDate,
        tblCompany.IntName AS companyname,
        tblClient.FirstName+' '+tblClient.LastName AS adjustername,
        tblClient.LastName,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=1 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS janns,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=2 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS febns,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=3 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS marns,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=4 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS aprns,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=5 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS mayns,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=6 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS junns,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=7 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS julns,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=8 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS augns,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=9 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS sepns,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=10 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS octns,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=11 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS novns,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        CASE WHEN MONTH(tblCase.ApptDate)=12 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS decns,
        1 AS total,
        CASE WHEN tblCaseAppt.ApptStatusID=101 OR
                  tblCase.Status=9 THEN 1
             ELSE 0
        END AS totalns,
        tblCase.OfficeCode
    FROM
        tblCase
    INNER JOIN tblCaseAppt ON tblCase.CaseNbr=tblCaseAppt.CaseNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCaseAppt.DoctorCode=tblDoctor.DoctorCode
    WHERE
        tblCaseAppt.ApptStatusID IN (100, 101)
GO
PRINT N'Altering [dbo].[vwCaseIssue]...';


GO
ALTER VIEW vwCaseIssue
AS
    SELECT
        tblCaseIssue.CaseNbr,
        tblCaseIssue.IssueCode,
        tblIssue.Description,
        tblIssue.Instruction
    FROM
        tblCaseIssue
    INNER JOIN tblIssue ON tblCaseIssue.IssueCode=tblIssue.IssueCode
GO
PRINT N'Altering [dbo].[vwCaseOtherParty]...';


GO
ALTER VIEW vwCaseOtherParty
AS
    SELECT
        tblCaseOtherParty.CaseNbr,
        tblDoctor.DoctorCode,
        tblDoctor.Prefix,
        tblDoctor.Addr1,
        tblDoctor.Addr2,
        tblDoctor.City,
        tblDoctor.State,
        tblDoctor.Zip,
        tblDoctor.Phone,
        tblDoctor.PhoneExt,
        tblDoctor.FaxNbr,
        tblDoctor.EmailAddr,
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctor.CompanyName,
        tblDoctor.OPSubType AS type
    FROM
        tblCaseOtherParty
    INNER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
    WHERE
        (tblDoctor.OPType='OP')
GO
PRINT N'Altering [dbo].[vwCaseServices]...';


GO
ALTER VIEW vwCaseServices
AS
    SELECT
        tblCase.CaseNbr,
        tblCaseOtherParty.DueDate,
        tblCaseOtherParty.Status,
        tblCase.OfficeCode,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.DoctorCode,
        tblExaminee.FirstName+' '+tblClient.LastName AS examineename,
        ISNULL(tblDoctor.FirstName, '')+' '+tblDoctor.LastName AS doctorname,
        tblCaseOtherParty.UserIDResponsible,
        tblCase.ApptDate,
        tblServices.ShortDesc AS service,
        tblServices.ServiceCode,
        tblDoctor.CompanyName,
        tblDoctor.OPSubType AS type
    FROM
        tblCaseOtherParty
    INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr=tblCase.CaseNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
GO
PRINT N'Altering [dbo].[vwCaseTypeOffice]...';


GO

ALTER VIEW vwCaseTypeOffice
AS
    SELECT  tblCaseTypeOffice.CaseType ,
            tblCaseType.Description ,
            tblCaseTypeOffice.OfficeCode ,
            tblCaseType.Code ,
            tblCaseType.DateAdded ,
            tblCaseType.UserIDAdded ,
            tblCaseType.DateEdited ,
            tblCaseType.UserIDEdited ,
            tblCaseType.InstructionFilename ,
            tblCaseType.Status
    FROM    tblcaseTypeOffice
            INNER JOIN tblCaseType ON tblCaseTypeOffice.CaseType = tblCaseType.Code
GO
PRINT N'Altering [dbo].[vwCaseTypeService]...';


GO

ALTER VIEW vwCaseTypeService
AS
    SELECT  tblCaseTypeService.CaseType ,
            tblCaseTypeService.ServiceCode ,
            tblCaseType.Description AS CaseTypeDesc ,
            tblServices.Description AS ServiceDesc ,
            tblServiceOffice.OfficeCode ,
            tblServices.ServiceType ,
            tblServices.ShowLegalTabOnCase ,
            tblServices.ApptBased
    FROM    tblCaseTypeService
            INNER JOIN tblServices ON tblCaseTypeService.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblCaseType ON tblCaseTypeService.CaseType = tblCaseType.Code
            INNER JOIN tblServiceOffice ON tblCaseTypeService.ServiceCode = tblServiceOffice.ServiceCode
                                               AND tblCaseTypeService.OfficeCode = tblServiceOffice.OfficeCode
    WHERE   ( tblCaseType.Status = 'Active' )
            AND ( tblServices.Status = 'Active' )
GO
PRINT N'Altering [dbo].[vwClaimNbrCheck]...';


GO
ALTER VIEW vwClaimNbrCheck
AS
    SELECT
        tblCase.ClaimNbr,
        tblCase.ClaimNbrExt,
        tblCase.DoctorName,
        tblSpecialty.Description AS Specialty,
        tblQueues.StatusDesc AS Status,
        tblCaseType.Description AS CaseType,
        tblServices.Description AS Service,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
GO
PRINT N'Altering [dbo].[vwClientWebAcct]...';


GO
ALTER VIEW vwClientWebAcct
AS
    SELECT  tblCompany.intname AS company ,
            tblClient.lastname ,
            tblClient.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblClient ON tblWebUser.WebUserID = tblClient.WebUserID
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
    WHERE   ( tblWebUser.UserType = 'CL' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  'Doctor/Provider' AS Company ,
            tblDoctor.lastname ,
            tblDoctor.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblDoctor ON tblWebUser.WebUserID = tblDoctor.WebUserID
    WHERE   ( tblWebUser.UserType = 'DR' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblDoctor.companyname AS Company ,
            tblDoctor.lastname ,
            tblDoctor.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblDoctor ON tblWebUser.WebUserID = tblDoctor.WebUserID
    WHERE   ( tblWebUser.UserType = 'OP' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblCCAddress.company ,
            tblCCAddress.lastname ,
            tblCCAddress.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblCCAddress ON tblWebUser.WebUserID = tblCCAddress.WebUserID
    WHERE   ( ( tblWebUser.UserType = 'AT' )
              OR ( tblWebUser.UserType = 'CC' )
            )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblTranscription.transcompany AS company ,
            '' AS lastname ,
            '' AS firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblTranscription ON tblWebUser.WebUserID = tblTranscription.WebUserID
    WHERE   ( tblWebUser.UserType = 'TR' )
            AND tblWebUser.StatusID <> 2
GO
PRINT N'Altering [dbo].[vwDoctorKeyword]...';


GO
ALTER VIEW vwDoctorKeyword
AS
    SELECT
        tblDoctorKeyWord.DoctorCode,
        tblDoctorKeyWord.KeywordID,
        tblKeyWord.Keyword
    FROM
        tblDoctorKeyWord
    INNER JOIN tblKeyWord ON tblDoctorKeyWord.KeywordID=tblKeyWord.KeywordID
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
            tblLocation.Location ,
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
			tblCase.ExtCaseNbr , 
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
PRINT N'Altering [dbo].[vwDrSchedule]...';


GO
ALTER VIEW vwDrSchedule
AS
    SELECT
        tblDoctorSchedule.DoctorCode,
        tblDoctorSchedule.LocationCode,
        tblDoctorSchedule.date,
        tblDoctorSchedule.StartTime,
        tblDoctorSchedule.Status,
        tblDoctorSchedule.Duration,
        tblDoctorSchedule.CaseNbr1,
        tblDoctorSchedule.CaseNbr1desc,
        tblDoctorSchedule.CaseNbr2,
        tblDoctorSchedule.CaseNbr2desc,
        tblDoctorSchedule.DateAdded,
        tblDoctorSchedule.UserIDAdded,
        tblDoctorSchedule.DateEdited,
        tblDoctorSchedule.UserIDEdited,
        tblDoctorSchedule.SchedCode,
        tblDoctorSchedule.CaseNbr3,
        tblDoctorSchedule.CaseNbr3Desc,
        tblServices_1.ShortDesc AS service1,
        tblCaseType_1.ShortDesc+'/'+tblServices_1.ShortDesc AS casetype1,
        tblServices_2.ShortDesc AS service2,
        tblCaseType_2.ShortDesc+'/'+tblServices_2.ShortDesc AS casetype2,
        tblCaseType_3.ShortDesc+'/'+tblServices_3.ShortDesc AS casetype3,
        tblServices_3.ShortDesc AS service3
    FROM
        tblCaseType tblCaseType_3
    RIGHT OUTER JOIN tblServices tblServices_3
    RIGHT OUTER JOIN tblCase tblCase_3 ON tblServices_3.ServiceCode=tblCase_3.ServiceCode ON tblCaseType_3.Code=tblCase_3.CaseType
    RIGHT OUTER JOIN tblDoctorSchedule ON tblCase_3.CaseNbr=tblDoctorSchedule.CaseNbr3
    LEFT OUTER JOIN tblCaseType tblCaseType_2
    RIGHT OUTER JOIN tblServices tblServices_2
    RIGHT OUTER JOIN tblCase tblcase_2 ON tblServices_2.ServiceCode=tblcase_2.ServiceCode ON tblCaseType_2.Code=tblcase_2.CaseType ON tblDoctorSchedule.CaseNbr2=tblcase_2.CaseNbr
    LEFT OUTER JOIN tblCaseType tblCaseType_1
    RIGHT OUTER JOIN tblCase tblCase_1 ON tblCaseType_1.Code=tblCase_1.CaseType
    LEFT OUTER JOIN tblServices tblServices_1 ON tblCase_1.ServiceCode=tblServices_1.ServiceCode ON tblDoctorSchedule.CaseNbr1=tblCase_1.CaseNbr
GO
PRINT N'Altering [dbo].[vwFees]...';


GO
ALTER VIEW vwFees
AS
    SELECT
        tblProduct.ProdCode,
        tblProduct.Description,
        tblProduct.LongDesc,
        tblProduct.CPTCode,
        tblFeeDetail.Fee,
        tblFeeDetail.LateCancelFee,
        tblFeeDetail.NoShowFee,
        tblFeeHeader.FeeCode AS Expr1,
        tblFeeHeader.FeeType,
        tblFeeHeader.Begin_Date,
        tblFeeHeader.End_Date,
        tblFeeHeader.LastUsed,
        tblProduct.Taxable,
        tblProduct.Status,
        tblProduct.INGLAcct,
        tblFeeHeader.Feedesc,
        tblFeeDetail.FeeCode,
        tblProduct.VOGLAcct,
        tblFeeDetail.CancelDays,
        tblFeeDetail.DrFee,
        tblFeeDetail.DrLateCancelFee,
        tblFeeDetail.DrNoShowFee,
        tblFeeHeader.DoctorCode,
        tblFeeHeader.DoctorLocation,
        tblFeeDetail.CancelDays2,
        tblFeeDetail.LateCancelFee2,
        tblFeeDetail.CancelDays3,
        tblFeeDetail.LateCancelFee3,
        tblFeeDetail.DrLateCancelFee2,
        tblFeeDetail.DrLateCancelFee3,
        tblFeeDetail.RecordInchesIncluded
    FROM
        tblProduct
    INNER JOIN tblFeeDetail ON tblProduct.ProdCode=tblFeeDetail.ProdCode
    INNER JOIN tblFeeHeader ON tblFeeDetail.FeeCode=tblFeeHeader.FeeCode
GO
PRINT N'Altering [dbo].[vwIMOLateCancel]...';


GO
ALTER VIEW vwIMOLateCancel
AS
    SELECT
        tblCase.ChartNbr,
        tblCase.CaseNbr,
        tblCase.ClaimNbr,
        tblCaseHistory.Type,
        tblCaseHistory.EventDate
    FROM
        tblCase
    RIGHT OUTER JOIN tblCaseHistory ON tblCase.CaseNbr=tblCaseHistory.CaseNbr
    WHERE
        (tblCaseHistory.Type='LateCancel')
GO
PRINT N'Altering [dbo].[vwOpenDrSchedule]...';


GO
ALTER VIEW vwOpenDrSchedule
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
GO
PRINT N'Altering [dbo].[vwProfit]...';


GO
ALTER VIEW vwProfit
AS
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblCompany.IntName AS company,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblCase.VoucherAmt,
        tblCase.VoucherDate,
        tblCase.InvoiceDate,
        tblCase.InvoiceAmt,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType,
        tblCaseType.Description AS casetypedesc,
        tblCase.DoctorCode,
        tblCase.DoctorName,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
GO
PRINT N'Altering [dbo].[vwProfitDocs]...';


GO
ALTER  VIEW vwProfitDocs
AS
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
        tblCompany.IntName AS company,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblCase.VoucherAmt,
        tblCase.VoucherDate,
        tblCase.InvoiceDate,
        tblCase.InvoiceAmt,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        tblDoctor.DoctorCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    UNION
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
        tblCompany.IntName AS company,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblCase.VoucherAmt,
        tblCase.VoucherDate,
        tblCase.InvoiceDate,
        tblCase.InvoiceAmt,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        tblDoctor.DoctorCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblCasePanel ON tblCase.PanelNbr=tblCasePanel.PanelNbr
    INNER JOIN tblDoctor ON tblCasePanel.DoctorCode=tblDoctor.DoctorCode
GO
PRINT N'Altering [dbo].[vwReferralbyMonthAppt]...';


GO
ALTER VIEW vwReferralbyMonthAppt
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.Status,
        tblCase.DoctorLocation AS locationcode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        ISNULL(tblUser.LastName, '')+
        CASE WHEN ISNULL(tblUser.LastName, '')='' OR
                  ISNULL(tblUser.FirstName, '')='' THEN ''
             ELSE ', '
        END+ISNULL(tblUser.FirstName, '') AS marketer,
        tblCase.DateAdded,
        tblCompany.IntName AS companyname,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.LastName,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        1 AS total,
        tblCaseType.Description AS CasetypeDesc,
        tblServices.Description AS service,
        tblServices.ServiceCode,
        tblCase.CaseType,
        tblCase.OfficeCode,
        tblOffice.Description AS officename,
        tblCase.QARep AS QARepCode,
        tblDoctor.DoctorCode,
        tblCase.DoctorLocation
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
GO
PRINT N'Altering [dbo].[vwReferralbyMonthApptDocs]...';


GO
ALTER VIEW vwReferralbyMonthApptDocs
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.Status,
        tblCase.DoctorLocation AS locationcode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        ISNULL(tblUser.LastName, '')+
        CASE WHEN ISNULL(tblUser.LastName, '')='' OR
                  ISNULL(tblUser.FirstName, '')='' THEN ''
             ELSE ', '
        END+ISNULL(tblUser.FirstName, '') AS marketer,
        tblCase.DateAdded,
        tblCompany.IntName AS companyname,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.LastName,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        1 AS total,
        tblCaseType.Description AS CasetypeDesc,
        tblServices.Description AS service,
        tblServices.ServiceCode,
        tblCase.CaseType,
        tblCase.OfficeCode,
        tblOffice.Description AS officename,
        tblCase.QARep AS QARepCode,
        tblDoctor.DoctorCode
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
    UNION
    SELECT
        tblCase.CaseNbr,
        tblCase.Status,
        tblCase.DoctorLocation AS locationcode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        tblUser.LastName+', '+tblUser.FirstName AS marketer,
        tblCase.DateAdded,
        tblCompany.IntName AS companyname,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.LastName,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        1 AS total,
        tblCaseType.Description AS CasetypeDesc,
        tblServices.Description AS service,
        tblServices.ServiceCode,
        tblCase.CaseType,
        tblCase.OfficeCode,
        tblOffice.Description AS officename,
        tblCase.QARep AS QARepCode,
        tblDoctor.DoctorCode
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    INNER JOIN tblCasePanel ON tblCase.PanelNbr=tblCasePanel.PanelNbr
    INNER JOIN tblDoctor ON tblCasePanel.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    WHERE
        (tblCase.Status<>9)
GO
PRINT N'Altering [dbo].[vwReferralbyMonthDateReceived]...';


GO
ALTER VIEW vwReferralbyMonthDateReceived
AS
    SELECT  tblCase.casenbr ,
            tblCase.status ,
            tblCase.doctorlocation AS locationcode ,
            tblCase.marketercode ,
            tblCase.clientcode ,
            tblClient.companycode ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            tblCase.DateReceived ,
            tblCompany.intname AS companyname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblClient.lastname ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS doctorname ,
            tblLocation.location ,
            YEAR(tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            tblCaseType.description AS CasetypeDesc ,
            tblServices.description AS service ,
            tblServices.servicecode ,
            tblCase.casetype ,
            tblCase.officecode ,
            tblOffice.description AS officename ,
            tblCase.QARep AS QARepcode ,
            tblDoctor.doctorcode
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblUser ON tblCase.marketercode = tblUser.userid
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
    WHERE   ( tblCase.status <> 9 )
GO
PRINT N'Altering [dbo].[vwReferralbyMonthDateReceivedDocs]...';


GO
ALTER VIEW vwReferralbyMonthDateReceivedDocs
AS
    SELECT  tblCase.casenbr ,
            tblCase.status ,
            tblCase.doctorlocation AS locationcode ,
            tblCase.marketercode ,
            tblCase.clientcode ,
            tblClient.companycode ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            tblCase.DateReceived ,
            tblCompany.intname AS companyname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblClient.lastname ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS doctorname ,
            tblLocation.location ,
            YEAR(tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            tblCaseType.description AS CasetypeDesc ,
            tblServices.description AS service ,
            tblServices.servicecode ,
            tblCase.casetype ,
            tblCase.officecode ,
            tblOffice.description AS officename ,
            tblCase.QARep AS QARepCode ,
            tblDoctor.doctorcode
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblUser ON tblCase.marketercode = tblUser.userid
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
    WHERE   ( tblCase.status <> 9 )
    UNION
    SELECT  tblCase.casenbr ,
            tblCase.status ,
            tblCase.doctorlocation AS locationcode ,
            tblCase.marketercode ,
            tblCase.clientcode ,
            tblClient.companycode ,
            tblUser.lastname + ', ' + tblUser.firstname AS marketer ,
            tblCase.DateReceived ,
            tblCompany.intname AS companyname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblClient.lastname ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS doctorname ,
            tblLocation.location ,
            YEAR(tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            tblCaseType.description AS CasetypeDesc ,
            tblServices.description AS service ,
            tblServices.servicecode ,
            tblCase.casetype ,
            tblCase.officecode ,
            tblOffice.description AS officename ,
            tblCase.QARep AS QARepcode ,
            tblDoctor.doctorcode
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.panelnbr
            INNER JOIN tblDoctor ON tblCasePanel.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblUser ON tblCase.marketercode = tblUser.userid
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
    WHERE   ( tblCase.status <> 9 )
GO
PRINT N'Altering [dbo].[vwRptMEINotification]...';


GO
ALTER VIEW vwRptMEINotification
AS
    SELECT
        tblCase.CaseNbr,
        tblExaminee.Addr1 AS examineeaddr1,
        tblExaminee.Addr2 AS examineeaddr2,
        tblExaminee.City+', '+tblExaminee.State+'  '+
        tblExaminee.Zip AS examineecitystatezip,
        tblLocation.Addr1 AS doctoraddr1,
        tblLocation.Addr2 AS doctoraddr2,
        tblLocation.City+', '+tblLocation.State+'  '+
        tblLocation.Zip AS doctorcitystatezip,
        tblCase.ApptDate,
        tblCase.ApptTime,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblExaminee.Phone1 AS examineephone,
        tblCCAddress_2.FirstName+' '+tblCCAddress_2.LastName AS attorneyname,
        tblCCAddress_2.Company AS attorneycompany,
        tblCCAddress_2.Address1 AS attorneyaddr1,
        tblCCAddress_2.Address2 AS attorneyaddr2,
        tblCCAddress_2.City+', '+tblCCAddress_2.State+'  '+tblCCAddress_2.Zip AS attorneycitystatezip,
        tblCCAddress_2.Phone+ISNULL(tblCCAddress_2.PhoneExtension, '') AS attorneyphone,
        tblCCAddress_2.Fax AS attorneyfax,
        tblCCAddress_2.Email AS attorneyemail,
        tblLocation.Location,
        tblExaminee.Email AS examineeemail,
        tblCase.OfficeCode,
        tblCase.DoctorName,
        tblCase.bln3DayNotifClaimant,
        tblCase.bln3DayNotifAttorney,
        tblCase.bln14DayNotifClaimant,
        tblCase.bln14DayNotifAttorney,
        tblServices.Description AS servicedesc,
        tblCase.DoctorCode,
        tblCase.Status
    FROM
        tblOffice
    INNER JOIN tblExaminee
    INNER JOIN tblCase ON tblExaminee.ChartNbr=tblCase.ChartNbr ON tblOffice.OfficeCode=tblCase.OfficeCode
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.PlaintiffAttorneyCode=tblCCAddress_2.ccCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    UNION
    SELECT
        tblCase_1.CaseNbr,
        tblExaminee_1.Addr1 AS examineeaddr1,
        tblExaminee_1.Addr2 AS examineeaddr2,
        tblExaminee_1.City+', '+tblExaminee_1.State+'  '+tblExaminee_1.Zip AS examineecitystatezip,
        tblLocation_1.Addr1 AS doctoraddr1,
        tblLocation_1.Addr2 AS doctoraddr2,
        tblLocation_1.City+', '+tblLocation_1.State+'  '+tblLocation_1.Zip AS doctorcitystatezip,
        tblCase_1.ApptDate,
        tblCase_1.ApptTime,
        tblExaminee_1.FirstName+' '+tblExaminee_1.LastName AS examineename,
        tblExaminee_1.Phone1 AS examineephone,
        tblCCAddress_2.FirstName+' '+tblCCAddress_2.LastName AS attorneyname,
        tblCCAddress_2.Company AS attorneycompany,
        tblCCAddress_2.Address1 AS attorneyaddr1,
        tblCCAddress_2.Address2 AS attorneyaddr2,
        tblCCAddress_2.City+', '+tblCCAddress_2.State+'  '+tblCCAddress_2.Zip AS attorneycitystatezip,
        tblCCAddress_2.Phone+ISNULL(tblCCAddress_2.PhoneExtension, '') AS attorneyphone,
        tblCCAddress_2.Fax AS attorneyfax,
        tblCCAddress_2.Email AS attorneyemail,
        tblLocation_1.Location,
        tblExaminee_1.Email AS examineeemail,
        tblCase_1.OfficeCode,
        tblCase_1.DoctorName,
        tblCase_1.bln3DayNotifClaimant,
        tblCase_1.bln3DayNotifAttorney,
        tblCase_1.bln14DayNotifClaimant,
        tblCase_1.bln14DayNotifAttorney,
        tblServices_1.Description AS servicedesc,
        tblCasePanel.DoctorCode,
        tblCase_1.Status
    FROM
        tblOffice AS tblOffice_1
    INNER JOIN tblExaminee AS tblExaminee_1
    INNER JOIN tblCase AS tblCase_1 ON tblExaminee_1.ChartNbr=tblCase_1.ChartNbr ON tblOffice_1.OfficeCode=tblCase_1.OfficeCode
    INNER JOIN tblServices AS tblServices_1 ON tblCase_1.ServiceCode=tblServices_1.ServiceCode
    INNER JOIN tblCasePanel ON tblCase_1.PanelNbr=tblCasePanel.PanelNbr
    LEFT OUTER JOIN tblLocation AS tblLocation_1 ON tblCase_1.DoctorLocation=tblLocation_1.LocationCode
    LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase_1.PlaintiffAttorneyCode=tblCCAddress_2.ccCode
GO
PRINT N'Altering [dbo].[vwRptOutstandingAuthorizations]...';


GO
ALTER VIEW vwRptOutstandingAuthorizations
AS
    SELECT TOP 100 PERCENT
        tblExaminee.LastName+', '+tblExaminee.FirstName AS Examinee,
        tblCase.ClaimNbr,
        tblCase.CaseNbr,
        tblRecordsObtainment.DateRequested,
        tblRecordsObtainment.DateReceived,
        tblCCAddress.LastName+', '+tblCCAddress.FirstName AS AttorneyName,
        tblCCAddress.Company AS FirmName,
        tblCCAddress.Phone,
        tblCCAddress.Fax,
        DATEDIFF(dd, tblRecordsObtainment.DateRequested, GETDATE()) AS DOS,
        tblCase.OfficeCode,
        tblCase.ExtCaseNbr
    FROM
        tblRecordsObtainment
    INNER JOIN tblCase ON tblRecordsObtainment.CaseNbr=tblCase.CaseNbr
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    LEFT OUTER JOIN tblCCAddress ON tblCase.PlaintiffAttorneyCode=tblCCAddress.ccCode
    WHERE
        (tblRecordsObtainment.ObtainmentTypeID=1) AND
        (tblRecordsObtainment.DateReceived IS NULL)
GO
PRINT N'Altering [dbo].[vwServiceOffice]...';


GO
ALTER VIEW vwServiceOffice
AS
    SELECT
        tblServiceOffice.ServiceCode,
        tblServices.Description,
        tblServiceOffice.OfficeCode,
        tblServices.ShortDesc,
        tblServices.Status
    FROM
        tblServiceOffice
    INNER JOIN tblServices ON tblServiceOffice.ServiceCode=tblServices.ServiceCode
GO
PRINT N'Altering [dbo].[vwSpecialServices]...';


GO
ALTER VIEW vwSpecialServices
AS
    SELECT
        tblCaseOtherParty.CaseNbr,
        tblCaseOtherParty.Type,
        tblCaseOtherParty.DueDate,
        tblCaseOtherParty.UserIDResponsible,
        tblCaseOtherParty.Status,
        ISNULL(tblDoctor.FirstName, '')+' '+ISNULL(tblDoctor.LastName,
                                                       '') AS contactname,
        tblDoctor.Addr1,
        tblDoctor.Addr2,
        tblDoctor.City,
        tblDoctor.State,
        tblDoctor.Zip,
        tblDoctor.Phone,
        tblDoctor.PhoneExt,
        tblDoctor.FaxNbr,
        tblDoctor.EmailAddr,
        tblDoctor.CompanyName,
        vwDocument.ExamineeName,
        vwDocument.ExamineeAddr1,
        vwDocument.ExamineeAddr2,
        vwDocument.ExamineeCityStateZip,
        vwDocument.ClientName,
        vwDocument.Company,
        vwDocument.DoctorName,
        vwDocument.DoctorAddr1,
        vwDocument.DoctorAddr2,
        vwDocument.DoctorCityStateZip,
        vwDocument.ApptDate,
        vwDocument.Appttime,
        vwDocument.DoctorPhone,
        vwDocument.Location,
        vwDocument.ExamineePhone,
        vwDocument.officeCode,
        tblCaseOtherParty.Description,
        vwDocument.StatusDesc,
        vwDocument.ExtCaseNbr
    FROM
        tblCaseOtherParty
    INNER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
    INNER JOIN vwDocument ON tblCaseOtherParty.CaseNbr=vwDocument.CaseNbr
GO
PRINT N'Altering [dbo].[vwUpdateLastStatus]...';


GO
ALTER VIEW vwUpdateLastStatus
AS
    SELECT
        tblCase.CaseNbr,
        tblCaseHistory.EventDate,
        LEFT(tblCaseHistory.Eventdesc, 10) AS Expr1,
        tblCaseHistory.OtherInfo
    FROM
        tblCase
    INNER JOIN tblCaseHistory ON tblCase.CaseNbr=tblCaseHistory.CaseNbr
    WHERE
        (LEFT(tblCaseHistory.Eventdesc, 10)='Status Chg')
GO
PRINT N'Altering [dbo].[vwVoucherSelect]...';


GO
ALTER VIEW vwVoucherSelect
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.doctorcode AS OpCode ,
            ISNULL(tblDoctor.lastname, '') + ', '
            + ISNULL(tblDoctor.firstname, '') + ' '
            + ISNULL(tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN tblDoctor ON TblCase.doctorcode = tblDoctor.doctorcode
    UNION
    SELECT  tblCase.CaseNbr ,
            tblCaseotherparty.OpCode AS OpCode ,
            tblDoctor.companyname AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN TblCaseOtherParty ON tblCase.CaseNbr = TblCaseOtherParty.CaseNbr
            INNER JOIN tblDoctor ON TblCaseOtherParty.OPCode = tblDoctor.doctorcode
    UNION
    SELECT  tblCase.CaseNbr ,
            tblCasePanel.doctorcode AS OpCode ,
            ISNULL(tblDoctor.lastname, '') + ', '
            + ISNULL(tblDoctor.firstname, '') + ' '
            + ISNULL(tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.panelNbr
            INNER JOIN tblDoctor ON tblCasePanel.doctorcode = tblDoctor.doctorcode
GO
PRINT N'Altering [dbo].[spClientCases]...';


GO
ALTER  PROCEDURE spClientCases
    @clientcode AS INTEGER
AS
    SELECT TOP 100 PERCENT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        'C' AS ClientType,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS examineename,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblDoctor.DoctorCode,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCase.ClientCode=@clientcode
    UNION
    SELECT TOP 100 PERCENT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        'B' AS ClientType,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS examineename,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblDoctor.DoctorCode,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCase.BillClientCode=@clientcode
    ORDER BY
        tblCase.ApptDate DESC
GO
PRINT N'Altering [dbo].[spCompanyCases]...';


GO
ALTER  PROCEDURE spCompanyCases
    @companycode AS INTEGER
AS
    SELECT TOP 100 PERCENT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS examineename,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblDoctor.DoctorCode,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCompany.CompanyCode=@companycode
    ORDER BY
        tblCase.ApptDate DESC
GO


UPDATE tblControl SET DBVersion='2.79'
GO