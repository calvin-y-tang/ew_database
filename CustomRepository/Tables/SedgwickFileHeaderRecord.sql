CREATE TABLE [dbo].[SedgwickFileHeaderRecord] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [FileVersionNumber]   VARCHAR (8)   NULL,
    [VendorFileName]      VARCHAR (128) NULL,
    [FileReferenceNumber] VARCHAR (8)   NULL,
    [VendorCode]          VARCHAR (8)   NULL,
    [DateCreated]         DATETIME      NULL,
    [TimeCreated]         DATETIME      NULL,
    [BeginDate]           DATETIME      NULL,
    [BeginTime]           DATETIME      NULL,
    [EndingDate]          DATETIME      NULL,
    [EndingTime]          DATETIME      NULL,
    CONSTRAINT [PK_SedgwickFileHeaderRecord] PRIMARY KEY CLUSTERED ([Id] ASC)
);

