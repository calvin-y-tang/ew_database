
CREATE INDEX [IdxtblDoctorSchedule_BY_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc] ON [tblDoctorSchedule]([Status],[DoctorCode],[date],[SchedCode],[LocationCode],[StartTime],[Description],[CaseNbr1desc])
GO

CREATE INDEX [IdxtblCaseAppt_BY_CaseNbr] ON [tblCaseAppt]([CaseNbr])
GO

UPDATE tblControl SET DBVersion='2.18'
GO
