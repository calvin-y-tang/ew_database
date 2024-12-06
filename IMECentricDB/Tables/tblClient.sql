CREATE TABLE [dbo].[tblClient] (
    [CompanyCode]              INT              NULL,
    [ClientCode]               INT              IDENTITY (1, 1) NOT NULL,
    [ClientNbrOld]             VARCHAR (10)     NULL,
    [LastName]                 VARCHAR (50)     NULL,
    [FirstName]                VARCHAR (50)     NULL,
    [Title]                    VARCHAR (50)     NULL,
    [Prefix]                   VARCHAR (10)     NULL,
    [Suffix]                   VARCHAR (50)     NULL,
    [Addr1]                    VARCHAR (60)     NULL,
    [Addr2]                    VARCHAR (60)     NULL,
    [City]                     VARCHAR (60)     NULL,
    [State]                    VARCHAR (2)      NULL,
    [Zip]                      VARCHAR (10)     NULL,
    [Phone1]                   VARCHAR (15)     NULL,
    [Phone1Ext]                VARCHAR (15)     NULL,
    [Phone2]                   VARCHAR (15)     NULL,
    [Phone2Ext]                VARCHAR (15)     NULL,
    [Fax]                      VARCHAR (15)     NULL,
    [Email]                    VARCHAR (150)    NULL,
    [MarketerCode]             VARCHAR (15)     NULL,
    [Priority]                 VARCHAR (50)     NULL,
    [CaseType]                 VARCHAR (20)     NULL,
    [FeeSchedule]              INT              NULL,
    [Status]                   VARCHAR (10)     CONSTRAINT [DF_tblClient_Status] DEFAULT ('Active') NULL,
    [ReportPhone]              BIT              NULL,
    [DocumentEmail]            BIT              NULL,
    [DocumentFax]              BIT              NULL,
    [DocumentMail]             BIT              CONSTRAINT [DF_tblClient_DocumentMail] DEFAULT (1) NULL,
    [LastAppt]                 DATETIME         NULL,
    [DateAdded]                DATETIME         NULL,
    [UserIDAdded]              VARCHAR (15)     NULL,
    [DateEdited]               DATETIME         NULL,
    [UserIDEdited]             VARCHAR (15)     NULL,
    [USDVarchar1]              VARCHAR (50)     NULL,
    [USDVarchar2]              VARCHAR (50)     NULL,
    [USDDate1]                 DATETIME         NULL,
    [USDDate2]                 DATETIME         NULL,
    [USDText1]                 TEXT             NULL,
    [USDText2]                 TEXT             NULL,
    [USDInt1]                  INT              NULL,
    [USDInt2]                  INT              NULL,
    [USDMoney1]                MONEY            NULL,
    [USDMoney2]                MONEY            NULL,
    [Notes]                    TEXT             NULL,
    [BillAddr1]                VARCHAR (50)     NULL,
    [BillAddr2]                VARCHAR (50)     NULL,
    [BillCity]                 VARCHAR (50)     NULL,
    [BillState]                VARCHAR (2)      NULL,
    [BillZip]                  VARCHAR (10)     NULL,
    [BillAttn]                 VARCHAR (70)     NULL,
    [ARKey]                    VARCHAR (50)     NULL,
    [BillFax]                  VARCHAR (15)     NULL,
    [QARep]                    VARCHAR (15)     NULL,
    [PhotoRqd]                 BIT              NULL,
    [CertifiedMail]            BIT              NULL,
    [Country]                  VARCHAR (50)     NULL,
    [PublishOnWeb]             BIT              CONSTRAINT [DF_tblclient_publishonweb] DEFAULT (0) NULL,
    [WebGUID]                  UNIQUEIDENTIFIER NULL,
    [WebLastSynchDate]         DATETIME         NULL,
    [ProcessorFirstName]       VARCHAR (30)     NULL,
    [ProcessorLastName]        VARCHAR (50)     NULL,
    [ProcessorPhone]           VARCHAR (15)     NULL,
    [ProcessorPhoneExt]        VARCHAR (10)     NULL,
    [ProcessorFax]             VARCHAR (15)     NULL,
    [ProcessorEmail]           VARCHAR (200)    NULL,
    [UseNotificationOverrides] BIT              CONSTRAINT [DF_tblClient_UseNotificationOverrides] DEFAULT (0) NULL,
    [TypeCode]                 INT              NULL,
    [CSR1]                     VARCHAR (15)     NULL,
    [CSR2]                     VARCHAR (15)     NULL,
    [AutoReSchedule]           BIT              NULL,
    [FldSupervisor]            BIT              NULL,
    [WebUserID]                INT              NULL,
    [DocumentPublish]          BIT              CONSTRAINT [DF_tblClient_DocumentPublish] DEFAULT (0) NULL,
    [HCAIInsurerID]            VARCHAR (50)     NULL,
    [HCAIBranchID]             VARCHAR (50)     NULL,
    [EWClientID]               INT              NULL,
    [IsUnknown]                BIT              CONSTRAINT [DF_tblClient_IsUnknown] DEFAULT ((0)) NOT NULL,
    [CreateCvrLtr]             BIT              CONSTRAINT [DF_tblClient_CreateCvrLtr] DEFAULT ((0)) NOT NULL,
    [SpecialReqNotes]          TEXT             NULL,
    [DistributionNotes]        VARCHAR(MAX)     NULL, 
    [EmployeeNumber]           VARCHAR(255)     NULL, 
	[FirstCaseNbr]             INT              NULL,
	[CRMPrimaryEmail]		   VARCHAR(255)     NULL,	
    [InputSourceID]			   INT		        NOT NULL,
    [DateInactivated]          DATETIME         NULL,
    [UserInactivated]          VARCHAR (20)     NULL,
    CONSTRAINT [PK_tblClient] PRIMARY KEY CLUSTERED ([ClientCode] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tblClient_tblCompany] FOREIGN KEY ([CompanyCode]) REFERENCES [dbo].[tblCompany] ([CompanyCode])
);


GO
ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany];




GO
ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany];




GO
ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany];




GO
ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany];




GO
ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany];


GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_tblClient_Email]
    ON [dbo].[tblClient]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblClient_CompanyCode]
    ON [dbo].[tblClient]([CompanyCode] ASC);


GO



GO
CREATE NONCLUSTERED INDEX [IX_tblClient_ClientCode]
    ON [dbo].[tblClient]([ClientCode] ASC)
    INCLUDE([LastName], [FirstName], [Phone1], [CompanyCode]);

