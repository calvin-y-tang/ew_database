-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 142
-- IMEC-14425 - No Show Letter template based on number of no show appts for case
     INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
     VALUES (137, 'NoShowTemplateToUse', 'Case', 'Determine No Show Template to use for a case based on the # of no shows', 1, 1107, 0, 'MinNoShowApptCnt', 'MaxNoShowApptCnt', 'NoShowDocument', NULL, NULL, 0, NULL)
     GO

     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (137, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, '1', '1', 'AllState1stNS', NULL, NULL, 0, NULL, 0),
            (137, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, NULL, NULL, 'AllState2ndNS', NULL, NULL, 0, NULL, 0)
    GO

-- IMEC-14445 - Changes to Implement Liberty QA Questions Feature for Finalize Report
-- Ensure that all tables are empty
	DELETE FROM tblQuestionSet
	GO 
	DELETE FROM tblQuestionSetDetail
	GO
-- New security token
	INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
		VALUES('CaseQAChecklistOverride', 'Case - QA Questions Override', GETDATE())
	GO


-- IMEC-14553
    DECLARE
	    @BusinessRuleID INT = 197,
	    @Today DATETIME = sysdatetime(),
	    @LibertyID INT = 31,
	    @Zone1 INT = 1250,
	    @Zone2 INT = 1275,
	    @FLCentral INT = 1000,
	    @FLNorth INT = 1100,
	    @FLSouth INT = 1200;


    -- delete the old data so that this script is idempotent
    DELETE FROM dbo.tblBusinessRule WHERE BusinessRuleID = @BusinessRuleID;
    DELETE FROM dbo.tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID;

    -- header row
    INSERT INTO dbo.tblBusinessRule
    (BusinessRuleID,Category, [Name], Descrip, IsActive, EventID,
    Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, Param6Desc, 
    BrokenRuleAction, AllowOverride)
    VALUES
    (
	    -- EventID 1016 is CaseDataModified
	    197, 'Case', 'RestrictFeeZoneList', 'Exclude listed fee zones', 1, 1016,
	    'Fee zones to exclude', NULL, NULL, NULL, NULL, NULL,
	    0, 0
    );

    -- create the detail rows for both conditions (Liberty and not Liberty)
    INSERT INTO dbo.tblBusinessRuleCondition
    (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, 
    OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, 
    Param1, Param2, Param3, Param4, Param5, Param6, 
    [skip], ExcludeJurisdiction)
    VALUES
    -- Liberty (exclude North, South, and Central)
    (@BusinessRuleID,'PC',@LibertyID,2,1,@Today,'Admin',
    NULL,NULL,NULL,NULL,
    concat(@FLNorth, ',', @FLSouth, ',', @FLCentral), NULL, NULL, NULL, NULL, NULL,
    0, null),
    -- Not Liberty (exclude zones 1 and 2)
    (@BusinessRuleID,'SW',-1,2,1,@Today,'Admin',
    NULL,NULL,NULL,NULL,
    concat(@Zone1, ',', @Zone2), NULL, NULL, NULL, NULL, NULL,
    0, NULL);
    GO
