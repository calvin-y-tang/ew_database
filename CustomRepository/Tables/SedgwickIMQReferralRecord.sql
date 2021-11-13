CREATE TABLE [dbo].[SedgwickIMQReferralRecord] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Sequence]    VARCHAR (8)   NOT NULL,
    [Answer]      BIT           NOT NULL,
    [Description] VARCHAR (180) NOT NULL,
    [ReferralId]  INT           NOT NULL,
    CONSTRAINT [PK_SedgwickIMQReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickIMQReferralRecord_SedgwickReferralRecord] FOREIGN KEY ([ReferralId]) REFERENCES [dbo].[SedgwickReferralRecord] ([Id])
);

