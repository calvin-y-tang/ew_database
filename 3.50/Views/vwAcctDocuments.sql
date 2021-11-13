CREATE VIEW vwAcctDocuments
AS
    SELECT  tblCase.CaseNbr ,
            tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            CASE WHEN tblDoctor.Credentials IS NOT NULL
                 THEN tblDoctor.FirstName + ' ' + tblDoctor.LastName + ', '
                      + tblDoctor.Credentials
                 ELSE tblDoctor.[Prefix] + ' ' + tblDoctor.FirstName + ' '
                      + tblDoctor.LastName
            END AS DoctorName ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblAcctHeader.ClientCode AS InvClientCode ,
            tblAcctHeader.CompanyCode AS InvCompanyCode ,
            InvCl.LastName + ', ' + InvCl.FirstName AS InvClientName ,
            InvCom.IntName AS InvCompanyName ,
            tblCase.Priority ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS adjusteremail ,
            tblClient.Fax AS adjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.BatchNbr ,
            tblCase.ServiceCode ,
            tblAcctHeader.OfficeCode ,
            tblDoctor.DoctorCode ,
            tblAcctHeader.ApptDate ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblAcctHeader
            INNER JOIN tblCase ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
            LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode
