CREATE VIEW vwWALI
AS
    SELECT  tblDoctorSchedule.SchedCode,
			tblDoctorSchedule.DoctorCode,
			tblDoctorSchedule.date,
			tblCase.CaseNbr,
			tblCaseType.EWBusLineID
	FROM    tblDoctorSchedule 
				LEFT OUTER JOIN tblCase
					INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code	
					LEFT OUTER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				ON tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)