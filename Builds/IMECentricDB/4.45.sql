

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
PRINT N'Dropping [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_EntityCommunicationSent]...';


GO
DROP INDEX [IX_tblExternalCommunications_EntityCommunicationSent]
    ON [dbo].[tblExternalCommunications];


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
PRINT N'Dropping [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_BulkBillingIDCommunicationSent]...';


GO
DROP INDEX [IX_tblExternalCommunications_BulkBillingIDCommunicationSent]
    ON [dbo].[tblExternalCommunications];


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
PRINT N'Altering [dbo].[tblExternalCommunications]...';


GO
ALTER TABLE [dbo].[tblExternalCommunications]
    ADD [DateProcessed] DATETIME NULL;


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
PRINT N'Creating [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_EntityCommunicationSent]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_EntityCommunicationSent]
    ON [dbo].[tblExternalCommunications]([EntityType] ASC, [EntityID] ASC, [DateProcessed] ASC)
    INCLUDE([CommunicationSent]);


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
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [MFAEmailAddr] VARCHAR (70) NULL;


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
PRINT N'Creating [dbo].[sp_CreateExternalCommunications]...';


GO
CREATE PROCEDURE [dbo].[sp_CreateExternalCommunications]
	@caseHistoryID INT,
	@currDateTime DATETIME, 
	@entityType VARCHAR(2), 
	@entityID VARCHAR(64)
AS
BEGIN
	-- create new entry in table
	INSERT INTO tblExternalCommunications(DateAdded, EventDate, CaseNbr, ChartNbr, CaseHistoryID, UserID, 
		DoctorCode, DoctorSpecialty, ApptDateTime, DateCanceled, CaseHistoryType, EWBusLineID, EWServiceTypeID, 
		OfficeCode, ApptLocationCode, ClaimNbr, EWFacilityID, EntityType, EntityID)
			SELECT @currDateTime, 
				   ch.EventDate, 
				   ch.CaseNbr, 
				   c.ChartNbr, 
				   ch.ID, 
				   ch.UserID, 
				   c.DoctorCode, 
				   c.DoctorSpecialty, 
				   c.ApptTime,
				   c.DateCanceled, 
				   ch.Type, 
				   ct.EWBusLineID, 
				   s.EWServiceTypeID, 
				   c.OfficeCode, 
				   c.DoctorLocation,
				   c.ClaimNbr, 
				   f.EWFacilityID, 
				   @entityType, 
				   @entityID 
			  FROM tblcasehistory AS ch 
					 INNER JOIN tblcase AS c ON ch.casenbr = c.casenbr
					 INNER JOIN tblcasetype AS ct ON c.casetype = ct.code
					 INNER JOIN tblservices AS s ON c.servicecode = s.ServiceCode
					 INNER JOIN tbloffice AS o ON c.OfficeCode = o.OfficeCode
					 INNER JOIN tblEWFacility AS f ON o.EWFacilityID = f.EWFacilityID
					 INNER JOIN tblEWFacilityGroupSummary AS fgs ON f.EWFacilityID = fgs.EWFacilityID 
			 WHERE ch.ID = @caseHistoryID
	
	-- return PKey of item created
	SELECT @@IDENTITY as newID

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
-- Sprint 119

-- IMEC-13817 - Create business rules for Automated Referral Acknowledgement
DELETE 
  FROM tblExternalCommunications
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1070, 'CaseHistoryAdded', 'Case')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (116, 'CreateExtComm', 'Case', 'Create entry in tblExternalCommunications', 1, 1070, 0, 'ExtCommTypesAllowed', 'ExtCommEntity', NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (116, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'NewCase;', 'EntityType=PC;EntityID=9', NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13820 add new security token for edit doctor notes
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorEditNotes', 'Doctor - Edit Notes (Notes/QANotes/RecordReqNotes)', GETDATE())
GO

-- IMEC-13847 patch tblWebUser.MFAEmailAddr column using email address from source table
UPDATE wu
   SET MFAEmailAddr = CASE
                         WHEN cl.Email IS NOT NULL THEN SUBSTRING(cl.Email, 1, 
                                              CASE CHARINDEX(';', cl.Email)
                                              WHEN 0 THEN LEN(cl.Email)  
                                              ELSE CHARINDEX(';', cl.Email) - 1
                                              END) 
                         WHEN dr.EmailAddr IS NOT NULL THEN SUBSTRING(dr.EmailAddr, 1, 
                                              CASE CHARINDEX(';', dr.EmailAddr)
                                              WHEN 0 THEN LEN(dr.EmailAddr) 
                                              ELSE CHARINDEX(';', dr.EmailAddr) - 1
                                              END)
                         WHEN atty.Email IS NOT NULL THEN SUBSTRING(atty.Email, 1, 
                                              CASE CHARINDEX(';', atty.Email)
                                              WHEN 0 THEN LEN(atty.Email) 
                                              ELSE CHARINDEX(';', atty.Email) - 1
                                              END)
                         WHEN tr.Email IS NOT NULL THEN SUBSTRING(tr.Email, 1, 
                                              CASE CHARINDEX(';', tr.Email)
                                              WHEN 0 THEN LEN(tr.Email) 
                                              ELSE CHARINDEX(';', tr.Email) - 1
                                              END)
                         WHEN drA.Email IS NOT NULL THEN SUBSTRING(drA.Email, 1, 
                                              CASE CHARINDEX(';', drA.Email)
                                              WHEN 0 THEN LEN(drA.Email) 
                                              ELSE CHARINDEX(';', drA.Email) - 1
                                              END) 
                         ELSE NULL
                    END
FROM tblWebUser AS wu
          LEFT OUTER JOIN tblClient AS cl ON cl.ClientCode = wu.IMECentricCode AND wu.UserType = 'CL'
          LEFT OUTER JOIN tblDoctor AS dr ON dr.DoctorCode = wu.IMECentricCode AND wu.UserType IN ('DR', 'OP')
          LEFT OUTER JOIN tblCCAddress AS atty ON atty.ccCode = wu.IMECentricCode AND wu.UserType = 'AT'
          LEFT OUTER JOIN tblTranscription AS tr ON tr.TransCode = wu.IMECentricCode AND wu.UserType = 'TR'
          LEFT OUTER JOIN tblDrAssistant AS drA ON drA.DrAssistantID = wu.IMECentricCode AND wu.UserType = 'DA'
WHERE wu.MFAEmailAddr IS NULL
GO 

