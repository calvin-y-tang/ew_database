CREATE TABLE [dbo].[SedgwickReferralRecord] (
    [Id]                               INT            IDENTITY (1, 1) NOT NULL,
    [RecordType]                       VARCHAR (8)    NOT NULL,
    [ClientNumber]                     INT            NOT NULL,
    [ClaimNumber]                      VARCHAR (32)   NOT NULL,
    [ShortVendorId]                    VARCHAR (8)    NOT NULL,
    [CMSProcessingOffice]              INT            NOT NULL,
    [ClaimUniqueId]                    VARCHAR (32)   NOT NULL,
    [ClaimSystemId]                    VARCHAR (32)   NOT NULL,
    [ReferralUniqueId]                 VARCHAR (32)   NOT NULL,
    [LastUpdated]                      VARCHAR (8)    NULL,
    [ServiceTypeCode]                  VARCHAR (8)    NULL,
    [ServiceSubTypeCode]               VARCHAR (8)    NULL,
    [MLSClaimIndicator]                VARCHAR (8)    NULL,
    [ManagedCareActivationIndicator]   VARCHAR (8)    NULL,
    [ManagedCareActivationDate]        VARCHAR (8)    NULL,
    [ManagedCareReactivationIndicator] VARCHAR (8)    NULL,
    [ManagedCareReactivationDate]      VARCHAR (8)    NULL,
    [ReferralUniqueKey]                VARCHAR (32)   NULL,
    [ReferralHeaderId]                 INT            NOT NULL,
    [PackageURLExpiration]             DATETIME       NULL,
    [PackageToken]                     VARCHAR (128)  NULL,
    [PackageURL]                       VARCHAR (1024) NULL,
    [HasMedicalDocuments]              BIT            NULL,
    CONSTRAINT [PK_SedgwickReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickReferralRecord_SedgwickReferralHeader] FOREIGN KEY ([ReferralHeaderId]) REFERENCES [dbo].[SedgwickReferralHeader] ([Id])
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_SedgwickReferralRecord_ReferralUniqueId]
    ON [dbo].[SedgwickReferralRecord]([ReferralUniqueId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SedgwickReferralRecord_ClaimUniqueId]
    ON [dbo].[SedgwickReferralRecord]([ClaimUniqueId] ASC);

