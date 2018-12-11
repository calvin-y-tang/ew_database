

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
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DefaultWebCompanyID] INT NULL;


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
    ADD [EmailDocAsLink]     BIT CONSTRAINT [DF_tblDocument_EmailDocAsLink] DEFAULT ((0)) NOT NULL,
        [DaysEmailLinkValid] INT NULL;


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
PRINT N'Altering [dbo].[tblDPSBundle]...';


GO
ALTER TABLE [dbo].[tblDPSBundle]
    ADD [DPSSystemID] INT CONSTRAINT [DF_tblDPSBundle_DPSSystemID] DEFAULT ((0)) NOT NULL;


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
PRINT N'Altering [dbo].[tblDPSBundleCaseDocument]...';


GO
ALTER TABLE [dbo].[tblDPSBundleCaseDocument] ALTER COLUMN [Filename] VARCHAR (40) NULL;


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
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [DPSSystemID] INT CONSTRAINT [DF_tblOffice_DPSSystemID] DEFAULT ((0)) NOT NULL,
        [DPSFolderID] INT NULL;


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
PRINT N'Altering [dbo].[tblWebCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblWebCompany]
    ADD [URL]               VARCHAR (200) NULL,
        [WebActionLinkPage] VARCHAR (50)  NULL;


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
PRINT N'Creating [dbo].[tblWebActionLink]...';


GO
CREATE TABLE [dbo].[tblWebActionLink] (
    [WebActionLinkID] INT           IDENTITY (1, 1) NOT NULL,
    [UniqueKey]       VARCHAR (36)  NOT NULL,
    [ActionType]      VARCHAR (20)  NULL,
    [UserType]        VARCHAR (2)   NULL,
    [UserCode]        INT           NULL,
    [Param]           VARCHAR (100) NULL,
    [ExpirationDate]  DATETIME      NULL,
    [DateUsed]        DATETIME      NULL,
    [DateAdded]       DATETIME      NOT NULL,
    [UserIDAdded]     VARCHAR (15)  NOT NULL,
    CONSTRAINT [PK_tblWebActionLink] PRIMARY KEY CLUSTERED ([WebActionLinkID] ASC)
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
PRINT N'Creating [dbo].[tblWebActionLinkItem]...';


GO
CREATE TABLE [dbo].[tblWebActionLinkItem] (
    [WebActionLinkItemID] INT           IDENTITY (1, 1) NOT NULL,
    [WebActionLinkID]     INT           NOT NULL,
    [ActionTable]         VARCHAR (100) NOT NULL,
    [ActionKey]           INT           NULL,
    [DateAdded]           DATETIME      NOT NULL,
    [UserIDAdded]         VARCHAR (15)  NOT NULL,
    CONSTRAINT [PK_tblWebActionLinkItem] PRIMARY KEY CLUSTERED ([WebActionLinkItemID] ASC)
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
PRINT N'Creating [dbo].[DF_tblWebActionLink_UniqueKey]...';


GO
ALTER TABLE [dbo].[tblWebActionLink]
    ADD CONSTRAINT [DF_tblWebActionLink_UniqueKey] DEFAULT (NEWID()) FOR [UniqueKey];


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
PRINT N'Altering [dbo].[vwCaseOtherContacts]...';


GO

ALTER VIEW [dbo].[vwCaseOtherContacts]
AS
	SELECT CaseNbr, 'CC' AS Type, FirstName, LastName, Company, Email, Fax, 'AT' AS UserType, ccCode AS UserCode
	  FROM vwCaseCC
	
	UNION
	
	SELECT C.CaseNbr, 'DefAttny', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax, 'AT', DefenseAttorneyCode
	  FROM tblCase AS C 
			INNER JOIN tblCCAddress AS CC ON DefenseAttorneyCode=CCCode
	
	UNION
	
	SELECT C.CaseNbr, 'DefParalegal:', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax, 'DP', DefParaLegal 
	  FROM tblCase AS C 
			INNER JOIN tblCCAddress AS CC ON C.DefParaLegal=CCCode

	UNION

	SELECT casenbr, type, firstname, lastname, companyname, emailAddr, faxNbr, 'OP', DoctorCode
	  FROM vwCaseOtherParty

	UNION

	SELECT C.CaseNbr, 'ExamLoc', L.ContactFirst, L.ContactLast, L.Location, L.Email, L.Fax, 'EL',  L.LocationCode
	  FROM tblCase AS C 
			INNER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode

	UNION

	SELECT C.CaseNbr, 'Treat Phy', E.TreatingPhysician, '', '', E.TreatingPhysicianEmail, E.TreatingPhysicianFax, 'TP', E.ChartNbr  
	  FROM tblCase AS C 
			INNER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr

	UNION

	SELECT C.CaseNbr, '3rd Party', CL.FirstName, CL.LastName, COM.IntName, CL.Email, COALESCE(NULLIF(CL.BillFax,''), NULLIF(CL.Fax,'')), 'CL', BillClientCode
	  FROM tblCase AS C 
			INNER JOIN tblClient AS CL ON C.BillClientCode = CL.ClientCode 
			INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode

	UNION

	SELECT C.CaseNbr, 'Processor', CL.ProcessorFirstName, CL.ProcessorLastName, COM.IntName, CL.ProcessorEmail, CL.ProcessorFax, 'PR', CL.ClientCode
	  FROM tblCase AS C 
			INNER JOIN tblClient AS CL ON C.ClientCode=CL.ClientCode 
			INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode

	UNION

	SELECT TRO.CaseNbr, 'Facility', TF.ContactFirst, TF.ContactLast, TF.Name, TF.Email, TF.Fax, 'OF', TF.FacilityID 
	  FROM tblCase AS C 
			INNER JOIN tblRecordsObtainment AS TRO ON TRO.CaseNbr = C.CaseNbr 
			INNER JOIN tblFacility AS TF ON TF.FacilityID = TRO.FacilityID
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
PRINT N'Altering [dbo].[proc_CaseProblem_Insert]...';


GO
ALTER PROCEDURE [proc_CaseProblem_Insert]
(
	@casenbr int,
	@problemcode int,
	@problemareacode int = NULL,
	@dateadded datetime = NULL,
	@useridadded varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblcaseproblem]
	(
		[casenbr],
		[problemcode],
		[problemareacode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@problemcode,
		@problemareacode,
		@dateadded,
		@useridadded
	)

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
PRINT N'Altering [dbo].[proc_LoadCaseSearchProgressive]...';


GO
ALTER PROCEDURE [proc_LoadCaseSearchProgressive] 
(
	@ClaimNbr varchar(50),
	@ClaimNbrExt varchar(50),
	@LastName varchar(50),
	@CompanyCode int
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(2000)
	DECLARE @modulo as NVARCHAR(5) = '%'

    SET @StrSQL = 'SELECT TOP 50 * FROM tblCase INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ' +
		'WHERE (tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE CompanyCode = ' + CAST(@CompanyCode AS VARCHAR(20)) + ')) '

		IF LEN(@ClaimNbr) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbr LIKE ''' + @modulo + @ClaimNbr + @modulo + ''') '
		END 
		
		IF LEN(@ClaimNbrExt) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbrExt LIKE ''' + @modulo + @ClaimNbrExt + @modulo + ''') '
		END 

		IF LEN(@LastName) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblExaminee.LastName LIKE ''' + @modulo + @LastName + @modulo + ''') '
		END 

        SET @StrSQL = @StrSQL + ' ORDER BY tblCase.DateAdded DESC, tblCase.ClaimNbr, tblExaminee.LastName'

		PRINT @StrSQL
		
		BEGIN
			EXEC SP_EXECUTESQL @StrSQL
		END

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
PRINT N'Altering [dbo].[spDoctorSearch]...';


GO
ALTER PROCEDURE [dbo].[spDoctorSearch]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(200) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')

	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
	BEGIN
		SET @strDrSchCol = ' DS.SchedCode,'
		SET @strDrSchFrom = ' INNER JOIN tblDoctorSchedule AS DS ON DS.DoctorCode = DL.DoctorCode AND DS.LocationCode = DL.LocationCode AND DS.Status=''Open'' AND DS.StartTime>=@_StartDate '
	END
	ELSE

		SET @strDrSchCol = '(SELECT TOP 1 SchedCode FROM tblDoctorSchedule AS DS WHERE DS.DoctorCode=DL.DoctorCode AND DS.LocationCode=DL.LocationCode AND DS.date >= dbo.fnDateValue(@_StartDate) AND DS.Status = ''Open'' ORDER BY DS.date) AS SchedCode,'

--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
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
PRINT N'Creating [dbo].[proc_GetDocumentShareByGuid]...';


GO
CREATE PROCEDURE [proc_GetDocumentShareByGuid]

@Guid varchar(36)

AS

SELECT tblCaseDocuments.CaseNbr, tblCaseDocuments.sFileName, tblCaseDocuments.Description, tblWebActionLink.UserType, 
	tblWebActionLink.UserCode, ISNULL(tblPublishOnWeb.Viewed, 0) Viewed, tblCaseDocuments.SeqNo, tblWebActionLink.Param,
	ISNULL(tblPublishOnWeb.PublishAsPDF, 0) PublishAsPDF, tblCaseDocuments.Type, tblCaseDocType.Description DocTypeDesc, 
	tblCaseDocuments.DateAdded, tblWebActionLink.ExpirationDate
	FROM tblWebActionLink
		INNER JOIN tblWebActionLinkItem ON tblWebActionLink.WebActionLinkID = tblWebActionLinkItem.WebActionLinkID
		INNER JOIN tblCaseDocuments ON tblWebActionLinkItem.ActionKey = tblCaseDocuments.SeqNo
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.SeqNo = tblPublishOnWeb.TableKey
		INNER JOIN tblCaseDocType ON tblCaseDocuments.CaseDocTypeId = tblCaseDocType.CaseDocTypeId
		WHERE tblPublishOnWeb.TableType = 'tblCaseDocuments'
		AND tblPublishOnWeb.UserCode = tblWebActionLink.UserCode
		AND tblWebActionLink.UniqueKey = @Guid
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
PRINT N'Creating [dbo].[proc_GetOfficeFacilityInfo]...';


GO
CREATE PROCEDURE [proc_GetOfficeFacilityInfo]
(
	@Officecode int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblOffice 
		INNER JOIN tblEWFacility ON tblOffice.EwFacilityID = tblEWFacility.EWFacilityID 
		WHERE OfficeCode = @Officecode

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
PRINT N'Creating [dbo].[proc_Info_Generic_MgtRpt_PatchData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_PatchData]
AS

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsExaminee

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_GenericConfirmationsExaminee
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) EXGROUPS
	WHERE EXGROUPS.[ROW_NUM]  = 1
	ORDER BY EXGROUPS.CaseApptID

SELECT *
   INTO ##tmp_GenericConfirmationsAtty
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) ATYGROUPS
	WHERE ATYGROUPS.[ROW_NUM]  = 1
	ORDER BY ATYGROUPS.CaseApptID


-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'

-- return the main table
SELECT * 
  FROM ##tmp_GenericInvoices
ORDER BY InvoiceNo

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
PRINT N'Creating [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
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
	(SELECT se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr 
	   FROM tblCaseSLARuleDetail as sla 
			 LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID 
			 INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr 
			 INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr 
			 INNER JOIN tblClient as cli on cli.ClientCode = ah.ClientCode 
			 INNER JOIN tblCompany as com on com.CompanyCode = cli.CompanyCode 
	 WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0)) 
  		  AND (AH.DocumentType = 'IN' 
		  AND AH.DocumentStatus = 'Final' 
		  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate) 
	 GROUP BY (se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr ) 
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  D.DoctorCode as DoctorID,
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
  case S.EWServiceTypeID
    when 2 then C.DateMedsRecd
    when 3 then C.DateMedsRecd
    when 4 then C.DateMedsRecd
    when 5 then C.DateMedsRecd
  end as DateMedsReceived,
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
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode
left outer join tblCompany as CO on Inv.CompanyCode = CO.CompanyCode
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
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
  ) as VO on Inv.RelatedInvHeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND CO.ParentCompanyID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND CO.ParentCompanyID > 0))

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
PRINT N'Creating [dbo].[proc_Info_Liberty_BulkBilling_PatchData]...';

--IF EXISTS (
--        SELECT type_desc, type
--        FROM sys.procedures WITH(NOLOCK)
--        WHERE NAME = 'proc_Info_Liberty_BulkBilling_PatchData'
--            AND type = 'P'
--      )
--     DROP PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_PatchData]
--GO

GO
CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_PatchData]
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_LibertyConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_LibertyConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_LibertyConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_LibertyConfirmationsExaminee

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_LibertyConfirmationsExaminee
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_LibertyInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) GROUPS
	WHERE GROUPS.[ROW_NUM]  = 1
	ORDER BY GROUPS.CaseApptID


	SELECT *
   INTO ##tmp_LibertyConfirmationsAtty
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_LibertyInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) GROUPS
	WHERE GROUPS.[ROW_NUM]  = 1
	ORDER BY GROUPS.CaseApptID

-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_LibertyInvoices as ui
	inner join ##tmp_LibertyConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_LibertyInvoices as ui
	inner join ##tmp_LibertyConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'



-- return the main table
SELECT * 
  FROM ##tmp_LibertyInvoices
ORDER BY InvoiceNo
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
PRINT N'Creating [dbo].[proc_Info_Liberty_BulkBilling_QueryData]...';

--IF EXISTS (
--        SELECT type_desc, type
--        FROM sys.procedures WITH(NOLOCK)
--        WHERE NAME = 'proc_Info_Liberty_BulkBilling_QueryData'
--            AND type = 'P'
--      )
--     DROP PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_QueryData]
--GO

GO
CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Liberty Bulk Billing Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_LibertyInvoices') IS NOT NULL DROP TABLE ##tmp_LibertyInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;

WITH AcctDetailsCTE AS 
(select ad.HeaderId, ad.CPTCode 
	from tblAcctDetail as ad 
	where (ad.CPTCode IS NOT NULL) 
	  and (LEN(RTRIM(LTRIM(ad.CPTCode))) > 0) 
) 
SELECT
  EWF.DBID as DBID,
  cast('Database' as varchar(15)) as DB,
  AH.HeaderID,
  AH.EWFacilityID,
  AH.CaseDocID,
  ISNULL(AH.CaseApptID, C.CaseApptID) as CaseApptID,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as VarChar(15)) as InvoiceNo,
  EWF.FedTaxID,
  isnull(EWF.RemitAddress, EWF.Address) as "VendorMailingAddress",
  cast(AH.DocumentNbr as varchar(15)) as DocumentNo,
  AH.DocumentDate as InvoiceDate,
  cast(C.CaseNbr as varchar(15)) as CaseNbr,
  cast(C.ExtCaseNbr as varchar(15)) as ExtCaseNbr,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  EWF.FacilityName "VendorName",
  ISNULL(CLI.FirstName, '') + ' ' + ISNULL(CLI.LastName, '') as ClientName,
  AH.ClaimNbr as ClaimNumber,
  C.DateAdded,
  C.RptSentDate as ReportSentDate,
  C.DateReceived,
  C.Jurisdiction,
  isnull(E.FirstName, '') + ' ' + isnull(E.LastName, '') as "ClaimantName",
  E.State as "ClaimantState",    
  CA.ApptTime as AppointmentDate,
  apts.Name as AppointmentStatus,
  case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName +', ' + isnull(D.FirstName, '') end as ProviderName,
  isnull(d.LastName, '') as ProviderLastName,
  isnull(d.FirstName, '') as ProviderFirstName,
  C.SReqSpecialty as RequestedSpecialty,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  AH.DocumentTotalUS as "Charge",
  CD.Param as "CustomerDataParam",
  CD2.Param as "InvCustomerDataParam", 
  CONVERT(VARCHAR(64), NULL) as "iCaseReferralType",
  CONVERT(VARCHAR(64), NULL) as "iCaseICMServiceType",
  CONVERT(VARCHAR(64), NULL) as "iCaseNbr",
  CONVERT(VARCHAR(64), NULL) as "iCaseCompanyMarket",
  CONVERT(VARCHAR(16), NULL) as "iCaseDateSubmitted",
  CONVERT(VARCHAR(64), NULL) as "iCaseClaimID",
  CONVERT(VARCHAR(64), NULL) as "iCaseOfficeNumber",
  CONVERT(VARCHAR(64), NULL) AS "iCaseClaimType",
  CONVERT(VARCHAR(64), NULL) AS "iCaseReportUploadDate",
  CONVERT(VARCHAR(64), NULL) AS "iCaseIMERequestAs",
  CONVERT(VARCHAR(64), NULL) AS "iCaseServiceType",
  CONVERT(BIT, NULL) as "NotiCaseReferral", 
  STUFF((SELECT '; ' + CPTCode FROM AcctDetailsCTE 
    WHERE AcctDetailsCTE.HeaderID = AH.HeaderID      
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as CPTCodes, 
  CONVERT(INT, NULL) AS "Count", 
  CONVERT(VARCHAR(10), NULL) AS "Time",
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts,
  CONVERT(VARCHAR(12), NULL) AS ExpenseCode,
  BL.Name as "LineOfBusiness",
  (isnull([FeeAmount],0) + isnull([No Show],0) + isnull([Late Canceled],0) + isnull([PeerReview],0) + isnull([Addendum], 0)) as ExamFee,
  isnull([Diag], 0) as RadiololgyFee,
  (isnull([Interpret],0) + isnull([Trans],0) + isnull([BillReview],0) + isnull([Legal],0) + isnull([Processing],0) + isnull([Nurse],0)
	+ isnull(ft.[Phone],0) + isnull([MSA],0) + isnull([Clinical],0) + isnull([Tech],0) + isnull([Medicare],0) + isnull([OPO],0) 
	+ isnull([Rehab],0)	+ isnull([AddReview],0) + isnull([AdminFee],0) + isnull([FacFee],0) + isnull([Other],0)) as Other
INTO ##tmp_LibertyInvoices
FROM tblAcctHeader as AH
	INNER JOIN tblCase as C on AH.CaseNbr = C.CaseNbr
	INNER JOIN tblClient as CLI on AH.ClientCode = CLI.ClientCode
	INNER JOIN tblCompany as CO on CLI.CompanyCode = CO.CompanyCode
	LEFT OUTER JOIN tblDoctor as D on AH.DrOpCode = D.DoctorCode
	LEFT OUTER JOIN tblExaminee as E on C.ChartNbr = E.ChartNbr
	LEFT OUTER JOIN tblCaseType as CT on C.CaseType = CT.Code
	LEFT OUTER JOIN tblServices as S on C.ServiceCode = S.ServiceCode
	LEFT OUTER JOIN tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	LEFT OUTER JOIN tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	LEFT OUTER JOIN tblOffice as O on C.OfficeCode = O.OfficeCode
	LEFT OUTER JOIN tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
    LEFT OUTER JOIN tblCaseAppt as CA on isnull(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	LEFT OUTER JOIN tblApptStatus as apts on CA.ApptStatusID = apts.ApptStatusID
	LEFT OUTER JOIN tblCustomerData as CD on (C.CaseNbr = CD.TableKey AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN tblCustomerData as CD2 on (AH.HeaderID = CD2.TableKey AND CD2.TableType = 'tblAcctHeader' AND CD2.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN
(
  select Pvt.*
  from (
    select
      AD.HeaderID,
      isnull(case when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID in (51,102) then 'Late Canceled'
                  when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID = 101 then 'No Show'
                  else EWFC.Mapping5 end, 'Other') as FeeColumn,
      AD.ExtendedAmount	
    from tblCase as C
    inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
    inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
    inner join tblProduct as P on P.ProdCode = AD.ProdCode
    inner join tblCaseType as CT on C.CaseType = CT.Code
    inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
    inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
    left outer join tblApptStatus as A on A.ApptStatusID = AH.ApptStatusID
  ) as tmp
  pivot
  (
    sum(ExtendedAmount) --aggregrate function that give the value for the columns from FeeColumn
    for FeeColumn in (  --list out the values in FeeColumn that need to be a column
      [FeeAmount],
      [No Show],
      [Late Canceled],
      [Interpret],
      [Trans],
      [Diag],
      [BillReview],
      [PeerReview],
      [Addendum],
      [Legal],
      [Processing],
      [Nurse],
      [Phone],
      [MSA],
      [Clinical],
      [Tech],
      [Medicare],
      [OPO],
      [Rehab],
      [AddReview],
      [AdminFee],
      [FacFee],
      [Other])
  ) as Pvt
) as FT on FT.HeaderID = AH.HeaderID
where AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate
      AND AH.DocumentType = 'IN' 
      AND AH.DocumentStatus = 'Final' 
      AND CO.BulkBillingID = 1 
      AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY InvoiceNo

print 'Data retrieved'
set nocount off
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
PRINT N'Creating [dbo].[proc_RelatedParty_LoadByCaseNbr]...';


GO
CREATE PROCEDURE [proc_RelatedParty_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 RpCode FROM tblCaseRelatedParty WHERE CaseNbr = @CaseNbr

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
PRINT N'Creating [dbo].[proc_Info_Generic_MgtRpt]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
AS
	EXEC [dbo].[proc_Info_Generic_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList, @companyCodeList
	EXEC [dbo].[proc_Info_Generic_MgtRpt_PatchData]
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
PRINT N'Creating [dbo].[proc_Info_Liberty_BulkBilling]...';

--IF EXISTS (
--        SELECT type_desc, type
--        FROM sys.procedures WITH(NOLOCK)
--        WHERE NAME = 'proc_Info_Liberty_BulkBilling'
--            AND type = 'P'
--      )
--     DROP PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling]
--GO

GO
CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
	-- EXEC [dbo].[proc_Info_Liberty_BulkBilling_InitData]
	EXEC [dbo].[proc_Info_Liberty_BulkBilling_QueryData] @startDate, @endDate, @ewFacilityIdList
	EXEC [dbo].[proc_Info_Liberty_BulkBilling_PatchData]
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
---Issue 7809 Progressive - Add link in email for report
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@ViewDocumentURL@','') 
GO
