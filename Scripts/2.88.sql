PRINT N'Altering [dbo].[tblAcctDetail]...';


GO
ALTER TABLE [dbo].[tblAcctDetail]
    ADD [FeeCode] INT NULL;


GO
PRINT N'Creating [dbo].[tblServiceWorkflow].[IX_U_tblServiceWorkflow_OfficeCodeCaseTypeServiceCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblServiceWorkflow_OfficeCodeCaseTypeServiceCode]
    ON [dbo].[tblServiceWorkflow]([OfficeCode] ASC, [CaseType] ASC, [ServiceCode] ASC);


GO
PRINT N'Altering [dbo].[vwAbetonCompanyFees]...';


GO
ALTER VIEW vwAbetonCompanyFees
AS
    SELECT  tblFeeHeader.FeeCode ,
            tblFeeHeader.Feedesc ,
            tblFeeHeader.Begin_Date ,
            tblFeeHeader.End_Date ,
            tblProduct.Description AS ProductDesc ,
            tblFeeDetailAbeton.latecancelfee AS FSLateCancel ,
            tblFeeDetailAbeton.noshowfee AS FSNoShow ,
            tblFeeDetailAbeton.canceldays AS FSCancelDays ,
            tblFeeDetailAbeton.flatfee ,
            tblFeeDetailAbeton.OfficeCode ,
            tblFeeDetailAbeton.CaseType ,
            tblFeeDetailAbeton.ProdCode
    FROM    tblFeeHeader
            INNER JOIN tblFeeDetailAbeton ON tblFeeDetailAbeton.FeeCode = tblFeeHeader.FeeCode
            INNER JOIN tblProduct ON tblFeeDetailAbeton.ProdCode = tblProduct.ProdCode
GO
PRINT N'Altering [dbo].[vwAbetonProviderFees]...';


GO

ALTER VIEW vwAbetonProviderFees
AS
    SELECT  tblFeeHeader.FeeCode ,
            tblFeeHeader.Feedesc ,
            tblFeeHeader.Begin_Date ,
            tblFeeHeader.End_Date ,
            tblAbetonProviderFees.ProdCode ,
            tblAbetonProviderFees.ProviderFee AS DrFee ,
            tblAbetonProviderFees.InvoiceAmount AS Fee ,
            tblAbetonProviderFees.InvoiceNoShowFee AS NoShowFee ,
            tblAbetonProviderFees.VoucherNoShowFee AS DrNoShowFee ,
            tblAbetonProviderFees.InvoiceLateCancelFee AS LateCancelFee ,
            tblAbetonProviderFees.VoucherLateCancelFee AS DrLateCancelFee ,
            tblAbetonProviderFees.LateCancelDays AS CancelDays ,
            tblProduct.Description AS ProductDesc ,
            tblAbetonProviderFees.DrOpCode ,
            tblAbetonProviderFees.OfficeCode ,
            tblAbetonProviderFees.CaseType ,
            tblFeeDetailAbeton.latecancelfee AS FSLateCancel ,
            tblFeeDetailAbeton.noshowfee AS FSNoShow ,
            tblFeeDetailAbeton.canceldays AS FSCancelDays ,
            tblFeeDetailAbeton.flatfee ,
            tblFeeDetailAbeton.feeplus ,
            tblFeeDetailAbeton.MinFee ,
            tblFeeDetailAbeton.Rounding ,
            tblFeeDetailAbeton.RoundOn ,
            tblFeeDetailAbeton.Divisor ,
            tblFeeDetailAbeton.RevenueAcct ,
            tblFeeDetailAbeton.ExpenseAcct ,
            tblFeeDetailAbeton.Dept
    FROM    tblFeeHeader
            INNER JOIN tblFeeDetailAbeton ON tblFeeDetailAbeton.FeeCode = tblFeeHeader.FeeCode
            INNER JOIN tblAbetonProviderFees ON tblFeeDetailAbeton.FeeCode = tblAbetonProviderFees.FeeCode
                                                AND tblFeeDetailAbeton.OfficeCode = tblAbetonProviderFees.OfficeCode
                                                AND tblFeeDetailAbeton.CaseType = tblAbetonProviderFees.CaseType
                                                AND tblFeeDetailAbeton.ProdCode = tblAbetonProviderFees.ProdCode
            INNER JOIN tblProduct ON tblProduct.ProdCode = tblAbetonProviderFees.ProdCode
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
		tblCase.ExtCaseNbr,
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
		tblCase.ExtCaseNbr,
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
		tblCase.ExtCaseNbr,
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
		tblCase.ExtCaseNbr,
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



UPDATE tblControl SET DBVersion='2.88'
GO