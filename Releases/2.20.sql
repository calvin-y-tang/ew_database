
ALTER TABLE tblIMEData
 ADD DirWebQuickReferralFiles VARCHAR(70)
GO

CREATE TABLE [dbo].[tblWebQRRequest](
	[QRRequestID] [int] IDENTITY(1,1) NOT NULL,
	[ReqService] [varchar](40) NULL,
	[ReqType] [varchar](40) NULL,
	[RefCompanyName] [varchar](30) NULL,
	[RefCompanyAddress1] [varchar](30) NULL,
	[RefCompanyAddress2] [varchar](30) NULL,
	[RefCompanyCity] [varchar](30) NULL,
	[RefCompanyProvince] [varchar](25) NULL,
	[RefCompanyPostalCode] [varchar](15) NULL,
	[RefPersonFirstName] [varchar](30) NULL,
	[RefPersonLastName] [varchar](30) NULL,
	[RefPersonOffice] [varchar](50) NULL,
	[RefPersonPhone] [varchar](30) NULL,
	[RefPersonFax] [varchar](30) NULL,
	[RefPersonEmail] [varchar](255) NULL,
	[ExamineeFileNum] [varchar](50) NULL,
	[ExamineeDOI] [smalldatetime] NULL,
	[ExamineeDOB] [smalldatetime] NULL,
	[ExamineePrefix] [varchar](15) NULL,
	[ExamineeFirstName] [varchar](30) NULL,
	[ExamineeLastName] [varchar](30) NULL,
	[ExamineeAddress1] [varchar](30) NULL,
	[ExamineeAddress2] [varchar](30) NULL,
	[ExamineeCity] [varchar](30) NULL,
	[ExamineeProvince] [varchar](25) NULL,
	[ExamineePostalCode] [varchar](15) NULL,
	[ExamineePhone] [varchar](30) NULL,
	[ExamineeFax] [varchar](30) NULL,
	[ExamineeEmail] [varchar](255) NULL,
	[ExamineeSSN] [varchar](15) NULL,
	[ExamineeGender] [varchar](10) NULL,
	[Transportation] [varchar](10) NULL,
	[Interpretation] [varchar](10) NULL,
	[Language] [varchar](50) NULL,
	[AdditionalTransInterpNeeds] [varchar](2000) NULL,
	[CorrespFirstName] [varchar](30) NULL,
	[CorrespLastName] [varchar](30) NULL,
	[CorrespEmail] [varchar](255) NULL,
	[ReqPhysicianFirstName] [varchar](30) NULL,
	[ReqPhysicianLastName] [varchar](30) NULL,
	[ReqSpecialties] [varchar](4000) NULL,
	[SubspecialtyExpertise] [varchar](4000) NULL,
	[PhysSpecInstructions] [varchar](4000) NULL,
	[PreferredTimeline] [varchar](4000) NULL,
	[DiagInjDescMedBrief] [varchar](4000) NULL,
	[DateAdded] [smalldatetime] NULL,
	[IPAddress] [varchar](50) NULL,
	[EWFacilityID] [int] NULL


 CONSTRAINT [PK_tblWebQRRequest] PRIMARY KEY CLUSTERED 
(
	[QRRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tblWebQRConfig](
	[EWFacilityID] [int] NOT NULL,
	[QuickReferralEnabled] [bit] NOT NULL,
	[Email] [varchar](200) NOT NULL,
 CONSTRAINT [PK_tblWebQRConfig] PRIMARY KEY CLUSTERED 
(
	[EWFacilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebQRRequest_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebQRRequest_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_WebQRRequest_LoadByPrimaryKey]
(
	@QRRequestID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebQRRequest]
	WHERE
		([QRRequestID] = @QRRequestID)

	SET @Err = @@Error

	RETURN @Err
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebQRRequest_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebQRRequest_Insert];
GO

CREATE PROCEDURE [proc_WebQRRequest_Insert]
(
	@QRRequestID int = NULL output,
	@ReqService varchar(40) = NULL,
	@ReqType varchar(40) = NULL,
	@RefCompanyName varchar(30) = NULL,
	@RefCompanyAddress1 varchar(30) = NULL,
	@RefCompanyAddress2 varchar(30) = NULL,
	@RefCompanyCity varchar(30) = NULL,
	@RefCompanyProvince varchar(25) = NULL,
	@RefCompanyPostalCode varchar(15) = NULL,
	@RefPersonFirstName varchar(30) = NULL,
	@RefPersonLastName varchar(30) = NULL,
	@RefPersonOffice varchar(50) = NULL,
	@RefPersonPhone varchar(30) = NULL,
	@RefPersonFax varchar(30) = NULL,
	@RefPersonEmail varchar(255) = NULL,
	@ExamineeFileNum varchar(50) = NULL,
	@ExamineeDOI smalldatetime = NULL,
	@ExamineeDOB smalldatetime = NULL,
	@ExamineePrefix varchar(15) = NULL,
	@ExamineeFirstName varchar(30) = NULL,
	@ExamineeLastName varchar(30) = NULL,
	@ExamineeAddress1 varchar(30) = NULL,
	@ExamineeAddress2 varchar(30) = NULL,
	@ExamineeCity varchar(30) = NULL,
	@ExamineeProvince varchar(25) = NULL,
	@ExamineePostalCode varchar(15) = NULL,
	@ExamineePhone varchar(30) = NULL,
	@ExamineeFax varchar(30) = NULL,
	@ExamineeEmail varchar(255) = NULL,
	@ExamineeSSN varchar(15) = NULL,
	@ExamineeGender varchar(10) = NULL,
	@Transportation varchar(10) = NULL,
	@Interpretation varchar(10) = NULL,
	@Language varchar(50) = NULL,
	@AdditionalTransInterpNeeds varchar(2000) = NULL,
	@CorrespFirstName varchar(30) = NULL,
	@CorrespLastName varchar(30) = NULL,
	@CorrespEmail varchar(255) = NULL,
	@ReqPhysicianFirstName varchar(30) = NULL,
	@ReqPhysicianLastName varchar(30) = NULL,
	@ReqSpecialties varchar(4000) = NULL,
	@SubspecialtyExpertise varchar(4000) = NULL,
	@PhysSpecInstructions varchar(4000) = NULL,
	@PreferredTimeline varchar(4000) = NULL,
	@DiagInjDescMedBrief varchar(4000) = NULL,
	@DateAdded smalldatetime = NULL,
	@EWFacilityID int = NULL,
	@IPAddress varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblWebQRRequest]
	(
		[ReqService],
		[ReqType],
		[RefCompanyName],
		[RefCompanyAddress1],
		[RefCompanyAddress2],
		[RefCompanyCity],
		[RefCompanyProvince],
		[RefCompanyPostalCode],
		[RefPersonFirstName],
		[RefPersonLastName],
		[RefPersonOffice],
		[RefPersonPhone],
		[RefPersonFax],
		[RefPersonEmail],
		[ExamineeFileNum],
		[ExamineeDOI],
		[ExamineeDOB],
		[ExamineePrefix],
		[ExamineeFirstName],
		[ExamineeLastName],
		[ExamineeAddress1],
		[ExamineeAddress2],
		[ExamineeCity],
		[ExamineeProvince],
		[ExamineePostalCode],
		[ExamineePhone],
		[ExamineeFax],
		[ExamineeEmail],
		[ExamineeSSN],
		[ExamineeGender],
		[Transportation],
		[Interpretation],
		[Language],
		[AdditionalTransInterpNeeds],
		[CorrespFirstName],
		[CorrespLastName],
		[CorrespEmail],
		[ReqPhysicianFirstName],
		[ReqPhysicianLastName],
		[ReqSpecialties],
		[SubspecialtyExpertise],
		[PhysSpecInstructions],
		[PreferredTimeline],
		[DiagInjDescMedBrief],
		[DateAdded],
		[EWFacilityID],
		[IPAddress]
	)
	VALUES
	(
		@ReqService,
		@ReqType,
		@RefCompanyName,
		@RefCompanyAddress1,
		@RefCompanyAddress2,
		@RefCompanyCity,
		@RefCompanyProvince,
		@RefCompanyPostalCode,
		@RefPersonFirstName,
		@RefPersonLastName,
		@RefPersonOffice,
		@RefPersonPhone,
		@RefPersonFax,
		@RefPersonEmail,
		@ExamineeFileNum,
		@ExamineeDOI,
		@ExamineeDOB,
		@ExamineePrefix,
		@ExamineeFirstName,
		@ExamineeLastName,
		@ExamineeAddress1,
		@ExamineeAddress2,
		@ExamineeCity,
		@ExamineeProvince,
		@ExamineePostalCode,
		@ExamineePhone,
		@ExamineeFax,
		@ExamineeEmail,
		@ExamineeSSN,
		@ExamineeGender,
		@Transportation,
		@Interpretation,
		@Language,
		@AdditionalTransInterpNeeds,
		@CorrespFirstName,
		@CorrespLastName,
		@CorrespEmail,
		@ReqPhysicianFirstName,
		@ReqPhysicianLastName,
		@ReqSpecialties,
		@SubspecialtyExpertise,
		@PhysSpecInstructions,
		@PreferredTimeline,
		@DiagInjDescMedBrief,
		@DateAdded,
		@EWFacilityID,
		@IPAddress	
	)

	SET @Err = @@Error

	SELECT @QRRequestID = SCOPE_IDENTITY()

	RETURN @Err
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebQRConfig_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebQRConfig_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_WebQRConfig_LoadByPrimaryKey]
(
	@EWFacilityId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebQRConfig]
	WHERE
		([EWFacilityId] = @EWFacilityId)

	SET @Err = @@Error

	RETURN @Err
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetDoctorScheduleByDocCodeAndDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetDoctorScheduleByDocCodeAndDate];
GO

CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleByDocCodeAndDate]

@DoctorCode int,
@ApptDateStart smalldatetime,
@ApptDateEnd smalldatetime,
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int
	
	SELECT DISTINCT TOP 100 PERCENT 
		tblCase.casenbr, 
		tblCase.dateadded, 
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename, 
		tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
		tblCompany.intname AS companyname, 
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.ApptTime,
		tblCase.claimnbr, 
		tblLocation.Location,
		tblServices.description AS service, 
		tblCase.DoctorName AS provider, 
		tblWebQueues.description AS WebStatus, 
		tblWebQueues.statuscode, 
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr 
		FROM tblCase 
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
		INNER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
		INNER JOIN tblLocation on tblCase.DoctorLocation = tblLocation.LocationCode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
			AND tblPublishOnWeb.tabletype = 'tblCase' 
			AND tblPublishOnWeb.PublishOnWeb = 1 
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.DoctorCode = @DoctorCode)
		AND (tblCase.ApptDate >= @ApptDateStart)
		AND (tblCase.ApptDate <= @ApptDateEnd)
		AND (tblCase.status <> 0)
		ORDER BY tblLocation.Location, ApptTime

	SET @Err = @@Error

	RETURN @Err
END

GO

INSERT INTO [tbllanguage] ([Description])
 select 'Chuukese'
 where not exists (select description from tblLanguage where description='Chuukese')
GO

UPDATE tblControl SET DBVersion='2.20'
GO
