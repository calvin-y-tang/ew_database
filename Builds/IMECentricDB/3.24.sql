CREATE TABLE [dbo].[tblCaseIssueQuestion] (
    [CaseIssueQuestionID] INT          IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT          NOT NULL,
    [IssueQuestionID]     INT          NOT NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCaseIssueQuestion] PRIMARY KEY CLUSTERED ([CaseIssueQuestionID] ASC)
);
GO

PRINT N'Altering [dbo].[tblCasePeerBill]...';


GO
ALTER TABLE [dbo].[tblCasePeerBill] ALTER COLUMN [CPTCode] VARCHAR (50) NULL;


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [LockTimeoutSec]  INT NULL,
        [SettingCacheMin] INT NULL,
        [UserCacheMin]    INT NULL,
        [SettingVersion]  INT CONSTRAINT [DF_tblControl_SettingVersion] DEFAULT ((1)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [ShowFollowUpOnCaseOpen] BIT CONSTRAINT [DF_tblOffice_ShowFollowUpOnCaseOpen] DEFAULT ((0)) NOT NULL,
        [EnvelopeFolderID]       INT NULL,
        [UseCaseLock]            BIT NULL;


GO
PRINT N'Altering [dbo].[tblQuestionSetDetail]...';


GO
ALTER TABLE [dbo].[tblQuestionSetDetail] DROP COLUMN [DateEdited], COLUMN [DisplayOrder], COLUMN [UserIDEdited];


GO
ALTER TABLE [dbo].[tblQuestionSetDetail]
    ADD [GroupOrder] INT NULL,
        [RowOrder]   INT NULL;


GO
PRINT N'Creating [dbo].[tblQuestionSetDetail].[IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID]
    ON [dbo].[tblQuestionSetDetail]([QuestionSetID] ASC, [IssueQuestionID] ASC);


GO
PRINT N'Altering [dbo].[tblServiceWorkflow]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD [UsePeerBill] BIT CONSTRAINT [DF_tblServiceWorkflow_UsePeerBill] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblServiceWorkflowQueueDocument]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflowQueueDocument]
    ADD [EnvelopeAOrder] INT NULL,
        [EnvelopeBOrder] INT NULL,
        [EnvelopeCOrder] INT NULL,
        [EnvelopeDOrder] INT NULL;


GO
PRINT N'Altering [dbo].[tblUser]...';


GO
ALTER TABLE [dbo].[tblUser]
    ADD [UserVersion] INT CONSTRAINT [DF_tblUser_UserVersion] DEFAULT ((1)) NOT NULL;


GO
PRINT N'Creating [dbo].[tblBusinessRule]...';


GO
CREATE TABLE [dbo].[tblBusinessRule] (
    [BusinessRuleID]   INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (35)  NULL,
    [Category]         VARCHAR (20)  NULL,
    [Descrip]          VARCHAR (150) NULL,
    [IsActive]         BIT           NOT NULL,
    [EventID]          INT           NULL,
    [AllowOverride]    BIT           NOT NULL,
    [Param1Desc]       VARCHAR (20)  NULL,
    [Param2Desc]       VARCHAR (20)  NULL,
    [Param3Desc]       VARCHAR (20)  NULL,
    [Param4Desc]       VARCHAR (20)  NULL,
    [Param5Desc]       VARCHAR (20)  NULL,
    [BrokenRuleAction] INT           NOT NULL,
    CONSTRAINT [PK_tblBusinessRule] PRIMARY KEY CLUSTERED ([BusinessRuleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblBusinessRuleCondition]...';


GO
CREATE TABLE [dbo].[tblBusinessRuleCondition] (
    [BusinessRuleConditionID] INT          IDENTITY (1, 1) NOT NULL,
    [EntityType]              VARCHAR (2)  NULL,
    [EntityID]                INT          NULL,
    [BillingEntity]           INT          NOT NULL,
    [ProcessOrder]            INT          NULL,
    [BusinessRuleID]          INT          NOT NULL,
    [DateAdded]               DATETIME     NULL,
    [UserIDAdded]             VARCHAR (20) NULL,
    [DateEdited]              DATETIME     NULL,
    [UserIDEdited]            VARCHAR (20) NULL,
    [OfficeCode]              INT          NULL,
    [EWBusLineID]             INT          NULL,
    [EWServiceTypeID]         INT          NULL,
    [Jurisdiction]            VARCHAR (5)  NULL,
    [Param1]                  VARCHAR (20) NULL,
    [Param2]                  VARCHAR (20) NULL,
    [Param3]                  VARCHAR (20) NULL,
    [Param4]                  VARCHAR (20) NULL,
    [Param5]                  VARCHAR (20) NULL,
    CONSTRAINT [PK_tblBusinessRuleCondition] PRIMARY KEY CLUSTERED ([BusinessRuleConditionID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCaseDocumentsDicom]...';


GO
CREATE TABLE [dbo].[tblCaseDocumentsDicom] (
    [CaseDocDicomID]                    INT            IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                           INT            NOT NULL,
    [CaseDocID]                         INT            NOT NULL,
    [MediaType]                         VARCHAR (100)  NOT NULL,
    [DiscID]                            VARCHAR (100)  NULL,
    [PatientName]                       VARCHAR (200)  NULL,
    [PatientId]                         VARCHAR (200)  NULL,
    [PatientBirthDate]                  VARCHAR (50)   NULL,
    [PatientSex]                        VARCHAR (50)   NULL,
    [StudyDate]                         VARCHAR (50)   NULL,
    [StudyTime]                         VARCHAR (50)   NULL,
    [StudyDescription]                  VARCHAR (500)  NULL,
    [StudyUID]                          VARCHAR (200)  NULL,
    [StudyID]                           VARCHAR (200)  NULL,
    [StudyDirRecType]                   VARCHAR (100)  NULL,
    [SeriesUID]                         VARCHAR (200)  NULL,
    [SeriesNumber]                      INT            NULL,
    [SeriesDate]                        VARCHAR (50)   NULL,
    [SeriesTime]                        VARCHAR (50)   NULL,
    [SeriesDescription]                 VARCHAR (500)  NULL,
    [SeriesModality]                    VARCHAR (50)   NULL,
    [SeriesDirRecType]                  VARCHAR (100)  NULL,
    [InstanceNumber]                    INT            NULL,
    [InstanceUID]                       VARCHAR (200)  NULL,
    [ReferenceFileID]                   VARCHAR (200)  NULL,
    [InstanceDirRecType]                VARCHAR (100)  NULL,
    [MediaStorageSopInstanceUid]        VARCHAR (200)  NULL,
    [SopClass]                          VARCHAR (200)  NULL,
    [Modality]                          VARCHAR (50)   NULL,
    [Filename]                          VARCHAR (500)  NULL,
    [Filesize]                          INT            NULL,
    [AcquisitionDate]                   VARCHAR (50)   NULL,
    [AcquisitionTime]                   VARCHAR (50)   NULL,
    [ContentDate]                       VARCHAR (10)   NULL,
    [ContentTime]                       VARCHAR (10)   NULL,
    [InstitutionName]                   VARCHAR (200)  NULL,
    [InstitutionAddress]                VARCHAR (500)  NULL,
    [InstitutionalDepartmentName]       VARCHAR (200)  NULL,
    [ReferringPhysiciansName]           VARCHAR (200)  NULL,
    [ProtocolName]                      VARCHAR (200)  NULL,
    [RequestedProcedureDescription]     VARCHAR (200)  NULL,
    [PerformedProcedureStepDescription] VARCHAR (200)  NULL,
    [IsValidatedFileExists]             BIT            NOT NULL,
    [IsValidatedBinary]                 BIT            NOT NULL,
    [FlagForUse]                        BIT            NOT NULL,
    [Notes]                             VARCHAR (2000) NULL,
    [ImportedOn]                        DATETIME       NULL,
    [ImportedBy]                        VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblCaseDocumentsDicom] PRIMARY KEY CLUSTERED ([CaseDocDicomID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCaseDocumentTransfer]...';


GO
CREATE TABLE [dbo].[tblCaseDocumentTransfer] (
    [CaseDocumentTransferID] INT            IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                INT            NOT NULL,
    [SeqNo]                  INT            NOT NULL,
    [OfficeCode]             INT            NOT NULL,
    [FileName]               VARCHAR (255)  NOT NULL,
    [FolderID]               INT            NOT NULL,
    [SubFolder]              VARCHAR (32)   NULL,
    [DateAdded]              DATETIME       NOT NULL,
    [UserIDAdded]            VARCHAR (15)   NOT NULL,
    [DateEdited]             DATETIME       NULL,
    [UserIDEdited]           VARCHAR (15)   NULL,
    [TransferType]           INT            NULL,
    [TransferDateTime]       DATETIME       NULL,
    [StatusCode]             VARCHAR (12)   NULL,
    [StatusMessage]          VARCHAR (2048) NULL,
    CONSTRAINT [PK_tblCaseDocumentTransfer] PRIMARY KEY CLUSTERED ([CaseDocumentTransferID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDoctorDrAssistant]...';


GO
CREATE TABLE [dbo].[tblDoctorDrAssistant] (
    [DrAssistantID] INT          NOT NULL,
    [DoctorCode]    INT          NOT NULL,
    [UserIDAdded]   VARCHAR (15) NOT NULL,
    [DateAdded]     DATETIME     NOT NULL,
    CONSTRAINT [PK_tblDoctorDrAssistant] PRIMARY KEY CLUSTERED ([DrAssistantID] ASC, [DoctorCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblDrAssistant]...';


GO
CREATE TABLE [dbo].[tblDrAssistant] (
    [DrAssistantID] INT           IDENTITY (1, 1) NOT NULL,
    [LastName]      VARCHAR (50)  NOT NULL,
    [FirstName]     VARCHAR (50)  NOT NULL,
    [Email]         VARCHAR (255) NOT NULL,
    [Phone]         VARCHAR (15)  NOT NULL,
    [UserIDAdded]   VARCHAR (15)  NOT NULL,
    [DateAdded]     DATETIME      NOT NULL,
    [UserIDEdited]  VARCHAR (15)  NULL,
    [DateEdited]    DATETIME      NULL,
    CONSTRAINT [PK_tblDrAssistant] PRIMARY KEY CLUSTERED ([DrAssistantID] ASC)
);


GO
PRINT N'Creating [dbo].[tblLock]...';


GO
CREATE TABLE [dbo].[tblLock] (
    [LockID]     INT          IDENTITY (1, 1) NOT NULL,
    [TableType]  VARCHAR (50) NULL,
    [TableKey]   INT          NULL,
    [DateLocked] DATETIME     NULL,
    [DateAdded]  DATETIME     NULL,
    [UserID]     VARCHAR (50) NULL,
    [SessionID]  VARCHAR (50) NOT NULL,
    [ModuleName] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblLock] PRIMARY KEY CLUSTERED ([LockID] ASC)
);


GO
PRINT N'Creating [dbo].[tblLock].[IX_U_tblLock_TableTypeTableKey]...';


GO
CREATE NONCLUSTERED INDEX [IX_U_tblLock_TableTypeTableKey]
    ON [dbo].[tblLock]([TableType] ASC, [TableKey] ASC)
    INCLUDE([SessionID], [UserID]);


GO
PRINT N'Creating [dbo].[tblSession]...';


GO
CREATE TABLE [dbo].[tblSession] (
    [PrimaryKey]      INT          IDENTITY (1, 1) NOT NULL,
    [SessionID]       VARCHAR (50) NOT NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (50) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (50) NULL,
    [AppName]         VARCHAR (30) NULL,
    [WorkstationName] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSession] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblSession].[IX_U_tblSession_SessionID]...';


GO
CREATE NONCLUSTERED INDEX [IX_U_tblSession_SessionID]
    ON [dbo].[tblSession]([SessionID] ASC);


GO
PRINT N'Creating [dbo].[tblWebReferral]...';


GO
CREATE TABLE [dbo].[tblWebReferral] (
    [WebReferralID]                INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                      INT           NULL,
    [ClaimNbr]                     VARCHAR (50)  NULL,
    [ClaimNbrExt]                  VARCHAR (50)  NULL,
    [ClientCode]                   INT           NULL,
    [ClientName]                   VARCHAR (100) NULL,
    [ServiceType]                  INT           NULL,
    [ServiceDesc]                  VARCHAR (MAX) NULL,
    [CaseType]                     INT           NULL,
    [CaseTypeDesc]                 VARCHAR (MAX) NULL,
    [Jurisdiction]                 VARCHAR (5)   NULL,
    [RequestedVenue]               VARCHAR (50)  NULL,
    [DateOfInjury1]                DATETIME      NULL,
    [DateOfInjury2]                DATETIME      NULL,
    [DateOfInjury3]                DATETIME      NULL,
    [DateOfInjury4]                DATETIME      NULL,
    [WCBNbr]                       VARCHAR (50)  NULL,
    [IMETimeframeReq]              VARCHAR (30)  NULL,
    [HearingDeadlineDate]          DATETIME      NULL,
    [AmendedRequest]               BIT           NOT NULL,
    [ContactAttorney]              BIT           NOT NULL,
    [ContactClaimant]              BIT           NOT NULL,
    [ClaimantLocations]            VARCHAR (500) NULL,
    [ExamineePrefix]               VARCHAR (10)  NULL,
    [ExamineeFirstName]            VARCHAR (50)  NULL,
    [ExamineeLastName]             VARCHAR (50)  NULL,
    [ExamineeDOB]                  DATETIME      NULL,
    [ExamineeAddress1]             VARCHAR (50)  NULL,
    [ExamineeAddress2]             VARCHAR (50)  NULL,
    [ExamineeCity]                 VARCHAR (70)  NULL,
    [ExamineeState]                VARCHAR (5)   NULL,
    [ExamineeZip]                  VARCHAR (10)  NULL,
    [ExamineePhone1]               VARCHAR (15)  NULL,
    [ExamineePhone2]               VARCHAR (15)  NULL,
    [ExamineeMobilePhone]          VARCHAR (15)  NULL,
    [ExamineeFax]                  VARCHAR (15)  NULL,
    [ExamineeEmail]                VARCHAR (100) NULL,
    [ExamineeSSN]                  VARCHAR (15)  NULL,
    [ExamineeGender]               VARCHAR (10)  NULL,
    [TreatingPhysicianName]        VARCHAR (100) NULL,
    [TreatingPhysicianAddress1]    VARCHAR (80)  NULL,
    [TreatingPhysicianCity]        VARCHAR (70)  NULL,
    [TreatingPhysicianState]       VARCHAR (5)   NULL,
    [TreatingPhysicianZip]         VARCHAR (10)  NULL,
    [TreatingPhysicianPhone1]      VARCHAR (15)  NULL,
    [TreatingPhysicianPhone2]      VARCHAR (15)  NULL,
    [TreatingPhysicianFax]         VARCHAR (15)  NULL,
    [TreatingPhysicianEmail]       VARCHAR (100) NULL,
    [ProviderName]                 VARCHAR (100) NULL,
    [MedicalRecordStatus]          VARCHAR (30)  NULL,
    [InterpreterRequired]          BIT           NOT NULL,
    [LanguageRequired]             BIT           NOT NULL,
    [Language]                     VARCHAR (50)  NULL,
    [TransportationRequired]       BIT           NOT NULL,
    [SendBillToContactName]        VARCHAR (100) NULL,
    [SendBillToCompanyName]        VARCHAR (100) NULL,
    [Issues]                       VARCHAR (MAX) NULL,
    [Problems]                     VARCHAR (MAX) NULL,
    [Specialties]                  VARCHAR (MAX) NULL,
    [Degrees]                      VARCHAR (MAX) NULL,
    [SpecialInstructions]          VARCHAR (MAX) NULL,
    [OtherComments]                VARCHAR (MAX) NULL,
    [PlaintiffAttorneyPrefix]      VARCHAR (10)  NULL,
    [PlaintiffAttorneyFirstName]   VARCHAR (50)  NULL,
    [PlaintiffAttorneyLastName]    VARCHAR (50)  NULL,
    [PlaintiffAttorneyCompany]     VARCHAR (100) NULL,
    [PlaintiffAttorneyAddress1]    VARCHAR (50)  NULL,
    [PlaintiffAttorneyAddress2]    VARCHAR (50)  NULL,
    [PlaintiffAttorneyCity]        VARCHAR (70)  NULL,
    [PlaintiffAttorneyState]       VARCHAR (5)   NULL,
    [PlaintiffAttorneyZip]         VARCHAR (10)  NULL,
    [PlaintiffAttorneyPhone1]      VARCHAR (15)  NULL,
    [PlaintiffAttorneyPhone2]      VARCHAR (15)  NULL,
    [PlaintiffAttorneyFax]         VARCHAR (15)  NULL,
    [PlaintiffAttorneyEmail]       VARCHAR (100) NULL,
    [DefenseAttorneyPrefix]        VARCHAR (10)  NULL,
    [DefenseAttorneyFirstName]     VARCHAR (50)  NULL,
    [DefenseAttorneyLastName]      VARCHAR (50)  NULL,
    [DefenseAttorneyCompany]       VARCHAR (100) NULL,
    [DefenseAttorneyAddress1]      VARCHAR (50)  NULL,
    [DefenseAttorneyAddress2]      VARCHAR (50)  NULL,
    [DefenseAttorneyCity]          VARCHAR (70)  NULL,
    [DefenseAttorneyState]         VARCHAR (5)   NULL,
    [DefenseAttorneyZip]           VARCHAR (10)  NULL,
    [DefenseAttorneyPhone1]        VARCHAR (15)  NULL,
    [DefenseAttorneyPhone2]        VARCHAR (15)  NULL,
    [DefenseAttorneyFax]           VARCHAR (15)  NULL,
    [DefenseAttorneyEmail]         VARCHAR (100) NULL,
    [CaseManagerPrefix]            VARCHAR (10)  NULL,
    [CaseManagerFirstName]         VARCHAR (50)  NULL,
    [CaseManagerLastName]          VARCHAR (50)  NULL,
    [CaseManagerCompany]           VARCHAR (100) NULL,
    [CaseManagerAddress1]          VARCHAR (50)  NULL,
    [CaseManagerAddress2]          VARCHAR (50)  NULL,
    [CaseManagerCity]              VARCHAR (70)  NULL,
    [CaseManagerState]             VARCHAR (5)   NULL,
    [CaseManagerZip]               VARCHAR (10)  NULL,
    [CaseManagerPhone1]            VARCHAR (15)  NULL,
    [CaseManagerPhone2]            VARCHAR (15)  NULL,
    [CaseManagerFax]               VARCHAR (15)  NULL,
    [CaseManagerEmail]             VARCHAR (100) NULL,
    [ClaimantEmployerCompany]      VARCHAR (100) NULL,
    [ClaimantEmployerFirstName]    VARCHAR (50)  NULL,
    [ClaimantEmployerLastName]     VARCHAR (50)  NULL,
    [ClaimantEmployerAddress1]     VARCHAR (50)  NULL,
    [ClaimantEmployerCity]         VARCHAR (70)  NULL,
    [ClaimantEmployerState]        VARCHAR (5)   NULL,
    [ClaimantEmployerZip]          VARCHAR (10)  NULL,
    [ClaimantEmployerPhone1]       VARCHAR (15)  NULL,
    [ClaimantEmployerPhone2]       VARCHAR (15)  NULL,
    [ClaimantEmployerFax]          VARCHAR (15)  NULL,
    [ClaimantEmployerEmail]        VARCHAR (100) NULL,
    [InsuringCompany]              VARCHAR (50)  NULL,
    [InsuredName]                  VARCHAR (100) NULL,
    [InsuredAddress1]              VARCHAR (50)  NULL,
    [InsuredCity]                  VARCHAR (70)  NULL,
    [InsuredState]                 VARCHAR (5)   NULL,
    [InsuredZip]                   VARCHAR (10)  NULL,
    [InsuredPhone1]                VARCHAR (15)  NULL,
    [InsuredPhone2]                VARCHAR (15)  NULL,
    [InsuredFax]                   VARCHAR (15)  NULL,
    [InsuredEmail]                 VARCHAR (100) NULL,
    [InsuredPolicyNumber]          VARCHAR (50)  NULL,
    [ThirdPartyBillingPrefix]      VARCHAR (10)  NULL,
    [ThirdPartyBillingFirstName]   VARCHAR (50)  NULL,
    [ThirdPartyBillingLastName]    VARCHAR (50)  NULL,
    [ThirdPartyBillingCompany]     VARCHAR (100) NULL,
    [ThirdPartyBillingAddress1]    VARCHAR (50)  NULL,
    [ThirdPartyBillingAddress2]    VARCHAR (50)  NULL,
    [ThirdPartyBillingCity]        VARCHAR (70)  NULL,
    [ThirdPartyBillingState]       VARCHAR (5)   NULL,
    [ThirdPartyBillingZip]         VARCHAR (10)  NULL,
    [ThirdPartyBillingPhone1]      VARCHAR (15)  NULL,
    [ThirdPartyBillingPhone2]      VARCHAR (15)  NULL,
    [ThirdPartyBillingFax]         VARCHAR (15)  NULL,
    [ThirdPartyBillingEmail]       VARCHAR (100) NULL,
    [OtherPartyAddressType]        VARCHAR (50)  NULL,
    [OtherPartyCompanyName]        VARCHAR (100) NULL,
    [OtherPartyFirstName]          VARCHAR (50)  NULL,
    [OtherPartyLastName]           VARCHAR (50)  NULL,
    [OtherPartyAddress1]           VARCHAR (50)  NULL,
    [OtherPartyAddress2]           VARCHAR (50)  NULL,
    [OtherPartyCity]               VARCHAR (70)  NULL,
    [OtherPartyState]              VARCHAR (5)   NULL,
    [OtherPartyZip]                VARCHAR (10)  NULL,
    [OtherPartyPhone1]             VARCHAR (15)  NULL,
    [OtherPartyPhone2]             VARCHAR (15)  NULL,
    [OtherPartyFax]                VARCHAR (15)  NULL,
    [OtherPartyEmail]              VARCHAR (100) NULL,
    [SendToOtherParty]             VARCHAR (MAX) NULL,
    [ICDCode1]                     VARCHAR (70)  NULL,
    [ICDStatus1]                   VARCHAR (20)  NULL,
    [ICDBodySide1]                 VARCHAR (20)  NULL,
    [ICDDescription1]              VARCHAR (100) NULL,
    [ICDCode2]                     VARCHAR (70)  NULL,
    [ICDStatus2]                   VARCHAR (20)  NULL,
    [ICDBodySide2]                 VARCHAR (20)  NULL,
    [ICDDescription2]              VARCHAR (100) NULL,
    [ICDCode3]                     VARCHAR (70)  NULL,
    [ICDStatus3]                   VARCHAR (20)  NULL,
    [ICDBodySide3]                 VARCHAR (20)  NULL,
    [ICDDescription3]              VARCHAR (100) NULL,
    [ICDCode4]                     VARCHAR (70)  NULL,
    [ICDStatus4]                   VARCHAR (20)  NULL,
    [ICDBodySide4]                 VARCHAR (20)  NULL,
    [ICDDescription4]              VARCHAR (100) NULL,
    [PreviousClaimsClaimNbr1]      VARCHAR (50)  NULL,
    [PreviousClaimsPPDAward1]      VARCHAR (30)  NULL,
    [PreviousClaimsMajorBodyPart1] VARCHAR (50)  NULL,
    [PreviousClaimsMinorBodyPart1] VARCHAR (50)  NULL,
    [PreviousClaimsBodySide1]      VARCHAR (50)  NULL,
    [Notes]                        VARCHAR (MAX) NULL,
    [AttorneyNote]                 VARCHAR (MAX) NULL,
    [ScheduleNotes]                VARCHAR (MAX) NULL,
    [BillingNote]                  VARCHAR (MAX) NULL,
    [OfficeCode]                   INT           NULL,
    [OfficeDesc]                   VARCHAR (100) NULL,
    [RecCode]                      INT           NULL,
    [RecDesc]                      VARCHAR (100) NULL,
    [QARep]                        VARCHAR (50)  NULL,
    [Status]                       INT           NULL,
    [StatusDesc]                   VARCHAR (100) NULL,
    [SchedCode]                    INT           NULL,
    [ReportVerbal]                 BIT           NOT NULL,
    [PhotoRqd]                     BIT           NOT NULL,
    [CertifiedMail]                BIT           NOT NULL,
    [HearingDate]                  DATETIME      NULL,
    [ApptDate]                     DATETIME      NULL,
    [ApptTime]                     DATETIME      NULL,
    [ApptMadeDate]                 DATETIME      NULL,
    [ApptStatusId]                 INT           NULL,
    [CaseApptId]                   INT           NULL,
    [CommitDate]                   DATETIME      NULL,
    [DateReceived]                 DATETIME      NULL,
    [DateAcknowledged]             DATETIME      NULL,
    [DateAdded]                    DATETIME      NULL,
    [UserIdAdded]                  VARCHAR (50)  NULL,
    [DateEdited]                   DATETIME      NULL,
    [UserIdEdited]                 VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblWebReferral] PRIMARY KEY CLUSTERED ([WebReferralID] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


GO
PRINT N'Creating [dbo].[DF_tblBusinessRule_AllowOverride]...';


GO
ALTER TABLE [dbo].[tblBusinessRule]
    ADD CONSTRAINT [DF_tblBusinessRule_AllowOverride] DEFAULT ((0)) FOR [AllowOverride];


GO
PRINT N'Creating [dbo].[DF_tblBusinessRule_IsActive]...';


GO
ALTER TABLE [dbo].[tblBusinessRule]
    ADD CONSTRAINT [DF_tblBusinessRule_IsActive] DEFAULT ((1)) FOR [IsActive];


GO
PRINT N'Creating [dbo].[DF_tblBusinessRuleCondition_BillingEntity]...';


GO
ALTER TABLE [dbo].[tblBusinessRuleCondition]
    ADD CONSTRAINT [DF_tblBusinessRuleCondition_BillingEntity] DEFAULT ((0)) FOR [BillingEntity];


GO
PRINT N'Creating [dbo].[DF_tblCaseDocumentsDicom_FlagForUse]...';


GO
ALTER TABLE [dbo].[tblCaseDocumentsDicom]
    ADD CONSTRAINT [DF_tblCaseDocumentsDicom_FlagForUse] DEFAULT ((0)) FOR [FlagForUse];


GO
PRINT N'Creating [dbo].[DF_tblCaseDocumentsDicom_IsValidatedBinary]...';


GO
ALTER TABLE [dbo].[tblCaseDocumentsDicom]
    ADD CONSTRAINT [DF_tblCaseDocumentsDicom_IsValidatedBinary] DEFAULT ((0)) FOR [IsValidatedBinary];


GO
PRINT N'Creating [dbo].[DF_tblCaseDocumentsDicom_IsValidatedFileExists]...';


GO
ALTER TABLE [dbo].[tblCaseDocumentsDicom]
    ADD CONSTRAINT [DF_tblCaseDocumentsDicom_IsValidatedFileExists] DEFAULT ((0)) FOR [IsValidatedFileExists];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_AmendedRequest]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_AmendedRequest] DEFAULT ((0)) FOR [AmendedRequest];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_CertifiedMail]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_CertifiedMail] DEFAULT ((0)) FOR [CertifiedMail];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_ContactAttorney]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_ContactAttorney] DEFAULT ((0)) FOR [ContactAttorney];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_ContactClaimant]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_ContactClaimant] DEFAULT ((0)) FOR [ContactClaimant];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_InterpreterNeeded]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_InterpreterNeeded] DEFAULT ((0)) FOR [InterpreterRequired];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_InterpreterNeeded1]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_InterpreterNeeded1] DEFAULT ((0)) FOR [LanguageRequired];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_PhotoRqd]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_PhotoRqd] DEFAULT ((0)) FOR [PhotoRqd];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_ReportVerbal]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_ReportVerbal] DEFAULT ((0)) FOR [ReportVerbal];


GO
PRINT N'Creating [dbo].[DF_tblWebReferral_TransportationNeeded]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD CONSTRAINT [DF_tblWebReferral_TransportationNeeded] DEFAULT ((0)) FOR [TransportationRequired];


GO
PRINT N'Altering [dbo].[vwServiceWorkflow]...';


GO
ALTER VIEW vwServiceWorkflow
AS
    SELECT
        WF.ServiceWorkflowID,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.UserIDAdded,
        WF.DateAdded,
        WF.UserIDEdited,
        WF.DateEdited,
        WF.ExamineeAddrReqd,
        WF.ExamineeSSNReqd,
        WF.AttorneyReqd,
        WF.DOIRqd,
        WF.ClaimNbrRqd,
        WF.JurisdictionRqd,
        WF.EmployerRqd,
        WF.TreatingPhysicianRqd,
        WF.CalcFrom,
        WF.DaysToForecastDate,
        WF.DaysToInternalDueDate,
        WF.DaysToExternalDueDate,
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus,
		WF.UsePeerBill
    FROM
        tblServiceWorkflow AS WF
    INNER JOIN tblCaseType AS CT ON WF.CaseType=CT.Code
    INNER JOIN tblServices AS S ON S.ServiceCode=WF.ServiceCode
    INNER JOIN tblOffice AS O ON O.OfficeCode=WF.OfficeCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowID,
                        COUNT(ServiceWorkflowQueueID) AS QueueCount
                     FROM
                        tblServiceWorkflowQueue
                     GROUP BY
                        ServiceWorkflowID
                    ) AS WFQ ON WFQ.ServiceWorkflowID=WF.ServiceWorkflowID
GO
PRINT N'Altering [dbo].[vwServiceWorkflowQueueDocument]...';


GO
ALTER VIEW vwServiceWorkflowQueueDocument
AS
    SELECT
        WFQD.ServiceWorkflowQueueDocumentID,
        WFQ.ServiceWorkflowQueueID,
        WF.ServiceWorkflowID,
        WF.ServiceCode,
        WF.CaseType,
        WF.OfficeCode,
        WFQ.StatusCode,
        WFQD.Document,
        WFQD.Attachment,
        WFQD.ProcessOrder,
        WFQD.PrintCopies,
        WFQD.EmailDoctor,
        WFQD.EmailAttorney,
        WFQD.EmailClient,
        WFQD.FaxDoctor,
        WFQD.FaxAttorney,
        WFQD.FaxClient,
		WFQD.EnvelopeAOrder, 
		WFQD.EnvelopeBOrder, 
		WFQD.EnvelopeCOrder, 
		WFQD.EnvelopeDOrder
    FROM
        tblServiceWorkflowQueueDocument AS WFQD
    INNER JOIN tblServiceWorkflowQueue AS WFQ ON WFQ.ServiceWorkflowQueueID=WFQD.ServiceWorkflowQueueID
    INNER JOIN tblServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Insert]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Insert]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int = NULL output,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32),
	@CaseDocTypeId int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseDocuments]
	(
		[casenbr],
		[document],
		[type],
		[reporttype],
		[description],
		[sfilename],
		[dateadded],
		[useridadded],
		[dateedited],
		[useridedited],
		[PublishedTo],
		[Viewed],
		[FileMoved],
		[FileSize],
		[Source],
		[FolderID],
		[SubFolder],
		[CaseDocTypeId]
	)
	VALUES
	(
		@casenbr,
		@document,
		@type,
		@reporttype,
		@description,
		@sfilename,
		@dateadded,
		@useridadded,
		@dateedited,
		@useridedited,
		@PublishedTo,
		@Viewed,
		@FileMoved,
		@FileSize,
		@Source,
		@FolderID,
		@SubFolder,
		@CaseDocTypeId
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID
		AND (casenbr = @CaseNbr)
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Update]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Update]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32),
	@CaseDocTypeId int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseDocuments]
	SET
		[casenbr] = @casenbr,
		[document] = @document,
		[type] = @type,
		[reporttype] = @reporttype,
		[description] = @description,
		[sfilename] = @sfilename,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[PublishedTo] = @PublishedTo,
		[Viewed] = @Viewed,
		[FileMoved] = @FileMoved,
		[FileSize] = @FileSize,
		[Source] = @Source,
		[FolderID] = @FolderID,
		[SubFolder] = @SubFolder,
		[CaseDocTypeId] = @CaseDocTypeId
	WHERE
		[seqno] = @seqno


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseHistory_Insert]...';


GO
ALTER PROCEDURE [proc_CaseHistory_Insert]
(
	@id int = NULL output,
	@casenbr int,
	@eventdate datetime,
	@eventdesc varchar(50) = NULL,
	@userid varchar(15) = NULL,
	@otherinfo varchar(1000) = NULL,
	@duration int = NULL,
	@type varchar(20) = NULL,
	@status int = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@dateadded datetime = NULL,
	@SubCaseID int = NULL,
	@Highlight bit = NULL,
	@Viewed bit,
	@PublishedTo varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseHistory]
	(
		[casenbr],
		[eventdate],
		[eventdesc],
		[userid],
		[otherinfo],
		[duration],
		[type],
		[status],
		[dateedited],
		[useridedited],
		[dateadded],
		[SubCaseID],
		[Highlight],
		[Viewed],
		[PublishedTo]
	)
	VALUES
	(
		@casenbr,
		@eventdate,
		@eventdesc,
		@userid,
		@otherinfo,
		@duration,
		@type,
		@status,
		@dateedited,
		@useridedited,
		@dateadded,
		@SubCaseID,
		@Highlight,
		@Viewed,
		@PublishedTo
	)

	SET @Err = @@Error

	SELECT @id = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin bit = 0

AS

IF @IsAdmin = 1
	BEGIN
		SELECT DISTINCT *
		FROM tblCaseHistory 
		WHERE casenbr = @CaseNbr AND tblCaseHistory.PublishOnWeb = 1
	END
ELSE
	BEGIN
		SELECT DISTINCT * FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (casenbr = @CaseNbr)
	END
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadExprtGridByCaseNbr]...';


GO
ALTER PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblCaseHistory.UserID as 'User', tblCaseHistory.DateAdded as 'Date Added', eventdesc as Description, otherinfo as Info 
		FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (casenbr = @CaseNbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseHistory_Update]...';


GO
ALTER PROCEDURE [proc_CaseHistory_Update]
(
	@id int,
	@casenbr int,
	@eventdate datetime,
	@eventdesc varchar(50) = NULL,
	@userid varchar(15) = NULL,
	@otherinfo varchar(1000) = NULL,
	@duration int = NULL,
	@type varchar(20) = NULL,
	@status int = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@dateadded datetime = NULL,
	@SubCaseID int = NULL,
	@Highlight bit = NULL,
	@Viewed bit,
	@PublishedTo varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseHistory]
	SET
		[casenbr] = @casenbr,
		[eventdate] = @eventdate,
		[eventdesc] = @eventdesc,
		[userid] = @userid,
		[otherinfo] = @otherinfo,
		[duration] = @duration,
		[type] = @type,
		[status] = @status,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[dateadded] = @dateadded,
		[SubCaseID] = @SubCaseID,
		[Highlight] = @Highlight,
		[Viewed] = @Viewed,
		[PublishedTo] = @PublishedTo
	WHERE
		[id] = @id


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseHistory_UpdateViewed]...';


GO
/****** Object:  StoredProcedure [proc_CaseHistory_UpdateViewed]    Script Date: 2/16/2010 11:24:36 PM ******/
ALTER PROCEDURE [proc_CaseHistory_UpdateViewed]

@casenbr int

AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE tblCaseHistory SET viewed = 1 WHERE casenbr = @casenbr 

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_DoctorAssistant_LoadByPrimaryKey]...';


GO
CREATE PROCEDURE [proc_DoctorAssistant_LoadByPrimaryKey]
(
	@DrAssistantId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblDrAssistant]
	WHERE
		([DrAssistantId] = @DrAssistantId)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[spCaseSearchForDicom]...';


GO


create proc spCaseSearchForDicom
	@casenbr int = 0,
	@claimnbr varchar(50) = null,
	@fname varchar(50) = null,
	@lname varchar(50) = null,
	@dob varchar(10) = null
as


	if @casenbr > 0 or (@claimnbr is not null and len(@claimnbr) > 0)
	begin

	
	select 
		c.CaseNbr, c.ChartNbr, 
		('Case Nbr:' + convert(varchar(50), c.CaseNbr) + ' - Chart NBR: ' + convert(varchar(50), c.ChartNbr) + ' - Examinee: ' + examinee.FirstName + ' ' + examinee.LastName) as CaseHeader,
		examinee.FirstName + ' ' + examinee.LastName as ExamineeName,
		examinee.FirstName as ExamineeFirstName,
		examinee.LastName as ExamineeLastName,
		examinee.Sex ,
		examinee.DOB as ExamineeDOB,
		 c.[Status], 
		c.CaseType, ct.ShortDesc as CaseTypeDesc,
		c.SchedCode, c.PanelNbr,
		--c.ApptDate, c.ApptTime, 
		c.ServiceCode,  svc.Description AS Servicedesc,
		c.DoctorCode,
		doc.FirstName as DocFirstName,
		doc.LastName as DocLastName,
		c.DoctorName as Paneldesc, c.DoctorSpecialty, 
		c.DoctorLocation, 
		ds.LocationCode ,
		convert(varchar(10), ds.date, 101) as ApptDate,
		(ds.StartTime),substring(convert(varchar, getdate(), 108),0,6) as ApptTime, 
		ds.Description as ApptDesc,
		ds.Status as ApptStatus, 
		loc.Location,
		loc.Addr1,
		loc.Addr2,
		loc.City,
		loc.State,
		loc.Zip,   
		c.ClaimNbr, c.ClaimNbrExt, 
		c.ClientCode, 
		client.FirstName + ' ' + client.LastName AS ClientName,
		c.CompanyCode, 
		co.IntName as CompanyIntName,
		co.ExtName AS Company,
		c.CaseApptID,
		ca.ApptStatusID, aptstatus.Name as ApptStatus
	from tblCase c
		join tblExaminee examinee on c.ChartNbr = examinee.ChartNbr
		join tblCaseAppt ca on c.CaseApptID = ca.CaseApptID and c.CaseNbr = ca.CaseNbr
		join tblApptStatus aptstatus on ca.ApptStatusID = aptstatus.ApptStatusID
		join tblCaseType ct on c.CaseType = ct.Code
		join tblServices svc on c.ServiceCode = svc.ServiceCode 
		join tblcompany co on co.companycode = c.companycode
		join tblclient as client on client.clientcode = c.ClientCode
		join tblServices on c.ServiceCode = tblServices.ServiceCode 
		left join tblCasePanel cp on cp.PanelNbr = c.PanelNbr
		left join tblDoctorSchedule ds on ds.SchedCode = ISNULL(cp.SchedCode, c.SchedCode)
		join tblLocation loc on ds.LocationCode = loc.LocationCode
		join tblDoctor doc on ds.DoctorCode = doc.DoctorCode
	
	where 
		c.SchedCode is not null --// only care about scheduled appointments
		and year(c.apptdate) >= year(getdate()) --// only current year to limit performance
		and c.ApptDate > getdate()
		and InvoiceDate is null 
		and ca.ApptStatusID = 10

		and (
			--// check on case number
			c.CaseNbr = @casenbr

			or
			--// check on claim number
			(@claimnbr is not null and replace(replace(replace(replace(upper(c.ClaimNbr), '-', ''),'.',''),'_',''),' ','') like replace(replace(replace(replace(upper(@claimnbr), '-', ''),'.',''),'_',''),' ','') + '%')
		)


	end
	else
	begin
		
		select 
			c.CaseNbr, c.ChartNbr, 
			('Case Nbr:' + convert(varchar(50), c.CaseNbr) + ' - Chart NBR: ' + convert(varchar(50), c.ChartNbr) + ' - Examinee: ' + examinee.FirstName + ' ' + examinee.LastName) as CaseHeader,
			examinee.FirstName + ' ' + examinee.LastName as ExamineeName,
			examinee.FirstName as ExamineeFirstName,
			examinee.LastName as ExamineeLastName,
			examinee.Sex ,
			examinee.DOB as ExamineeDOB,
			 c.[Status], 
			c.CaseType, ct.ShortDesc as CaseTypeDesc,
			c.SchedCode, c.PanelNbr,
			--c.ApptDate, c.ApptTime, 
			c.ServiceCode,  svc.Description AS Servicedesc,
			c.DoctorCode,
			doc.FirstName as DocFirstName,
			doc.LastName as DocLastName,
			c.DoctorName as Paneldesc, c.DoctorSpecialty, 
			c.DoctorLocation, 
			ds.LocationCode ,
			convert(varchar(10), ds.date, 101) as ApptDate,
			(ds.StartTime),substring(convert(varchar, getdate(), 108),0,6) as ApptTime, 
			ds.Description as ApptDesc,
			ds.Status as ApptStatus, 
			loc.Location,
			loc.Addr1,
			loc.Addr2,
			loc.City,
			loc.State,
			loc.Zip,   
			c.ClaimNbr, c.ClaimNbrExt, 
			c.ClientCode, 
			client.FirstName + ' ' + client.LastName AS ClientName,
			c.CompanyCode, 
			co.IntName as CompanyIntName,
			co.ExtName AS Company,
			c.CaseApptID,
			ca.ApptStatusID, aptstatus.Name as ApptStatus
		from tblCase c
			join tblExaminee examinee on c.ChartNbr = examinee.ChartNbr
			join tblCaseAppt ca on c.CaseApptID = ca.CaseApptID and c.CaseNbr = ca.CaseNbr
			join tblApptStatus aptstatus on ca.ApptStatusID = aptstatus.ApptStatusID
			join tblCaseType ct on c.CaseType = ct.Code
			join tblServices svc on c.ServiceCode = svc.ServiceCode 
			join tblcompany co on co.companycode = c.companycode
			join tblclient as client on client.clientcode = c.ClientCode
			join tblServices on c.ServiceCode = tblServices.ServiceCode 
			left join tblCasePanel cp on cp.PanelNbr = c.PanelNbr
			left join tblDoctorSchedule ds on ds.SchedCode = ISNULL(cp.SchedCode, c.SchedCode)
			join tblLocation loc on ds.LocationCode = loc.LocationCode
			join tblDoctor doc on ds.DoctorCode = doc.DoctorCode
	
		where 
			c.SchedCode is not null --// only care about scheduled appointments
			and year(c.apptdate) >= year(getdate()) --// only current year to limit performance
			and c.ApptDate > getdate()
			and InvoiceDate is null 
			and ca.ApptStatusID = 10

			and (
				--// check the name
				(
				(upper(examinee.FirstName) like (case when isnull(@fname,'') = '' then '%' else @fname + '%' end)) 
				and
				(upper(examinee.LastName) like (case when isnull(@lname,'') = '' then '%' else @lname + '%' end)) 
				)

				and

				--// check the dob
				(
					(@dob is not null and (convert(int,coalesce(convert(varchar(8),examinee.dob,(112)),(0)),(0))) = @dob)
					or
					(@dob is null and 1 = 1)
				)
			)

	end
GO
PRINT N'Creating [dbo].[spGetBusinessRules]...';


GO
CREATE PROCEDURE dbo.spGetBusinessRules
(
	@eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @groupDigits INT

	SET @groupDigits = 10000000

	SELECT * FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,
	 ROW_NUMBER() OVER (PARTITION BY BR.BusinessRuleID ORDER BY tmpBR.GroupID*@groupDigits+(CASE tmpBR.EntityType WHEN 'SW' THEN 4 WHEN 'PC' THEN 3 WHEN 'CO' THEN 2 WHEN 'CL' THEN 1 ELSE 9 END)*1000000+tmpBR.ProcessOrder) AS RowNbr,
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder
	FROM
	(
	SELECT 1 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (0,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 2 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (1,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 3 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	WHERE 1=1
	AND (BRC.EntityType='SW')
	) AS tmpBR
	INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
	LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
	LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
	WHERE BR.IsActive=1
	and BR.EventID=@eventID
	AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
	AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
	AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
	AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR
	WHERE sortedBR.RowNbr=1
	ORDER BY sortedBR.BusinessRuleID
END
GO
PRINT N'Creating [dbo].[spLock_Create]...';


GO
CREATE PROCEDURE spLock_Create
(
	@tableType VARCHAR(50),
	@tableKey INT,
	@userID varchar(50),
	@sessionID varchar(50),
	@moduleName varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO tblLock
	(
		TableType,
		TableKey,
		DateLocked,
		DateAdded,
		UserID,
		SessionID,
		ModuleName
	)
	SELECT @tableType,
		   @tableKey,
		   GETDATE(),
		   GETDATE(),
		   @userID,
		   @sessionID,
		   @moduleName
	WHERE NOT EXISTS
	(
		SELECT L.LockID
		  FROM tblLock AS L INNER JOIN tblControl AS C ON C.InstallID=1
		WHERE L.TableType=@tableType AND L.TableKey=@tableKey
		  AND DATEADD(SECOND, C.LockTimeoutSec, L.DateLocked)>GETDATE()
	)


	IF @@ROWCOUNT<>1
		SELECT CAST(0 AS BIT) AS Locked, L.LockID, L.UserID FROM tblLock AS L WHERE L.TableType=@tableType AND L.TableKey=@tableKey
	ELSE
		SELECT CAST(1 AS BIT) AS Locked, L.LockID, L.UserID FROM tblLock AS L WHERE L.LockID=SCOPE_IDENTITY()

END
GO








INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('ApptOverride', 'Appointments - Override', GETDATE())
GO
-- Issue 6600 Two new security tokens for Dr Assistant
Insert into tblUserFunction 
values
('DrAssistantAdd', 'Doctor Assistant – Add/Edit', CONVERT (date, GETDATE())),
('DrAssistantDelete', 'Doctor Assistant - Delete', CONVERT (date, GETDATE()))
Go






INSERT INTO [dbo].[tblBusinessRule] ([Name], [Category], [Descrip], [IsActive], [EventID], [AllowOverride], [Param1Desc], [Param2Desc], [Param3Desc], [Param4Desc], [Param5Desc], [BrokenRuleAction]) VALUES ('MaxApptPerDay', 'Appointment', 'Maximum number of appointments on the same day for the same examinee', 1, 1101, 1, 'Max Appointments', NULL, NULL, NULL, 'Override Token', 0)
INSERT INTO [dbo].[tblBusinessRule] ([Name], [Category], [Descrip], [IsActive], [EventID], [AllowOverride], [Param1Desc], [Param2Desc], [Param3Desc], [Param4Desc], [Param5Desc], [BrokenRuleAction]) VALUES ('MustUseRequestedSpecialty', 'Appointment', 'Do not allow scheduling an appointment with specialty different from client requested', 1, 1101, 1, NULL, NULL, NULL, NULL, 'Override Token', 0)
INSERT INTO [dbo].[tblBusinessRule] ([Name], [Category], [Descrip], [IsActive], [EventID], [AllowOverride], [Param1Desc], [Param2Desc], [Param3Desc], [Param4Desc], [Param5Desc], [BrokenRuleAction]) VALUES ('MinsReqMultiApptSameClaim', 'Appointment', 'Minutes required between two examinees'' appointment on the same claim number', 1, 1101, 1, 'Minutes Required', NULL, NULL, NULL, 'Override Token', 0)
GO




INSERT INTO tblSetting (Name, Value) VALUES ('UseSessionTable', 'True')
GO
UPDATE tblControl SET LockTimeoutSec=1800
UPDATE tblControl SET UserCacheMin=15
UPDATE tblControl SET SettingCacheMin=480
GO









UPDATE tblControl SET DBVersion='3.24'
GO