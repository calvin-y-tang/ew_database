
CREATE PROCEDURE [proc_GetDegreeComboItems]

@CountryID int

AS

SELECT [EWAccreditationID], [Name] + ' - ' + [Description] Description FROM [tblEWAccreditation] 
WHERE PublishOnWeb = 1
	AND (CountryID = @CountryID)
	OR (CountryID is null)
ORDER BY [SeqNo]

