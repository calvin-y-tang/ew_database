CREATE VIEW vwIMOLateCancel
AS
    SELECT
        tblCase.ChartNbr,
        tblCase.CaseNbr,
        tblCase.ClaimNbr,
        tblCaseHistory.Type,
        tblCaseHistory.EventDate
    FROM
        tblCase
    RIGHT OUTER JOIN tblCaseHistory ON tblCase.CaseNbr=tblCaseHistory.CaseNbr
    WHERE
        (tblCaseHistory.Type='LateCancel')
