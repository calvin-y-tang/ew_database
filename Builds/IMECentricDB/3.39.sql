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
    ADD [DoctorScheduledRank] INT NULL,
        [ScheduleMethod]      INT NULL;


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
    ADD [DoctorScheduledRank] INT NULL,
        [ScheduleMethod]      INT NULL;


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
PRINT N'Altering [dbo].[tblDoctorSearchResult]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD [DisplayScore] NUMERIC (35, 13) NULL,
        [DoctorRank]   BIGINT           NULL;


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
PRINT N'Altering [dbo].[vwDoctorSearchResult]...';


GO

ALTER VIEW [dbo].[vwDoctorSearchResult]
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

       ISNULL(CONVERT(VARCHAR, DS.date, 101), 'Call for Appt') AS FirstAvail,
       DS.Date,
       DS.StartTime,

       DR.LastName + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
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
    LEFT OUTER JOIN tblDoctorSchedule AS DS ON DS.SchedCode = DSR.SchedCode
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
PRINT N'Altering [dbo].[proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseDocuments.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description AS doctypedesc, tblCase.DoctorSpecialty, tblCase.DoctorName
	FROM tblCaseDocuments
		INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		LEFT JOIN tblCaseDocType on tblCaseDocuments.CaseDocTypeID = tblCaseDocType.CaseDocTypeID
	WHERE (tblPublishOnWeb.TableType = 'tblCaseDocuments')
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
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
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]...';


GO
ALTER PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseHistory.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename, tblCase.DoctorName, tblCase.DoctorSpecialty
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
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
PRINT N'Altering [dbo].[proc_GetReferralSummaryNewProgressive]...';


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummaryNewProgressive]

@WebStatus varchar(50),
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblCase.MMIReachedStatus,
		tblCase.DoctorSpecialty,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		tblQueues.statuscode AS QueueStatusCode,
		tblQueues.StatusDesc,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUser ON tblPublishOnWeb.UserCode = tblWebUser.IMECentricCode
			AND tblPublishOnWeb.UserType = tblWebUser.UserType
			AND tblWebUser.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status NOT IN (8,9))

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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(4), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	ISNULL(AH.ServiceState, C.Jurisdiction) as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ISNULL(ca.datereceived, c.DateReceived) as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(2)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments
INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

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
PRINT N'Altering [dbo].[spDoctorSearch]...';


GO
ALTER PROCEDURE spDoctorSearch
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
	@EWServiceTypeID AS INT = NULL
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
			@_Proximity INT',
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
			@_Proximity = @Proximity
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
	       --INNER JOIN ranking AS R ON R.PrimaryKey = DSR.PrimaryKey
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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
AS

--
-- Hartford Data patching 
--

set nocount on 

Print 'Fixing up Company Names'

-- fix up the Company Names 
UPDATE hi SET hi.IntName = isnull(hm.NewOfficeName, hi.IntName), hi.LitOrAppeal = IIF(hm.IsLawOffice = 1, 'Litigation', 'NA')
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordOfficeMap as hm on hi.IntName = hm.CurrentOfficeName

Print 'Fixing up Specialties and Sub-Specialties'
-- fix up the specialities
UPDATE hi SET hi.Specialty = isnull(sm.NewSpecialtyName, hi.Specialty)
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordSpecialtyMap as sm on hi.Specialty = sm.CurrentSpecialtyName

-- fix up the sub-specialities
UPDATE hi SET hi.SubSpecialty = isnull(ssm.NewSpecialtyName, hi.SubSpecialty)
	from ##tmp_HartfordInvoices as hi
 	left outer join ##tmp_HartfordSubSpecialtyMap as ssm on hi.SubSpecialty = ssm.CurrentSpecialtyName
	
Print 'Fixing up Service Types'
UPDATE hi SET hi.ServiceType = CASE 
								WHEN hi.ServiceTypeID = 1 THEN 'IME'
								WHEN hi.ServiceTypeID = 2 THEN 'MRR'
								WHEN hi.ServiceTypeID = 3 THEN 'MRR'
								WHEN hi.ServiceTypeID = 4 THEN 'MRR'
								WHEN hi.ServiceTypeID = 5 THEN 'MRR'
								WHEN hi.ServiceTypeID = 6 THEN 'MRR'
								WHEN hi.ServiceTypeID = 7 THEN 'Other'
								WHEN hi.ServiceTypeID = 8 THEN 'Addendum - IME'
								WHEN hi.ServiceTypeID = 9 THEN 'Other'
								ELSE 'Other'
							  END
FROM ##tmp_HartfordInvoices as hi

Print 'Check for FCE services via Sub-Speciality'
UPDATE hi SET hi.ServiceType = CASE
								WHEN hi.SubSpecialty like '%FCE%' THEN 'FCE'
								ELSE hi.ServiceType
							   END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Line of Business'
UPDATE hi SET hi.LOB = CASE hi.LOB
						WHEN '1' THEN 'PL'
						WHEN '2' THEN 'PL'
						WHEN '3' THEN 'P&C'
						WHEN '4' THEN 'GBC'
						WHEN '5' THEN 'PL'
						ELSE ''
                       END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Coverage Types'
UPDATE hi SET hi.CoverageType = CASE 
									WHEN hi.CoverageType = 'Workers Comp' THEN 'WC'
									WHEN hi.CoverageType like '%auto%' THEN 'Auto'
									WHEN hi.CoverageType = 'Liability' THEN 'Auto'
									WHEN hi.CoverageType = 'Disability' THEN 'LTD'									
									ELSE 'Other'
								END
from ##tmp_HartfordInvoices as hi

Print 'Fixing up Network and Juris TAT'
UPDATE hi SET hi.InOutNetwork = CASE 
									WHEN hi.InOutNetwork = '1' THEN 'Out'
									WHEN hi.InOutNetwork = '2' THEN 'In'
									ELSE ''
								END,
		      hi.JurisTAT = CASE 
								WHEN hi.ServiceVariance > 0 THEN 'No'
								ELSE 'Yes'				
		                    END			  
FROM ##tmp_HartfordInvoices as hi

Print 'Set Service Variance to NULL (per the spec)'
UPDATE hi SET ServiceVariance = NULL 
  FROM ##tmp_HartfordInvoices as hi
  
Print 'Getting Exception Data'
UPDATE hi SET hi.PrimaryException = CASE 
									WHEN (SRD.DisplayOrder = 1 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
									ELSE ''
								 END,
			  hi.SecondaryException = CASE
									WHEN (SRD.DisplayOrder = 2 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
								    ELSE ''
								 END,
			  Comments = ISNULL(Comments, '') + ISNULL(SE.Descrip + ' ', '')

FROM ##tmp_HartfordInvoices as hi
	LEFT OUTER JOIN tblSLARule as SR on hi.SLARuleID = SR.SLARuleID
	LEFT OUTER JOIN tblSLARuleDetail as SRD on SR.SLARuleID = SRD.SLARuleID
	LEFT OUTER JOIN tblCaseSLARuleDetail as CSRD ON (hi.CaseNbr = CSRD.CaseNbr AND SRD.SLARuleDetailID = CSRD.SLARuleDetailID)
	LEFT OUTER JOIN tblSLAException as SE ON CSRD.SLAExceptionID = SE.SLAExceptionID
	

Print 'Update Primary and Secondary Exceptions'
UPDATE hi SET PrimaryDriver = CASE 
									WHEN hi.PrimaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.PrimaryException = 'CL' THEN 'Provider'
									WHEN hi.PrimaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.PrimaryException = 'NS' THEN 'Claimant'
									WHEN hi.PrimaryException = 'SA' THEN 'Provider'
									WHEN hi.PrimaryException = 'SR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'AR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'C' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'NA' THEN 'NA'
                                 END,
				SecondaryDriver = CASE 
									WHEN hi.SecondaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.SecondaryException = 'CL' THEN 'Provider'
									WHEN hi.SecondaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.SecondaryException = 'NS' THEN 'Claimant'
									WHEN hi.SecondaryException = 'SA' THEN 'Provider'
									WHEN hi.SecondaryException = 'SR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'AR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'C' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'NA' THEN 'NA'
                                 END
FROM ##tmp_HartfordInvoices as hi

-- return file result set
select * 
	from ##tmp_HartfordInvoices

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
PRINT N'Altering [dbo].[spCaseReports]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[spCaseReports] ( @casenbr integer )
AS 
	DECLARE @MasterCaseNbr INTEGER 
	
	SET @MasterCaseNbr = (SELECT MasterCaseNbr FROM tblCase WHERE CaseNbr = @casenbr)

	SELECT 
            @casenbr AS CaseNbr,
			CaseNbr AS DocCaseNbr, 
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            reporttype,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages,
			FolderID,
			SubFolder, 
			CaseDocTypeID,
			SharedDoc 
    FROM    dbo.tblCaseDocuments AS CD
    WHERE   ( type = 'Report' )
			 AND (CD.CaseNbr = @CaseNbr OR (CD.SharedDoc=1 AND CD.MasterCaseNbr = @MasterCaseNbr AND @MasterCaseNbr IS NOT NULL))
    ORDER BY dateadded DESC
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
PRINT N'Creating [dbo].[proc_GetCaseDetailsProgressive]...';


GO
CREATE PROCEDURE [proc_GetCaseDetailsProgressive] 
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCase
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr WHERE tblCase.CaseNbr = @CaseNbr

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
PRINT N'Creating [dbo].[proc_Info_Progressive_MgtRpt_PatchData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_PatchData]
AS

print 'Retrieve the SLA reason'
 UPDATE T SET  
  T.SLAExceptions=(STUFF((SELECT ', ' + RTRIM(StartDate.Descrip) + ' to '+ RTRIM(EndDate.Descrip) + ': ' + CAST(RTRIM(SE.Descrip) + IIF(LEN(CSRD.Explanation) = 0, '', ': ') + RTRIM(ISNULL(CSRD.Explanation,'')) AS VARCHAR(4096))
 FROM tblCaseSLARuleDetail AS CSRD
	 INNER JOIN tblSLAException AS SE ON SE.SLAExceptionID = CSRD.SLAExceptionID
	 INNER JOIN tblSLARuleDetail AS SRD ON SRD.SLARuleDetailID = CSRD.SLARuleDetailID
	 INNER JOIN tblSLARule AS SR ON SR.SLARuleID = SRD.SLARuleID
	 LEFT OUTER JOIN tblTATCalculationMethod AS CalcMeth ON CalcMeth.TATCalculationMethodID = SRD.TATCalculationMethodID
	 LEFT OUTER JOIN tblDataField AS StartDate ON StartDate.DataFieldID = CalcMeth.StartDateFieldID
	 LEFT OUTER JOIN tblDataField AS EndDate ON EndDate.DataFieldID = CalcMeth.EndDateFieldID 
	 LEFT OUTER JOIN tblDataField AS TATDate ON TATDate.DataFieldID = CalcMeth.TATDataFieldID
  WHERE T.CaseNbr = CSRD.CaseNbr
  FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(4096)'),1,2,''))
  FROM ##tmpProgessiveMgtRpt as T


print 'Retrieve the most recent Report Date Viewed from the portal for each case ...'
UPDATE pmr SET pmr.ReportRetrievalDate = docs.DateViewed
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY cd.CaseNbr ORDER BY cd.SeqNo DESC) as ROWNUM, cd.CaseNbr, cd.SeqNo, pow.DateViewed
				FROM tblCaseDocuments as cd
					LEFT OUTER JOIN tblPublishOnWeb as pow on cd.SeqNo = pow.TableKey and pow.TableType = 'tblCaseDocuments'
				WHERE (cd.CaseNbr IN (Select pr.CaseNbr FROM ##tmpProgessiveMgtRpt as pr))
				  AND (cd.Type = 'Report') 
				) as tbl
		WHERE tbl.ROWNUM = 1) AS docs ON pmr.CaseNbr = docs.CaseNbr

print 'Get first no show appt date and time'
UPDATE pmr SET pmr.FirstNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 1 ) AS apt ON pmr.CaseNbr = apt.CaseNbr


print 'Get second no show appt date and time'
UPDATE pmr SET pmr.SecondNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 2 ) AS apt ON pmr.CaseNbr = apt.CaseNbr

print 'Get third no show appt date and time'
UPDATE pmr SET pmr.ThirdNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 3 ) AS apt ON pmr.CaseNbr = apt.CaseNbr

print 'Return final result set'
SELECT *
  FROM ##tmpProgessiveMgtRpt 

print 'clean up'
IF OBJECT_ID('tempdb..##tmpProgessiveMgtRpt') IS NOT NULL DROP TABLE ##tmpProgessiveMgtRpt
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
PRINT N'Creating [dbo].[proc_Info_Progressive_MgtRpt_QueryData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Executing main query ...';

WITH OtherDetailCTE AS (
  SELECT C.CaseNbr, AD.LongDesc
    FROM tblCase as C
		inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
		inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
		inner join tblProduct as P on P.ProdCode = AD.ProdCode
		inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
		inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
   WHERE ISNULL(EWFC.Mapping5, 'Other') = 'Other'
)
SELECT 
  EWF.DBID,
  EWF.EWFacilityID,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  C.Jurisdiction,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as varchar(15)) as InvoiceNbr,
  convert(datetime, AH.DocumentDate, 101) as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  CO.IntName as Company,
  cast('' as varchar(1)) as Contracted,
  cast('' as varchar(1)) as InNetwork,
  L.City as ExamCity,
  L.State as ExamState,
  BL.Name AS BusinessLine,
  C.ClaimNbr as ClaimNumber,
  C.ClaimNbrExt as "FeatureNumber",
  E.FirstName as ExamineeFirstName,
  E.LastName as ExamineeLastName,
  case 
    when S.ShortDesc = 'EMCR' then 'EMC Peer Review' 
    when S.Description like '%clarification%' then 'Clarification'
    when S.EWServiceTypeID in (2,3,4,5) then 'Peer Review'
    when S.EWServiceTypeID in (8,9) then 'Addendum'
    else ST.Name
  end as ServiceType,
  S.Description as Service,
  case
    when AH.ApptStatusID is null then isnull(CA.SpecialtyCode, C.DoctorSpecialty)
    else AHCA.SpecialtyCode
  end as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  case
    when AH.ApptStatusID is not null then AHAS.Name
    when C.[Status] = 9 then 'Canceled'
    when C.RptSentDate is not null then 'Report Sent'
    when isnull(CA.ApptTime, C.ApptTime) is not null then 'Appt Letter Sent'
    else 'Pending'
  end as [Status],
  case when C.[Status] in (8, 9) then 'Closed' else 'Open' end as OpenClosedStatus,
  case
    when AH.ApptStatusID is null then isnull(CA.DateReceived, C.DateReceived)
    else AHCA.DateReceived
  end as DateReceived,
  case
    when AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
    else convert(datetime, AHCA.ApptTime, 101)
  end as ExamDate,
  case
    when AH.ApptStatusID is null then isnull(C.RptSentDate, AH.Finalized)
    else cast(null as datetime)
  end as RptSentDate,
 C.TATAwaitingScheduling,
 C.TATCalculationGroupID,
 C.TATEnteredToAcknowledged,
 C.TATEnteredToMRRReceived,
 C.TATEnteredToScheduled,
 C.TATExamToClientNotified,
 C.TATExamToRptReceived,
 C.TATQACompleteToRptSent,
 C.TATReport,
 C.TATRptReceivedToQAComplete,
 C.TATRptSentToInvoiced,
 C.TATScheduledToExam,
 C.TATServiceLifeCycle,
 convert(varchar(12), null) as "InjuryToExam",
 convert(varchar(12), null) as "InjuryToReportSent",
 convert(varchar(8), null) as "Hours",
  case S.EWServiceTypeID
    when 2 then C.DateMedsRecd
    when 3 then C.DateMedsRecd
    when 4 then C.DateMedsRecd
    when 5 then C.DateMedsRecd
  end as DateMedsReceived,
  case when C.DefenseAttorneyCode is null and C.PlaintiffAttorneyCode is null then 'No' else 'Yes' end as Attorney,
  case
    when AH.ApptStatusID is null then D.FirstName
    else AHD.FirstName
  end as DoctorFirstName,
  case
    when AH.ApptStatusID is null then D.LastName
    else AHD.LastName
  end as DoctorLastName,
  case 
	when cb.ExtName = 'Attorney' then 'Attorney'
	when (cb.ExtName = 'Examinee' or ca.ApptStatusID = 102) then 'Patient'
	when cb.ExtName = 'Client' then 'Adjuster'
	when cb.ExtName = 'Doctor' then 'Doctor'	
  end as "CanceledBy",
  
  case when AH.DocumentNbr is null then 'No' else 'Yes' end as Invoiced,
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
  [PhoneConf],
  [MSA],
  [Clinical],
  [Tech],
  [Medicare],
  [OPO],
  [Rehab],
  [AddReview],
  [AdminFee],
  [FacFee],
  [Other],
  stuff((select '; '+LongDesc from OtherDetailCTE
         where OtherDetailCTE.CaseNbr=C.CaseNbr
         for XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as OtherDetail,
  AH.DocumentTotal,
  CL.FirstName as ClientFirstName,
  CL.LastName as ClientLastName,
  Q.StatusDesc as QueueStatus,
  CAS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CONVERT(VARCHAR(4096), NULL) AS SLAExceptions,
  AH.HeaderID,
  CONVERT(DATETIME, NULL) AS "FirstNoShow",
  CONVERT(DATETIME, NULL) AS "SecondNoShow",
  CONVERT(DATETIME, NULL) AS "ThirdNoShow",
  CONVERT(DATETIME, NULL) AS "ReportRetrievalDate"
INTO ##tmpProgessiveMgtRpt
FROM tblCase as C
left outer join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
left outer join
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
      [PhoneConf],
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
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on C.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode
	left outer join tblCaseAppt as CA on C.CaseApptID = CA.CaseApptID
	left outer join tblApptStatus as CAS on isnull(CA.ApptStatusID, C.ApptStatusID) = CAS.ApptStatusID
	left outer join tblLocation as L on isnull(CA.LocationCode, C.DoctorLocation) = L.LocationCode
	left outer join tblDoctor as D on isnull(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblCaseAppt as AHCA on AH.CaseApptID = AHCA.CaseApptID
	left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
	left outer join tblDoctor as AHD on AHCA.DoctorCode = AHD.DoctorCode
	left outer join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
	left outer join tblEWFacility as EWF on O.EWFacilityID = EWF.EWFacilityID
	left outer join tblEWFacilityGroupSummary as EFGS on O.EWFacilityID = EFGS.EWFacilityID
	left outer join tblQueues as Q on C.Status = Q.StatusCode
	left outer join tblCanceledBy as cb on isnull(ca.CanceledByID, c.CanceledByID) = cb.CanceledByID
WHERE (C.DateAdded >= @startDate and C.DateAdded <= @endDate)
      and (CO.ParentCompanyID = 39)
      and (O.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      and (not (C.[Status] = 9 and AH.HeaderID is null))
      and (not (C.[Status] = 8 and AH.HeaderID is null and D.DoctorCode is null))
      and (not (S.EWServiceTypeID in (6, 999)))
ORDER BY EFGS.BusUnitSeqNo, C.Jurisdiction, S.Description, C.DateAdded, C.CaseNbr,
         CASE
           WHEN AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
           ELSE convert(datetime, AHCA.ApptTime, 101)
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
PRINT N'Creating [dbo].[proc_Info_Progressive_MgtRpt]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

IF OBJECT_ID('tempdb..##tmpProgessiveMgtRpt') IS NOT NULL DROP TABLE ##tmpProgessiveMgtRpt

print 'Executing main progressive query ...'
EXEC [dbo].[proc_Info_Progressive_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList
print 'Executing progressive patch data ...'
EXEC [dbo].[proc_Info_Progressive_MgtRpt_PatchData]
GO












INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteDate@','') 
 
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteComment@','') 
Go  

INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@FeeScheduleAmount@','') 
 
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteFeeRangeFrom@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteFeeRangeTo@','') 
 
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteFeeUnit@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteNoShowFee@','') 
 
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteLateCancelFee@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteLateCancelDays@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteSpecialty@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteDoctorName@','') 
Go  
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteNetwork@','') 
Go  

INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteProduct@','') 
Go  

INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@QuoteOutofNetworkReason@','') 
Go  











UPDATE tblControl SET DBVersion='3.39'
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

