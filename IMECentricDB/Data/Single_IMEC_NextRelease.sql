-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 146


-- **** Canadian DB change ***************
-- IMEC-14824 - Add case priority values for DirectIME
USE [IMECentricDirectIME]

begin try
    begin transaction directIMEpriorities

    INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
    VALUES ('24Hr', '24 Hour Rush', GETDATE(), 'Admin', 30),
           ('5Day', '5 Day Rush', GETDATE(), 'Admin', 60),
           ('10Day', '10 Day Rush', GETDATE(), 'Admin', 70),
           ('RushVerbal', 'Rush Verbal', GETDATE(), 'Admin', 90)

	declare @newRuleId int = (select  Max(BusinessRuleID)+1 from tblBusinessRule);

    -- business rule to set list of case priorities
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
    VALUES (@newRuleId, 'SetCasePriorities', 'Case', 'Set list of case priorities to use', 1, 1016, 0, 'PriorityList', 0)

    -- BRC for office BC in DirectIME
    INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, OfficeCode, Param1)
    VALUES ('SW', 2, 1, @newRuleId, GETDATE(), 'Admin', 3, '''Normal'',''48Hr'',''Hold'',''24Hr'',''5Day'',''10Day'',''RushVerbal''')

    -- BRC for DirectIME offices in general
    INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
    VALUES ('SW', 2, 2, @newRuleId, GETDATE(), 'Admin', '''Normal'',''48Hr'',''Hold''')

    commit transaction directIMEpriorities
end try
begin catch
    declare @RN varchar(2) = CHAR(13)+CHAR(10)
    print ERROR_MESSAGE() + @RN
    print 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
    print 'Rolling back transaction.'
    rollback transaction directIMEpriorities
end catch

GO


