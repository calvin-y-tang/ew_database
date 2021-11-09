CREATE TABLE [dbo].[GeicoCustomer] (
    [Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (128) NOT NULL,
    CONSTRAINT [PK_GeicoCustomer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

