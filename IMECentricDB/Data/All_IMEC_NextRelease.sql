-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 134

-- JAP - IMEC-14200 - set default value for previously added DoNotUse column
UPDATE tblDoctorSpecialty SET DoNotUse = 0 WHERE DoNotUse IS NULL
GO 

-- TL - IMEC-14212 - new business rule to allow companies and PC's to opt out of having MedIndex-Final document published on web
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES (170, 'OptOutPOWMedIndexFinal', 'Case', 'IMEC-14212 - Entities opting out of publishing to web DPS document MedIndex-Final for client and/or billing client', 1,
        1015, 0, 'ClientTypeToOptOut', 0)
GO
