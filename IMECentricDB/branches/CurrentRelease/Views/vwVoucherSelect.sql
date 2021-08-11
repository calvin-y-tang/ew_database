CREATE VIEW vwVoucherSelect
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.doctorcode AS OpCode ,
            ISNULL(tblDoctor.lastname, '') + ', '
            + ISNULL(tblDoctor.firstname, '') + ' '
            + ISNULL(tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN tblDoctor ON TblCase.doctorcode = tblDoctor.doctorcode
    UNION
    SELECT  tblCase.CaseNbr ,
            tblCaseotherparty.OpCode AS OpCode ,
            tblDoctor.companyname AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN TblCaseOtherParty ON tblCase.CaseNbr = TblCaseOtherParty.CaseNbr
            INNER JOIN tblDoctor ON TblCaseOtherParty.OPCode = tblDoctor.doctorcode
    UNION
    SELECT  tblCase.CaseNbr ,
            tblCasePanel.doctorcode AS OpCode ,
            ISNULL(tblDoctor.lastname, '') + ', '
            + ISNULL(tblDoctor.firstname, '') + ' '
            + ISNULL(tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.panelNbr
            INNER JOIN tblDoctor ON tblCasePanel.doctorcode = tblDoctor.doctorcode
    UNION
    SELECT  tblCase.CaseNbr ,
            tblCaseApptPanel.doctorcode AS OpCode ,
            ISNULL(tblDoctor.lastname, '') + ', '
            + ISNULL(tblDoctor.firstname, '') + ' '
            + ISNULL(tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    tblCase
            INNER JOIN tblCaseAppt ON tblCase.CaseNbr = tblCaseAppt.CaseNbr
            INNER JOIN tblCaseApptPanel ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
            INNER JOIN tblDoctor ON tblCaseApptPanel.doctorcode = tblDoctor.doctorcode
