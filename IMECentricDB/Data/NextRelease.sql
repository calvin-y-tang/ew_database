
-- IMEC-12442 add Conflict of interest business rule and security token
INSERT INTO tblUserFunction 
VALUES('ConflictOfInterestOverride', 'Appointments - Conflict of Interest Override', GetDate())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (163, 'ApptConflictOfInterest', 'Case', 'Scheduling a case check for a conflict of interest', 1, 1101, 1, 'IncludeServiceTypeID', 'SubFormToDisplay', NULL, NULL, 'Override Sec Token', 0, NULL)
GO
