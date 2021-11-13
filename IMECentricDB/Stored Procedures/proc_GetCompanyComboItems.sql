
CREATE PROCEDURE [proc_GetCompanyComboItems]

AS

SELECT companycode, intname from tblCompany 

ORDER BY intname

