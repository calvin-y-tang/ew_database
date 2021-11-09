CREATE TABLE [dbo].[SedgwickReferralHeader] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [RecordType]        VARCHAR (8)   NOT NULL,
    [FileVersionNumber] VARCHAR (8)   NOT NULL,
    [VendorFileName]    VARCHAR (132) NOT NULL,
    [FileRefenceNumber] VARCHAR (8)   NOT NULL,
    [VendorCode]        VARCHAR (8)   NOT NULL,
    [DateCreated]       VARCHAR (8)   NOT NULL,
    [TimeCreated]       VARCHAR (8)   NOT NULL,
    [BeginDate]         VARCHAR (8)   NULL,
    [BeginTime]         VARCHAR (8)   NULL,
    [EndingDate]        VARCHAR (8)   NULL,
    [EndingTime]        VARCHAR (8)   NULL,
    CONSTRAINT [PK_SedgwickReferralHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);

