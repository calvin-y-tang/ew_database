CREATE VIEW [dbo].[vwGetWebActionLinkURLInfo]
	AS 
		SELECT 
			WAL.WebActionLinkID, C.CaseNbr, c.OfficeCode,
			WC.WebCompanyID, WC.URL, WC.WebActionLinkPage, WAL.UniqueKey, WAL.ExpirationDate
		FROM 
			tblWebActionLink AS WAL, 
			tblCase as C
				INNER JOIN tblControl AS Ctrl ON Ctrl.InstallID = 1
				INNER JOIN tblOffice AS O ON O.OfficeCode = C.OfficeCode
				INNER JOIN tblWebCompany AS WC ON WC.WebCompanyID = ISNULL(O.WebCompanyID, Ctrl.DefaultWebCompanyID) 

