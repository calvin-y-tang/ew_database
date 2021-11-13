CREATE TABLE [dbo].[SedgwickCOMReferralRecord] (
    [Id]                    INT          IDENTITY (1, 1) NOT NULL,
    [InjuredWorkerLanguage] VARCHAR (40) NOT NULL,
    [ReferralId]            INT          NOT NULL,
    CONSTRAINT [PK_SedgwickCOMReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickCOMReferralRecord_SedgwickReferralRecord] FOREIGN KEY ([ReferralId]) REFERENCES [dbo].[SedgwickReferralRecord] ([Id])
);

