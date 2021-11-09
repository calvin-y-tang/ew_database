CREATE TABLE [dbo].[SedgwickRMDReferralRecord] (
    [Id]             INT          IDENTITY (1, 1) NOT NULL,
    [MDName]         VARCHAR (40) NOT NULL,
    [MDAddressLine1] VARCHAR (30) NULL,
    [MDAddressLine2] VARCHAR (30) NULL,
    [MDCity]         VARCHAR (25) NULL,
    [MDState]        CHAR (2)     NULL,
    [MDZipcode]      VARCHAR (15) NULL,
    [MDPhone]        VARCHAR (18) NULL,
    [MDCounty]       VARCHAR (25) NULL,
    [MDCountry]      VARCHAR (25) NULL,
    [MDTaxID]        VARCHAR (12) NULL,
    [MDTaxSub]       CHAR (3)     NULL,
    [ReferralId]     INT          NOT NULL,
    CONSTRAINT [PK_SedgwickRMDReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickRMDReferralRecord_SedgwickReferralRecord] FOREIGN KEY ([ReferralId]) REFERENCES [dbo].[SedgwickReferralRecord] ([Id])
);

