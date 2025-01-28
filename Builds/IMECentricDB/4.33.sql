

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblEWDrDocType]...';


GO
ALTER TABLE [dbo].[tblEWDrDocType]
    ADD [ControlledByIMEC] BIT CONSTRAINT [DF_tblEWDrDocType_ControlledByIMEC] DEFAULT (0) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
-- Sprint 109

-- IMEC-13504 - create new business rules for Liberty to force value for Case Priorty
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (156, 'SetCasePriorityOnSave', 'Case', 'Check/Set the case Priority value when case is saved', 1, 1016, 0, 'SetPriorityTo', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (156, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, 'OR', 'RushReport', NULL, NULL, NULL, NULL, 0, NULL), 
        (156, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, 'WA', 'RushReport', NULL, NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13523 patch data in tblEWDrDocType
UPDATE tblEWDrDocType
   SET ControlledByIMEC = 0
WHERE EWDrDocTypeID IN (2,4,5,6,11)
GO

UPDATE tblEWDrDocType
   SET ControlledByIMEC = 1
WHERE EWDrDocTypeID IN (1,3,7,8,9,10,12,13,14,15,16)
GO

