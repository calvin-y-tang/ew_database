
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
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [LegalCourtVenue]       VARCHAR (70) NULL,
        [LegalCourtCounty]      VARCHAR (50) NULL,
        [LegalCity]             VARCHAR (50) NULL,
        [LegalInsuranceCompany] VARCHAR (70) NULL,
        [ExamStartTime]         DATETIME     NULL,
        [ExamEndTime]           DATETIME     NULL,
        [TimeReviewingRecords]  VARCHAR (20) NULL;


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
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [DateApptLetterSent] DATETIME NULL;


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
PRINT N'Creating [dbo].[tblCaseAppt].[IX_tblCaseAppt_CaseNbrApptTimeDoctorCodeLocationCodeDoctorBlockTimeSlotID]...';


GO
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_tblCaseAppt_CaseNbrApptTimeDoctorCodeLocationCodeDoctorBlockTimeSlotID')
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_CaseNbrApptTimeDoctorCodeLocationCodeDoctorBlockTimeSlotID]
    ON [dbo].[tblCaseAppt]([ApptStatusID] ASC)
    INCLUDE([CaseNbr], [ApptTime], [DoctorCode], [LocationCode], [DoctorBlockTimeSlotID]);


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
PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument]
    ADD [ContentType] VARCHAR (50) NULL;


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
PRINT N'Creating [dbo].[tblDoctorBlockTimeSlot].[IX_tblDoctorBlockTimeSlot_DoctorBlockTimeDayIDStartTime]...';


GO
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_tblDoctorBlockTimeSlot_DoctorBlockTimeDayIDStartTime')
CREATE NONCLUSTERED INDEX [IX_tblDoctorBlockTimeSlot_DoctorBlockTimeDayIDStartTime]
    ON [dbo].[tblDoctorBlockTimeSlot]([DoctorBlockTimeDayID] ASC, [StartTime] ASC);


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
PRINT N'Altering [dbo].[vwDrSchedGetNonBlockTimeAppt]...';


GO
ALTER VIEW [dbo].[vwDrSchedGetNonBlockTimeAppt]
	AS 
		SELECT 
			ca.CaseApptID,
			ca.CaseNbr,
			ca.ApptStatusID,
			ISNULL(cap.DoctorCode, ca.DoctorCode) as Doctorcode,
			ca.LocationCode, 
			ca.ApptTime,
			ca.Duration,
			-- IDs that are useful to have at hand
			c.CaseNbr AS ApptSlotCaseNbr,
			c.ChartNbr,
			cl.ClientCode,
			c.ServiceCode,
			c.CaseType,
			co.CompanyCode,
			-- details used in UI
			ex.LastName + ', ' + ex.FirstName AS ExamineeName,
			co.IntName AS CompanyName,
			ct.ShortDesc AS CaseTypeShortDesc,
			serv.ShortDesc AS ServiceShortDesc
		FROM
			tblCaseAppt AS ca
				LEFT OUTER JOIN tblCaseApptPanel AS CAP on cap.CaseApptID = ca.CaseApptID
				INNER JOIN tblCase AS c ON c.CaseNbr = ca.CaseNbr
				INNER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				INNER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				INNER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				INNER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				INNER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
		WHERE 
			ca.DoctorBlockTimeSlotID IS NULL
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

--spGetAllBusinessRules already exists
/*
PRINT N'Creating [dbo].[spGetAllBusinessRules]...';


GO
CREATE PROCEDURE dbo.spGetAllBusinessRules
(
	@eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT distinct * FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder
	FROM
	(
		SELECT 1 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
			LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
		WHERE 1=1
			AND (BRC.BillingEntity IN (0,2))
			AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

		UNION

		SELECT 2 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
			LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
		WHERE 1=1
			AND (BRC.BillingEntity IN (1,2))
			AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

		UNION

		SELECT 3 AS GroupID, BRC.*
		FROM tblBusinessRuleCondition AS BRC
		WHERE 1=1
			AND (BRC.EntityType='SW')
	) AS tmpBR
		INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
		LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
		LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
	WHERE BR.IsActive=1
		and BR.EventID=@eventID
		AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
		AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
		AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
		AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder
END
GO

*/


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
insert into tblCodes (Category, SubCategory, Value)
Values ('DocumentContentType', 'Referral Confirmation', 1), 
       ('DocumentContentType', 'Appointment Confirmation', 2), 
       ('DocumentContentType', 'Fee Quote Notice', 3), 
       ('DocumentContentType', 'Fee Approval Notice', 4), 
       ('DocumentContentType', 'Medical Records Request', 5), 
       ('DocumentContentType', 'IME Cite Letter', 6), 
       ('DocumentContentType', 'Appointment Delay', 7), 
       ('DocumentContentType', 'Physician Selection', 8), 
       ('DocumentContentType', 'Cover Letter Request', 9), 
       ('DocumentContentType', 'Reschedule Notice', 10), 
       ('DocumentContentType', 'Attendance Confirmation', 11), 
       ('DocumentContentType', 'No Show Notice', 12), 
       ('DocumentContentType', 'IME Report Cover Sheet', 13), 
       ('DocumentContentType', 'Invoice', 14), 
       ('DocumentContentType', 'Voucher', 15), 
       ('DocumentContentType', 'Invoice Status Inquiries', 16), 
       ('DocumentContentType', 'Cancellation Notice', 17)

GO
UPDATE tblBusinessRule
   SET Param4Desc = 'MatchOnContentType'
  FROM tblBusinessRule
 WHERE BusinessRuleID in (109,110,111)
GO


insert into tblSetting (Name, Value)
Values ('ApptLetterContentType', 'Appointment Confirmation')


Go
  
