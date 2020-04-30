

CREATE PROCEDURE [proc_GetSpecialtyComboItems]

AS

SELECT [specialtycode], [description] FROM [tblSpecialty] 
WHERE PublishOnWeb = 1
ORDER BY [description]



