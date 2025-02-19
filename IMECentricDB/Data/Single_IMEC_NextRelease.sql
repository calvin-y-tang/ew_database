-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 145

--INEC 14451 - liberty-Scheduling

use IMECentricEW

begin try
    begin transaction matchSpecialty
    
   
    declare @parentCompany int = (select ParentCompanyID from tblEWParentCompany where [Name]
                               = 'Liberty Mutual');
    declare @ruleName varchar(34) = 'MatchDoctorSpecialty';
	declare @Category varchar(20)='Appointment';
	declare @description varchar(150)= 'Match User Selected Doctor Speciality with Requested Speciality in Case Parameters';
	declare @IsActive bit = 1;
	declare @AllowOverride bit = 1;
	declare @EventId int =1101;
	declare @Param1Desc varchar(20) = 'StartDate'
	declare @Param2Desc varchar(20) = 'AppointmentMessage'
	declare @Param3Desc varchar(20) = 'CaseCustomerDataParamCondtion'
	declare @Param4Desc varchar(20) = 'Company Name'
	declare @Param5Desc varchar(20) = 'OverrideToken'
	declare @Param6Desc varchar (20)='PanelExamMessage'
    
	declare @Param1 varchar(100) = 'LibertyGuardrailsStartDate'; 
	declare @Param2 varchar(128)= 'Liberty has requested a specialty for this exam and you are required to schedule a doctor that matches that specialty.'
	declare @Param3 varchar(100)='NotiCaseReferral="0"'
	declare @Param4 varchar(100)='Liberty Mutual'
	declare @Param5 varchar (100)= 'LibertySchedulingOverride'	
	declare @Param6 varchar(MAX)= 'WARNING: Liberty has requested specialties for this exam. Since this is a panel exam, you are required to schedule only doctors that match those specialties.  Any other specialty would require Liberty approval.'
	declare  @EntityType varchar(2)='PC';


	 print 'Clearing out old rules rules...' 

	   
		delete from tblBusinessRuleCondition
		 where [BusinessRuleID] in (Select BusinessRuleID from tblBusinessRule where Name= @ruleName);

		delete from tblBusinessRule where Name = @ruleName;
		 


	declare @newRuleId int = (select  Max(BusinessRuleID)+1 from tblBusinessRule);

	INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID]
           ,[Name]
           ,[Category]
           ,[Descrip]
           ,[IsActive]
           ,[EventID]
           ,[AllowOverride]
           ,[Param1Desc]
           ,[Param2Desc]
           ,[Param3Desc]
           ,[Param4Desc]
           ,[Param5Desc]
           ,[BrokenRuleAction]
           ,[Param6Desc])
     VALUES
           (@newRuleId,
            @ruleName,
            @Category,
            @description,
            @IsActive,
            @EventId,
            1
           ,@Param1Desc
           ,@Param2Desc
           ,@Param3Desc
           ,@Param4Desc
           ,@Param5Desc
           ,0
           ,@Param6Desc)



    print 'Inserting new rules...'
    insert into tblBusinessRuleCondition (
        [EntityType], [EntityID]    , [BillingEntity], [ProcessOrder], [BusinessRuleID], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [OfficeCode], [EWBusLineID], [EWServiceTypeID], [Jurisdiction], [Param1] , [Param2],[Param3], [Param4],[Param5],[Param6]
    )
    values
        ('PC'       , @parentCompany, 2              , 1             , @newRuleId         , GETDATE()  , 'Admin'      , GETDATE()   , 'Admin'       , NULL        , NULL     , NULL             , NULL          , @Param1  , @Param2,@Param3,@Param4, @Param5, @Param6)
      
       -- test with throw enabled
    --select *
    --from tblBusinessRule br
    --    join tblBusinessRuleCondition brc
    --    on brc.BusinessRuleID = br.BusinessRuleID
    --where br.Name = @ruleName
    --order by brc.BusinessRuleID, brc.ProcessOrder

    --;throw 51000, 'Rollback for testing.', 1;
    
    commit transaction matchSpecialty
end try
begin catch
    declare @RN varchar(2) = CHAR(13)+CHAR(10)
    print ERROR_MESSAGE() + @RN
    print 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
    print 'Rolling back transaction.'
    rollback transaction matchSpecialty
end catch

-- IMEC-14800 - carve out workers comp cases for TX, CA, and WA for Liberty guardrails
--  create new business rule and event to check Liberty cases for quote
USE IMECentricEW
BEGIN TRY
    BEGIN TRANSACTION imec14800_newBR

	INSERT INTO tblEvent (EventID, Descrip, Category) VALUES (9999, 'All', 'Application')

	INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
	VALUES (209, ' LibertyGRsApplyToIMECEW', 'Case', 'Check if Liberty guardrails apply for Liberty cases', 1, 9999, 0, 'TrueOrFalse', 0)

	DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = ' LibertyGRsApplyToIMECEW')

	IF @BusinessRuleID IS NOT NULL

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA', 'False')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX', 'False')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA', 'False')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2)
	VALUES ('PC', 31, 2, 4, @BusinessRuleID, GETDATE(), 'Admin', 'True')

	COMMIT TRANSACTION imec14800_newBR

END TRY
BEGIN CATCH
    DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
    PRINT ERROR_MESSAGE() + @RN
    PRINT 'On line: ' + convert(NVARCHAR(4), ERROR_LINE()) + @RN
    PRINT 'Rolling back transaction.'
    ROLLBACK TRANSACTION imec14800_newBR
END CATCH


-- IMEC-14800 - carve out workers comp cases for TX, CA, and WA for Liberty guardrails
   -- add additional BRC's to set additional fee choices on quote form - use "default" fees in these scenarios
USE IMECentricEW
BEGIN TRY
    BEGIN TRANSACTION imec14800_addquotefees

	DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'SetQuoteAdditionalFeeChoices')

	IF @BusinessRuleID IS NOT NULL

	UPDATE tblBusinessRuleCondition SET ProcessOrder = (ProcessOrder + 1) WHERE BusinessRuleID = @BusinessRuleID

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA', '1,2,3,4,5,6,7,8')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX', '1,2,3,4,5,6,7,8')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA', '1,2,3,4,5,6,7,8')

	COMMIT TRANSACTION imec14800_addquotefees

END TRY
BEGIN CATCH
    DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
    PRINT ERROR_MESSAGE() + @RN
    PRINT 'On line: ' + convert(NVARCHAR(4), ERROR_LINE()) + @RN
    PRINT 'Rolling back transaction.'
    ROLLBACK TRANSACTION imec14800_addquotefees
END CATCH



-- IMEC-14800 - carve out workers comp cases for TX, CA, and WA for Liberty guardrails
   -- add additional BRC's to enable / disable the Med Rec Pages textbox on the quote form
USE IMECentricEW
BEGIN TRY
    BEGIN TRANSACTION imec14800_medrecpgsfield

	DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'UseQuoteSpecialColumns')

	IF @BusinessRuleID IS NOT NULL

	UPDATE tblBusinessRuleCondition SET ProcessOrder = 2 WHERE BusinessRuleID = @BusinessRuleID AND EntityType = 'PC' AND EntityID = 31

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA', 'False')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX', 'False')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param1)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA', 'False')

	COMMIT TRANSACTION imec14800_medrecpgsfield

END TRY
BEGIN CATCH
    DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
    PRINT ERROR_MESSAGE() + @RN
    PRINT 'On line: ' + convert(NVARCHAR(4), ERROR_LINE()) + @RN
    PRINT 'Rolling back transaction.'
    ROLLBACK TRANSACTION imec14800_medrecpgsfield
END CATCH


-- IMEC-14801 - carve out workers comp cases for TX, CA, and WA for Liberty guardrails
   -- add additional BRC's to set max amount for invoice
USE IMECentricEW
BEGIN TRY
    BEGIN TRANSACTION imec14801_invmaxamount

	DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'LibertyGuardRailsInvoice')

	IF @BusinessRuleID IS NOT NULL

	UPDATE tblBusinessRuleCondition SET ProcessOrder = 3 WHERE BusinessRuleID = @BusinessRuleID AND EntityType = 'PC' AND EntityID = 31

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA')

	COMMIT TRANSACTION imec14801_invmaxamount

END TRY
BEGIN CATCH
    DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
    PRINT ERROR_MESSAGE() + @RN
    PRINT 'On line: ' + convert(NVARCHAR(4), ERROR_LINE()) + @RN
    PRINT 'Rolling back transaction.'
    ROLLBACK TRANSACTION imec14801_invmaxamount
END CATCH



-- IMEC-14800 - carve out workers comp cases for TX, CA, and WA for Liberty guardrails
   -- fix typo in business rule description
USE IMECentricEW
BEGIN TRY
    BEGIN TRANSACTION imec14800_fixtypo

	UPDATE tblBusinessRule SET Descrip = 'Liberty Quote GR - rules for calculating med rec page amounts' WHERE Name = 'LibertyQuoteMedRecPgCalculations'

	COMMIT TRANSACTION imec14800_fixtypo

END TRY
BEGIN CATCH
    DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
    PRINT ERROR_MESSAGE() + @RN
    PRINT 'On line: ' + convert(NVARCHAR(4), ERROR_LINE()) + @RN
    PRINT 'Rolling back transaction.'
    ROLLBACK TRANSACTION imec14800_fixtypo
END CATCH
GO

-- IMEC-14820 - Progressive INV Quote secruity token & BizRule
USE IMECentricEW 
GO
     DELETE FROM tblUserFunction WHERE FunctionCode = 'ProgQuoteFSMatchOverride'
     GO
     INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
     VALUES('ProgQuoteFSMatchOverride', 'Progressive - Quote Override matching FS item', GETDATE())
     GO

     BEGIN TRY
          BEGIN TRANSACTION imec14820

          DECLARE @ruleName VARCHAR(34) = 'ProgressiveINVQuoteRules';
          DECLARE @Category VARCHAR(20) = 'Accounting';
          DECLARE @description VARCHAR(150)= 'Determine if this is a Progressive Quote for which Rules need to be applied';
          DECLARE @IsActive BIT = 1;
          DECLARE @AllowOverride BIT = 1;
          DECLARE @EventId INT = 1060; -- Fee Quote Saved
          DECLARE @Param1Desc VARCHAR(20) = 'StartDate';
          DECLARE @Param2Desc VARCHAR(20) = NULL;
          DECLARE @Param3Desc VARCHAR(20) = NULL;
          DECLARE @Param4Desc VARCHAR(20) = NULL;
          DECLARE @Param5Desc VARCHAR(20) = 'SecurityToken';
          DECLARE @Param6Desc VARCHAR(20) = NULL;
     
          -- ###################################################################
          PRINT 'Clearing out old rules...' 
     
          DELETE FROM tblBusinessRuleCondition
           WHERE [BusinessRuleID] IN (SELECT BusinessRuleID 
                                        FROM tblBusinessRule 
                                       WHERE Name = @ruleName);
          DELETE FROM tblBusinessRule 
           WHERE Name = @ruleName;

          -- ###################################################################
          PRINT 'Create new rule...'
     
          DECLARE @newRuleId INT = (SELECT MAX(BusinessRuleID) + 1 FROM tblBusinessRule);
	     INSERT INTO dbo.tblBusinessRule
                (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, 
                 Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
          VALUES
                (@newRuleId, @ruleName, @Category, @description, @IsActive, @EventId, 1,
                 @Param1Desc, @Param2Desc, @Param3Desc, @Param4Desc, @Param5Desc, 0, @Param6Desc)

          -- ###################################################################
          PRINT 'Create new rule conditions...'

          DECLARE @EntityType VARCHAR(2) = 'PC';
          DECLARE @EntityID INT = 39; -- Progressive Parent Company
          DECLARE @BillingEntityID INT = 2; -- Billing & Case
          DECLARE @ProcessOrder INT = 2; -- leaving a spot so that we can exclude CO/CL IDs that we don't want to follow the rules for
          DECLARE @OfficeID INT = NULL;
          DECLARE @EWBusLineID INT = 2; -- first party auto
          DECLARE @EWServiceTypeID INT = 1; -- IME
          DECLARE @Jursidiction VARCHAR(5) = NULL;
          DECLARE @Param1 VARCHAR(100) = '2025-02-10';
          DECLARE @Param2 VARCHAR(128) = NULL;
          DECLARE @Param3 VARCHAR(100) = NULL;
          DECLARE @Param4 VARCHAR(100) = NULL;
          DECLARE @Param5 VARCHAR(100) = 'ProgQuoteFSMatchOverride';
          DECLARE @Param6 VARCHAR(MAX) = NULL;

         INSERT INTO dbo.tblBusinessRuleCondition 
               (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, 
                OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1 , Param2, Param3, Param4, Param5, Param6, Skip, ExcludeJurisdiction)
         VALUES
               (@EntityType, @EntityID, @BillingEntityID, @ProcessOrder, @newRuleId, GETDATE(), 'Admin', GETDATE(), 'Admin', 
                @OfficeID, @EWBusLineID, @EWServiceTypeID, @Jursidiction, @Param1, @Param2, @Param3, @Param4, @Param5, @Param6, 0, 0)
        
         COMMIT TRANSACTION imec14820
     END TRY
     BEGIN CATCH
         DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
         PRINT ERROR_MESSAGE() + @RN
         PRINT 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
         PRINT 'Rolling back transaction.'
         ROLLBACK TRANSACTION imec14820
     END CATCH

GO

