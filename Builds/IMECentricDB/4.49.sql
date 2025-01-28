

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
    ADD [InvTaxCalcMethod] INT CONSTRAINT [DF_tblAcctHeader_InvTaxCalcMethod] DEFAULT (0) NULL;


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
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl] ALTER COLUMN [XMediusFaxPrefix] VARCHAR (32) NULL;


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
PRINT N'Altering [dbo].[vwCaseAppt]...';


GO
ALTER VIEW vwCaseAppt
AS
WITH allDoctors AS (
          SELECT  
               CA.CaseApptID ,
               ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
               CASE WHEN CA.DoctorCode IS NULL THEN
               LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
               ELSE
               LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
               END AS DoctorName,
               CASE WHEN CA.DoctorCode IS NULL THEN
               ISNULL(DP.LastName,'')+ISNULL(', '+DP.FirstName,'')
               ELSE
               ISNULL(D.LastName,'')+ISNULL(', '+D.FirstName,'')
               END AS DoctorNameLF,
               ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
           FROM tblCaseAppt AS CA
           LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
        CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CB.ExtName AS CanceledByExtName ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,

        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        
        (SELECT STRING_AGG(DoctorCode, '\')  FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID) AS DoctorCodes,
        (SELECT STRING_AGG(DoctorName, '\') FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID) AS DoctorNames,
        (SELECT STRING_AGG(DoctorNameLF, '\') FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID) AS DoctorNamesLF,
        (SELECT STRING_AGG(SpecialtyCode, '\') FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID) AS Specialties,

        CA.DateReceived, 
        FZ.Name AS FeeZoneName,
        C.OfficeCode,
        CA.AwaitingScheduling

     FROM tblCaseAppt AS CA
	        INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
            INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
            LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
            LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
            LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID
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
-- Sprint 123


-- IMEC-13930 - O365 Changes for Xmedius Faxing feature.
INSERT INTO tblSetting(Name, Value)
VALUES('FaxSysFormat', 'Default'),
      ('FaxPhonePrefix','91')
GO


-- IMEC-13942 - set default values for column [InvTaxCalcMethod] in tblAcctHeader
UPDATE tblAcctHeader SET InvTaxCalcMethod = 0
GO


