CREATE PROC spDoctorCases
    @doctorCode AS INTEGER
AS 
    SELECT
            tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS ExamineeName ,
            tblCase.ApptDate ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorName ,
            tblCase.ClientCode ,
            tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
            tblClient.CompanyCode ,
            tblCompany.IntName ,
            tblLocation.Location ,
            @doctorCode AS DoctorCode ,
            tblQueues.StatusDesc, 
			tbloffice.ShortDesc
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblDoctor ON tblDoctor.DoctorCode = @doctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode 
			LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
    WHERE   tblCase.DoctorCode = @doctorcode
            OR tblCase.PanelNbr IN ( SELECT PanelNbr
                                     FROM   tblCasePanel
                                     WHERE  DoctorCode = @doctorCode )

