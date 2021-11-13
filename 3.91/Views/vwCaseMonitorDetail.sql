CREATE VIEW vwCaseMonitorDetail
AS
    SELECT
		C.CaseNbr,
        C.Status AS StatusCode,
        IIF(C.Priority<>'Normal', 1, 0) AS Rush,
        IIF(ISNULL(C.Priority, 'Normal')='Normal', 1, 0) AS Normal,
        C.MarketerCode,
        C.DoctorLocation,
        C.DoctorCode,
        C.CompanyCode,
        C.OfficeCode,
        C.SchedulerCode,
        C.QARep,
        C.ServiceCode,
        C.CaseType,
		C.DateAdded,
		C.ApptDate,
        Q.FunctionCode,
        Q.FormToOpen,
        Q.StatusDesc,
        Q.DisplayOrder, 
		ISNULL(BillCompany.ParentCompanyID, Company.ParentCompanyID) AS ParentCompanyID,
		ST.Name As ServiceTypDesc,
		SE.EWServiceTypeID
    FROM
        tblCase AS C
			INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
			INNER JOIN tblCompany AS Company ON Company.CompanyCode = C.CompanyCode
			LEFT OUTER JOIN tblServices AS SE ON C.ServiceCode = SE.ServiceCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
    WHERE
        C.Status NOT IN (8, 9, -100)
