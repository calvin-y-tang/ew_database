CREATE VIEW vwCaseWebReservedAppts
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.MarketerCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            tblCase.Priority ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr + ' ' + ISNULL(tblCase.ClaimNbrExt, '') AS ClaimNbr,
            tblLocation.Location ,
            tblCase.ApptSelect ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,

            DBTD.ScheduleDate ,
            DBTD.DoctorCode ,
			DBTS.StartTime,
            DBTD.LocationCode AS doctorLocation,
            tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName, ' ') AS DoctorName ,

            tblqueues.FunctionCode ,
            tblCase.Casetype ,
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID, 
			tblCase.Jurisdiction, 
			CaseType.ShortDesc AS CaseTypeDesc 
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
			INNER JOIN tblCaseApptRequest AS ApptReq ON tblCase.CaseNbr = ApptReq.CaseNbr
            LEFT JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			LEFT JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT JOIN tblCaseType AS CaseType ON CaseType.Code = tblCase.CaseType
			LEFT JOIN tblDoctorBlockTimeSlot AS DBTS ON ApptReq.CaseApptRequestID = DBTS.CaseApptRequestID
			LEFT JOIN tblDoctorBlockTimeDay AS DBTD ON DBTS.DoctorBlockTimeDayID = DBTD.DoctorBlockTimeDayID
            LEFT JOIN tblLocation ON DBTD.LocationCode = tblLocation.LocationCode
            LEFT JOIN tblDoctor ON DBTD.DoctorCode = tblDoctor.DoctorCode