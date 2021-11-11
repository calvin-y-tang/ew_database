CREATE TABLE [dbo].[Doctor] (
    [DoctorID]       INT          IDENTITY (1, 1) NOT NULL,
    [DoctorGUID]     INT          NULL,
    [DataFeedID]     VARCHAR (15) NULL,
    [GPEntityPrefix] VARCHAR (3)  NULL,
    [GPVendorID]     VARCHAR (15) NULL,
    [IMECentricID]   INT          NULL,
    [SourceID]       INT          NULL,
    [FirstName]      VARCHAR (50) NULL,
    [LastName]       VARCHAR (50) NULL,
    [MiddleInitial]  VARCHAR (1)  NULL,
    [Prefix]         VARCHAR (10) NULL,
    [Credentials]    VARCHAR (15) NULL,
    [CompanyName]    VARCHAR (64) NULL,
    [PayeeName]      VARCHAR (50) NULL,
    [FedTaxID]       VARCHAR (15) NULL,
    [NPI]            VARCHAR (20) NULL,
    [Address1]       VARCHAR (50) NULL,
    [Address2]       VARCHAR (50) NULL,
    [Address3]       VARCHAR (50) NULL,
    [City]           VARCHAR (35) NULL,
    [State]          VARCHAR (3)  NULL,
    [Zip]            VARCHAR (10) NULL,
    [County]         VARCHAR (50) NULL,
    [Country]        VARCHAR (2)  NULL,
    [Phone]          VARCHAR (21) NULL,
    [PhoneExt]       VARCHAR (15) NULL,
    [Fax]            VARCHAR (21) NULL,
    [Cell]           VARCHAR (21) NULL,
    [Email]          VARCHAR (70) NULL,
    [DateEdited]     DATETIME     NULL,
    [OPType]         VARCHAR (5)  NULL,
    [OPSubType]      VARCHAR (15) NULL,
    [Active]         BIT          NULL,
    [GPExportStatus] INT          NULL,
    [DateAdded]      DATETIME     CONSTRAINT [DF_Doctor_DateAdded] DEFAULT (getdate()) NULL,
    [EFTPayments]    BIT          NULL,
    [EFTBankName]    VARCHAR (30) NULL,
    [EFTAccount]     VARCHAR (34) NULL,
    [EFTRouting]     NCHAR (10)   NULL,
    [Prepay]         BIT          NULL,
    [DateLastUsed]   DATETIME     NULL,
    [CRNMasterID]    INT          NULL,
    CONSTRAINT [PK_Doctor] PRIMARY KEY CLUSTERED ([DoctorID] ASC)
);




GO



GO



GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Doctor_GPEntityPrefixIMECentricID]
    ON [dbo].[Doctor]([GPEntityPrefix] ASC, [IMECentricID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Doctor_GPEntityPrefixDataFeedID]
    ON [dbo].[Doctor]([GPEntityPrefix] ASC, [DataFeedID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Doctor_GPVendorID]
    ON [dbo].[Doctor]([GPVendorID] ASC);

