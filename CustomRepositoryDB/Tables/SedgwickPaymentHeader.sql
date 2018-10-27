CREATE TABLE [dbo].[SedgwickPaymentHeader] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [FileVersionNumber]   VARCHAR (8)   NULL,
    [VendorFileName]      VARCHAR (256) NULL,
    [FileReferenceNumber] VARCHAR (4)   NULL,
    [VendorCode]          VARCHAR (4)   NULL,
    [DateCreated]         VARCHAR (8)   NULL,
    [TimeCreated]         VARCHAR (6)   NULL,
    [BeginDate]           VARCHAR (8)   NULL,
    [BeginTime]           VARCHAR (6)   NULL,
    [EndDate]             VARCHAR (8)   NULL,
    [EndTime]             VARCHAR (6)   NULL,
    [ProcessDate]         VARCHAR (8)   NULL,
    [TransmissionDate]    VARCHAR (8)   NULL,
    CONSTRAINT [PK_SedgwickPaymentHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);

