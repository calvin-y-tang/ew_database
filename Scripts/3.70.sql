

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
		S.Name AS Status, 
		Serv.Description, 
		ServType.EWServiceTypeID, 
		ServType.Name As ServiceTypDesc
    FROM
        tblDPSBundle AS B
			LEFT OUTER JOIN tblDPSStatus AS S ON S.DPSStatusID = B.DPSStatusID
			LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
			LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
			LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
			LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode	
			LEFT OUTER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
			LEFT OUTER JOIN tblServices AS Serv ON Serv.ServiceCode = C.ServiceCode
			LEFT OUTER JOIN tblEWServiceType AS ServType ON ServType.EWServiceTypeID = Serv.EWServiceTypeID
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
-- Issue 11606 - ESIS to require Employer field
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(130, 'CaseRequiredFields', 'Case', 'Define required fields on case form', 1, 1016, 0, 'FieldName1', 'FieldName2', 'FieldName3', 'FieldName4', 'FieldName5', 0)
GO



