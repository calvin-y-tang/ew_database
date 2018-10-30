CREATE VIEW vwSpecialServices
AS
    SELECT
        tblCaseOtherParty.CaseNbr,
        tblCaseOtherParty.Type,
        tblCaseOtherParty.DueDate,
        tblCaseOtherParty.UserIDResponsible,
        tblCaseOtherParty.Status,
        ISNULL(tblDoctor.FirstName, '')+' '+ISNULL(tblDoctor.LastName,
                                                       '') AS contactname,
        tblDoctor.Addr1,
        tblDoctor.Addr2,
        tblDoctor.City,
        tblDoctor.State,
        tblDoctor.Zip,
        tblDoctor.Phone,
        tblDoctor.PhoneExt,
        tblDoctor.FaxNbr,
        tblDoctor.EmailAddr,
        tblDoctor.CompanyName,
        vwDocument.ExamineeName,
        vwDocument.ExamineeAddr1,
        vwDocument.ExamineeAddr2,
        vwDocument.ExamineeCityStateZip,
        vwDocument.ClientName,
        vwDocument.Company,
        vwDocument.DoctorName,
        vwDocument.DoctorAddr1,
        vwDocument.DoctorAddr2,
        vwDocument.DoctorCityStateZip,
        vwDocument.ApptDate,
        vwDocument.Appttime,
        vwDocument.DoctorPhone,
        vwDocument.Location,
        vwDocument.ExamineePhone,
        vwDocument.officeCode,
        tblCaseOtherParty.Description,
        vwDocument.StatusDesc,
        vwDocument.ExtCaseNbr
    FROM
        tblCaseOtherParty
    INNER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
    INNER JOIN vwDocument ON tblCaseOtherParty.CaseNbr=vwDocument.CaseNbr
