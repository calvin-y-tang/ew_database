CREATE VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,tblCase.DoctorName
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,tblCase.MarketerCode AS MarketerName
           ,tblCompany.intname AS CompanyName
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.Status
           ,tblCase.DateAdded
           ,tblCase.DoctorCode
           ,tblCase.MarketerCode
           ,tblQueues.StatusDesc
           ,tblServices.shortdesc AS Service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,'ViewCase' AS FunctionCode
           ,tblCase.casetype
		   ,tblCase.ExtCaseNbr
		   ,ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID 
		   ,tblEWServiceType.Name As ServiceTypDesc
		   ,tblServices.EWServiceTypeID
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID

