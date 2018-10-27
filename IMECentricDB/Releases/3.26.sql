PRINT N'Altering [dbo].[tblCaseOtherParty]...';


GO
ALTER TABLE [dbo].[tblCaseOtherParty] DROP COLUMN [Selected];


GO
PRINT N'Altering [dbo].[vwCaseOpenServices]...';


GO
ALTER VIEW vwCaseOpenServices
AS
    SELECT  tblCase.CaseNbr ,
            tblCaseOtherParty.DueDate ,
            tblCaseOtherParty.Status ,
            tblCase.OfficeCode ,
            tblCase.DoctorLocation ,
            tblCase.MarketerCode ,
            tblCase.DoctorCode ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblCaseOtherParty.UserIDResponsible ,
            tblCase.ApptDate ,
            tblServices.ShortDesc AS service ,
            tblServices.ServiceCode ,
            OP.CompanyName ,
            OP.OPSubType ,
            tblCase.SchedulerCode ,
            tblCase.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor OP ON tblCaseOtherParty.OPCode = OP.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
			INNER JOIN tblCompany ON tblCompany.CompanyCode = tblCase.CompanyCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
GO












PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [CancelReasonDetailID]   INT NULL,
        [IsAutoReExam]           BIT NULL,
        [ContactClientForReExam] BIT NULL,
        [RequestedDoctorCode]    INT NULL,
        [RequestedLocationCode]  INT NULL;


GO
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [CancelReasonDetailID] INT NULL;


GO
PRINT N'Altering [dbo].[tblCasePeerBill]...';


GO
ALTER TABLE [dbo].[tblCasePeerBill]
    ADD [ServiceEndDate] DATETIME NULL;


GO
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [ReceiveMedRecsElectronically] BIT NULL,
        [ViewDICOMOnWebPortal]         BIT NULL;


GO
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [IsReExam]          BIT CONSTRAINT [DF_tblServices_IsReExam] DEFAULT ((0)) NOT NULL,
        [ReExamServiceCode] INT NULL;


GO
PRINT N'Creating [dbo].[tblCancelReasonDetail]...';


GO
CREATE TABLE [dbo].[tblCancelReasonDetail] (
    [CancelReasonDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [CancelReasonGroupID]  INT          NOT NULL,
    [ExtName]              VARCHAR (50) NULL,
    [Descrip]              VARCHAR (50) NULL,
    [ReasonType]           VARCHAR (50) NULL,
    [RequireAddtlInfo]     BIT          NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    [UserIDAdded]          VARCHAR (15) NOT NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCancelReasonDetail] PRIMARY KEY CLUSTERED ([CancelReasonDetailID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCancelReasonGroup]...';


GO
CREATE TABLE [dbo].[tblCancelReasonGroup] (
    [CancelReasonGroupID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]        INT          NOT NULL,
    [ParentCompanyID]     INT          NULL,
    [Active]              BIT          NOT NULL,
    [DateAdded]           DATETIME     NOT NULL,
    [UserIDAdded]         VARCHAR (15) NOT NULL,
    [DateEdited]          DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCancelReasonGroup] PRIMARY KEY CLUSTERED ([CancelReasonGroupID] ASC)
);


GO
PRINT N'Creating [dbo].[tblTempData]...';


GO
CREATE TABLE [dbo].[tblTempData] (
    [PrimaryKey] INT          IDENTITY (1, 1) NOT NULL,
    [SessionID]  VARCHAR (50) NOT NULL,
    [ModuleName] VARCHAR (50) NOT NULL,
    [DateAdded]  DATETIME     NULL,
    [UserID]     VARCHAR (50) NULL,
    [IntValue1]  INT          NULL,
    [BitValue1]  BIT          NULL,
    CONSTRAINT [PK_tblTempData] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblTempData].[IX_tblTempData_SessionIDModuleName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTempData_SessionIDModuleName]
    ON [dbo].[tblTempData]([SessionID] ASC, [ModuleName] ASC)
    INCLUDE([IntValue1], [BitValue1]);


GO
PRINT N'Creating [dbo].[DF_tblCancelReasonDetail_RequireAddtlInfo]...';


GO
ALTER TABLE [dbo].[tblCancelReasonDetail]
    ADD CONSTRAINT [DF_tblCancelReasonDetail_RequireAddtlInfo] DEFAULT ((0)) FOR [RequireAddtlInfo];


GO
PRINT N'Creating [dbo].[DF_tblCancelReasonGroup_Active]...';


GO
ALTER TABLE [dbo].[tblCancelReasonGroup]
    ADD CONSTRAINT [DF_tblCancelReasonGroup_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating [dbo].[vwCaseReExam]...';


GO
CREATE VIEW vwCaseReExam
AS
SELECT  C.CaseNbr ,
        C.DoctorName ,
        C.ApptDate ,
        C.ClaimNbr ,

		C.DoctorCode ,
		C.SchedulerCode ,
		C.OfficeCode ,
		C.MarketerCode ,
		CL.CompanyCode ,
		C.ClientCode ,
		C.DoctorLocation ,
		C.QARep ,
		C.CaseType ,
		C.ServiceCode , 
		C.ExtCaseNbr , 
		
		C.Priority,
		C.MasterSubCase,
		c.PanelNbr,

        EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
        CL.LastName + ', ' + CL.FirstName AS ClientName ,
        COM.IntName AS CompanyName ,
        L.Location ,

        S.ShortDesc AS Service ,
        Q.ShortDesc AS Status ,

		C.ReExam ,
		C.ReExamDate ,
		C.ReExamProcessed,
		CASE WHEN C.ContactClientForReExam IS NULL THEN '' WHEN C.ContactClientForReExam=1 THEN 'Y' ELSE 'N' END AS ContactClientForReExam,
		IIF(C.ReExamNoticePrinted=1, 'Y', 'N') AS ReExamNoticePrinted,
		
		(SELECT COUNT(AC.CaseNbr) FROM tblCase AS AC INNER JOIN tblServices AS S ON AC.ServiceCode=S.ServiceCode
		 WHERE C.MasterCaseNbr=AC.MasterCaseNbr AND C.DoctorSpecialty=AC.DoctorSpecialty AND S.IsReExam=1) AS NbrReExam,

		ISNULL(BillCompany.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
		LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
		LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
WHERE ReExam = 1
GO




INSERT INTO tblUserFunction VALUES ('CancelReasonMaintAddEdit', 'Cancel Reason List - Add/Edit', '2018-03-20')
GO




UPDATE tblControl SET DBVersion='3.26'
GO