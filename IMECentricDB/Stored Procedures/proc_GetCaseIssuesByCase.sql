
CREATE PROCEDURE [proc_GetCaseIssuesByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseIssue 
	INNER JOIN tblIssue ON tblCaseIssue.issuecode = tblIssue.issuecode 
	WHERE casenbr = @CaseNbr


