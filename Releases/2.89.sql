PRINT N'Altering [dbo].[proc_CheckForWebEventOverride]...';


GO
ALTER PROCEDURE [proc_CheckForWebEventOverride]

@IMECentricCode int,
@UserType varchar(50),
@Description varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) FROM tblWebEventsOverride
		WHERE IMECentricCode = @IMECentricCode AND Description = @Description AND NotifyTo LIKE '%' + @UserType + '%'

	SET @Err = @@Error

	RETURN @Err
END
GO


PRINT N'Dropping [dbo].[DF_tblCaseTypeService_EmployerRqd]...';


GO
ALTER TABLE [dbo].[tblCaseTypeService] DROP CONSTRAINT [DF_tblCaseTypeService_EmployerRqd];


GO
PRINT N'Dropping [dbo].[DF_tblCaseTypeService_TreatingPhysicianRqd]...';


GO
ALTER TABLE [dbo].[tblCaseTypeService] DROP CONSTRAINT [DF_tblCaseTypeService_TreatingPhysicianRqd];


GO
PRINT N'Dropping [dbo].[DF_tblQueueDocuments_PublishOnWeb]...';


GO
ALTER TABLE [dbo].[tblQueueDocuments] DROP CONSTRAINT [DF_tblQueueDocuments_PublishOnWeb];


GO
PRINT N'Dropping [dbo].[DF_tblServiceQueues_createinvoice]...';


GO
ALTER TABLE [dbo].[tblServiceQueues] DROP CONSTRAINT [DF_tblServiceQueues_createinvoice];


GO
PRINT N'Dropping [dbo].[DF_tblServiceQueues_createvoucher]...';


GO
ALTER TABLE [dbo].[tblServiceQueues] DROP CONSTRAINT [DF_tblServiceQueues_createvoucher];


GO
PRINT N'Dropping [dbo].[tblFRForecast]...';


GO
DROP TABLE [dbo].[tblFRForecast];


GO
PRINT N'Dropping [dbo].[vwCaseTypeOffice]...';


GO
DROP VIEW [dbo].[vwCaseTypeOffice];


GO
PRINT N'Dropping [dbo].[vwCaseTypeService]...';


GO
DROP VIEW [dbo].[vwCaseTypeService];


GO
PRINT N'Dropping [dbo].[vwCaseTypeServiceDocument]...';


GO
DROP VIEW [dbo].[vwCaseTypeServiceDocument];


GO
PRINT N'Dropping [dbo].[vwCaseTypeServiceQueues]...';


GO
DROP VIEW [dbo].[vwCaseTypeServiceQueues];


GO
PRINT N'Dropping [dbo].[vwServiceOffice]...';


GO
DROP VIEW [dbo].[vwServiceOffice];


GO
PRINT N'Dropping [dbo].[tblCaseTypeService]...';


GO
DROP TABLE [dbo].[tblCaseTypeService];


GO
PRINT N'Dropping [dbo].[tblQueueDocuments]...';


GO
DROP TABLE [dbo].[tblQueueDocuments];


GO
PRINT N'Dropping [dbo].[tblServiceQueues]...';


GO
DROP TABLE [dbo].[tblServiceQueues];


GO
PRINT N'Altering [dbo].[tblCompanyOffice]...';


GO
ALTER TABLE [dbo].[tblCompanyOffice]
    ADD [FeeCode]         INT          NULL,
        [InvoiceDocument] VARCHAR (15) NULL;


GO
PRINT N'Creating [dbo].[tblCompanyDocuments]...';


GO
CREATE TABLE [dbo].[tblCompanyDocuments] (
    [CompanyDocumentID] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyCode]       INT           NOT NULL,
    [FolderID]          INT           NOT NULL,
    [DocumentType]      INT           NOT NULL,
    [DocumentFilename]  VARCHAR (256) NOT NULL,
    [Description]       VARCHAR (128) NULL,
    [DateAdded]         DATETIME      NOT NULL,
    [UserIDAdded]       VARCHAR (15)  NOT NULL,
    [DateEdited]        DATETIME      NOT NULL,
    [UserIDEdited]      VARCHAR (15)  NOT NULL,
    [Active]            BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([CompanyDocumentID] ASC)
);


GO
PRINT N'Creating [dbo].[tblEWParentCompanyDocuments]...';


GO
CREATE TABLE [dbo].[tblEWParentCompanyDocuments] (
    [ParentCompanyDocumentID] INT           IDENTITY (1, 1) NOT NULL,
    [ParentCompanyID]         INT           NOT NULL,
    [FolderID]                INT           NOT NULL,
    [DocumentType]            INT           NOT NULL,
    [DocumentFilename]        VARCHAR (256) NOT NULL,
    [Description]             VARCHAR (128) NULL,
    [DateAdded]               DATETIME      NOT NULL,
    [UserIDAdded]             VARCHAR (15)  NOT NULL,
    [DateEdited]              DATETIME      NOT NULL,
    [UserIDEdited]            VARCHAR (15)  NOT NULL,
    [Active]                  BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ParentCompanyDocumentID] ASC)
);


GO
PRINT N'Creating [dbo].[tblFeeHeaderOffice]...';


GO
CREATE TABLE [dbo].[tblFeeHeaderOffice] (
    [FeeCode]     INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFeeHeaderOffice] PRIMARY KEY CLUSTERED ([FeeCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblProductOffice]...';


GO
CREATE TABLE [dbo].[tblProductOffice] (
    [ProdCode]    INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblProductOffice] PRIMARY KEY CLUSTERED ([ProdCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblTranscriptionJob].[IX_tblTranscriptionJob_EWTransDeptID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_EWTransDeptID]
    ON [dbo].[tblTranscriptionJob]([EWTransDeptID] ASC);


GO
PRINT N'Creating [dbo].[tblTranscriptionJob].[IX_tblTranscriptionJob_TranscriptionStatusCodeWorkflow]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_TranscriptionStatusCodeWorkflow]
    ON [dbo].[tblTranscriptionJob]([TranscriptionStatusCode] ASC, [Workflow] ASC);


GO
PRINT N'Altering [dbo].[vwApptLogDocs]...';


GO
ALTER VIEW vwApptLogDocs
AS
    SELECT 
            tblCase.CaseNbr ,
            CA.DateAdded ,
            CA.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, CA.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            ISNULL(CA.SpecialtyCode, tblCaseApptPanel.SpecialtyCode) AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        PriorAppt.ApptTime
              FROM      tblCaseAppt AS PriorAppt
                        WHERE PriorAppt.CaseNbr = tblCase.CaseNbr
                        AND PriorAppt.CaseApptID<CA.CaseApptID
              ORDER BY  PriorAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tblDoctor.ProvTypeCode,
			tblCase.ExtCaseNbr
    FROM    tblCaseAppt AS CA
			INNER JOIN tblApptStatus ON CA.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON CA.CaseNbr = tblCase.CaseNbr

            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            
			LEFT OUTER JOIN tblCaseApptPanel ON CA.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblDoctor ON ISNULL(CA.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode

            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON CA.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9
GO
PRINT N'Altering [dbo].[vwCaseAppt]...';


GO
ALTER VIEW vwCaseAppt
AS
WITH allDoctors AS (
          SELECT  
               CA.CaseApptID ,
               ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
               CASE WHEN CA.DoctorCode IS NULL THEN
               LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
               ELSE
               LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
               END AS DoctorName,
               CASE WHEN CA.DoctorCode IS NULL THEN
               ISNULL(DP.LastName,'')+ISNULL(', '+DP.FirstName,'')
               ELSE
               ISNULL(D.LastName,'')+ISNULL(', '+D.FirstName,'')
               END AS DoctorNameLF,
               ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
           FROM tblCaseAppt AS CA
           LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
        CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CB.ExtName AS CanceledByExtName ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,
        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(100)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+DoctorNameLF FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNamesLF,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS Specialties,
          CA.DateReceived, 
          FZ.Name AS FeeZoneName,
		  C.OfficeCode
     FROM tblCaseAppt AS CA
	 INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
     LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID
GO
PRINT N'Altering [dbo].[vwTranscriptionTracker]...';


GO
 ALTER VIEW vwTranscriptionTracker
 AS
    SELECT  CT.TranscriptionJobID ,
			CT.TranscriptionStatusCode ,
            CT.CaseNbr ,
            CASE WHEN C.CaseNbr IS NULL THEN 0
                 ELSE 1
            END AS CaseSelected ,
            DATEDIFF(DAY, C.LastStatusChg, GETDATE()) AS IQ ,
            C.ApptDate ,
            C.ApptTime ,
            C.Priority ,
			IsNull(P.Rank, 100) AS PriorityRank ,
            EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
            CASE WHEN C.PanelNbr IS NULL
                 THEN D.LastName + ', ' + ISNULL(D.FirstName, ' ')
                 ELSE C.DoctorName
            END AS DoctorName ,
            L.Location ,
            COM.IntName AS CompanyName ,
            S.ShortDesc AS Service ,
            CASE WHEN CT.TransCode = -1 THEN '<Job Request>'
                 ELSE T.TransCompany
            END AS TransGroup ,
            Q.ShortDesc AS CaseStatus ,
            TS.Descrip AS TransStatus ,
            C.OfficeCode ,
            T.TransCode ,
			T.Workflow ,
            CT.DateAdded ,
            CT.DateCompleted ,
			CT.LastStatusChg ,
            TD.Name AS TransDept ,
			CT.EWTransDeptID , 
			C.ExtCaseNbr ,
			TD.EWTimeZoneID ,
			DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()) AS TransDeptDateTime,
			dbo.fnGetTATMins(CT.LastStatusChg, DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE())) AS TAT,
			dbo.fnGetTATString(dbo.fnGetTATMins(CT.LastStatusChg, DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()))) AS TATString
    FROM    tblTranscriptionJob CT
            INNER JOIN tblTranscriptionStatus TS ON CT.TranscriptionStatusCode = TS.TranscriptionStatusCode
            LEFT OUTER JOIN tblTranscription T ON T.TransCode = CT.TransCode
            LEFT OUTER JOIN tblCase C ON CT.CaseNbr = C.CaseNbr
            LEFT OUTER JOIN tblExaminee EE ON C.ChartNbr = EE.ChartNbr
            LEFT OUTER JOIN tblQueues Q ON C.Status = Q.StatusCode
            LEFT OUTER JOIN tblServices S ON C.ServiceCode = S.ServiceCode
            LEFT OUTER JOIN tblClient CL ON C.ClientCode = CL.ClientCode
            LEFT OUTER JOIN tblCompany COM ON COM.CompanyCode = CL.CompanyCode
            LEFT OUTER JOIN tblDoctor D ON C.DoctorCode = D.DoctorCode
            LEFT OUTER JOIN tblLocation L ON C.DoctorLocation = L.LocationCode
            LEFT OUTER JOIN tblPriority P ON C.Priority = P.PriorityCode
            LEFT OUTER JOIN tblEWTransDept TD ON CT.EWTransDeptID = TD.EWTransDeptID
			LEFT OUTER JOIN tblControl AS CTRL ON 1=1
GO
PRINT N'Creating [dbo].[vwFeeDetailAbeton]...';


GO
CREATE VIEW vwFeeDetailAbeton
AS
SELECT tblFeeDetailAbeton.*, tblProduct.Description
 FROM tblFeeDetailAbeton
 INNER JOIN tblProduct ON tblProduct.ProdCode = tblFeeDetailAbeton.ProdCode
GO
PRINT N'Altering [dbo].[proc_CaseAppt_Insert]...';


GO
ALTER PROCEDURE [proc_CaseAppt_Insert]
(
	@CaseApptId int = NULL output,
	@CaseNbr int,
	@ApptTime datetime,
	@DoctorCode int = NULL,
	@LocationCode int = NULL,
	@SpecialtyCode varchar(50) = NULL,
	@ApptStatusId int,
	@DateAdded datetime = NULL,
	@DateReceived datetime = NULL,
	@UserIdAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIdEdited varchar(15) = NULL,
	@CanceledById int = NULL,
	@Reason varchar(300) = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseAppt]
	(
		[CaseNbr],
		[ApptTime],
		[DoctorCode],
		[LocationCode],
		[SpecialtyCode],
		[ApptStatusId],
		[DateAdded],
		[DateReceived],
		[UserIdAdded],
		[DateEdited],
		[UserIdEdited],
		[CanceledById],
		[Reason],
		[LastStatusChg]
	)
	VALUES
	(
		@CaseNbr,
		@ApptTime,
		@DoctorCode,
		@LocationCode,
		@SpecialtyCode,
		@ApptStatusId,
		@DateAdded,
		@DateReceived,
		@UserIdAdded,
		@DateEdited,
		@UserIdEdited,
		@CanceledById,
		@Reason,
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @CaseApptId = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetClientSubordinates]...';


GO
ALTER PROCEDURE [proc_GetClientSubordinates]

@WebUserID int

AS

SELECT DISTINCT lastname + ', ' + firstname + ' ' + tblCompany.intname name, clientcode FROM tblclient
	INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
	WHERE clientcode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = @WebUserID)
	AND tblClient.Status = 'Active'
	ORDER BY name
GO
PRINT N'Altering [dbo].[proc_GetSuperUserAvailUserListItemsNew]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetSuperUserAvailUserListItemsNew]

@WebUserID int

AS

SELECT DISTINCT clientcode as imecentriccode, tblwebuseraccount.webuserid,  tblwebuseraccount.usertype,
tblCompany.intname company, firstname + ' ' + lastname name
	FROM tblclient
	INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	WHERE tblwebuseraccount.WebUserID <> @WebUserID AND tblClient.Status = 'Active'
UNION
SELECT DISTINCT cccode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(company,'N/A') company, firstname + ' ' + lastname name
	FROM tblCCAddress
	INNER JOIN tblwebuseraccount ON tblCCAddress.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT doctorcode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname name
	FROM tblDoctor
	INNER JOIN tblwebuseraccount ON tblDoctor.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT transcode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
	FROM tblTranscription
	INNER JOIN tblwebuseraccount ON tblTranscription.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'TR'
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
ORDER BY company, name
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetSuperUserComboItems]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetSuperUserComboItems]

AS

SELECT DISTINCT tblwebuseraccount.webuserid AS webID, tblCompany.intname company, tblCompany.intname + ' - ' + lastname + ', ' + firstname name
	FROM tblclient
	INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	WHERE tblClient.Status = 'Active'
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(company,'N/A') company, ISNULL(company,'N/A') + ' - ' +  lastname + ', ' + firstname name
	FROM tblCCAddress
	INNER JOIN tblwebuseraccount ON tblCCAddress.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(companyname,'N/A') company, ISNULL(companyname,'N/A') + ' - ' + lastname + ', ' + firstname  name
	FROM tblDoctor
	INNER JOIN tblwebuseraccount ON tblDoctor.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
	FROM tblTranscription
	INNER JOIN tblwebuseraccount ON tblTranscription.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND tblWebUserAccount.UserType = 'TR'
ORDER BY company, name
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_RequestNextTranscriptionJob]...';


GO
ALTER PROCEDURE proc_RequestNextTranscriptionJob
    (
      @transCode INT ,
      @dateAssigned DATETIME ,
      @transcriptionJobID INT OUTPUT 
    )
AS 
    BEGIN
        SET NOCOUNT ON
        DECLARE @error INT
		DECLARE @workflow INT

        BEGIN TRAN
        --Look for the next availabel job in the queue (where TranscriptionStatusCode is 20 and TransCode is -1)
        --Order the jobs by priority ranking first, in case the priority of the case is not set, default it to 100
        --then order by AppTime then TranscriptionJobID
        SET @transcriptionJobID = ( SELECT TOP 1
                                            J.TranscriptionJobID
                                    FROM    tblTranscriptionJob AS J ( UPDLOCK )
                                            INNER JOIN tblCase AS C ON J.CaseNbr = C.CaseNbr
                                            LEFT OUTER JOIN tblPriority AS P ON C.Priority = P.PriorityCode
                                    WHERE   J.TransCode = -1
                                            AND TranscriptionStatusCode = 20
                                    ORDER BY ISNULL(P.Rank, 100) ,
                                            C.ApptTime ,
                                            J.TranscriptionJobID
                                  )
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done
        --If no transcription job available, exit procedure
        IF @transcriptionJobID IS NULL 
            GOTO Done
		
		--Get transcription group workflow
		SELECT @workflow = workflow FROM tblTranscription WHERE TransCode = @transCode

		--Set values in transcription job and case records
        UPDATE TJ
        SET     TransCode = @transCode ,
                DateAssigned = DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, C.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()),
				Workflow = @workflow
		FROM tblTranscriptionJob AS TJ
		LEFT OUTER JOIN tblEWTransDept AS TD ON TD.EWTransDeptID = TJ.EWTransDeptID
		LEFT OUTER JOIN tblControl AS C ON 1=1
        WHERE   TranscriptionJobID = @transcriptionJobID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

        UPDATE  tblCase
        SET     TransCode = @transCode
        WHERE   CaseNbr = ( SELECT  CaseNbr
                            FROM    tblTranscriptionJob
                            WHERE   TranscriptionJobID = @transcriptionJobID
                          )
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		--Commit transaction
        COMMIT TRAN
 
        Done:
        IF @error <> 0 
            SET @transcriptionJobID = NULL
        IF @transcriptionJobID IS NULL 
            ROLLBACK TRAN

        SET NOCOUNT OFF
        RETURN @error
    END
GO
PRINT N'Creating [dbo].[proc_GetSaveDateTimeByEWTimeZoneID]...';


GO
CREATE PROCEDURE [proc_GetSaveDateTimeByEWTimeZoneID]
(
	@EWTimeZoneID int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT dbo.fnGetUTCOffset (EWTimeZoneID, getutcdate()) Offset
		FROM tblEWTimeZone
		WHERE EWTimeZoneID = @EWTimeZoneID

	SET @Err = @@Error

	RETURN @Err
END
GO

UPDATE tblControl SET DBVersion='2.89'
GO