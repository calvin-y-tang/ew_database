

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
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [Suffix] VARCHAR (128) NULL;


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
PRINT N'Altering [dbo].[vwAcctingParam]...';


GO
ALTER VIEW vwAcctingParam
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.ServiceCode ,
            C.Notes ,
			C.ExtCaseNbr, 

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,

            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                     + ISNULL(ATDr.firstName, '')
            END AS DrOpName ,

            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ATDr.LastName + IIF(ISNULL(ATDr.Suffix, '') = '', '', ' (' + ATDr.Suffix + ')')  
                + ', ' + ISNULL(ATDr.FirstName, '')
            END AS DrOpNameSuffix ,

            COM.CompanyCode ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
			ATL.LocationCode AS DoctorLocation ,
            ATL.Location AS Location ,

			C.BillingNote ,
            COM.Notes AS CompanyNotes ,
            CL.Notes AS ClientNotes ,
            ATDr.Notes AS DoctorNotes ,
			ATDr.DrAcctingNote ,

            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
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
PRINT N'Altering [dbo].[vwDoctorSearchResultNew]...';


GO
ALTER VIEW [dbo].[vwDoctorSearchResultNew]
AS
SELECT DSR.PrimaryKey,
	   DSR.SessionID,
       DSR.DoctorCode,
       DSR.LocationCode,
       DSR.SchedCode,
       DSR.Selected,
       DSR.Proximity,
	   IIF(DSR.Proximity=9999, '?', CAST(FORMAT(DSR.Proximity, '#.0')  AS VARCHAR)) AS ProximityString,
       REPLACE(DSR.SpecialtyCodes, ', ', CHAR(13) + CHAR(10)) AS SpecialtyCodes,

       ISNULL(CONVERT(VARCHAR, BTD.ScheduleDate, 101), 'Call for Appt') AS FirstAvail,
       BTD.ScheduleDate AS Date,
       BTS.StartTime,

       DR.LastName + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       DR.LastName + IIF(ISNULL(DR.Suffix, '') = '', '', ' (' + DR.Suffix + ')')  + ', ' + ISNULL(DR.FirstName, '') AS DoctorNameSuffix,
       DR.Prepaid,
       DR.Status,
       DR.Credentials,
       DR.Notes,
       L.Location,
       L.City,
       L.State,
       L.Phone,
       L.County,
	   DSR.DisplayScore,
	   DSR.DoctorRank

FROM tblDoctorSearchResult AS DSR
	INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
    INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
    INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
	LEFT OUTER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeSlotID=DSR.SchedCode
	LEFT OUTER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorBlockTimeDayID=BTS.DoctorBlockTimeDayID
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
PRINT N'Creating [dbo].[vwCRNCaseDetailAssigned]...';


GO
CREATE VIEW vwCRNCaseDetailAssigned
AS 
SELECT  d.DoctorCode AS ReviewerID, 
		ca.CaseNbr AS CaseID, 
		MAX(ca.DateAdded) AS AssignedDate
FROM    dbo.tblCaseAppt AS ca WITH (nolock) LEFT OUTER JOIN
        dbo.tblCaseApptPanel AS cp WITH (nolock) ON cp.CaseApptID = ca.CaseApptID LEFT OUTER JOIN
		dbo.tblDoctor AS d WITH (nolock) ON d.DoctorCode = COALESCE (cp.DoctorCode, ca.DoctorCode)
WHERE     (d.EWParentDocID IS NOT NULL)
GROUP BY d.DoctorCode, ca.CaseNbr
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
-- Sprint 94

