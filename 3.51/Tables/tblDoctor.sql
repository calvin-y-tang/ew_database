CREATE TABLE [dbo].[tblDoctor] (
    [LastName]                     VARCHAR (50) NULL,
    [FirstName]                    VARCHAR (50) NULL,
    [MiddleInitial]                VARCHAR (2)  NULL,
    [Credentials]                  VARCHAR (50) NULL,
    [SSNTaxID]                     VARCHAR (50) NULL,
    [LicenseNbr]                   VARCHAR (50) NULL,
    [UPIN]                         VARCHAR (50) NULL,
    [SchedulePriority]             INT          CONSTRAINT [DF_tblDoctor_SchedulePriority] DEFAULT ((3)) NULL,
    [Status]                       VARCHAR (10) NULL,
    [Notes]                        TEXT         NULL,
    [DateAdded]                    DATETIME     NULL,
    [DateEdited]                   DATETIME     NULL,
    [UserIDAdded]                  VARCHAR (15) NULL,
    [UserIDEdited]                 VARCHAR (15) NULL,
    [DoctorCode]                   INT          IDENTITY (1, 1) NOT NULL,
    [Prefix]                       VARCHAR (10) NULL,
    [Addr1]                        VARCHAR (50) NULL,
    [Addr2]                        VARCHAR (50) NULL,
    [City]                         VARCHAR (50) NULL,
    [State]                        VARCHAR (2)  NULL,
    [Zip]                          VARCHAR (15) NULL,
    [Phone]                        VARCHAR (15) NULL,
    [PhoneExt]                     VARCHAR (15) NULL,
    [CellPhone]                    VARCHAR (15) NULL,
    [Pager]                        VARCHAR (15) NULL,
    [FaxNbr]                       VARCHAR (15) NULL,
    [EmailAddr]                    VARCHAR (70) NULL,
    [Qualifications]               TEXT         NULL,
    [Prepaid]                      BIT          NULL,
    [County]                       VARCHAR (50) NULL,
    [USDVarchar1]                  VARCHAR (50) NULL,
    [USDVarchar2]                  VARCHAR (50) NULL,
    [USDDate1]                     DATETIME     NULL,
    [USDDate2]                     DATETIME     NULL,
    [USDText1]                     TEXT         NULL,
    [USDText2]                     TEXT         NULL,
    [USDInt1]                      INT          NULL,
    [USDInt2]                      INT          NULL,
    [USDMoney1]                    MONEY        NULL,
    [USDMoney2]                    MONEY        NULL,
    [WCNbr]                        VARCHAR (50) NULL,
    [FeeCode]                      INT          NULL,
    [APKey]                        VARCHAR (50) NULL,
    [RemitAttn]                    VARCHAR (70) NULL,
    [RemitAddr1]                   VARCHAR (70) NULL,
    [RemitAddr2]                   VARCHAR (70) NULL,
    [RemitCity]                    VARCHAR (70) NULL,
    [RemitState]                   VARCHAR (10) NULL,
    [RemitZip]                     VARCHAR (10) NULL,
    [CreateVouchers]               BIT          NULL,
    [INFeeCode]                    INT          NULL,
    [OPType]                       VARCHAR (5)  NULL,
    [OPSubType]                    VARCHAR (15) NULL,
    [CompanyName]                  VARCHAR (70) NULL,
    [ProdCode]                     INT          NULL,
    [CreateInvoices]               BIT          NULL,
    [Country]                      VARCHAR (50) NULL,
    [PrintOnCheckAs]               VARCHAR (70) NULL,
    [UnRegNbr]                     VARCHAR (50) NULL,
    [NPINbr]                       VARCHAR (20) NULL,
    [ProvTypeCode]                 INT          NULL,
    [USDDate3]                     DATETIME     NULL,
    [USDDate4]                     DATETIME     NULL,
    [PublishOnWeb]                 BIT          NULL,
    [USDVarchar3]                  VARCHAR (50) NULL,
    [INGLAcctDoctor]               VARCHAR (50) NULL,
    [INGLAcctAdmin]                VARCHAR (50) NULL,
    [VOGLAcctDoctor]               VARCHAR (50) NULL,
    [WebUserID]                    INT          NULL,
    [USDDate5]                     DATETIME     NULL,
    [USDDate6]                     DATETIME     NULL,
    [USDDate7]                     DATETIME     NULL,
    [OldKey]                       INT          NULL,
    [Booking]                      INT          CONSTRAINT [DF_tblDoctor_Booking] DEFAULT ((2)) NULL,
    [HCAIProviderRegistryID]       VARCHAR (50) NULL,
    [EWDoctor]                     BIT          NULL,
    [DateLastUsed]                 DATETIME     NULL,
    [CredentialingStatus]          VARCHAR (20) NULL,
    [CredentialingSource]          VARCHAR (15) NULL,
    [CredentialingUpdated]         DATETIME     NULL,
    [CredentialingNotes]           VARCHAR (50) NULL,
    [WAProviderStateID]            VARCHAR (20) NULL,
    [WAProviderNationalID]         VARCHAR (20) NULL,
    [ReportTemplate]               VARCHAR (15) NULL,
    [DictationAuthorID]            VARCHAR (10) NULL,
    [EWDoctorID]                   INT          NULL,
    [DOB]                          DATETIME     NULL,
    [PracticingDoctor]             INT          NULL,
    [CalcTaxOnVouchers]            BIT          NULL,
    [AddExceptionTriggered]        BIT          NULL,
    [GPIDMethod]                   INT          NULL,
    [GPVendorID]                   VARCHAR (15) NULL,
    [NPPublishOnWeb]               BIT          CONSTRAINT [DF_tblDoctor_NPPublishOnWeb] DEFAULT ((1)) NOT NULL,
    [QANotes]                      TEXT         NULL,
    [MedRecordReqNotes]            TEXT         NULL,
    [DrAcctingNote]                TEXT         NULL,
    [DrMedRecsInDays]              INT          CONSTRAINT [DF_tblDoctor_DrMedRecsInDays] DEFAULT ((0)) NOT NULL,
    [TXMTaxID]                     VARCHAR (11) NULL,
    [SORMTaxID]                    VARCHAR (11) NULL,
    [TXMProviderName]              VARCHAR (70) NULL,
    [SORMProviderName]             VARCHAR (70) NULL,
    [ExpectedVisitDuration]        VARCHAR (25) NULL,
	[UseConfirmation]		 BIT		  CONSTRAINT [DF_tblDoctor_UseConfirmation] DEFAULT (0) NOT	NULL,
    [ReceiveMedRecsElectronically] BIT          NULL,
    [ViewDICOMOnWebPortal]         BIT          NULL,
    [DICOMHandlingPreference]      INT          NULL,
    CONSTRAINT [PK_tblDoctor] PRIMARY KEY CLUSTERED ([DoctorCode] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_OPTypeLastNameFirstName]
    ON [dbo].[tblDoctor]([OPType] ASC, [LastName] ASC, [FirstName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_LastNameFirstNameMiddleInitial]
    ON [dbo].[tblDoctor]([LastName] ASC, [FirstName] ASC, [MiddleInitial] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_DictationAuthorID]
    ON [dbo].[tblDoctor]([DictationAuthorID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_DoctorCode]
    ON [dbo].[tblDoctor]([DoctorCode] ASC)
    INCLUDE([LastName], [FirstName], [MiddleInitial], [Credentials]);

