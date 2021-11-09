CREATE TABLE [dbo].[SedgwickReferralTrailer] (
    [Id]               INT         IDENTITY (1, 1) NOT NULL,
    [RecordType]       VARCHAR (8) NOT NULL,
    [TotalRecordCount] INT         NOT NULL,
    [ReferralHeaderId] INT         NOT NULL,
    [AckRecordCount]   INT         NOT NULL,
    CONSTRAINT [PK_SedgwickReferralTrailer] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickReferralTrailer_SedgwickReferralHeader] FOREIGN KEY ([ReferralHeaderId]) REFERENCES [dbo].[SedgwickReferralHeader] ([Id])
);

