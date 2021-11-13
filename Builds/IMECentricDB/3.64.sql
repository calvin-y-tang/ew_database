

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
PRINT N'Dropping [dbo].[DF_tblDoctorSearchResult_AvgMargin]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult] DROP CONSTRAINT [DF_tblDoctorSearchResult_AvgMargin];


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
PRINT N'Altering [dbo].[tblDrDoNotUse]...';


GO
ALTER TABLE [dbo].[tblDrDoNotUse]
    ADD [Reason] VARCHAR (100)  NULL,
        [Note]   VARCHAR (1000) NULL;


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
PRINT N'Creating [dbo].[tblElectronicMessage]...';


GO
CREATE TABLE [dbo].[tblElectronicMessage] (
    [MessageID]   INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]     INT           NULL,
    [SubjectLine] VARCHAR (120) NULL,
    [UserIDSent]  VARCHAR (15)  NULL,
    [DateSent]    DATETIME      NULL,
    [Document]    VARCHAR (15)  NULL,
    [To]          VARCHAR (200) NOT NULL,
    [CC]          VARCHAR (200) NOT NULL,
    [BCC]         VARCHAR (200) NOT NULL,
    [RecordType]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblElectronicMessage] PRIMARY KEY CLUSTERED ([MessageID] ASC)
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
PRINT N'Creating [dbo].[DF_tblDoctorSearchResult_AvgMargin]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD CONSTRAINT [DF_tblDoctorSearchResult_AvgMargin] DEFAULT ((100)) FOR [AvgMargin];


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
PRINT N'Altering [dbo].[vwDPSCases]...';


GO
ALTER VIEW dbo.vwDPSCases
AS
    SELECT 
        C.CaseNbr,
        C.ExtCaseNbr,
        B.DPSBundleID,
		B.CombinedDPSBundleID,
		CASE
			WHEN B.DPSBundleTypeID = 1 THEN 'Original'
			WHEN B.DPSBundleTypeID = 2 THEN 'Rework'
			WHEN B.DPSBundleTypeID = 3 THEN 'Review'
		ELSE
			'Unknown'
		END AS DPSBundleType,
        DATEDIFF(d, B.DateEdited, GETDATE()) AS IQ,
        E.FirstName+' '+E.LastName AS ExamineeName,
        Com.IntName AS CompanyName,
        D.FirstName+' '+D.LastName AS DoctorName,
        C.ApptTime,
        B.ContactName,
		B.DateCompleted,
        B.DPSStatusID,       
        B.DateAcknowledged,
        C.OfficeCode,
        C.ServiceCode,
        C.SchedulerCode,
        C.QARep,
        C.MarketerCode,
        Com.ParentCompanyID,
        C.DoctorLocation,
        D.DoctorCode,
        Com.CompanyCode,
        C.CaseType,
		C.Status AS CaseStatus,
		Q.StatusDesc,
        E.ChartNbr,
		S.Name AS Status
    FROM
        tblDPSBundle AS B
	LEFT OUTER JOIN tblDPSStatus AS S ON S.DPSStatusID = B.DPSStatusID
    LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
    LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
    LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
    LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
    LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode	
	LEFT OUTER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
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
delete from tblBusinessRule WHERE BusinessRuleID in (109,110,111)
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(109, 'ClientGenDocsToAddtlEmail', 'Case', 'When sending docs to client cc/bcc additional email addresses', 1, 1201, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
      (110, 'ClientDistDocsToAddtlEmail', 'Case', 'When distribute docs to client cc/bcc additional email addresses', 1, 1202, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
	  (111, 'ClientDistRptToAddtlEmail', 'Case', 'When distribute rpts to client cc/bcc additional email addresses', 1, 1320, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0), 
	  (108, 'MatchClaimNbrToEmployer1', 'Case', 'Ensure that selected Employer is Valid for Claim Nbr', 1, 1016, 0, 'ClaimNbrStartsWith', 'ClaimNbrEndsWith', 'AllowedEmployerID', NULL, 'OverrideToken', 0)
GO


insert into tblMessageToken (Name, Description)
values ('@ExamineeLastName@',''), ('@ExamineeFirstName@',''), ('@ExamineeMiddleInitial@','')
GO


-- Issue 11184 (Enhance EDI queue functionality to allow users to remove sent invoices) - adding security token
INSERT INTO tblUserFunction VALUES ('EDIManualAck', 'EDI - Manually Acknowledge Sent Invoices', '2020-01-14')
GO



--Remove certain old Do Not Use reasons if they exist
delete from tblCodes 
WHERE Category = 'DNU' and Value like 'Doctor Reason%';
GO


-- Insert the new Do Not Use reasons
insert into tblCodes (Category, SubCategory, Value) 
values
('DNU','Reason','Deceased')
,('DNU','Reason','Retired/No Longer Active Practice')
,('DNU','Reason','No Longer Performing IME''s/Peers')
,('DNU','Reason','Works Exclusively for Competitor')
,('DNU','Reason','Credentialing Reason (for Cause)')
,('DNU','Reason','Non-Compliant with Credentialing Requests')
,('DNU','Reason','Excessive Fees')
,('DNU','Reason','Difficulty Scheduling')
,('DNU','Reason','Delayed Dictation/Report Delivery')
,('DNU','Reason','Subpar Reports')
,('DNU','Reason','Duplicate Profile')
,('DNU','Reason','Error in Entering Profile')
,('DNU','Reason','Inactivity for Extended Period')
,('DNU','Reason','Only License Held Is Expired')
,('DNU','Reason','Other (provide narrative detail)')
,('DNU','Reason','Unknown (provide narrative detail)')
GO


