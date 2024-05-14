

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
PRINT N'Creating [dbo].[tblNotify].[IX_tblNotify_UserMethodDelivered]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblNotify_UserMethodDelivered]
    ON [dbo].[tblNotify]([UserID] ASC, [NotifyMethodID] ASC, [DateDelivered] ASC)
    INCLUDE([UserType], [NotifyEventID], [CaseNbr], [ActionType], [ActionKey], [DateAdded], [UserIDAdded], [TableType], [UserCode]);


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
PRINT N'Creating [dbo].[fnConfListIsPhoneValid]...';


GO
CREATE FUNCTION [dbo].[fnConfListIsPhoneValid]
(
	@phoneString AS VARCHAR(16)
)
RETURNS VARCHAR(8)
AS
BEGIN
	
    /*
        Dev Notes: 
            Created for use in Confirmation List processing to validate phone number.
            A valid phone number: 
                - has numeric digits  0 - 9
                - exactly 10 numeric digits
                - can also have the following formatting characters: "(", ")", "-" or " " (space)
    */

    DECLARE @tmpPhone VARCHAR(16)
    DECLARE @len INTEGER
    DECLARE @charPOS INTEGER
    DECLARE @oneChar CHAR(1)
    DECLARE @phoneIsValid VARCHAR(8)

    SET @len = LEN(@phoneString)
    SET @charPOS = 1

    -- can only have 0-9, hyphen, paren, or empty string
    SET @tmpPhone = ''
    SET @phoneIsValid = 'True'
    WHILE (@charPOS <= @len) and (@phoneIsValid = 'True')
    BEGIN

        SET @oneChar = SUBSTRING(@phoneString, @charPOS, 1)
        IF (@oneChar >= '0' and @oneChar <= '9') 
            SET @tmpPhone = @tmpPhone + @oneChar
        ELSE IF (@oneChar <> '-' AND @oneChar <> '(' AND @oneChar <> ')' AND @oneChar <> ' ')
            SET @phoneIsValid = 'False'
          
        SET @charPOS = @charPOS + 1

    END
     
    -- check to see if we have 10 digit phone
    If @phoneIsValid = 'True' AND LEN(@tmpPhone) <> 10 
        SET @phoneIsValid = 'False'
	
    RETURN @phoneIsValid

END
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
