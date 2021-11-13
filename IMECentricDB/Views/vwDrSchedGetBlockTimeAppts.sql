CREATE VIEW [dbo].[vwDrSchedGetBlockTimeAppts]
	AS 
		SELECT
			-- tblDoctorBlockTimeSlot details
			TimeSlot.*,
			-- other miscellaneous IDs that are helpful to have
			c.CaseNbr AS ApptSlotCaseNbr, 
			c.ChartNbr,
			c.ClientCode, 
			c.ServiceCode, 
			c.CaseType, 
			co.CompanyCode, 
			-- details that are used in UI
			ex.LastName + ', ' + ex.Firstname as ExamineeName, 
			co.intname as CompanyName,
			ct.shortdesc as CaseTypeShortDesc,
			serv.ShortDesc as ServiceShortDesc,
			IIF(c.PanelNbr IS NOT NULL AND c.PanelNbr > 0, c.DoctorName, '') AS PanelDoctor 
		FROM 
			tblDoctorBlockTimeSlot AS TimeSlot
				LEFT OUTER JOIN tblCaseAppt AS ca ON ca.CaseApptID = TimeSlot.CaseApptID
				LEFT OUTER JOIN tblCaseApptRequest AS car ON car.CaseApptRequestID = TimeSlot.CaseApptRequestID
				LEFT OUTER JOIN tblCase AS c ON c.CaseNbr = IIF(ca.CaseNbr IS NULL, car.CaseNbr, ca.CaseNbr)
				LEFT OUTER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				LEFT OUTER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				LEFT OUTER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				LEFT OUTER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				LEFT OUTER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode

