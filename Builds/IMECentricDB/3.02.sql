PRINT N'Altering [dbo].[tblConfirmationResult]...';


GO
ALTER TABLE [dbo].[tblConfirmationResult]
    ADD [HandleMethod] INT CONSTRAINT [DF_tblConfirmationResult_HandleMethod] DEFAULT ((1)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationSetup]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup] DROP COLUMN [Phone];


GO
PRINT N'Altering [dbo].[tblWebEventsOverride]...';


GO
ALTER TABLE [dbo].[tblWebEventsOverride] ALTER COLUMN [Type] VARCHAR (20) NULL;


GO
PRINT N'Altering [dbo].[spCompanyCases]...';


GO
ALTER PROCEDURE spCompanyCases
    @CompanyCode AS INTEGER
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS ExamineeName,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS ClientName,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc AS OfficeName
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCompany.CompanyCode=@CompanyCode
    ORDER BY
        tblCase.ApptDate DESC
GO



DELETE FROM	tblWebEvents WHERE Code = 110
GO
SET IDENTITY_INSERT tblWebEvents ON
INSERT tblWebEvents (Code, Description, DateAdded, UserIdAdded, [Type], PublishOnWeb, PublishedTo, NotifyTo) VALUES (110, 'Confirmation', GETDATE(), 'System', 'Confirmation', 1, 'CL', '')
SET IDENTITY_INSERT tblWebEvents OFF
GO
DELETE FROM	tblWebEventsOverride WHERE WebEventsCode = 110
GO

INSERT INTO tblUserFunction VALUES ('ServiceWorkflowRqdFrcstEdit','Services Workflow Reqd/Fcst - Add/Edit')
GO

UPDATE tblConfirmationResult SET HandleMethod=1
UPDATE tblConfirmationResult SET HandleMethod=2 WHERE ResultCode IN ('O','W',' ','#','P','\')
GO

UPDATE tblControl SET DBVersion='3.02'
GO
