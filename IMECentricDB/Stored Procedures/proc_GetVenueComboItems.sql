CREATE PROCEDURE [proc_GetVenueComboItems]

@State varchar(2)

AS

SELECT * FROM tblVenue WHERE State = @State ORDER BY County
