CREATE TABLE [dbo].[tblEWParentCompany] (
    [ParentCompanyID]                INT NOT NULL,
    [Name]                           VARCHAR (40) NOT NULL,
    [GPParentCustomerID]             VARCHAR (15) NULL,
    [CompanyFilter]                  VARCHAR (80) NULL,
    [NationalAccount]                BIT NOT NULL,
    [SeqNo]                          INT NULL,
    [DataHandling]                   INT NULL,
    [FolderID]                       INT NULL,
    [SLADocumentFileName]            VARCHAR (80) NULL,
    [BulkBillingID]                  INT NULL, 
    [RequireInOutNetwork]            INT NULL, 
    [ServiceIncludeExclude]          BIT NULL, 
	[CaseAcknowledgment]             BIT NULL,
	[ParentCompanyURL]               VARCHAR (MAX) NULL,
    [RequirePracticingDoctor]        BIT NULL, 
    [RequireStateLicence]            BIT NULL, 
    [RequireCertification]           BIT NULL, 
    [RequireFeeZoneNYFL]             BIT NULL, 
    [Param]                          VARCHAR(1024) NULL, 
	[EWNetworkID]                    INT NULL,
	[CountryID]                      INT NULL,
	[DateAdded]                      DATETIME    NULL, 
    [UserIDAdded]                    VARCHAR(15) NULL, 
    [DateEdited]                     DATETIME    NULL, 
    [UserIDEdited]                   VARCHAR(15) NULL,
	[DICOMHandlingPreference]        INT         NULL,
	[AllowMedIndex]                  BIT         NULL,
	[ShowFinancialInfo]              BIT         NULL,
	[AllowScheduling]                BIT         NULL,
    CONSTRAINT [PK_tblEWParentCompany] PRIMARY KEY CLUSTERED ([ParentCompanyID] ASC)
);

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWParentCompany_Name]
    ON [dbo].[tblEWParentCompany]([Name] ASC);

