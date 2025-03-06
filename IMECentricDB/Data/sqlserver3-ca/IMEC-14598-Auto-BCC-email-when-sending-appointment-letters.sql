-- IMEC-14598 - Auto BCC email when sending appointment letters for Scheduled, Cancelled, and Late Cancelled

Use [IMECentricMedylex]  -- Note, this is a Canadian DB on a different server
BEGIN TRY
    BEGIN TRANSACTION IMEC14598

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (203, 'GenDocsToAddtlEmail', 'Case', 'When generating docs, CC/BCC additional email addresses', 1, 1201, 0, 'AttachOption', 'CCEmailAddress', 'BCCEmailAddress', 'MatchOnContentType', 0)

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (204, 'DistDocsToAddtlEmail', 'Case', 'When distributing docs, CC/BCC additional email addresses', 1, 1202, 0, 'AttachOption', 'CCEmailAddress', 'BCCEmailAddress', 'MatchOnContentType', 0)

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (205, 'DistRptToAddtlEmail', 'Case', 'When distributing reports, CC/BCC additional email addresses', 1, 1320, 0, 'AttachOption', 'CCEmailAddress', 'BCCEmailAddress', 'MatchOnContentType', 0)


DECLARE @BusinessRuleID1 INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'GenDocsToAddtlEmail')
DECLARE @BusinessRuleID2 INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'DistDocsToAddtlEmail')
DECLARE @BusinessRuleID3 INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'DistRptToAddtlEmail')
DECLARE @BCCEmail VARCHAR(100) = 'appointments@medylex.com'

IF @BusinessRuleID1 IS NOT NULL
BEGIN
	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID1, GETDATE(), 'Admin', '1', @BCCEmail, 'Appointment Confirmation')

	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID1, GETDATE(), 'Admin', '1', @BCCEmail, 'Cancellation Notice')
END

IF @BusinessRuleID2 IS NOT NULL
BEGIN
	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID2, GETDATE(), 'Admin', '1', @BCCEmail, 'Appointment Confirmation')

	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID2, GETDATE(), 'Admin', '1', @BCCEmail, 'Cancellation Notice')
END

IF @BusinessRuleID3 IS NOT NULL
BEGIN
	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID3, GETDATE(), 'Admin', '1', @BCCEmail, 'Appointment Confirmation')

	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('SW', 2, 3, @BusinessRuleID3, GETDATE(), 'Admin', '1', @BCCEmail, 'Cancellation Notice')
END

    commit transaction IMEC14598
end try
begin catch
    declare @RN varchar(2) = CHAR(13)+CHAR(10)
    print ERROR_MESSAGE() + @RN
    print 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
    print 'Rolling back transaction.'
    rollback transaction IMEC14598
end catch