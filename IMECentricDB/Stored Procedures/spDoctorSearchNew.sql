CREATE PROCEDURE [dbo].[spDoctorSearchNew]
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
    @Specialties AS VARCHAR(3000) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@ThirdPartyParentCompanyID AS INT = NULL, 
	@BillClientCompanyCode AS INT = NULL,
	@BillClientCode AS INT = NULL, 
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL,
	@UserID AS VARCHAR(15) = NULL, 
	@CaseType AS INT = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(3000)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)
	DECLARE @DNUCaseTypeWhere VARCHAR(64)

	DECLARE @useSpecialtyExpire AS VARCHAR(10)
	DECLARE @strWhereSpecialtyExpire AS VARCHAR(1000)

	-- Get tblSetting that determines when Expiration date is checked for license and specialty
	SET @strWhereSpecialtyExpire = ''
	SET @useSpecialtyExpire = ISNULL((SELECT value FROM tblSetting WHERE Name = 'UseSpecialtyExpirationDate'), 'False')
	IF @useSpecialtyExpire = 'True'
	BEGIN
		SET @strWhereSpecialtyExpire = ' AND (CAST(ExpireDate AS DATE) > CAST(GETDATE() AS DATE) OR ExpireDate IS NULL) '
	END

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
			SET @strDrSchCol = ' BTS.DoctorBlockTimeSlotID AS SchedCode,' +
							   ' ROW_NUMBER() OVER (PARTITION BY BTS.DoctorBlockTimeDayID, BTS.StartTime ORDER BY BTS.DoctorBlockTimeSlotID) AS DisplayScore,'
			SET @strDrSchFrom = ' INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTD.ScheduleDate>=@_StartDate ' +
								' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID AND BTS.DoctorBlockTimeSlotStatusID=10'
		END
	ELSE
		SET @strDrSchCol = '(SELECT TOP 1 BTS.DoctorBlockTimeSlotID AS SchedCode FROM tblDoctorBlockTimeDay AS BTD ' +
						   ' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID' +
						   ' WHERE BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTS.DoctorBlockTimeSlotStatusID=10' +
						   ' AND BTD.ScheduleDate >= dbo.fnDateValue(@_StartDate) ORDER BY BTD.ScheduleDate) AS SchedCode,' +
						   ' 1 AS DisplayScore,'


--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
	DisplayScore,
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
	BEGIN
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN 
			(SELECT DISTINCT DoctorCode 
			  FROM tblDoctorDocuments 
			 WHERE EWDrDocTypeID = 11 
			   AND State = @_State ' + 
			   @strWhereSpecialtyExpire + ')'
	END

	-- DEV NOTE: When board cert is required we need to check for a matching Doctor Document
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN 
				(SELECT DISTINCT DoctorCode 
				   FROM tblDoctorDocuments 
				  WHERE EWDrDocTypeID = 2 
				    AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties) > 0 ' + 
					@strWhereSpecialtyExpire + ' )'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN 
				(SELECT DISTINCT DoctorCode 
				   FROM tblDoctorDocuments 
				  WHERE EWDrDocTypeID = 2 ' + 
				  @strWhereSpecialtyExpire + ' )'
	END
	-- DEV NOTE: when board cert is required this exclude specialties that do not have a Doctor Document.
	--           when board cert is NOT required doctors with these specialties are included.
	IF @Specialties IS NOT NULL
	BEGIN
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN 
			(SELECT DISTINCT DoctorCode 
				FROM tblDoctorSpecialty 
				WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties) > 0)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'

	SET @DNUCaseTypeWhere = IIF(@CaseType IS NULL OR @CaseType = -1, NULL, ' AND (CaseType = -1 OR CaseType = ' + CAST(@CaseType AS VARCHAR(5)) + ') ' )

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'

	IF @ThirdPartyParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ThirdPartyParentCompanyID ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'
	IF @BillClientCompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_BillClientCompanyCode ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'
	IF @BillClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_BillClientCode ' + IIF(@DNUCaseTypeWhere IS NULL, '', @DNUCaseTypeWhere) + ')'

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

	IF @EWBusLineID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorBusLine WHERE EWBusLineID = @_EWBusLineID)'

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
			@_lstSpecialties VARCHAR(3000) ,
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
			@_ThirdPartyParentCompanyID INT,	
			@_BillClientCompanyCode INT,		
			@_BillClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50),
			@_EWBusLineID INT 
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
			@_ThirdPartyParentCompanyID = @ThirdPartyParentCompanyID,
			@_BillClientCompanyCode = @BillClientCompanyCode,
			@_BillClientCode = @BillClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName, 
			@_EWBusLineID = @EWBusLineID
	SET @returnValue = @@ROWCOUNT
	
	--Use only the first row of the same start time (DisplayScore was set to 1 during INSERT)
	DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND ISNULL(DisplayScore,0)<>1

	--Remove results for access restrictions
	IF (SELECT RestrictToFavorites FROM tblUser WHERE UserID = ISNULL(@UserID,'')) = 1
	begin
		with userOfficeStates as
		(
			select distinct f.State
			from tblUser u
			join tblUserOffice uo
				on u.UserID = uo.UserID
			join tblOffice o
				on uo.OfficeCode = o.OfficeCode
			join tblEWFacility f with (nolock)
				on o.EWFacilityID = f.EWFacilityID
			where u.UserID = ISNULL(@UserID, '')
		),
		locationOffficeStates as
		(
			select l.LocationCode
			from tblLocation l
			join userOfficeStates s on s.State = l.State
		)
		DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND LocationCode NOT IN
		(
			select LocationCode from locationOffficeStates
		)
	end


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(3000)'),1,2,'')),'')
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
	UPDATE tblDoctorSearchResult SET DisplayScore = NULL
		WHERE SessionID = @tmpSessionID

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
