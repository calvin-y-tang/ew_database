CREATE TABLE [dbo].[tblHCAIProvider] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [FirstName]          VARCHAR (50) NULL,
    [LastName]           VARCHAR (50) NULL,
    [ProviderRegistryID] VARCHAR (50) NULL,
    [ProviderOccupation] VARCHAR (50) NULL,
    [RegistrationNumber] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblHCAIProvider] PRIMARY KEY CLUSTERED ([ID] ASC)
);

