CREATE TABLE [dbo].[tblServiceWorkflow] (
    [ServiceWorkflowID]     INT          IDENTITY (1, 1) NOT NULL,
    [OfficeCode]            INT          NOT NULL,
    [CaseType]              INT          NOT NULL,
    [ServiceCode]           INT          NOT NULL,
    [UserIDAdded]           VARCHAR (15) NULL,
    [DateAdded]             DATETIME     NULL,
    [UserIDEdited]          VARCHAR (15) NULL,
    [DateEdited]            DATETIME     NULL,
    [ExamineeAddrReqd]      BIT          CONSTRAINT [DF_tblServiceWorkflow_ExamineeAddrReqd] DEFAULT ((0)) NOT NULL,
    [ExamineeSSNReqd]       BIT          CONSTRAINT [DF_tblServiceWorkflow_ExamineeSSNReqd] DEFAULT ((0)) NOT NULL,
    [AttorneyReqd]          BIT          CONSTRAINT [DF_tblServiceWorkflow_AttorneyReqd] DEFAULT ((0)) NOT NULL,
    [DOIRqd]                BIT          CONSTRAINT [DF_tblServiceWorkflow_DOIRqd] DEFAULT ((0)) NOT NULL,
    [ClaimNbrRqd]           BIT          CONSTRAINT [DF_tblServiceWorkflow_ClaimNbrRqd] DEFAULT ((0)) NOT NULL,
    [JurisdictionRqd]       BIT          CONSTRAINT [DF_tblServiceWorkflow_JurisdictionRqd] DEFAULT ((0)) NOT NULL,
    [EmployerRqd]           BIT          CONSTRAINT [DF_tblServiceWorkflow_EmployerRqd] DEFAULT ((0)) NOT NULL,
    [TreatingPhysicianRqd]  BIT          CONSTRAINT [DF_tblServiceWorkflow_TreatingPhysicianRqd] DEFAULT ((0)) NOT NULL,
    [CalcFrom]              VARCHAR (10) NULL,
    [DaysToForecastDate]    INT          NULL,
    [DaysToInternalDueDate] INT          NULL,
    [DaysToExternalDueDate] INT          NULL,
    [UsePeerBill]           BIT          CONSTRAINT [DF_tblServiceWorkflow_UsePeerBill] DEFAULT ((0)) NOT NULL, 
	[DaysToDoctorRptDueDate] INT         NULL,
	[InternalDueDateType]	INT	CONSTRAINT [DF_tblServiceWorkflow_InternalDueDateType]  DEFAULT 1 NOT NULL,
	[ExternalDueDateType]	INT	CONSTRAINT [DF_tblServiceWorkflow_ExternalDueDateType]  DEFAULT 1 NOT NULL,
	[DoctorRptDueDateType]	INT	CONSTRAINT [DF_tblServiceWorkflow_DoctorRptDueDateType]  DEFAULT 1 NOT NULL,
	[ForecastDateType]		INT	CONSTRAINT [DF_tblServiceWorkflow_ForecastDateType]  DEFAULT 1 NOT NULL,
    [WcCaseTypeRqd]         BIT          CONSTRAINT [DF_tblServiceWorkflow_WcCaseTypeRqd] DEFAULT ((0)) NULL, 
    [DobRqd]                BIT          CONSTRAINT [DF_tblServiceWorkflow_DobRqd] DEFAULT ((0)) NULL, 
    CONSTRAINT [PK_tblServiceWorkflow] PRIMARY KEY CLUSTERED ([ServiceWorkflowID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblServiceWorkflow_OfficeCodeCaseTypeServiceCode]
    ON [dbo].[tblServiceWorkflow]([OfficeCode] ASC, [CaseType] ASC, [ServiceCode] ASC);


GO