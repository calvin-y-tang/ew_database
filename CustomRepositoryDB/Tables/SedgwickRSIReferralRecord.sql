CREATE TABLE [dbo].[SedgwickRSIReferralRecord] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [RecordType]          VARCHAR (8)    NOT NULL,
    [ClientNumber]        INT            NOT NULL,
    [ClaimNumber]         VARCHAR (32)   NOT NULL,
    [ShortVendorId]       VARCHAR (8)    NOT NULL,
    [CMSProcessingOffice] INT            NOT NULL,
    [ClaimUniqueId]       VARCHAR (32)   NOT NULL,
    [ClaimSystemId]       VARCHAR (32)   NOT NULL,
    [ReferralUniqueId]    VARCHAR (32)   NOT NULL,
    [NoteSequence]        INT            NOT NULL,
    [SpecialInstructions] VARCHAR (2048) NULL,
    [ReferralId]          INT            NOT NULL,
    CONSTRAINT [PK_SedgwickRSIReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickRSIReferralRecord_SedgwickReferralRecord] FOREIGN KEY ([ReferralId]) REFERENCES [dbo].[SedgwickReferralRecord] ([Id])
);

