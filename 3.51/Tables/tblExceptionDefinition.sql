CREATE TABLE [dbo].[tblExceptionDefinition] (
    [ExceptionDefID]   INT            IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (100)  NULL,
    [Entity]           VARCHAR (10)   NOT NULL,
    [IMECentricCode]   INT            NULL,
    [ExceptionID]      INT            NOT NULL,
    [CaseTypeCode]     INT            CONSTRAINT [DF_tblExceptionDefinition_CaseTypeCode] DEFAULT ((-1)) NULL,
    [ServiceCode]      INT            CONSTRAINT [DF_tblExceptionDefinition_ServiceCode] DEFAULT ((-1)) NULL,
    [StatusCode]       INT            CONSTRAINT [DF_tblExceptionDefinition_StatusCode] DEFAULT ((-1)) NULL,
    [StatusCodeValue]  INT            NULL,
    [DisplayMessage]   BIT            CONSTRAINT [DF_tblExceptionDefinition_DisplayMessage] DEFAULT ((0)) NOT NULL,
    [RequireComment]   BIT            CONSTRAINT [DF_tblExceptionDefinition_RequireComment] DEFAULT ((0)) NOT NULL,
    [EmailMessage]     BIT            CONSTRAINT [DF_tblExceptionDefinition_EmailMessage] DEFAULT ((0)) NOT NULL,
    [EditEmail]        BIT            CONSTRAINT [DF_tblExceptionDefinition_EditEmail] DEFAULT ((0)) NOT NULL,
    [GenerateDocument] BIT            CONSTRAINT [DF_tblExceptionDefinition_GenerateDocument] DEFAULT ((0)) NOT NULL,
    [Message]          TEXT           NULL,
    [EmailScheduler]   BIT            CONSTRAINT [DF_tblExceptionDefinition_EmailScheduler] DEFAULT ((0)) NOT NULL,
    [EmailQA]          BIT            CONSTRAINT [DF_tblExceptionDefinition_EmailQA] DEFAULT ((0)) NOT NULL,
    [EmailOther]       VARCHAR (200)  NULL,
    [EmailSubject]     VARCHAR (300)  NULL,
    [EmailText]        TEXT           NULL,
    [Document1]        VARCHAR (50)   NULL,
    [Document2]        VARCHAR (50)   NULL,
    [Status]           VARCHAR (10)   CONSTRAINT [DF_tblExceptionDefinition_Status] DEFAULT ('Active') NULL,
    [DateAdded]        DATETIME       NULL,
    [UserIDAdded]      VARCHAR (50)   NULL,
    [DateEdited]       DATETIME       NULL,
    [UserIDEdited]     VARCHAR (50)   NULL,
    [UseBillingEntity] BIT            CONSTRAINT [DF_tblExceptionDefinition_UseBillingEntity] DEFAULT ((0)) NOT NULL,
    [AllOffice]        BIT            CONSTRAINT [DF_tblExceptionDefinition_AllOffice] DEFAULT ((0)) NOT NULL,
    [CreateCHAlert]    BIT            CONSTRAINT [DF_tblExceptionDefinition_CreateCHAlert] DEFAULT ((0)) NOT NULL,
    [CHEventDesc]      VARCHAR (50)   NULL,
    [CHOtherInfo]      VARCHAR (3000) NULL,
    [AllEWServiceType] BIT            CONSTRAINT [DF_tblExceptionDefinition_AllEWServiceType] DEFAULT ((1)) NOT NULL,
    [AllCaseType]      BIT            CONSTRAINT [DF_tblExceptionDefinition_AllCaseType] DEFAULT ((1)) NOT NULL,
    [AllService]       BIT            CONSTRAINT [DF_tblExceptionDefinition_AllService] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblExceptionDefinition] PRIMARY KEY CLUSTERED ([ExceptionDefID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblExceptionDefinition_ExceptionID]
    ON [dbo].[tblExceptionDefinition]([ExceptionID] ASC);

