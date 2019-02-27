CREATE VIEW vwAcctMonitorDetail
AS
    SELECT  AT.StatusCode ,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            AT.DrOpCode AS DoctorCode ,
            C.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType ,
			Q.FunctionCode,
			Q.FormToOpen,
			Q.StatusDesc,
			Q.DisplayOrder,
			ISNULL(BillCompany.ParentCompanyID, Company.ParentCompanyID) AS ParentCompanyID
    FROM    tblAcctingTrans AS AT
				INNER JOIN tblCase AS C ON AT.CaseNbr = C.CaseNbr
				INNER JOIN tblQueues AS Q ON Q.StatusCode = AT.StatusCode
				INNER JOIN tblCompany AS Company ON Company.CompanyCode = C.CompanyCode
				LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
				LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
    WHERE   AT.StatusCode <> 20;