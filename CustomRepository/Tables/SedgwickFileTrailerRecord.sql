CREATE TABLE [dbo].[SedgwickFileTrailerRecord] (
    [Id]                                 INT IDENTITY (1, 1) NOT NULL,
    [ClaimDataRecordCount]               INT NOT NULL,
    [ClaimContactInformationRecordCount] INT NOT NULL,
    [ClientInformationRecord]            INT NOT NULL,
    [ProcessingUnitRecord]               INT NOT NULL,
    [TotalRecordCount]                   INT NOT NULL,
    [HeaderRecordId]                     INT NOT NULL,
    CONSTRAINT [PK_SedgwickFileTrailerRecord] PRIMARY KEY CLUSTERED ([Id] ASC)
);

