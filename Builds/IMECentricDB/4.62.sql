
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
PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [QADateTransmitted] DATETIME NULL;


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
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [CaseDocFolderID] INT NULL,
        [AcctDocFolderID] INT NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


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
PRINT N'Altering [dbo].[tblProblem]...';


GO
ALTER TABLE [dbo].[tblProblem]
    ADD [Description_Encrypted] VARBINARY (MAX) NULL;


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
PRINT N'Altering [dbo].[tblExaminee_AfterUpdate_TRG]...';


GO
CREATE OR ALTER TRIGGER [dbo].[tblExaminee_AfterUpdate_TRG]
   ON  [dbo].[tblExaminee]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE E
        SET E.SSN_Encrypted = IIF(I.SSN = D.SSN,
                                  E.SSN_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.SSN)),
            E.DOB_Encrypted = IIF(I.DOB = D.DOB, 
                                  E.DOB_Encrypted, 
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, I.DOB, 20)))
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
        WHERE I.SSN <> D.SSN OR I.SSN IS NULL OR D.SSN IS NULL
           OR I.DOB <> D.DOB OR I.DOB IS NULL OR D.DOB IS NULL
     
     UPDATE E
        SET E.SSN = NULL, 
            E.DOB = NULL
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END
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
PRINT N'Creating [dbo].[tblProblem_AfterInsert_TRG]...';


GO
CREATE OR ALTER TRIGGER [dbo].[tblProblem_AfterInsert_TRG]
   ON  [dbo].[tblProblem]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE P
        SET P.Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description)
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode;

END
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
PRINT N'Creating [dbo].[tblProblem_AfterUpdate_TRG]...';


GO
CREATE OR ALTER TRIGGER [dbo].[tblProblem_AfterUpdate_TRG]
   ON  [dbo].[tblProblem]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE P
        SET P.Description_Encrypted = IIF(I.Description = D.Description,
                                  P.Description_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description))
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode
        WHERE I.Description <> D.Description 
           OR I.Description IS NULL 
           OR D.Description IS NULL;

     UPDATE P
        SET P.Description = NULL
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode;
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END
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
PRINT N'Creating [dbo].[vwCaseApptNoLock]...';


GO
CREATE OR ALTER VIEW [dbo].[vwCaseApptNoLock]
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
           FROM tblCaseAppt AS CA with (nolock)
           LEFT OUTER JOIN tblDoctor AS D with (nolock) ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP with (nolock) ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP with (nolock) ON CAP.DoctorCode=DP.DoctorCode
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

         FROM tblCaseAppt AS CA with (nolock) 
	            INNER JOIN tblCase AS C with (nolock) ON C.CaseNbr = CA.CaseNbr
                INNER JOIN tblApptStatus AS S with (nolock) ON CA.ApptStatusID = S.ApptStatusID
                LEFT OUTER JOIN tblCanceledBy AS CB with (nolock) ON CA.CanceledByID=CB.CanceledByID
                LEFT OUTER JOIN tblLocation AS L with (nolock) ON CA.LocationCode=L.LocationCode
                LEFT OUTER JOIN tblEWFeeZone AS FZ with (nolock) ON CA.EWFeeZoneID = FZ.EWFeeZoneID
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
exec sp_refreshview 'vwCaseApptNoLock'


GO
PRINT N'Creating [dbo].[vwtblExamineeNoLock]...';


GO
CREATE OR ALTER VIEW [dbo].[vwtblExamineeNoLock]
AS 
		SELECT 
		ChartNbr                     	,
		OldChartNbr                  	,
		LastName                     	,
		FirstName                    	,
		MiddleInitial                	,
		Addr1                        	,
		Addr2                        	,
		City                         	,
		State                        	,
		Zip                          	,
		Phone1                       	,
		Phone2                       	,
		ISNULL(CONVERT(VARCHAR(15), DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, SSN_Encrypted)), 
		       SSN) AS SSN              ,
		Sex                          	,
		ISNULL(CONVERT(DATETIME, (CONVERT(VARCHAR, DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, DOB_Encrypted)))),
		       DOB) AS DOB              ,
		DateAdded                    	,
		DateEdited                   	,
		UserIDAdded                  	,
		UserIDEdited                 	,
		Note                         	,
		County                       	,
		Prefix                       	,
		USDVarchar1                  	,
		USDVarchar2                  	,
		USDDate1                     	,
		USDDate2                     	,
		USDText1                     	,
		USDText2                     	,
		USDInt1                      	,
		USDInt2                      	,
		USDMoney1                    	,
		USDMoney2                    	,
		Fax                          	,
		Email,
		Insured                      	,
		Employer                     	,
		TreatingPhysician            	,
		InsuredAddr1                 	,
		InsuredCity                  	,
		InsuredState                 	,
		InsuredZip                   	,
		InsuredSex                   	,
		InsuredRelationship          	,
		InsuredPhone                 	,
		InsuredPhoneExt              	,
		InsuredFax                   	,
		InsuredEmail                 	,
		ExamineeStatus               	,
		TreatingPhysicianAddr1       	,
		TreatingPhysicianCity        	,
		TreatingPhysicianState       	,
		TreatingPhysicianZip         	,
		TreatingPhysicianPhone       	,
		TreatingPhysicianPhoneExt    	,
		TreatingPhysicianFax         	,
		TreatingPhysicianEmail       	,
		EmployerAddr1                	,
		EmployerCity                 	,
		EmployerState                	,
		EmployerZip                  	,
		EmployerPhone                	,
		EmployerPhoneExt             	,
		EmployerFax                  	,
		EmployerEmail                	,
		Country                      	,
		PolicyNumber                 	,
		EmployerContactFirstName     	,
		EmployerContactLastName      	,
		TreatingPhysicianLicenseNbr  	,
		TreatingPhysicianTaxID       	,
		TreatingPhysicianCredentials 	,
		TreatingPhysicianDiagnosis   	,
		MobilePhone	                    ,
		TreatingPhysicianNPINbr       	,
		WorkPhone	
	FROM tblExaminee with (nolock)
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
exec sp_refreshview 'vwtblExamineeNoLock'

GO
PRINT N'Creating [dbo].[vwtblProblem]...';


GO
CREATE OR ALTER VIEW [dbo].[vwtblProblem]
	AS 
	SELECT 
        ProblemCode,
		CONVERT(VARCHAR(50), DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, Description_Encrypted)) AS Description,
		Status,
		DateAdded,
		UserIDAdded,
		DateEdited,
		UserIDEdited,
		PublishOnWeb,
		WebSynchDate,
		WebID
	 FROM tblProblem
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
exec sp_refreshview 'vwtblProblem'


GO
PRINT N'Altering [dbo].[vw_WebCoverLetterInfo]...';


GO
ALTER VIEW vw_WebCoverLetterInfo

AS

SELECT
	--case
	tblCase.casenbr AS Casenbr,
	tblCase.chartnbr AS Chartnbr,
	tblCase.doctorlocation AS Doctorlocation,
	tblCase.clientcode AS clientcode,
	tblCase.Appttime AS Appttime,
	tblCase.dateofinjury AS DOI,
	tblCase.dateofinjury AS DOI2,
	tblCase.dateofinjury2 AS DOISecond,
	tblCase.dateofinjury3 AS DOIThird,
	tblCase.dateofinjury4 AS DOIFourth,
	tblCase.notes AS Casenotes,
	tblCase.DoctorName AS doctorformalname,
	tblCase.ClaimNbrExt AS ClaimNbrExt,
	tblCase.Jurisdiction AS Jurisdiction,
	tblCase.ApptDate AS Apptdate,
	tblCase.claimnbr AS claimnbr,
	tblCase.doctorspecialty AS Specialtydesc,

	--examinee
	tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblExaminee.addr1 AS examineeaddr1,
	tblExaminee.addr2 AS examineeaddr2,
	tblExaminee.city AS ExamineeCity,
	tblExaminee.state AS ExamineeState,
	tblExaminee.zip AS ExamineeZip,
	tblExaminee.phone1 AS examineephone,
	tblExaminee.SSN AS ExamineeSSN,
	tblExaminee.sex AS ExamineeSex,
	tblExaminee.DOB AS ExamineeDOB,
	tblExaminee.insured AS insured,

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.Employer  
		ELSE tblEmployer.Name  
		END) AS Employer,  

	tblExaminee.treatingphysician AS TreatingPhysician,

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerAddr1  
		ELSE tblEmployerAddress.Address1 
		END) AS EmployerAddr1,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerCity  
		ELSE tblEmployerAddress.City  
		END) AS EmployerCity,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerState  
		ELSE tblEmployerAddress.State  
		END) AS EmployerState,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerZip  
		ELSE tblEmployerAddress.Zip  
		END) AS EmployerZip,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerPhone  
		ELSE tblEmployerAddress.Phone  
		END) AS EmployerPhone,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerFax  
		ELSE tblEmployerAddress.Fax  
		END) AS EmployerFax,  
            
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerEmail  
		ELSE tblEmployerAddress.Email  
		END) AS EmployerEmail,  

	--case type
	tblCaseType.description AS Casetype,

	--service
	tblServices.description AS servicedesc,

	--client
	tblClient.firstname + ' ' + tblClient.lastname AS clientname,
	tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
	tblClient.phone1 AS clientphone,
	tblClient.fax AS Clientfax,

	--company
	tblCompany.intname company,

	--defense attorney
	cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
	cc1.company AS dattorneycompany,
	cc1.address1 AS dattorneyaddr1,
	cc1.address2 AS dattorneyaddr2,
	cc1.phone AS dattorneyphone,
	cc1.fax AS dattorneyfax,
	cc1.email AS dattorneyemail,

	--plaintiff attorney
	cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
	cc2.company AS pattorneycompany,
	cc2.address1 AS pattorneyaddr1,
	cc2.address2 AS pattorneyaddr2,
	cc2.phone AS pattorneyphone,
	cc2.fax AS pattorneyfax,
	cc2.email AS pattorneyemail,

	--doctor
	'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation,

	--problems
	tblProblem.description AS Problems

FROM  tblCase
	INNER JOIN vwtblExaminee AS tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER JOIN	tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN	tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN	tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN	tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN	tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
	LEFT OUTER JOIN	tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
	LEFT OUTER JOIN	tblCaseProblem ON tblCase.casenbr = tblCaseProblem.casenbr
	LEFT OUTER JOIN	vwtblProblem AS tblProblem ON tblCaseProblem.problemcode = tblProblem.problemcode
    LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
    LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID
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
PRINT N'Altering [dbo].[vwCaseProblem]...';


GO
ALTER VIEW vwCaseProblem
AS
	SELECT 
		tblCaseProblem.CaseNbr, 
		tblCaseProblem.ProblemCode, 
		tblProblem.Description, 
		ISNULL(tblProblemArea.Description, '') AS AreaDesc
	FROM tblCaseProblem 
		INNER JOIN vwtblProblem AS tblProblem ON tblCaseProblem.ProblemCode = tblProblem.ProblemCode 
		LEFT OUTER JOIN tblProblemArea ON tblCaseProblem.ProblemAreaCode = tblProblemArea.ProblemAreaCode
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
			FROM vwtblProblem AS P
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
PRINT N'Creating [dbo].[vwDocumentNoLock]...';


GO
CREATE OR ALTER VIEW [dbo].[vwDocumentNoLock]
AS 
	    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,
			tblCase.AddlClaimNbrs, 

            tblApptStatus.Name AS ApptStatus ,

            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,

            tblCase.DoctorCode ,
            tblCase.DoctorLocation ,

			tblcase.EmployerID ,
			tblcase.EmployerAddressID ,

            tblExaminee.City AS ExamineeCity ,
            UPPER(tblExaminee.State) AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + UPPER(tblExaminee.State) + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
			tblExaminee.WorkPhone AS ExamineeWorkPhone,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblExaminee.county AS Examineecounty ,
            tblExaminee.Prefix AS ExamineePrefix ,

            tblExaminee.USDvarchar1 AS ExamineeUSDvarchar1 ,
            tblExaminee.USDvarchar2 AS ExamineeUSDvarchar2 ,
            tblExaminee.USDDate1 AS ExamineeUSDDate1 ,
            tblExaminee.USDDate2 AS ExamineeUSDDate2 ,
            tblExaminee.USDtext1 AS ExamineeUSDtext1 ,
            tblExaminee.USDtext2 AS ExamineeUSDtext2 ,
            tblExaminee.USDint1 AS ExamineeUSDint1 ,
            tblExaminee.USDint2 AS ExamineeUSDint2 ,
            tblExaminee.USDmoney1 AS ExamineeUSDmoney1 ,
            tblExaminee.USDmoney2 AS ExamineeUSDmoney2 ,

            tblExaminee.note AS ChartNotes ,
            tblExaminee.Fax AS ExamineeFax ,
            tblExaminee.Email AS ExamineeEmail ,
            tblExaminee.insured AS Examineeinsured ,
            tblExaminee.middleinitial AS Examineemiddleinitial ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            UPPER(tblExaminee.InsuredState) AS InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,

            tblExaminee.TreatingPhysician ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            UPPER(tblExaminee.TreatingPhysicianState) AS TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,
			tblExaminee.TreatingPhysicianNPINbr,

            tblEmployer.EWParentEmployerID, 
			(Case ISNULL(tblcase.EmployerID, 0)
              WHEN 0
              THEN tblExaminee.Employer  
			  ELSE tblEmployer.Name  
			  END) AS Employer,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerAddr1  
			  ELSE tblEmployerAddress.Address1 
			  END) AS EmployerAddr1,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN NULL 
			  ELSE tblEmployerAddress.Address2 
			  END) AS EmployerAddr2,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerCity  
			  ELSE tblEmployerAddress.City  
			  END) AS EmployerCity,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN UPPER(tblExaminee.EmployerState)  
			  ELSE UPPER(tblEmployerAddress.State)  
			  END) AS EmployerState,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerZip  
			  ELSE tblEmployerAddress.Zip  
			  END) AS EmployerZip,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerPhone  
			  ELSE tblEmployerAddress.Phone  
			  END) AS EmployerPhone,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerPhoneExt  
			  ELSE tblEmployerAddress.PhoneExt  
			  END) AS EmployerPhoneExt,  

			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerFax  
			  ELSE tblEmployerAddress.Fax  
			  END) AS EmployerFax,  
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerEmail  
			  ELSE tblEmployerAddress.Email  
			  END) AS EmployerEmail,  
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactLastName  
			  ELSE tblEmployerAddress.ContactLast  
			  END) AS EmployerContactLastName,  
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactFirstName  
			  ELSE tblEmployerAddress.ContactFirst  
			  END) AS EmployerContactFirstName,  

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + UPPER(tblClient.State) + '  ' + tblClient.Zip AS ClientCityStateZip ,
            tblClient.Fax AS ClientFax ,
            tblClient.Email AS ClientEmail ,
            'Dear ' + tblClient.firstName + ' ' + tblClient.lastName AS ClientSalutation ,
            tblClient.title AS Clienttitle ,
            tblClient.Prefix AS ClientPrefix ,
            tblClient.suffix AS Clientsuffix ,
            tblClient.USDvarchar1 AS ClientUSDvarchar1 ,
            tblClient.USDvarchar2 AS ClientUSDvarchar2 ,
            tblClient.USDDate1 AS ClientUSDDate1 ,
            tblClient.USDDate2 AS ClientUSDDate2 ,
            tblClient.USDtext1 AS ClientUSDtext1 ,
            tblClient.USDtext2 AS ClientUSDtext2 ,
            tblClient.USDint1 AS ClientUSDint1 ,
            tblClient.USDint2 AS ClientUSDint2 ,
            tblClient.USDmoney1 AS ClientUSDmoney1 ,
            tblClient.USDmoney2 AS ClientUSDmoney2 ,
            tblClient.CompanyCode ,
            tblClient.Notes AS ClientNotes ,
            tblClient.BillAddr1 ,
            tblClient.BillAddr2 ,
            tblClient.BillCity ,
            UPPER(tblClient.BillState) AS BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            UPPER(tblClient.State) AS ClientState ,
            tblClient.City AS ClientCity ,
            tblClient.Zip AS ClientZip ,

            tblCompany.extName AS Company ,
            tblCompany.USDvarchar1 AS CompanyUSDvarchar1 ,
            tblCompany.USDvarchar2 AS CompanyUSDvarchar2 ,
            tblCompany.USDDate1 AS CompanyUSDDate1 ,
            tblCompany.USDDate2 AS CompanyUSDDate2 ,
            tblCompany.USDtext1 AS CompanyUSDtext1 ,
            tblCompany.USDtext2 AS CompanyUSDtext2 ,
            tblCompany.USDint1 AS CompanyUSDint1 ,
            tblCompany.USDint2 AS CompanyUSDint2 ,
            tblCompany.USDmoney1 AS CompanyUSDmoney1 ,
            tblCompany.USDmoney2 AS CompanyUSDmoney2 ,
            tblCompany.Notes AS CompanyNotes ,

            tblCase.QARep ,
            tblCase.Doctorspecialty ,
            tblCase.BillClientCode AS CaseBillClientCode ,
            tblCase.officeCode ,
            tblCase.PanelNbr ,

            ISNULL(tblUser.lastName, '')
            + Case WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstName, '') AS scheduler ,

            tblCase.marketerCode AS Marketer ,
            tblCase.Dateadded AS DateCalledIn ,
            tblCase.Dateofinjury AS DOI ,
            tblCase.Allegation ,
            tblCase.Notes ,
            tblCase.CaseType ,
            'Dear ' + tblExaminee.firstName + ' ' + tblExaminee.lastName AS Examineesalutation ,
            tblCase.status ,
            tblCase.calledInBy ,
            tblCase.chartnbr ,
            tblCase.reportverbal ,
            tblCase.Datemedsrecd AS medsrecd ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffAttorneyCode ,
            tblCase.defenseAttorneyCode ,
            tblCase.serviceCode ,
            tblCase.FaxPattny ,
            tblCase.FaxDoctor ,
            tblCase.FaxClient ,
            tblCase.EmailClient ,
            tblCase.EmailDoctor ,
            tblCase.EmailPattny ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.commitDate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblCase.scheduleNotes ,
            tblCase.requesteddoc ,

            tblCase.USDvarchar1 AS CaseUSDvarchar1 ,
            tblCase.USDvarchar2 AS CaseUSDvarchar2 ,
            tblCase.USDDate1 AS CaseUSDDate1 ,
            tblCase.USDDate2 AS CaseUSDDate2 ,
            tblCase.USDtext1 AS CaseUSDtext1 ,
            tblCase.USDtext2 AS CaseUSDtext2 ,
            tblCase.USDint1 AS CaseUSDint1 ,
            tblCase.USDint2 AS CaseUSDint2 ,
            tblCase.USDmoney1 AS CaseUSDmoney1 ,
            tblCase.USDmoney2 AS CaseUSDmoney2 ,
            tblCase.USDDate3 AS CaseUSDDate3 ,
            tblCase.USDDate4 AS CaseUSDDate4 ,
            tblCase.USDDate5 AS CaseUSDDate5 ,
            tblCase.USDBit1 AS CaseUSDboolean1 ,
            tblCase.USDBit2 AS CaseUSDboolean2 ,

            tblCase.sinternalCasenbr AS internalCasenbr ,
            tblDoctor.credentials AS Doctordegree ,
            tblCase.ClientCode ,
            tblCase.feeCode ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
            tblCase.CertMailNbr2 ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.masterCasenbr ,
            tblCase.prevappt ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblCase.DateReceived ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCase.AttorneyNote ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblCase.ForecastDate ,
			tblCase.DoctorRptDueDate , 
			tblCase.DoctorReason ,
            tblCase.DefParaLegal ,

            tblCase.MasterSubCase ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.PublishOnWeb ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.TransCode ,
            tblCase.RptFinalizedDate ,

			tblCase.ICDCodeA ,
			tblCase.ICDCodeB ,
			tblCase.ICDCodeC ,
			tblCase.ICDCodeD ,
			tblCase.ICDCodeE ,
			tblCase.ICDCodeF ,
			tblCase.ICDCodeG ,
			tblCase.ICDCodeH ,
			tblCase.ICDCodeI ,
			tblCase.ICDCodeJ ,
			tblCase.ICDCodeK ,
			tblCase.ICDCodeL ,

            'Dear ' + tblDoctor.firstName + ' ' + tblDoctor.lastName + ', ' + ISNULL(tblDoctor.credentials, '') AS DoctorSalutation ,
            tblDoctor.Notes AS DoctorNotes ,
            tblDoctor.Prefix AS DoctorPrefix ,
            tblDoctor.Addr1 AS DoctorcorrespAddr1 ,
            tblDoctor.Addr2 AS DoctorcorrespAddr2 ,
            tblDoctor.City + ', ' + UPPER(tblDoctor.State) + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
            tblDoctor.Phone + ' ' + ISNULL(tblDoctor.PhoneExt, ' ') AS DoctorcorrespPhone ,
            tblDoctor.FaxNbr AS DoctorcorrespFax ,
            tblDoctor.EmailAddr AS DoctorcorrespEmail ,
            tblDoctor.Qualifications ,
            tblDoctor.Prepaid ,
            tblDoctor.county AS DoctorCorrespCounty ,

            tblDoctor.USDvarchar1 AS DoctorUSDvarchar1 ,
            tblDoctor.USDvarchar2 AS DoctorUSDvarchar2 ,
            tblDoctor.USDvarchar3 AS DoctorUSDvarchar3 ,
            tblDoctor.USDDate1 AS DoctorUSDDate1 ,
            tblDoctor.USDDate2 AS DoctorUSDDate2 ,
            tblDoctor.USDDate3 AS DoctorUSDDate3 ,
            tblDoctor.USDDate4 AS DoctorUSDDate4 ,
            tblDoctor.USDDate5 AS DoctorUSDDate5 ,
            tblDoctor.USDDate6 AS DoctorUSDDate6 ,
            tblDoctor.USDDate7 AS DoctorUSDDate7 ,
            tblDoctor.USDtext1 AS DoctorUSDtext1 ,
            tblDoctor.USDtext2 AS DoctorUSDtext2 ,
            tblDoctor.USDint1 AS DoctorUSDint1 ,
            tblDoctor.USDint2 AS DoctorUSDint2 ,
            tblDoctor.USDmoney1 AS DoctorUSDmoney1 ,
            tblDoctor.USDmoney2 AS DoctorUSDmoney2 ,
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,
			tblDoctor.ExpectedVisitDuration As ExpectedVisitDuration,

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            UPPER(tblDoctor.remitState) AS remitState ,
            tblDoctor.remitZip ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feeCode AS drfeeCode ,
            tblDoctor.licensenbr AS Doctorlicense ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblDoctor.lastName AS DoctorlastName ,
            tblDoctor.firstName AS DoctorfirstName ,
            tblDoctor.middleinitial AS Doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstName, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastName, 1), '') AS Doctorinitials ,
            UPPER(tblDoctor.State) AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
			tblLocation.AddressInstructions,
            tblLocation.City + ', ' + UPPER(tblLocation.State) + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.insidedr ,
            tblLocation.Email AS DoctorEmail ,
            tblLocation.Fax AS DoctorFax ,
            tblLocation.Faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblLocation.county AS Doctorcounty ,
            tblLocation.vicinity AS Doctorvicinity ,
            tblLocation.contactPrefix AS DoctorLocationcontactPrefix ,
            tblLocation.contactfirst AS DoctorLocationcontactfirstName ,
            tblLocation.contactlast AS DoctorLocationcontactlastName ,
            tblLocation.Notes AS DoctorLocationNotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontactsalutation ,
            UPPER(tblLocation.State) AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            UPPER(tblLocation.State) AS State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + UPPER(tblCCAddress_2.State) + '  ' + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            UPPER(tblCCAddress_2.State) AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + UPPER(tblCCAddress_1.State) + '  ' + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            UPPER(tblCCAddress_1.State) AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + UPPER(tblCCAddress_3.State) + '  ' + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,


            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
			tblCaseType.ExternalDesc AS CaseTypeDesc ,
            --tblCaseType.description AS CaseTypeDesc ,  -- Issue 5985 - stop usign description and use ExternalDesc

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblCaseAppt.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,
			tblOffice.NYWCCompanyName ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany,                          
			
			tblCase.DateOfInjury2 AS DOI2, 
			tblCase.DateOfInjury3 AS DOI3, 
			tblCase.DateOfInjury4 AS DOI4,
			tblCase.InsuringCompany as InsuringCompany,
			tblCase.CaseCaption, 
			tblCase.LitigationNotes, 
			tblCase.BillClientCode,
            tblCase.WorkCompCaseType, 
			tblEWParentCompany.Name AS ParentCompanyName

    FROM    tblCase with (nolock)
            INNER JOIN vwtblExamineeNoLock AS tblExaminee with (nolock) ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice with (nolock) ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient with (nolock) ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany with (nolock) ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType with (nolock) ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues with (nolock) ON tblCase.status = tblQueues.statusCode

            LEFT OUTER JOIN tblDoctor with (nolock) ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation with (nolock) ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseAppt with (nolock) ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
            LEFT OUTER JOIN tblDoctorLocation with (nolock) ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode

            LEFT OUTER JOIN tblSpecialty with (nolock) ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue with (nolock) ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType with (nolock) ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState with (nolock) ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus with (nolock) ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser with (nolock) ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices with (nolock) ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 with (nolock) ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 with (nolock) ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 with (nolock) ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage with (nolock) ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription with (nolock) ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblApptStatus with (nolock) ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID
            LEFT OUTER JOIN tblEmployer with (nolock) on tblcase.EmployerID = tblEmployer.EmployerID 
            LEFT OUTER JOIN tblEmployerAddress with (nolock) on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID 
			LEFT OUTER JOIN tblEWParentCompany with (nolock) ON tblCompany.ParentCompanyID = tblEWParentCompany.ParentCompanyID
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
exec sp_refreshview 'vwDocumentNoLock'

GO
PRINT N'Altering [dbo].[fnGetCaseDocumentPath]...';


GO
/*
	Table-Valued Function that will return the fully qualified invoice/voucher or document path
	office code, EW Folder ID and SubFolder name for the CaseNbr specified

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)

*/
ALTER FUNCTION [dbo].[fnGetCaseDocumentPath]
(
  @caseNbr INT,			
  @docType VARCHAR(32)	
)
RETURNS @documentInfo TABLE
(
	DocumentPath VarChar(500),
	FolderID INT,
	SubFolder VarChar(32)
)
AS
BEGIN
	DECLARE @path VARCHAR(500)	
	DECLARE @folderID INT
	DECLARE @subFolder VARCHAR(32);
	
     WITH CaseFolderCTE AS
          (SELECT
              tblCase.CaseNbr AS CaseNbr, 
              tblCase.DateAdded AS DateAdded,
              IIF(@docType = 'invoice' OR @docType = 'voucher', 
                    IIF(PC.AcctDocFolderID IS NOT NULL AND PC.AcctDocFolderID > 0, PC.AcctDocFolderID, IME.AcctDocFolderID), 
                    IIF(PC.CaseDocFolderID IS NOT NULL AND PC.CaseDocFolderID > 0, PC.CaseDocFolderID, IME.CaseDocFolderID)
              ) AS FolderID
          FROM tblcase with (nolock)
               LEFT OUTER JOIN tblOffice with (nolock) ON tblCase.OfficeCode = tblOffice.OfficeCode
               INNER JOIN tblIMEData AS IME with (nolock) ON ISNULL(tblOffice.IMECode, 1) = IME.IMECode
               INNER JOIN tblClient AS cl with (nolock) ON cl.ClientCode = ISNULL(tblCase.BillClientCode, tblcase.ClientCode)
               INNER JOIN tblCompany AS co with (nolock) ON co.CompanyCode = cl.CompanyCode
               INNER JOIN tblEWParentCompany AS pc with (nolock) ON pc.ParentCompanyID = co.ParentCompanyID
          WHERE CaseNbr = @caseNbr 
            AND CaseNbr IS NOT NULL
          )
     SELECT @path = fldr.PathName 
			+ RTRIM(YEAR(DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, CaseNbr),

			@folderID = fldr.FolderID,
			
            @subFolder = RTRIM(YEAR(DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, CaseNbr) + '\'		
     FROM CaseFolderCTE
               LEFT OUTER JOIN tblEWFolderDef AS fldr ON fldr.FolderID = CaseFolderCTE.FolderID
	
     INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	
     RETURN
END
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
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255),
    @useCaseCompany BIT
AS 
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericInvoices') IS NOT NULL DROP TABLE ##tmp_GenericInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @xmlCompany XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
SET @xmlCompany = CAST('<X>' + REPLACE(@companyCodeList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;
print 'Company Code List: ' + @companyCodeList;

WITH SLADetailsCTE AS
(SELECT DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr
  FROM tblCaseSLARuleDetail as sla
LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID
LEFT OUTER JOIN tblSLARuleDetail as srd on sla.SLARuleDetailID = srd.SLARuleDetailID
LEFT OUTER JOIN tblTATCalculationMethod as tcm on srd.TATCalculationMethodID = tcm.TATCalculationMethodID
LEFT OUTER JOIN tblDataField as DF1 on tcm.StartDateFieldID = DF1.DataFieldID
LEFT OUTER JOIN tblDataField as DF2 on tcm.EndDateFieldID = DF2.DataFieldID
INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr
INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr
WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0))
  AND (AH.DocumentType = 'IN'
  AND AH.DocumentStatus = 'Final'
  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)  
GROUP BY (DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr
)
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  C.MasterCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  COM.IntName as CaseCompanyInt,
  COM.ExtName as CaseCompanyExt,
  case when isnull(CLI.LastName, '') = '' then isnull(CLI.FirstName, '') else CLI.LastName+', '+isnull(CLI.FirstName, '') end as CaseClient,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  ISNULL(CL.Email, '') as ClientEmail,
  D.DoctorCode as DoctorID, 
  D.Zip as DoctorZip,
  CASE 
  WHEN c.PanelNbr IS NOT NULL THEN c.DoctorName 
  ELSE case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end
  END as Doctor, 
  C.DoctorReason,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  Inv.ClaimNbr as ClaimNo,
  C.SInternalCaseNbr as InternalCaseNbr,
  Inv.Examinee as Examinee,
  CASE ISNULL(C.EmployerID, 0)
    WHEN 0 THEN E.Employer
    ELSE EM.Name
  END AS Employer,
  E.DOB as "Examinee DOB",
  E.SSN as "Examinee SSN",
  O.ShortDesc as Office,
  EL.Location as ExamLocationName,
  EL.Addr1 as ExamLocationAddress1,
  EL.Addr2 as ExamLocationAddress2,
  EL.City as ExamLocationCity,
  EL.State as ExamLocationState,
  EL.Zip as ExamLocationZip,
  EL.County as ExamCounty,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  EWF.GPFacility as GPFacility,
  Inv.Finalized as DateFinalized,
  Inv.UserIDFinalized as UserFinalized,
  Inv.BatchNbr as GPBatchNo,
  Inv.ExportDate as GPBatchDate,
  BB.Descrip as BulkBilling,
  DOC.Description as InvoiceDocument,
  APS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CB.ExtName as CanceledBy,
  CA.Reason as CancelReason,
  isnull(Inv.ClientRefNbr, '') as ClientRefNo,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.Jurisdiction,
  EWIS.Name as InputSource,
  EWIS.Mapping1 as SedgwickSource,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  CA.DateAdded as ApptMadeDate,
  C.OrigApptTime as OrigAppt,
  ISNULL(inv.CaseApptID, c.CaseApptID) as CaseApptID,
  CA.ApptTime as [ApptDate],
  C.RptFinalizedDate,
  C.RptSentDate,    
  C.DateMedsRecd as DateMedsReceived,
  C.OCF25Date,
  c.TATAwaitingScheduling,  
  c.TATEnteredToAcknowledged,
  c.TATEnteredToMRRReceived,
  c.TATEnteredToScheduled,
  c.TATExamToClientNotified,
  c.TATExamToRptReceived,
  c.TATQACompleteToRptSent,
  c.TATReport, 
  c.TATRptReceivedToQAComplete,
  c.TATRptSentToInvoiced,
  c.TATScheduledToExam,
  c.TATServiceLifeCycle, 
  C.DateAdded as CaseDateAdded,
  Inv.CaseDocID,
  case
    when EWReferralType=0 then ''
    when EWReferralType=1 then 'Incoming'
    when EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  '' as CaseIssues,
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as TaxTotal,
  Inv.DocumentTotalUS-cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as Revenue,
  Inv.DocumentTotalUS as InvoiceTotal,
  isnull(VO.Expense, 0) as Expense,
  VO.VoucherCount as Vouchers,
  VO.VoucherDateMin as VoucherDate1,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMin as varchar(15)) as VoucherNo1,
  VO.VoucherDateMax as VoucherDate2,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMax as varchar(15)) as VoucherNo2,
  (select count(LI.LineNbr) from tblAcctDetail as LI where LI.HeaderID = Inv.HeaderID) as LineItems,
 STUFF((SELECT '; ' + SLAReason FROM SLADetailsCTE
    WHERE SLADetailsCTE.CaseNbr = inv.CaseNbr
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as SLAReasons,
  CONVERT(DATETIME,     NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32),  NULL) as ClaimantConfirmationStatus,
  CONVERT(INT,          NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME,     NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32),  NULL) as AttyConfirmationStatus,
  CONVERT(INT,          NULL) as AttyCallAttempts,  
  CONVERT(MONEY,        NULL) AS FeeDetailExam,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailExamUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailBillReview,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailBillRvwUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailPeer,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailPeerUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailAdd,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAddUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailLegal,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailLegalUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailProcServ,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailProvServUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailDiag,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailDiagUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailNurseServ,
  CONVERT(MONEY,        NULL) AS FeeDetailPhone,
  CONVERT(MONEY,        NULL) AS FeeDetailMSA,
  CONVERT(MONEY,        NULL) AS FeeDetailClinical,
  CONVERT(MONEY,        NULL) AS FeeDetailTech,
  CONVERT(MONEY,        NULL) AS FeeDetailMedicare,
  CONVERT(MONEY,        NULL) AS FeeDetailOPO,
  CONVERT(MONEY,        NULL) AS FeeDetailRehab,
  CONVERT(MONEY,        NULL) AS FeeDetailAddRev,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAddRevUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailTrans,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailTransUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailMileage,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailMileageUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailTranslate,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailTranslateUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailAdminFee,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAdminFeeUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailFacFee,
  CONVERT(MONEY,        NULL) AS FeeDetailOther,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  ISNULL(C.Priority, 'Normal') AS CasePriority,
  CONVERT(DATE, C.AwaitingScheduling) as DateAwaitingScheduling,
  CO.ParentCompanyID,
  CONVERT(VARCHAR(32), NULL) AS ClaimUniqueId,
  CONVERT(VARCHAR(32), NULL) AS CMSClaimNumber,
  CONVERT(VARCHAR(8),  NULL) AS ShortVendorId,
  CONVERT(VARCHAR(12), NULL) AS ProcessingOfficeId,
  CONVERT(VARCHAR(32), NULL) AS ReferralUniqueId,
  CONVERT(VARCHAR(12), NULL) AS ClientCustomerId,
  CONVERT(VARCHAR(128),NULL) AS ClientCustomerName,
  C.ClaimNbrExt as ClaimNoExt,
  CONVERT(VARCHAR(32), NULL) as FeeQuoteAmount,
  CONVERT(VARCHAR(32), NULL) as FeeScheduleAmount,
  CONVERT(VARCHAR(64), NULL) AS OutOfNetworkReason,
  CONVERT(VARCHAR(12), 'N/A') AS MedRecPages,
  CONVERT(BIT, NULL) AS AddendumNeeded,
  C.[Status] as CaseStatus,
  C.DateReceived as CaseDateReceived,
  CA.DateShowNoShowLetterSent as DateSNSLetterSent
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode		-- invoice client (billing client)
left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode	    -- invoice company (billing company)
left outer join tblClient as CLI on C.ClientCode = CLI.ClientCode		-- case client
left outer join tblCompany as COM on CLI.CompanyCode = COM.CompanyCode	-- case company
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join vwtblExaminee as E on C.ChartNbr = E.ChartNbr
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblEWFacility as EWF on Inv.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on Inv.EWFacilityID = EFGS.EWFacilityID
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblDocument as DOC on Inv.DocumentCode = DOC.Document
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
left outer join tblCaseAppt as CA on isnull(Inv.CaseApptID, C.CaseApptID) = CA.CaseApptID
left outer join tblCaseAppt as AHCA on Inv.CaseApptID = AHCA.CaseApptID
left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
left outer join tblApptStatus as APS on isnull(Inv.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
left outer join tblLocation as EL on CA.LocationCode = EL.LocationCode
left outer join
  (select
     RelatedInvHeaderID, 
     sum(DocumentTotalUS)-sum(cast(Round(TaxTotal*ExchangeRate, 2) as Money)) as Expense,
     count(DocumentNbr) as VoucherCount,
     min(DocumentDate) as VoucherDateMin,  
     min(DocumentNbr) as VoucherNoMin,
     max(DocumentDate) as VoucherDateMax,
     max(DocumentNbr) as VoucherNoMax
   from tblAcctHeader
   where DocumentType='VO' and DocumentStatus='Final' 
         and (DocumentDate >= @startDate and DocumentDate <= @endDate )
   group by RelatedInvHeaderID
  ) as VO on Inv.HeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND  IIF(@useCaseCompany = 0, CO.ParentCompanyID, COM.ParentCompanyID)  in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND IIF(@useCaseCompany = 0, CO.ParentCompanyID, COM.ParentCompanyID) > 0))


ORDER BY EWF.GPFacility, Inv.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
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
PRINT N'Altering [dbo].[proc_GetCaseProblemsByCase]...';


GO


ALTER PROCEDURE [proc_GetCaseProblemsByCase]

@CaseNbr int

AS 

SELECT * 
FROM tblCaseProblem 
 INNER JOIN vwtblProblem AS tblProblem ON tblCaseProblem.Problemcode = tblProblem.Problemcode 
 WHERE casenbr = @CaseNbr
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
PRINT N'Altering [dbo].[proc_GetProblemComboItems]...';


GO

ALTER PROCEDURE [proc_GetProblemComboItems]

AS

	SELECT problemcode, description 
	  FROM vwtblProblem AS tblProblem 
	 WHERE PublishOnWeb = 1
	   AND Status = 'Active'
	ORDER BY description
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
PRINT N'Altering [dbo].[proc_Problem_LoadAll]...';


GO


ALTER PROCEDURE [proc_Problem_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *
 FROM [vwtblProblem]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END
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
PRINT N'Altering [dbo].[proc_Problem_LoadByPrimaryKey]...';


GO


ALTER PROCEDURE [proc_Problem_LoadByPrimaryKey]
(
 @problemcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *
 FROM [vwtblProblem]
 WHERE
  ([problemcode] = @problemcode)

 SET @Err = @@Error

 RETURN @Err
END
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

-- Sprint 138

-- IMEC-14286 - encrypt tblProblem.Description 
-- **** DEV NOTE MOVING THIS TO CHUBB DEPLOYMEMT SCRIPT (BELOW)
--GO
--OPEN SYMMETRIC KEY IMEC_CLE_Key
--      DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
--UPDATE tblProblem
--     SET Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), Description)
--     FROM tblExaminee
--GO


-- IMEC-14305 - Security Token & Business Rule to control access to "File Browse" button on Case Letter/Report
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseFileBrowseBtn', 'Case - Allow File Browse', GETDATE())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (122, 'SetEnableStateFileBrowse', 'Case', 'Set Enabled state of FIle Browse button for Documents and Reports', 1, 1016, 1, NULL, NULL, NULL, NULL, 'OvrRideSecToken', 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (122, 'PC', 16, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CaseFileBrowseBtn', 0, NULL)
GO


-- ****** NEED TO RUN THIS LAST *****
-- ***** CHUBB ENCRYPTION DEPLOYMENT *****
/*
     Background: 
          tblExaminee and tblProblem will have some encrypted columns. The original columns 
          will remain but have not data (set to NULL) and there will be new "encrypted"
          columns that will contain the encrypted values of the values in the original 
          columns. Update/Insert triggers are used to handle encrypting data values when
          items are added/modified in these tables.

     Description: 
          This is a special one-off script that will be used to encrypt some columns
          in tblExaminee and tblDescription. In order to ensure that no data loss
          occurs the following steps are needed.
               - Insert/Update triggers for tblExaminee and tblProblem must be dropped. if
                 they are not then we will end up losing the original data that was present 
                 in the columns that are being encrypted.
               - Now we can encrypted the data, which populates the new "encrypted" columns
               - At this point the original data values have been encrypted and saved to 
                 new columns. We can now blank out (set to NULL) the original columns. Leaving 
                 the original columns blank. Their only purpose is "fire" the  triggers for 
                 when those data elements are modified or new items added to the table.
               - Lastly we need to load the triggers for tblExaminee and tblProblems
*/

-- 1. Back up tables into a temp tables...
-- SELECT * INTO tmpProblem_PreEncrypt FROM tblProblem
-- SELECT * INTO tmpExaminee_PreEncrypt FROM tblExaminee
-- GO 

-- 2. Drop Update/Insert triggers. If we don't then encrypted values will update 
--    to the "new" values and we end up with no data!!!!
drop trigger [dbo].[tblExaminee_AfterUpdate_TRG]
drop trigger [dbo].[tblExaminee_AfterInsert_TRG]
drop trigger [dbo].[tblProblem_AfterUpdate_TRG]
drop trigger [dbo].[tblProblem_AfterInsert_TRG]
GO

-- 3. ensure Examinee data is encrypted
OPEN SYMMETRIC KEY IMEC_CLE_Key
          DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
UPDATE tblExaminee
     SET ssn_encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), SSN), 
         DOB_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, DOB, 20))
     FROM tblExaminee
     WHERE SSN_Encrypted IS NULL OR DOB_Encrypted IS NULL
GO

-- 4. ensure Problem data is encrypted
OPEN SYMMETRIC KEY IMEC_CLE_Key
      DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
UPDATE tblProblem
     SET Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), Description)
     FROM tblProblem
     WHERE Description_Encrypted IS NULL
GO

-- 4. clear out examinee and problem original values
UPDATE tblExaminee
     SET SSN = null,
         DOB = null
    FROM tblExaminee
GO
UPDATE tblProblem
   SET Description = null
  FROM tblProblem
GO

-- 5. Load triggers tblProblem
CREATE TRIGGER [dbo].[tblProblem_AfterInsert_TRG]
   ON  [dbo].[tblProblem]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE P
        SET P.Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description)
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode;

END

GO
CREATE TRIGGER [dbo].[tblProblem_AfterUpdate_TRG]
   ON  [dbo].[tblProblem]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE P
        SET P.Description_Encrypted = IIF(I.Description = D.Description,
                                  P.Description_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description))
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode
        WHERE I.Description <> D.Description 
           OR I.Description IS NULL 
           OR D.Description IS NULL;

     UPDATE P
        SET P.Description = NULL
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode;
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END

-- 6. Load triggers tblExaminee
GO
CREATE TRIGGER [dbo].[tblExaminee_AfterInsert_TRG]
   ON  [dbo].[tblExaminee]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE E
        SET E.SSN_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.SSN),
            E.DOB_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, I.DOB, 20))
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr

END

GO
CREATE TRIGGER [dbo].[tblExaminee_AfterUpdate_TRG]
   ON  [dbo].[tblExaminee]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE E
        SET E.SSN_Encrypted = IIF(I.SSN = D.SSN,
                                  E.SSN_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.SSN)),
            E.DOB_Encrypted = IIF(I.DOB = D.DOB, 
                                  E.DOB_Encrypted, 
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, I.DOB, 20)))
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
        WHERE I.SSN <> D.SSN OR I.SSN IS NULL OR D.SSN IS NULL
           OR I.DOB <> D.DOB OR I.DOB IS NULL OR D.DOB IS NULL
     
     UPDATE E
        SET E.SSN = NULL, 
            E.DOB = NULL
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END

