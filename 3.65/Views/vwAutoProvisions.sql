CREATE VIEW vwAutoProvisions
AS 
	SELECT 
			tblAutoProvisionLog.*, 
			tblCompany.CompanyCode AS CompanyCode,
			tblClientOffice.OfficeCode,
			tblCompany.ParentCompanyID AS ParentCompanyID,
			tblCompany.IntName
	  FROM tblAutoProvisionLog
			LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblAutoProvisionLog.EntityID
			LEFT OUTER JOIN tblClientOffice ON tblClientOffice.ClientCode = tblAutoProvisionLog.EntityID
			LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblEWParentCompany ON tblEWParentCompany.ParentCompanyID = tblCompany.ParentCompanyID
