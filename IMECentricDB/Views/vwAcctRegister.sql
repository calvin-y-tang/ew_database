CREATE VIEW vwAcctRegister
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
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.BatchNbr ,
            tblCase.ServiceCode ,
            tblAcctHeader.OfficeCode ,
            tblDoctor.DoctorCode ,
            tblAcctHeader.ApptDate ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr ,
            tblAcctDetail.extendedamount ,
            tblproduct.INglacct ,
            tblproduct.VOglacct ,
            tblAcctDetail.longdesc,
			IIF(ISNULL(TaxCode1,'')<>'', TaxCode1 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode2,'')<>'', TaxCode2 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode3,'')<>'', TaxCode3 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode4,'')<>'', TaxCode4 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode5,'')<>'', TaxCode5 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode6,'')<>'', TaxCode6 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode7,'')<>'', TaxCode7 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode8,'')<>'', TaxCode8 + CHAR(13) + CHAR(10) , '') AS taxcode,
			IIF(ISNULL(TaxAmount1,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount1) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount2,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount2) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount3,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount3) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount4,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount4) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount5,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount5) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount6,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount6) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount7,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount7) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount8,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount8) + CHAR(13) + CHAR(10), '') AS taxamount
    FROM    tblAcctHeader
			INNER JOIN tblAcctDetail ON tblAcctDetail.HeaderID = tblAcctHeader.HeaderID
            INNER JOIN tblProduct ON tblAcctDetail.prodcode = tblProduct.prodcode
            INNER JOIN tblCase ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
            LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode



