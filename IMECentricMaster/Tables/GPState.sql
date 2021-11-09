CREATE TABLE [dbo].[GPState] (
    [StateCode]   VARCHAR (2)  NOT NULL,
    [StateName]   VARCHAR (50) NULL,
    [CountryCode] VARCHAR (2)  NULL,
    CONSTRAINT [PK_GPState] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

