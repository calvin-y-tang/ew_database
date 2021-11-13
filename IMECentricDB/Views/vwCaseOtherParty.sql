CREATE VIEW vwCaseOtherParty
AS
    SELECT
        tblCaseOtherParty.CaseNbr,
        tblDoctor.DoctorCode,
        tblDoctor.Prefix,
        tblDoctor.Addr1,
        tblDoctor.Addr2,
        tblDoctor.City,
        tblDoctor.State,
        tblDoctor.Zip,
        tblDoctor.Phone,
        tblDoctor.PhoneExt,
        tblDoctor.FaxNbr,
        tblDoctor.EmailAddr,
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctor.CompanyName,
        tblDoctor.OPSubType AS type
    FROM
        tblCaseOtherParty
    INNER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
    WHERE
        (tblDoctor.OPType='OP')
