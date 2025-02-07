-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 144



-- IMEC-14723 - Update Med rec page calculations for certain scenarios
USE [IMECentricEW]

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'LibertyQuoteMedRecPgCalculations')

IF @BusinessRuleID IS NOT NULL
BEGIN
	DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID

	--   (1) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'T1', '250', '385', '0.1', '250')

	--   (2) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'T1', '250', '385', '0.2', '250')

	--   (3) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'T1', '250', '385', '0.1', '250')

	--   (4) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'T1', '250', '385', '0.2', '250')

	--   (13) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = IME; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 1, 'MI', 'T1', '250', '385', '0.1', '250')

	--   (14) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Peer review; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 2, 'MI', 'T1', '385')

	--   (15) Service Fee > 500 - ProdCode = 3030; all cases
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '3030', '0.1', '500')

	  --   (16) Service Fee > 500 - ProdCode = 3030; exclude CA for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA', '3030')

	  --   (17) Service Fee > 500 - ProdCode = 3030; exclude TX for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX', '3030')

	  --   (18) Service Fee > 500 - ProdCode = 3030; exclude WA for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA', '3030')

	--   (19) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'T1', '250', '385', '0.2', '250')

	--   (20) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'T1', '250', '385', '0.2', '250')

	--   (25) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Record review; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 3, 'MI', 'T1', '385')

	--   (5) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'CA', 'T1', '250', '385', '0.5', '250')

	--   (6) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'WA', 'T1', '250', '385', '0.5', '250')

	--   (7) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (8) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (9) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'CA', 'T1', '250', '385', '0.5', '250')

	--   (10) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'WA', 'T1', '250', '385', '0.5', '250')

	--   (11) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (12) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (21) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (22) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (23) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (24) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'WA', 'T1', '250', '385', '0.35', '250')

END

GO

-- IMEC-14728 - Need an additional serviceCode for FL office
--		**** This was applied to production  on 01/10/2025 but there is no harm in letting it run again.
USE [IMECentricEW]

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'AutoAckDPSBundle')

IF @BusinessRuleID IS NOT NULL
BEGIN
	UPDATE tblBusinessRuleCondition 
	   SET param6 = ';2070;3290;4121;2100;' , 
		   DateEdited = GETDATE(),
		   UserIDEdited = 'JPais'
	WHERE  BusinessRuleID = @BusinessRuleID
	   AND EWServiceTypeID = 1  
	   AND OfficeCode = 17
END

GO


-- IMEC-14730 - Liberty updates - add BRC for when no doctor and no reason - a.k.a panel exam
USE [IMECentricEW]
GO

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'SetQuoteAdditionalFeeChoices')

IF @BusinessRuleID IS NOT NULL
BEGIN
	DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', ';T1;', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', 'EW Selected', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
	VALUES ('SW', 2, 4, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,10', ';T2;', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,10', 'Client Selected', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param4)
	VALUES ('PC', 31, 2, 3, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', 'LibertyGuardrailsStartDate')

END
GO

-- IMEC-14664 - Do Not Show QA Checklist for Certain Conditions

use IMECentricEW

begin try
    begin transaction noTxOrCaWc
    
    declare @ruleId int = (select BusinessRuleID from tblBusinessRule where Name
                        = 'UseQAQuestionSet');
    declare @busLine int = (select EWBusLineID from tblEWBusLine where Name
                         = 'Workers Comp');
    declare @parentCompany int = (select ParentCompanyID from tblEWParentCompany where [Name]
                               = 'Liberty Mutual');
    declare @Param1 varchar(100) = 'LibertyGuardrailsStartDate';
    declare @Param2 varchar(100) = 'Exclude';

    update tblBusinessRule
    set Param2Desc = 'FlagForExclusion'
    where [BusinessRuleID] = @ruleId

    print 'Clearing out old rules rules...' 
    delete from tblBusinessRuleCondition
    where [BusinessRuleID] = @ruleId

    print 'Inserting new rules...'
    insert into tblBusinessRuleCondition (
        [EntityType], [EntityID]    , [BillingEntity], [ProcessOrder], [BusinessRuleID], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [OfficeCode], [EWBusLineID], [EWServiceTypeID], [Jurisdiction], [Param1] , [Param2]
    )
    values
        ('PC'       , @parentCompany, 2              , 1             , @ruleId         , GETDATE()  , 'Admin'      , GETDATE()   , 'Admin'       , NULL        , @busLine     , NULL             , 'CA'          , @Param1  , @Param2),
        ('PC'       , @parentCompany, 2              , 1             , @ruleId         , GETDATE()  , 'Admin'      , GETDATE()   , 'Admin'       , NULL        , @busLine     , NULL             , 'TX'          , @Param1  , @Param2),
        ('PC'       , @parentCompany, 2              , 2             , @ruleId         , GETDATE()  , 'Admin'      , GETDATE()   , 'Admin'       , NULL        , NULL         , NULL             , NULL          , @Param1  , NULL   )

    /*
    -- test with throw enabled
    select *
    from tblBusinessRule br
        join tblBusinessRuleCondition brc
        on brc.BusinessRuleID = br.BusinessRuleID
    where br.Name = 'UseQAQuestionSet'
    order by brc.BusinessRuleID, brc.ProcessOrder

    ;throw 51000, 'Rollback for testing.', 1;
    --*/
    commit transaction noTxOrCaWc
end try
begin catch
    declare @RN varchar(2) = CHAR(13)+CHAR(10)
    print ERROR_MESSAGE() + @RN
    print 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
    print 'Rolling back transaction.'
    rollback transaction noTxOrCaWc
end catch


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

-- IMEC-14208 - data patch for old entries in tblExternalCommunication to set processed date
USE [IMECentricEW]
UPDATE tblExternalCommunications SET DateProcessed = GETDATE(), DevNote = 'Data Patching DateProcessed - restarting service'
WHERE DateProcessed IS NULL AND CaseNbr IN (SELECT CaseNbr FROM tblCase WHERE Status IN (8, 9) OR DateAdded <= (GETDATE()-2) OR DateAdded IS NULL)
GO

---IMEC-14804 - Add Marketer Fields Based DB Triggers for Certain Tables
USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblCase_Log_AfterInsert_TRG] 
  ON [dbo].[tblCase]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
    INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
    SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCase', 'MarketerCode', 
               I.CaseNbr, D.MarketerCode, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CaseNbr = D.CaseNbr
         WHERE (D.MarketerCode <> I.MarketerCode)
END
GO

USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblCase_Log_AfterUpdate_TRG] 
  ON [dbo].[tblCase]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
    SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCase', 'MarketerCode', 
               I.CaseNbr, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CaseNbr = D.CaseNbr
         WHERE (D.MarketerCode <> I.MarketerCode)
END
GO

USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblCompany_Log_AfterInsert_TRG] 
  ON [dbo].[tblCompany]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
   INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCompany', 'MarketerCode', 
               I.CompanyCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CompanyCode = D.CompanyCode
         WHERE (D.MarketerCode <> I.MarketerCode)
END
GO

USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblCompany_Log_AfterUpdate_TRG]
    ON [dbo].[tblCompany]
AFTER UPDATE
AS
BEGIN    
    SET NOCOUNT ON        
        INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCompany', 'MarketerCode', 
               I.CompanyCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CompanyCode = D.CompanyCode
         WHERE (D.MarketerCode <> I.MarketerCode)
END
GO

USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblClient_Log_AfterInsert_TRG] 
  ON [dbo].[tblClient]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
   INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblClient', 'MarketerCode', 
               I.ClientCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.ClientCode = D.ClientCode
         WHERE (D.MarketerCode <> I.MarketerCode)
END
GO

USE [IMECentricEW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tblClient_Log_AfterUpdate_TRG]
    ON [dbo].[tblClient]
AFTER UPDATE
AS
BEGIN    
     SET NOCOUNT ON     
    	 INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
     SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblClient', 'MarketerCode', 
               I.ClientCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.ClientCode = D.ClientCode
         WHERE (D.MarketerCode <> I.MarketerCode)
END










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


