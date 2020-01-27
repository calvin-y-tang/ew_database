CREATE PROCEDURE [proc_GetOfficeComboItems]

AS

SELECT [Officecode], [description] FROM [tblOffice] 
WHERE PublishOnWeb = 1
ORDER BY [description]

