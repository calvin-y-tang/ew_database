CREATE TABLE [dbo].[InfoFeeZoneRegion] (
    [ZipCode]   CHAR (10)    NOT NULL,
    [City]      VARCHAR (64) NOT NULL,
    [County]    VARCHAR (32) NOT NULL,
    [StateName] VARCHAR (64) NOT NULL,
    [Region]    VARCHAR (64) NOT NULL,
    CONSTRAINT [PK_InfoFeeZoneRegion] PRIMARY KEY CLUSTERED ([ZipCode] ASC)
);

