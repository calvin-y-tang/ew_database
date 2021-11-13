CREATE TABLE [dbo].[EWParentCompany] (
    [ParentCompanyID]         INT            NOT NULL,
    [Name]                    VARCHAR (40)   NOT NULL,
    [GPParentCustomerID]      VARCHAR (15)   NULL,
    [CompanyFilter]           VARCHAR (80)   NULL,
    [NationalAccount]         BIT            NOT NULL,
    [SeqNo]                   INT            NULL,
    [DataHandling]            INT            NULL,
    [FolderID]                INT            NULL,
    [SLADocumentFileName]     VARCHAR (80)   NULL,
    [BulkBillingID]           INT            NULL,
    [RequireInOutNetwork]     INT            NULL,
    [ServiceIncludeExclude]   BIT            NULL,
    [ParentCompanyURL]        VARCHAR (MAX)  NULL,
    [CaseAcknowledgment]      BIT            NULL,
    [RequirePracticingDoctor] BIT            NULL,
    [RequireStateLicence]     BIT            NULL,
    [RequireCertification]    BIT            NULL,
    [Param]                   VARCHAR (1024) NULL,
    [RequireFeeZoneNYFL]      BIT            NULL,
    CONSTRAINT [PK_EWParentCompany] PRIMARY KEY CLUSTERED ([ParentCompanyID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWParentCompany_Name]
    ON [dbo].[EWParentCompany]([Name] ASC);

