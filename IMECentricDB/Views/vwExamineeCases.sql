 
CREATE VIEW vwExamineeCases
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ApptDate ,
            tblCase.ChartNbr ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblLocation.Location ,
            tblQueues.StatUSDesc ,
            ISNULL(tblSpecialty_2.Description, tblSpecialty_1.Description) AS Specialtydesc ,
            tblSpecialty_1.Description ,
            tblServices.ShortDesc ,
            tblCase.MastersubCase ,
            ISNULL(tblCase.MasterCaseNbr, tblCase.CaseNbr) AS MasterCaseNbr ,
            tblCase.DoctorName
    FROM    tblSpecialty tblSpecialty_2
            RIGHT OUTER JOIN tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblSpecialty tblSpecialty_1 ON tblCase.sreqSpecialty = tblSpecialty_1.SpecialtyCode ON tblSpecialty_2.SpecialtyCode = tblCase.DoctorSpecialty
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
