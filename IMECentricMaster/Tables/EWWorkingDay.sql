CREATE TABLE [dbo].[EWWorkingDay] (
    [CountryCode] VARCHAR (2) NOT NULL,
    [Month]       DATETIME    NOT NULL,
    [WorkingDays] INT         NOT NULL,
    CONSTRAINT [PK_EWWorkingDay] PRIMARY KEY CLUSTERED ([CountryCode] ASC, [Month] ASC)
);

