
CREATE INDEX [IdxtblDoctor_BY_OPTypeLastNameFirstName] ON [tblDoctor]([OPType],[LastName],[FirstName])
GO
CREATE INDEX [IdxtblCase_BY_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation] ON [tblCase]([DoctorCode],[CaseNbr],[ChartNbr],[ClientCode],[Status],[ApptDate],[DoctorLocation])
GO

DROP PROC spDoctorCases
GO
CREATE PROC spDoctorCases
    @doctorCode AS INTEGER
AS 
    SELECT TOP 100 PERCENT
            tblCase.CaseNbr ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS ExamineeName ,
            tblCase.ApptDate ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorName ,
            tblCase.ClientCode ,
            tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
            tblClient.CompanyCode ,
            tblCompany.IntName ,
            tblLocation.Location ,
            @doctorCode AS DoctorCode ,
            tblQueues.StatusDesc
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblDoctor ON tblDoctor.DoctorCode = @doctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
    WHERE   tblCase.DoctorCode = @doctorcode
            OR tblCase.PanelNbr IN ( SELECT PanelNbr
                                     FROM   tblCasePanel
                                     WHERE  DoctorCode = @doctorCode )
    ORDER BY tblCase.apptdate DESC

GO


DROP PROCEDURE SPExamineeCombo
GO
CREATE PROCEDURE SPExamineeCombo
    (
      @userid VARCHAR(20) ,
      @firstchar VARCHAR(1) ,
      @lastchar VARCHAR(1)
    )
AS 
    SELECT DISTINCT
            tblExaminee.ChartNbr ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname + ' '
            + ISNULL(tblExaminee.middleinitial, '') AS Examinee ,
            tblExaminee.City ,
            tblExaminee.State ,
            tblExaminee.phone1 AS Phone ,
            tblCase.ClaimNbr ,
            tblExaminee.DOB
    FROM    tblExaminee
            INNER JOIN tblCase ON tblCase.chartnbr = tblExaminee.chartnbr
    WHERE   tblCase.OfficeCode IN ( SELECT  OfficeCode
                                    FROM    tblUserOffice
                                    WHERE   UserID = @userid )
            AND LEFT(ISNULL(lastname, ''), 1) >= @firstchar
            AND LEFT(ISNULL(lastname, ''), 1) <= @lastchar
    ORDER BY tblExaminee.lastname + ', ' + tblExaminee.firstname + ' '
            + ISNULL(tblExaminee.middleinitial, '')
GO

DROP INDEX [tblCase].[IdxtblCase_BY_ChartNbrClaimNbrOfficeCode]
GO
CREATE INDEX [IdxtblCase_BY_OfficeCodeChartNbrClaimNbr] ON [tblCase]([OfficeCode],[ChartNbr],[ClaimNbr])
GO
DROP INDEX [tblExaminee].[IdxtblExaminee_BY_LastNameFirstNameMiddleInitialDOBStateCityPhone1]
GO
CREATE INDEX [IdxtblExaminee_BY_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB] ON [tblExaminee]([LastName],[FirstName],[MiddleInitial],[ChartNbr],[City],[State],[Phone1],[DOB])
GO
CREATE INDEX [IdxtblCase_For_MainForm] ON [tblCase]([Status],[ClientCode],[OfficeCode],[Priority],[CaseType],[ServiceCode],[DoctorCode],[DoctorLocation],[MarketerCode],[SchedulerCode],[QARep])
GO
CREATE INDEX [IdxtblClient_BY_ClientCodeCompanyCode] ON [tblClient]([ClientCode],[CompanyCode])
GO
CREATE INDEX [IdxtblWebUserAccount_BY_WebUserIDUserCodeUserType] ON [tblWebUserAccount]([WebUserID],[UserCode],[UserType])
GO
CREATE INDEX [IdxtblWebUserAccount_BY_UserCodeUserTypeIsActive] ON [tblWebUserAccount]([UserCode],[UserType],[IsActive])
GO
CREATE INDEX [IdxtblPublishOnWeb_BY_TableTypeUserTypeUserCodePublishOnWebTableKey] ON [tblPublishOnWeb]([TableType],[UserType],[UserCode],[PublishOnWeb], [TableKey])
GO

ALTER TABLE [tblCase]
  DROP CONSTRAINT [PK_case]
GO
ALTER TABLE [tblCase]
  ADD CONSTRAINT [PK_tblCase] PRIMARY KEY ([CaseNbr])
GO


UPDATE tblControl SET DBVersion='2.11'
GO
