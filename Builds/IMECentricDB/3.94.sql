

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
PRINT N'Altering [dbo].[tblCaseDetermination]...';


GO
ALTER TABLE [dbo].[tblCaseDetermination]
    ADD [DateSummarySent] DATETIME NULL;


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

PRINT N'Altering [dbo].[tblWorkstation]...';


GO
ALTER TABLE [dbo].[tblWorkstation]
    ADD [Param] [VARCHAR](200) NULL;

GO


-- Was deployed in last sprint
--PRINT N'Altering [dbo].[tblCaseRecRetrievalDocument]...';
--GO
--ALTER TABLE [dbo].[tblCaseRecRetrievalDocument]
--    ADD [WorkOrderLocation] VARCHAR (100) NULL;
--GO
--IF @@ERROR <> 0
--   AND @@TRANCOUNT > 0
--    BEGIN
--        ROLLBACK;
--    END
--IF @@TRANCOUNT = 0
--    BEGIN
--        INSERT  INTO #tmpErrors (Error)
--        VALUES                 (1);
--        BEGIN TRANSACTION;
--    END
--GO

PRINT N'Creating [dbo].[tblTask]...';


GO
CREATE TABLE [dbo].[tblTask] (
    [TaskID]        INT           IDENTITY (1, 1) NOT NULL,
    [DateAdded]     DATETIME      NOT NULL,
    [UserIDAdded]   VARCHAR (15)  NOT NULL,
    [DateCompleted] DATETIME      NULL,
    [StatusMessge]  VARCHAR (512) NULL,
    [ProcessName]   VARCHAR (50)  NOT NULL,
    [TableType]     VARCHAR (50)  NOT NULL,
    [TableKey]      INT           NOT NULL,
    [Date1]         DATETIME      NULL,
    [Date2]         DATETIME      NULL,
    [Int1]          DATETIME      NULL,
    [Int2]          DATETIME      NULL,
    CONSTRAINT [PK_tblTask] PRIMARY KEY CLUSTERED ([TaskID] ASC)
);


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
PRINT N'Creating [dbo].[tblTask].[IX_tblTask_DateCompletedProcessName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTask_DateCompletedProcessName]
    ON [dbo].[tblTask]([DateCompleted] ASC, [ProcessName] ASC);


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

/* Already exists.  Removing */
--PRINT N'Creating [dbo].[tblTaxAddress]...';


--GO
--CREATE TABLE [dbo].[tblTaxAddress] (
--    [TaxAddressID] INT          IDENTITY (1, 1) NOT NULL,
--    [TableType]    VARCHAR (2)  NULL,
--    [TableKey]     INT          NULL,
--    [TaxCode]      VARCHAR (20) NOT NULL,
--    [DateAdded]    DATETIME     NOT NULL,
--    [UserIDAdded]  VARCHAR (15) NOT NULL,
--    [DateEdited]   DATETIME     NULL,
--    [UserIDEdited] VARCHAR (15) NULL,
--    CONSTRAINT [PK_TblTaxAddress] PRIMARY KEY CLUSTERED ([TaxAddressID] ASC)
--);


--GO
--IF @@ERROR <> 0
--   AND @@TRANCOUNT > 0
--    BEGIN
--        ROLLBACK;
--    END

--IF @@TRANCOUNT = 0
--    BEGIN
--        INSERT  INTO #tmpErrors (Error)
--        VALUES                 (1);
--        BEGIN TRANSACTION;
--    END


--GO

PRINT N'Creating [dbo].[tblTaxAddress].[IX_tblTaxAddress_TableTypeKeyCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblTaxAddress_TableTypeKeyCode]
    ON [dbo].[tblTaxAddress]([TableType] ASC, [TableKey] ASC, [TaxCode] ASC);


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
PRINT N'Altering [dbo].[proc_GetExternalCommunication]...';


GO
ALTER PROCEDURE [dbo].[proc_GetExternalCommunication]
	@chID AS INTEGER,
	@parentCompanyID AS INTEGER
AS
	SELECT ch.EventDate,
		c.ChartNbr,
		ch.UserID,
		c.DoctorCode,
		c.DoctorSpecialty,
		c.ApptTime,
		c.DateCanceled,
		ch.[Type],
		ct.EWBusLineID,
		s.EWServiceTypeID,
		c.OfficeCode,
		c.DoctorLocation,
		c.claimnbr,
		f.EWFacilityID, 
		fgs.BusUnitGroupID,
		com.BulkBillingID
 FROM tblcasehistory AS ch 
 INNER JOIN tblcase AS c ON ch.casenbr = c.casenbr
 INNER JOIN tblcasetype AS ct ON c.casetype = ct.code
 INNER JOIN tblservices AS s ON c.servicecode = s.ServiceCode
 INNER JOIN tblcompany AS com ON c.companycode = com.companycode
 INNER JOIN tbloffice AS o ON c.OfficeCode = o.OfficeCode
 INNER JOIN tblEWFacility AS f ON o.EWFacilityID = f.EWFacilityID
 INNER JOIN tblEWFacilityGroupSummary AS fgs ON f.EWFacilityID = fgs.EWFacilityID
 WHERE (ch.ID = @chID)
   AND (com.ParentCompanyID = @parentCompanyID)
   AND (c.InputSourceID = 7)
   AND (s.EWServiceTypeID NOT IN (0))
   AND (ch.[Type] IN ('CANCEL', 'CANCELLED', 'FINALRPT', 'LATECANCEL', 'NEWCASE', 'NOSHOW', 'UNSCHEDULE', 'UNABLE', 'COMPLETE',
					'RPTSENTEMAIL', 'RPTSENTFAX', 'RPTSENTPRINT', 'RPTSENTWEB', 'SCHEDULED', 'SHOW', 'TRANSCRIPTION'))
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

-- Issue 12281 - AmTrust SLA Reminder Email for Appt
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (158, 'AutoSendSLAApptCreated', 'Case', 'Determine the Send Date for SLA Appt Not Set Email.', 1, 1001, 0, 'NbrHrsAddToOrigDate', 'ServiceCode', NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '700', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '3120', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '1200', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '15', NULL, NULL, NULL, NULL) 
GO 
