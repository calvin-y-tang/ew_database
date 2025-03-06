

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
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase];


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
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase]([OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [CertMailNbr], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [CertMailNbr2], [ExtCaseNbr], [EmployerID], [EmployerAddressID], [RPAMedRecRequestDate], [RPAMedRecUploadAckDate], [RPAMedRecUploadStatus], [BillClientCode]);


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
PRINT N'Creating [dbo].[tblCustomerData].[IX_tblCustomerData_TypeKeyName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCustomerData_TypeKeyName]
    ON [dbo].[tblCustomerData]([TableType] ASC, [TableKey] ASC, [CustomerName] ASC);


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
PRINT N'Creating [dbo].[tblOCRDocument].[IX_tblOCRDocument_CaseDocID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblOCRDocument_CaseDocID]
    ON [dbo].[tblOCRDocument]([CaseDocID] ASC);


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
PRINT N'Altering [dbo].[vwRptProgressiveRptWebLog]...';


GO

ALTER VIEW [dbo].[vwRptProgressiveRptWebLog]
AS
SELECT 
C.CaseNbr,
CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
EE.firstName + ' ' + EE.lastName AS Examinee,
CDT.Description AS DocType,
CD.Description AS DocDescrip,
POW.DateAdded AS DateUploaded,
CL.FirstName + ' ' + CL.LastName AS Client,
CL.EmployeeNumber AS ClientEmployeeNumber,
CL1.FirstName + ' ' + CL1.LastName AS ClientViewer,
CL1.EmployeeNumber AS ClientViewerEmployeeNumber,
TCD.FirstViewedOnWebDate AS DateViewed,
DATEDIFF(DAY, POW.DateAdded, TCD.FirstViewedOnWebDate) AS Days, 
S.Description AS Service,
CT.Description AS ClaimType,
C.ApptDate,
C.DoctorSpecialty,
C.DoctorName,
C.DateOfInjury,

CL.CompanyCode,
dbo.fnDateValue(POW.DateAdded) AS FilterDate

FROM tblCaseDocuments AS CD
INNER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
INNER JOIN tblPublishOnWeb AS POW ON POW.TableType='tblCaseDocuments' AND POW.TableKey=CD.SeqNo
INNER JOIN tblCaseDocuments AS TCD ON POW.TableKey = TCD.SeqNo
INNER JOIN tblWebUser AS TWU ON TCD.FirstViewedOnWebBy = TWU.UserID
INNER JOIN tblClient AS CL ON POW.UserType='CL' AND POW.UserCode=CL.ClientCode
INNER JOIN tblClient AS CL1 ON TWU.UserType='CL' AND TWU.IMECentricCode = CL1.ClientCode
INNER JOIN tblCase AS C ON C.CaseNbr = CD.CaseNbr
INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
WHERE CD.CaseDocTypeID=5 OR (CD.Description LIKE '%Woodbury~_Closed~_Letter%' ESCAPE '~')
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

-- Sprint 133

-- IMEC-14048 - add timeout to allow time for Helper to resize the image, save the file, and write to tblTempData
INSERT INTO tblSetting ([Name], [Value]) VALUES ('TimeOutResizeImage', '9000')

-- IMEC-14144 - add new bizRule condition for sending new case acknowledgements for Chubb Insurance
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES (116, 'PC', 16, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'NewCase;', 'EntityType=PC;EntityID=16', NULL, NULL, NULL, 0, NULL, 0)
GO

-- Add new security token for Doctor signature
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorAddEditSignatures', 'Doctor -Add/Edit Signatures', GETDATE())
GO

