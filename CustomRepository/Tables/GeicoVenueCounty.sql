CREATE TABLE [dbo].[GeicoVenueCounty] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [County]       VARCHAR (50) NULL,
    [ProperCounty] VARCHAR (50) NULL,
    CONSTRAINT [PK_GeicoVenueCounty] PRIMARY KEY CLUSTERED ([Id] ASC)
);

