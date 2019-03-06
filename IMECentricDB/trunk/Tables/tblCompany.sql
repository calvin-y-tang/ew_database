CREATE TABLE [dbo].[tblCompany] (
    [CompanyCode]                INT              IDENTITY (1, 1) NOT NULL,
    [ExtName]                    VARCHAR (70)     NULL,
    [IntName]                    VARCHAR (70)     NULL,
    [Addr1]                      VARCHAR (50)     NULL,
    [Addr2]                      VARCHAR (50)     NULL,
    [City]                       VARCHAR (50)     NULL,
    [State]                      VARCHAR (2)      NULL,
    [Zip]                        VARCHAR (10)     NULL,
    [MarketerCode]               VARCHAR (15)     NULL,
    [Priority]                   VARCHAR (50)     NULL,
    [Phone]                      VARCHAR (15)     NULL,
    [Status]                     VARCHAR (10)     NULL,
    [DateAdded]                  DATETIME         NULL,
    [UserIDAdded]                VARCHAR (20)     NULL,
    [DateEdited]                 DATETIME         NULL,
    [UserIDEdited]               VARCHAR (20)     NULL,
    [USDVarchar1]                VARCHAR (50)     NULL,
    [USDVarchar2]                VARCHAR (50)     NULL,
    [USDDate1]                   DATETIME         NULL,
    [USDDate2]                   DATETIME         NULL,
    [USDText1]                   TEXT             NULL,
    [USDText2]                   TEXT             NULL,
    [USDInt1]                    INT              NULL,
    [USDInt2]                    INT              NULL,
    [USDMoney1]                  MONEY            NULL,
    [USDMoney2]                  MONEY            NULL,
    [CreditHold]                 BIT              NULL,
    [FeeCode]                    INT              NULL,
    [Notes]                      TEXT             NULL,
    [PreInvoice]                 BIT              NULL,
    [InvoiceDocument]            VARCHAR (15)     NULL,
    [QARep]                      VARCHAR (15)     NULL,
    [PhotoRqd]                   BIT              NULL,
    [Country]                    VARCHAR (50)     NULL,
    [PublishOnWeb]               BIT              NULL,
    [WebGUID]                    UNIQUEIDENTIFIER NULL,
    [CSR1]                       VARCHAR (15)     NULL,
    [CSR2]                       VARCHAR (15)     NULL,
    [AutoReSchedule]             BIT              NULL,
    [Terms]                      VARCHAR (20)     NULL,
    [EWFacilityID]               INT              NULL,
    [InvRemitEWFacilityID]       INT              NULL,
    [EWCompanyTypeID]            INT              NULL,
    [EDIFormat]                  VARCHAR (50)     NULL,
    [OldKey]                     INT              NULL,
    [SecurityProfileID]          INT              NULL,
    [BulkBillingID]              INT              NULL,
    [ParentCompanyID]            INT              NULL,
    [EWCompanyID]                INT              NULL,
    [CaseType]                   INT              NULL,
    [Jurisdiction]               VARCHAR (5)      NULL,
    [ReportTemplate]             VARCHAR (15)     NULL,
    [GeneralFileUploadFolderID]  INT              NULL,
    [MMITracking]                BIT              NULL,
    [TaxExempt]                  BIT              NULL,
    [IsUnknown]                  BIT              CONSTRAINT [DF_tblCompany_IsUnknown] DEFAULT ((0)) NOT NULL,
    [AllowCoverLetterGeneration] BIT              NULL,
    [NPProviderSearch]           BIT              CONSTRAINT [DF_tblCompany_NPProviderSearch] DEFAULT ((0)) NOT NULL,
    [DataHandling]               INT              NULL,
    [Prompt3rdPartyBill]         BIT              CONSTRAINT [DF_tblCompany_Prompt3rdPartyBill] DEFAULT ((0)) NOT NULL,
    [GPCustomerID]               VARCHAR (15)     NULL,
    [CreateCvrLtr]               BIT              CONSTRAINT [DF_tblCompany_CreateCvrLtr] DEFAULT ((0)) NOT NULL,
    [SpecialReqNotes]            TEXT             NULL,
    [UseNotification]            BIT              CONSTRAINT [DF_tblCompany_UseNotification] DEFAULT ((0)) NOT NULL,
    [JopariPayerIdentifier]      VARCHAR(16)      NULL, 
    [JopariPayerName]            VARCHAR(64)      NULL, 
	[CaseAcknowledgment]         BIT              NULL,
    [DistributionNotes]          VARCHAR(MAX)     NULL, 
	[AutoPrintInvoice]           BIT              CONSTRAINT [DF_tblCompany_AutoPrintInvoice] DEFAULT ((1)) NOT NULL,
    [PortalVersion]				INT NULL, 
    [CountryID]				    INT NULL, 
    CONSTRAINT [PK_tblCompany] PRIMARY KEY CLUSTERED ([CompanyCode] ASC) WITH (FILLFACTOR = 90)
);








GO



GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_EWCompanyID]
    ON [dbo].[tblCompany]([EWCompanyID] ASC);


GO



GO

CREATE TRIGGER tblCompany_AfterInsert_TRG 
  ON tblCompany
AFTER INSERT
AS
  UPDATE tblCompany
   SET tblCompany.GPCustomerID=(SELECT TOP 1 FacilityID FROM tblControl)+'-'+CAST(tblCompany.CompanyCode AS VARCHAR)
   FROM Inserted
   WHERE tblCompany.CompanyCode = Inserted.CompanyCode

GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_IntName]
    ON [dbo].[tblCompany]([IntName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_City]
    ON [dbo].[tblCompany]([City] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_CompanyCodeIntNameExtName]
    ON [dbo].[tblCompany]([CompanyCode] ASC, [IntName] ASC, [ExtName] ASC);

