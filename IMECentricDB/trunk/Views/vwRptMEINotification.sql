CREATE VIEW vwRptMEINotification
AS
    SELECT
        tblCase.CaseNbr,
		tblCase.ExtCaseNbr,
        tblExaminee.Addr1 AS examineeaddr1,
        tblExaminee.Addr2 AS examineeaddr2,
        tblExaminee.City+', '+tblExaminee.State+'  '+
        tblExaminee.Zip AS examineecitystatezip,
        tblLocation.Addr1 AS doctoraddr1,
        tblLocation.Addr2 AS doctoraddr2,
        tblLocation.City+', '+tblLocation.State+'  '+
        tblLocation.Zip AS doctorcitystatezip,
        tblCase.ApptDate,
        tblCase.ApptTime,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblExaminee.Phone1 AS examineephone,
        tblCCAddress_2.FirstName+' '+tblCCAddress_2.LastName AS attorneyname,
        tblCCAddress_2.Company AS attorneycompany,
        tblCCAddress_2.Address1 AS attorneyaddr1,
        tblCCAddress_2.Address2 AS attorneyaddr2,
        tblCCAddress_2.City+', '+tblCCAddress_2.State+'  '+tblCCAddress_2.Zip AS attorneycitystatezip,
        tblCCAddress_2.Phone+ISNULL(tblCCAddress_2.PhoneExtension, '') AS attorneyphone,
        tblCCAddress_2.Fax AS attorneyfax,
        tblCCAddress_2.Email AS attorneyemail,
        tblLocation.Location,
        tblExaminee.Email AS examineeemail,
        tblCase.OfficeCode,
        tblCase.DoctorName,
        tblCase.bln3DayNotifClaimant,
        tblCase.bln3DayNotifAttorney,
        tblCase.bln14DayNotifClaimant,
        tblCase.bln14DayNotifAttorney,
        tblServices.Description AS servicedesc,
        tblCase.DoctorCode,
        tblCase.Status
    FROM
        tblOffice
    INNER JOIN tblExaminee
    INNER JOIN tblCase ON tblExaminee.ChartNbr=tblCase.ChartNbr ON tblOffice.OfficeCode=tblCase.OfficeCode
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.PlaintiffAttorneyCode=tblCCAddress_2.ccCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    UNION
    SELECT
        tblCase_1.CaseNbr,
		tblCase_1.ExtCaseNbr,
        tblExaminee_1.Addr1 AS examineeaddr1,
        tblExaminee_1.Addr2 AS examineeaddr2,
        tblExaminee_1.City+', '+tblExaminee_1.State+'  '+tblExaminee_1.Zip AS examineecitystatezip,
        tblLocation_1.Addr1 AS doctoraddr1,
        tblLocation_1.Addr2 AS doctoraddr2,
        tblLocation_1.City+', '+tblLocation_1.State+'  '+tblLocation_1.Zip AS doctorcitystatezip,
        tblCase_1.ApptDate,
        tblCase_1.ApptTime,
        tblExaminee_1.FirstName+' '+tblExaminee_1.LastName AS examineename,
        tblExaminee_1.Phone1 AS examineephone,
        tblCCAddress_2.FirstName+' '+tblCCAddress_2.LastName AS attorneyname,
        tblCCAddress_2.Company AS attorneycompany,
        tblCCAddress_2.Address1 AS attorneyaddr1,
        tblCCAddress_2.Address2 AS attorneyaddr2,
        tblCCAddress_2.City+', '+tblCCAddress_2.State+'  '+tblCCAddress_2.Zip AS attorneycitystatezip,
        tblCCAddress_2.Phone+ISNULL(tblCCAddress_2.PhoneExtension, '') AS attorneyphone,
        tblCCAddress_2.Fax AS attorneyfax,
        tblCCAddress_2.Email AS attorneyemail,
        tblLocation_1.Location,
        tblExaminee_1.Email AS examineeemail,
        tblCase_1.OfficeCode,
        tblCase_1.DoctorName,
        tblCase_1.bln3DayNotifClaimant,
        tblCase_1.bln3DayNotifAttorney,
        tblCase_1.bln14DayNotifClaimant,
        tblCase_1.bln14DayNotifAttorney,
        tblServices_1.Description AS servicedesc,
        tblCasePanel.DoctorCode,
        tblCase_1.Status
    FROM
        tblOffice AS tblOffice_1
    INNER JOIN tblExaminee AS tblExaminee_1
    INNER JOIN tblCase AS tblCase_1 ON tblExaminee_1.ChartNbr=tblCase_1.ChartNbr ON tblOffice_1.OfficeCode=tblCase_1.OfficeCode
    INNER JOIN tblServices AS tblServices_1 ON tblCase_1.ServiceCode=tblServices_1.ServiceCode
    INNER JOIN tblCasePanel ON tblCase_1.PanelNbr=tblCasePanel.PanelNbr
    LEFT OUTER JOIN tblLocation AS tblLocation_1 ON tblCase_1.DoctorLocation=tblLocation_1.LocationCode
    LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase_1.PlaintiffAttorneyCode=tblCCAddress_2.ccCode
