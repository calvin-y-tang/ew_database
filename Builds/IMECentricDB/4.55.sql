

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
PRINT N'Altering [dbo].[tblServiceWorkflow]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD [WcCaseTypeRqd] BIT CONSTRAINT [DF_tblServiceWorkflow_WcCaseTypeRqd] DEFAULT ((0)) NULL;


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
PRINT N'Altering [dbo].[vwServiceWorkflow]...';


GO
ALTER VIEW [dbo].[vwServiceWorkflow]
AS
    SELECT
        WF.ServiceWorkflowID,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.UserIDAdded,
        WF.DateAdded,
        WF.UserIDEdited,
        WF.DateEdited,
        WF.ExamineeAddrReqd,
        WF.ExamineeSSNReqd,
        WF.AttorneyReqd,
        WF.DOIRqd,
        WF.ClaimNbrRqd,
        WF.JurisdictionRqd,
        WF.EmployerRqd,
        WF.TreatingPhysicianRqd,
        WF.CalcFrom,
        WF.DaysToForecastDate,
        WF.DaysToInternalDueDate,
        WF.DaysToExternalDueDate,
		WF.DaysToDoctorRptDueDate,
		WF.InternalDueDateType,
		WF.ExternalDueDateType,
		WF.DoctorRptDueDateType,
		WF.ForecastDateType,
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus,
		WF.UsePeerBill,
		S.ProdCode, 
		CT.EWBusLineID, 
		S.EWServiceTypeID,
        WF.WcCaseTypeRqd
    FROM
        tblServiceWorkflow AS WF
    INNER JOIN tblCaseType AS CT ON WF.CaseType=CT.Code
    INNER JOIN tblServices AS S ON S.ServiceCode=WF.ServiceCode
    INNER JOIN tblOffice AS O ON O.OfficeCode=WF.OfficeCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowID,
                        COUNT(ServiceWorkflowQueueID) AS QueueCount
                     FROM
                        tblServiceWorkflowQueue
                     GROUP BY
                        ServiceWorkflowID
                    ) AS WFQ ON WFQ.ServiceWorkflowID=WF.ServiceWorkflowID
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
PRINT N'Altering [dbo].[vwRptDoctorSchedule]...';


GO
ALTER VIEW vwRptDoctorSchedule
AS
     SELECT CA.CaseApptID AS RecID,
            CA.DoctorCode ,            
			CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS Date,
			DATENAME(WEEKDAY, CAST(CAST(CA.ApptTime AS DATE) AS DATETIME))  AS DayOfWeekName,
            CA.ApptTime AS StartTime, 

            C.CaseNbr , 
			C.ExtCaseNbr , 
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions ,
            C.PhotoRqd ,
            C.PanelNbr ,
            C.DoctorName AS PanelDesc,
            C.OfficeCode AS CaseOfficeCode,

            CASE WHEN C.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter,

            EE.FirstName + ' ' + EE.LastName AS ScheduleDesc1,

			ISNULL(CT.ShortDesc, '') + ' / ' + ISNULL(S.Description, '') AS ScheduleDesc2,

            CO.ExtName AS Company ,

            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CL.Phone1 AS ClientPhone ,

			LO.OfficeCode as LocationOfficeCode,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS LocationPhone ,
            L.Fax AS LocationFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName,

			ISNULL((STUFF((
			SELECT CHAR(13) + CHAR(10) + CAST(P.Description AS VARCHAR)
			FROM tblProblem AS P
			INNER JOIN tblCaseProblem AS CP ON CP.ProblemCode = P.ProblemCode
			WHERE CP.CaseNbr=C.CaseNbr
			FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')),'') AS Problem

    FROM    tblCaseAppt AS CA

				INNER JOIN tblCase AS C ON CA.CaseApptID = C.CaseApptID
				INNER JOIN tblExaminee AS EE on C.ChartNbr = EE.ChartNbr
				INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
				INNER JOIN tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
				INNER JOIN tblCaseType AS CT on C.CaseType = CT.Code		
				INNER JOIN tblServices AS S on C.ServiceCode = S.ServiceCode 

				INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID

				LEFT JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = C.CaseApptID
                INNER JOIN tblDoctor AS DR ON DR.DoctorCode = IIF(CA.DoctorCode IS NULL OR CA.DoctorCode = 0, CAP.DoctorCode, CA.DoctorCode)
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

	WHERE CA.ApptStatusID IN (10,100,101,102)
	  AND C.Status <> 9
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

-- Sprint 130

-- IMEC-14063 - entries into tblConfiguration for EWIS External Document Intake process email additional actions - data driven
  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (25, 'RPA_PROG_UnknwnCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: File with Unknown Case Number Needs Correction";Body="Unknown Case Number for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (26, 'RPA_PROG_CopyFileErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: Failed to Copy Case Document";Body="Copy file error. File already exists or there was an I/O error. File has been moved to the Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (27, 'RPA_PROG_DefaultErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA Progressive Document Intake Process: Error with document";Body="File moved to Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (28, 'RPA_LibiCase_MultiCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Multiple Cases Exist for Internal case Number";Body="Found multiple cases with internal case number for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (29, 'RPA_LibiCase_UnknwnCaseNbrErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: File with Unknown Internal Case Number";Body="Could not find an active case for file: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (30, 'RPA_LibiCase_CopyFileErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Failed to Copy Case Document";Body="Copy file error. File already exists or there was an I/O error. File has been moved to the Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (31, 'RPA_LibiCase_DefaultErr', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="RPA LibertyiCase Document Intake Process: Error with document";Body="File moved to Exception folder: @filename@ <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (32, 'RPA_LibiCase_ReprocFirst', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The file has currently been reprocessed 0 times.<br />We will move the file back to the Inbox folder for reprocessing. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (33, 'RPA_LibiCase_ReprocMax', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The max number of retries has been reached. We will no longer attempt to process this file. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (34, 'RPA_LibiCase_ReprocContinued', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="We will move the file back to the Inbox folder for reprocessing. <br />"')

  INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
  VALUES (35, 'RPA_LibiCase_ReprocNum', 1, 'RPAEmails', GETDATE(), 'TLyde', 'Subject="";Body="The file has currently been reprocessed @attempts@ times with a max of @maxattempts@. <br />"')

GO

-- IMEC-14047 - Data Patch for new required service workflow variable WC Case Type - set default value to 0
  UPDATE tblServiceWorkflow SET WcCaseTypeRqd = 0
  GO
