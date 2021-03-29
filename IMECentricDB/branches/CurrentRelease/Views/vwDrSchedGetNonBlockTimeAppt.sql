CREATE VIEW [dbo].[vwDrSchedGetNonBlockTimeAppt]
	AS 
		SELECT 
			ca.CaseApptID,
			ca.CaseNbr,
			ca.ApptStatusID,
			ISNULL(cap.DoctorCode, ca.DoctorCode) as Doctorcode,
			ca.LocationCode, 
			ca.ApptTime,
			ca.Duration,
			-- IDs that are useful to have at hand
			c.CaseNbr AS ApptSlotCaseNbr,
			c.ChartNbr,
			cl.ClientCode,
			c.ServiceCode,
			c.CaseType,
			co.CompanyCode,
			-- details used in UI
			ex.LastName + ', ' + ex.FirstName AS ExamineeName,
			co.IntName AS CompanyName,
			ct.ShortDesc AS CaseTypeShortDesc,
			serv.ShortDesc AS ServiceShortDesc
		FROM
			tblCaseAppt AS ca
				LEFT OUTER JOIN tblCaseApptPanel AS CAP on cap.CaseApptID = ca.CaseApptID
				INNER JOIN tblCase AS c ON c.CaseNbr = ca.CaseNbr
				INNER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				INNER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				INNER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				INNER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				INNER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
		WHERE 
			ca.DoctorBlockTimeSlotID IS NULL

