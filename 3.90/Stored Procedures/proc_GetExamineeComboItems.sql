

CREATE PROCEDURE [proc_GetExamineeComboItems]

AS

SELECT DISTINCT chartnbr, lastname, firstname, lastname + ', ' + firstname AS ExamineeName 
FROM tblExaminee 

WHERE (NOT (tblExaminee.lastname IS NULL)) AND (NOT (tblExaminee.firstname IS NULL)) 
 AND (NOT (tblExaminee.lastname = '')) AND (NOT (tblExaminee.firstname = '')) 
ORDER BY tblExaminee.lastname



