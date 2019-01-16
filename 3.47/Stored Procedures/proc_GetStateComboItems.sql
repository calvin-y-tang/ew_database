

CREATE PROCEDURE [proc_GetStateComboItems]

AS

SELECT DISTINCT [Statecode], [StateName] FROM [tblstate] ORDER BY [StateName]




