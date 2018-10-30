CREATE VIEW vwCase
AS
    SELECT  CaseNbr ,
            DoctorLocation ,
            C.ClientCode ,
            C.MarketerCode ,
            SchedulerCode ,
            C.Status ,
            DoctorCode ,
            C.DateAdded ,
            ApptDate ,
            C.CompanyCode ,
            OfficeCode ,
            C.QARep ,
			C.CaseType ,
			C.ServiceCode ,
			C.ReExam ,
			C.ReExamProcessed ,
			C.ReExamDate, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID
    FROM    tblCase AS C
				INNER JOIN tblCompany ON tblCompany.CompanyCode = C.CompanyCode
				LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
				LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode

