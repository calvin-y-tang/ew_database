-- ----------------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric Canadian database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- ----------------------------------------------------------------------------------
-- sprint 146


-- **** Canadian DB change ***************
-- IMEC-14824 - Add case priority values for DirectIME

USE [IMECentricDirectIME]

begin try
    begin transaction directIMEpriorities

    declare @prioritycode1 varchar(50) = '24Hr';
    declare @prioritycode2 varchar(50) = '5Day';
    declare @prioritycode3 varchar(50) = '10Day';
    declare @prioritycode4 varchar(50) = 'RushVerbal';

    declare @priorityCount1 INT = (SELECT COUNT(*) FROM tblPriority WHERE PriorityCode = @prioritycode1)
    If @priorityCount1 = 0
    BEGIN
        INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
        VALUES (@prioritycode1, '24 Hour Rush', GETDATE(), 'Admin', 30)
    END

    declare @priorityCount2 INT = (SELECT COUNT(*) FROM tblPriority WHERE PriorityCode = @prioritycode2)
    If @priorityCount2 = 0
    BEGIN
        INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
        VALUES (@prioritycode2, '5 Day Rush', GETDATE(), 'Admin', 60)
    END

    declare @priorityCount3 INT = (SELECT COUNT(*) FROM tblPriority WHERE PriorityCode = @prioritycode3)
    If @priorityCount3 = 0
    BEGIN
        INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
        VALUES (@prioritycode3, '10 Day Rush', GETDATE(), 'Admin', 70)
    END

    declare @priorityCount4 INT = (SELECT COUNT(*) FROM tblPriority WHERE PriorityCode = @prioritycode4)
    If @priorityCount4 = 0
    BEGIN
        INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
        VALUES (@prioritycode4, 'Rush Verbal', GETDATE(), 'Admin', 90)
    END


	declare @newRuleId int = (select  Max(BusinessRuleID)+1 from tblBusinessRule);
    declare @BRName varchar(35) = 'SetCasePriorities';
    declare @BRID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = @BRName)

    If @BRID IS NULL
    BEGIN
        -- business rule to set list of case priorities
        INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
        VALUES (@newRuleId, @BRName, 'Case', 'Set list of case priorities to use', 1, 1016, 0, 'PriorityList', 0)

        -- BRC for office BC in DirectIME
        INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, OfficeCode, Param1)
        VALUES ('SW', 2, 1, @newRuleId, GETDATE(), 'Admin', 3, '''Normal'',''48Hr'',''Hold'',''24Hr'',''5Day'',''10Day'',''RushVerbal''')

        -- BRC for DirectIME offices in general
        INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
        VALUES ('SW', 2, 2, @newRuleId, GETDATE(), 'Admin', '''Normal'',''48Hr'',''Hold''')
    END

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




