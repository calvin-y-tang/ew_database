CREATE TABLE [dbo].[tblEWTimeZone] (
    [EWTimeZoneID]               INT           NOT NULL,
    [Name]                       VARCHAR (100) NOT NULL,
    [SupportsDaylightSavingTime] BIT           NOT NULL,
    [BaseUtcOffsetSec]           INT           NOT NULL,
    [ShortDesc]                  VARCHAR (10)  NULL,
    CONSTRAINT [PK_EWTimeZone] PRIMARY KEY CLUSTERED ([EWTimeZoneID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWTimeZone_Name]
    ON [dbo].[tblEWTimeZone]([Name] ASC);

