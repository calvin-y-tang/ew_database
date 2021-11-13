CREATE TABLE [dbo].[tblZipCode] (
    [kIndex]      INT          IDENTITY (1, 1) NOT NULL,
    [sZip]        VARCHAR (10) NULL,
    [sCity]       VARCHAR (30) NOT NULL,
    [sType]       VARCHAR (1)  NULL,
    [fLatitude]   FLOAT (53)   NULL,
    [fLongitude]  FLOAT (53)   NULL,
    [sState]      VARCHAR (2)  NULL,
    [sCountyName] VARCHAR (35) NULL,
    [iFIPS]       INT          NULL,
    CONSTRAINT [PK_tblZipCode] PRIMARY KEY CLUSTERED ([kIndex] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblZipCode_sZipsCountyNamesState]
    ON [dbo].[tblZipCode]([sZip] ASC, [sCountyName] ASC, [sState] ASC);

