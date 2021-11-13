CREATE VIEW vwStatusAppt
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblClient.LastName + ', ' + tblClient.FirstName AS clientname ,
            tblUser.LastName + ', ' + tblUser.FirstName AS schedulername ,
            tblCompany.IntName AS companyname ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS clientemail ,
            tblClient.Fax AS clientfax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblServices.ShortDesc AS service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblCase.QARep ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            DATEDIFF(DAY, tblCase.DateEdited, GETDATE()) AS DSE ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            tblCase.ServiceCode ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID,
			ISNULL(tblCaseAppt.ApptAttendance, '') as ApptAttendance
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
			LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
