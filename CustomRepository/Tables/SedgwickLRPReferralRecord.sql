CREATE TABLE [dbo].[SedgwickLRPReferralRecord] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [LegalRepresentation] BIT           NOT NULL,
    [AttyName]            VARCHAR (40)  NOT NULL,
    [AttyFirmName]        VARCHAR (40)  NULL,
    [AttyAddressLine1]    VARCHAR (30)  NULL,
    [AttyAddressLine2]    VARCHAR (30)  NULL,
    [AttyCity]            VARCHAR (15)  NULL,
    [AttyState]           CHAR (2)      NULL,
    [AttyZipcode]         VARCHAR (15)  NULL,
    [AttyPhone]           VARCHAR (18)  NULL,
    [AttyFax]             VARCHAR (18)  NULL,
    [AttyEmail]           VARCHAR (100) NULL,
    [AttyCounty]          VARCHAR (25)  NULL,
    [AttyCountry]         VARCHAR (25)  NULL,
    [AttyTaxID]           VARCHAR (9)   NULL,
    [AttyTaxSub]          VARCHAR (3)   NULL,
    [ReferralId]          INT           NOT NULL,
    CONSTRAINT [PK_SedgwickLRPReferralRecord] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SedgwickLRPReferralRecord_SedgwickReferralRecord] FOREIGN KEY ([ReferralId]) REFERENCES [dbo].[SedgwickReferralRecord] ([Id])
);

