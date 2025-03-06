

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
PRINT N'Altering [dbo].[tblAcctHeader]...';


GO
ALTER TABLE [dbo].[tblAcctHeader]
    ADD [TaxOfficeCode] INT NULL;


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
PRINT N'Altering [dbo].[tblAcctQuote]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD [DateClientCommResent] DATETIME NULL;


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


PRINT N'Altering [dbo].[tblCase]...';


GO

-- This table is temporarily altered to aaccount for three columns that already exist.
ALTER TABLE [dbo].[tblCase]
    ADD [RetrieveMedRecords]              BIT           CONSTRAINT [DF_tblCase_RetrieveMedRecords] DEFAULT ((0)) NULL,
        [RetrieveFilms]                   BIT           CONSTRAINT [DF_tblCase_RetrieveFilms] DEFAULT ((0)) NULL,
        [RetrieveStudies]                 VARCHAR (200) NULL,
        [AcctQuoteIDQuoteTATCalc]         INT           NULL,
        [AcctQuoteIDApprovalTATCalc]      INT           NULL,
        [TATExamSchedToQuoteSent]         INT           NULL,
        [TATExamSchedToApprovalSent]      INT           NULL,
        [TATApprovalSentToResentApproval] INT           NULL,
        [InvFeeQuoteTotalAmt]             MONEY         NULL,
        [InvFeeApprovalTotalAmt]          MONEY         NULL;


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
    ADD [BulkBillingID] INT NULL;


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
PRINT N'Creating [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_BulkBilling_CommSent]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_BulkBilling_CommSent]
    ON [dbo].[tblExternalCommunications]([BulkBillingID] ASC, [CommunicationSent] ASC);


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
PRINT N'Creating [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_CaseNbr_CHID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_CaseNbr_CHID]
    ON [dbo].[tblExternalCommunications]([CaseNbr] ASC, [CaseHistoryID] ASC);


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
   AND (ch.[Type] IN ('CANCEL', 'CANCELLED', 'FINALRPT', 'LATECANCEL', 'NEWCASE', 'NOSHOW', 
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
DELETE FROM tblSLAAction

SET IDENTITY_INSERT [dbo].[tblSLAAction] ON
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (1, 'Contacted Client', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (2, 'Contacted Doctor', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (3, 'Contacted Examinee', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (4, 'Resolve SLA', 0, 1)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (5, 'Other', 1, 0)
SET IDENTITY_INSERT [dbo].[tblSLAAction] OFF
GO

-- Issue 11897 - new SLA Metrics
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)
VALUES (216, 'tblCase', 'TATExamSchedToQuoteSent', null),
       (217, 'tblCase', 'TATExamSchedToApprovalSent', null),
       (218, 'tblCase', 'TATApprovalSentToResentApproval', null),
       (219, 'FeeQuote', 'DateClientInformed', 'Fee Quote Sent'), 
       (220, 'FeeApproval', 'DateClientInformed', 'Fee Approval Sent'),
       (221, 'FeeApproval', 'DateClientCommResent', 'Resent Fee Approval')
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
VALUES(21, 207, 219, 'Day', 216, 0),
      (22, 207, 220, 'Day', 217, 0), 
      (23, 220, 221, 'Day', 218, 0)
GO


-- New items

INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1060, 'Fee Quote/Approval Saved', 'Case')
GO

INSERT INTO tblTATCalculationMethodEvent (TATCalculationMethodID, EventID)
VALUES (21,1060), 
	   (22,1060), 
	   (23,1060)
GO

-- Final new area missed
INSERT INTO dbo.tblUserFunction
(FunctionCode, FunctionDesc, DateAdded)
VALUES
('SetTaxOffice', 'Accounting - Set Tax Office', GETDATE())

