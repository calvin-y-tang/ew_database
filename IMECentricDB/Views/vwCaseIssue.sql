CREATE VIEW vwCaseIssue
AS
    SELECT
        tblCaseIssue.CaseNbr,
        tblCaseIssue.IssueCode,
        tblIssue.Description,
        tblIssue.Instruction
    FROM
        tblCaseIssue
    INNER JOIN tblIssue ON tblCaseIssue.IssueCode=tblIssue.IssueCode
