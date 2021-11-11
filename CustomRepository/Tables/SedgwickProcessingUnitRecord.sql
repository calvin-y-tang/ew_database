CREATE TABLE [dbo].[SedgwickProcessingUnitRecord] (
    [OfficeNumber]     INT           NOT NULL,
    [OfficeName]       VARCHAR (50)  NULL,
    [ShippingAddress1] VARCHAR (32)  NULL,
    [ShippingAddress2] VARCHAR (32)  NULL,
    [City]             VARCHAR (20)  NULL,
    [State]            VARCHAR (2)   NULL,
    [Country]          VARCHAR (8)   NULL,
    [PostalCode]       VARCHAR (15)  NULL,
    [Phone]            VARCHAR (18)  NULL,
    [Fax]              VARCHAR (18)  NULL,
    [Manager]          VARCHAR (64)  NULL,
    [Coordinator]      VARCHAR (128) NULL,
    [OfficeEmail]      VARCHAR (320) NULL,
    CONSTRAINT [PK_SedgwickProcessingUnitRecord] PRIMARY KEY CLUSTERED ([OfficeNumber] ASC)
);



