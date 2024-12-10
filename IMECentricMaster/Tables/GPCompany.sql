CREATE TABLE [dbo].[GPCompany] (
    [PrimaryKey]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]   INT           NOT NULL,
    [ProcessedFlag]   BIT           NOT NULL,
    [ExportDate]      DATETIME      NOT NULL,
    [GPEntityPrefix]  VARCHAR (3)   NOT NULL,
    [GPCustomerID]    VARCHAR (15)  NOT NULL,
    [GPUserID]        VARCHAR (10)  NOT NULL,
    [CompanyName]     VARCHAR (100) NOT NULL,
    [Address1]        VARCHAR (60)  NULL,
    [Address2]        VARCHAR (60)  NULL,
    [Address3]        VARCHAR (60)  NULL,
    [City]            VARCHAR (35)  NULL,
    [State]           VARCHAR (2)   NULL,
    [Zip]             VARCHAR (10)  NULL,
    [Country]         VARCHAR (2)   NOT NULL,
    [Phone]           VARCHAR (21)  NULL,
    [IntName]         VARCHAR (70)  NULL,
    [ParentCompanyID] INT           NULL,
    [SourceID]        INT           NULL,
    [AcctingEmail]    VARCHAR (70)  NULL,
    [EWCompanyTypeID] INT           NULL,
    [CustomerType]    VARCHAR (100) NULL,
    [EFTBankName] VARCHAR(30) NULL, 
    [EFTAccount] VARCHAR(34) NULL, 
    [EFTRouting] VARCHAR(10) NULL, 
    CONSTRAINT [PK_GPCompany] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPCompany_ProcessedFlagGPCustomerID]
    ON [dbo].[GPCompany]([ProcessedFlag] ASC, [GPCustomerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPCompany_GPEntityPrefixFormatVersionProcessedFlag]
    ON [dbo].[GPCompany]([GPEntityPrefix] ASC, [FormatVersion] ASC, [ProcessedFlag] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPCompany_ExportDate]
    ON [dbo].[GPCompany]([ExportDate] ASC);

