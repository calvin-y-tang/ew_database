
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
PRINT N'Altering [dbo].[tblAcctQuote]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD [InNetwork] BIT CONSTRAINT [DF_tblAcctQuote_InNetwork] DEFAULT ((0)) NULL;


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
PRINT N'Altering [dbo].[tblQuoteRule]...';


GO
ALTER TABLE [dbo].[tblQuoteRule]
    ADD [EWSelected] BIT CONSTRAINT [DF_tblQuoteRule_EWSelected] DEFAULT ((0)) NULL,
        [InNetwork]  BIT CONSTRAINT [DF_tblQuoteRule_InNetwork] DEFAULT ((0)) NULL;


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
   AND (ch.[Type] IN ('CANCEL', 'CANCELLED', 'FINALRPT', 'LATECANCEL', 'NEWCASE', 'NOSHOW', 'UNSCHEDULE',
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

--Removed the last inserts because they existed in 3.86