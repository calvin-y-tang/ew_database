
CREATE VIEW vwCasePanel
AS
    SELECT  tblSpecialty.description AS SpecialtyDesc ,
            tblDoctor.lastName + ', ' + ISNULL(tblDoctor.firstName, '') AS DoctorName ,
            tblDoctor.firstName ,
            tblDoctor.Credentials ,
            tblCasePanel.Panelnbr ,
            tblCasePanel.DoctorCode ,
            tblCasePanel.Panelnote ,
            tblCasePanel.SpecialtyCode ,
            tblCasePanel.SchedCode ,
            tblCasePanel.DateAdded ,
            tblCasePanel.UserIDAdded ,
            tblCasePanel.DateEdited ,
            tblCasePanel.UserIDEdited ,
			tblCasePanel.DoctorReason
    FROM    tblCasePanel
            INNER JOIN tblDoctor ON tblCasePanel.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCasePanel.SpecialtyCode = tblSpecialty.SpecialtyCode

