CREATE TABLE [dbo].[EWState] (
    [StateCode]   VARCHAR (2)  NOT NULL,
    [StateName]   VARCHAR (50) NULL,
    [CountryCode] VARCHAR (2)  NULL,
    CONSTRAINT [PK_EWState] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

