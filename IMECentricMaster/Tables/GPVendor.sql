CREATE TABLE [dbo].[GPVendor] (
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]  INT           NOT NULL,
    [ProcessedFlag]  BIT           NOT NULL,
    [ExportDate]     DATETIME      NOT NULL,
    [GPEntityPrefix] VARCHAR (3)   NOT NULL,
    [GPVendorID]     VARCHAR (15)  NOT NULL,
    [GPUserID]       VARCHAR (10)  NOT NULL,
    [DoctorName]     VARCHAR (100) NOT NULL,
    [CompanyName]    VARCHAR (64)  NOT NULL,
    [PayeeName]      VARCHAR (64)  NOT NULL,
    [FedTaxID]       VARCHAR (15)  NULL,
    [Address1]       VARCHAR (60)  NULL,
    [Address2]       VARCHAR (60)  NULL,
    [Address3]       VARCHAR (60)  NULL,
    [City]           VARCHAR (35)  NULL,
    [State]          VARCHAR (2)   NULL,
    [Zip]            VARCHAR (10)  NULL,
    [Country]        VARCHAR (2)   NOT NULL,
    [Phone]          VARCHAR (21)  NULL,
    [Fax]            VARCHAR (21)  NULL,
    [Cell]           VARCHAR (21)  NULL,
    [Email]          VARCHAR (70)  NULL,
    [GPVendorClass]  VARCHAR (50)  NULL,
    [EFTPayments]    BIT           NULL,
    [EFTBankName]    VARCHAR (30)  NULL,
    [EFTAccount]     VARCHAR (34)  NULL,
    [EFTRouting]     VARCHAR (50)  NULL,
    [Prepay]         BIT           NULL,
    [OPType]         VARCHAR (5)   NULL,
    [SourceID]       INT           NULL,
    [RemitAttn]      VARCHAR (70)  NULL,
    [CRNMasterID]    INT           NULL,
    CONSTRAINT [PK_GPVendor] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPVendor_ProcessedFlagGPVendorID]
    ON [dbo].[GPVendor]([ProcessedFlag] ASC, [GPVendorID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPVendor_GPEntityPrefixFormatVersionProcessedFlag]
    ON [dbo].[GPVendor]([GPEntityPrefix] ASC, [FormatVersion] ASC, [ProcessedFlag] ASC);

