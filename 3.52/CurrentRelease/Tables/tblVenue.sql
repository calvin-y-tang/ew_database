CREATE TABLE [dbo].[tblVenue] (
    [VenueID] INT          IDENTITY (1, 1) NOT NULL,
    [County]  VARCHAR (50) NULL,
    [State]   VARCHAR (2)  NULL,
    CONSTRAINT [PK_tblVenue] PRIMARY KEY CLUSTERED ([VenueID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblVenue_StateCounty]
    ON [dbo].[tblVenue]([State] ASC, [County] ASC);

