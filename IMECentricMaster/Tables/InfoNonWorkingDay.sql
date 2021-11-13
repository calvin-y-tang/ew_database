CREATE TABLE [dbo].[InfoNonWorkingDay] (
    [NonWorkingDayID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CountryCode]     VARCHAR (2)  NULL,
    [State]           VARCHAR (3)  NULL,
    [NonWorkingDate]  DATETIME     NULL,
    [Descrip]         VARCHAR (30) NULL,
    CONSTRAINT [PK_InfoNonWorkingDay] PRIMARY KEY CLUSTERED ([NonWorkingDayID] ASC)
);

