CREATE PROCEDURE [proc_GetIssueComboItems]

@WebCompanyId int

AS

IF @WebCompanyId = 46
	BEGIN
		SELECT issuecode,description from tblIssue WHERE PublishOnWeb = 1 AND Status = 'Active' ORDER BY description
	END
ELSE
	BEGIN
		SELECT issuecode,description from tblIssue WHERE PublishOnWeb = 1 AND IssueCode NOT IN (12, 39, 40, 41) AND Status = 'Active' ORDER BY description
	END