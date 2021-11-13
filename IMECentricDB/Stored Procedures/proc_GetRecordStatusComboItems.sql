

CREATE PROCEDURE [proc_GetRecordStatusComboItems]

AS

SELECT [reccode], [description] FROM [tblRecordStatus] 
WHERE PublishOnWeb = 1
ORDER BY [description]



