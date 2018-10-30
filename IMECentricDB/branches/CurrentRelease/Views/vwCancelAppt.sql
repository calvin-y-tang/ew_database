CREATE VIEW vwCancelAppt
AS
    SELECT DISTINCT 
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.DoctorNames ,
            tblLocation.Location ,
            vwCaseAppt.CanceledByExtName ,
            vwCaseAppt.Reason ,
            vwCaseAppt.ApptTime ,
            vwCaseAppt.DateEdited ,
            vwCaseAppt.UserIDEdited ,
            tblOffice.Description AS Office ,
            tblCaseType.Description AS CaseType ,
            vwClient.Client ,
            vwClient.IntName AS Company ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee ,
            tblServices.Description AS Service ,
            tblCase.MarketerCode ,
            tblCase.CaseNbr ,
            tblCase.QARep ,
            tblCase.OfficeCode ,
            tblCaseType.Code ,
            vwClient.CompanyCode ,
            vwClient.ClientCode ,
            tblExaminee.ChartNbr ,
            tblServices.ServiceCode , 
			tblCase.ExtCaseNbr 
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN vwClient ON tblCase.ClientCode = vwClient.ClientCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
