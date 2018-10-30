CREATE TABLE [dbo].[tblEWFeeZone] (
    [EWFeeZoneID] INT          NOT NULL,
    [Name]        VARCHAR (30) NULL,
    [Status]      VARCHAR (10) NULL,
    [StateCode]   VARCHAR (2)  NULL,
    [CountryCode] VARCHAR (2)  NULL,
    CONSTRAINT [PK_tblEWFeeZone] PRIMARY KEY CLUSTERED ([EWFeeZoneID] ASC)
);

