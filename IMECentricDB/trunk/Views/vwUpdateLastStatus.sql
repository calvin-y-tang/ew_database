CREATE VIEW vwUpdateLastStatus
AS
    SELECT
        tblCase.CaseNbr,
        tblCaseHistory.EventDate,
        LEFT(tblCaseHistory.Eventdesc, 10) AS Expr1,
        tblCaseHistory.OtherInfo
    FROM
        tblCase
    INNER JOIN tblCaseHistory ON tblCase.CaseNbr=tblCaseHistory.CaseNbr
    WHERE
        (LEFT(tblCaseHistory.Eventdesc, 10)='Status Chg')
