PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [UseUDF] BIT CONSTRAINT [DF_tblControl_UseUDF] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblDoctorOffice]...';


GO
ALTER TABLE [dbo].[tblDoctorOffice]
    ADD [FeeCode] INT NULL;


GO





PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusSchedulerCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeStatusSchedulerCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentDateDocumentStatus]...';


GO
DROP INDEX [IX_tblAcctHeader_DocumentDateDocumentStatus]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentTypeDocumentDateDocumentStatus]...';


GO
DROP INDEX [IX_tblAcctHeader_DocumentTypeDocumentDateDocumentStatus]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblCaseOtherParty].[IX_tblCaseOtherParty_DueDate]...';


GO
DROP INDEX [IX_tblCaseOtherParty_DueDate]
    ON [dbo].[tblCaseOtherParty];


GO
PRINT N'Dropping [dbo].[tblDoctor].[IX_tblDoctor_OPTypeOPSubType]...';


GO
DROP INDEX [IX_tblDoctor_OPTypeOPSubType]
    ON [dbo].[tblDoctor];


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusSchedulerCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatusSchedulerCode]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC, [SchedulerCode] ASC)
    INCLUDE([ClientCode], [Priority], [QARep], [MarketerCode], [DoctorCode], [DoctorLocation], [ServiceCode], [CaseType]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateReceivedEWReferralTypeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateReceivedEWReferralTypeStatus]
    ON [dbo].[tblCase]([DateReceived] ASC, [EWReferralType] ASC, [Status] ASC)
    INCLUDE([CaseNbr], [ChartNbr], [ClientCode], [MarketerCode], [CaseType], [ApptTime], [ServiceCode], [DoctorCode], [OfficeCode], [Jurisdiction], [ForecastDate], [InputSourceID]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateReceivedOfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateReceivedOfficeCode]
    ON [dbo].[tblCase]([DateReceived] ASC, [OfficeCode] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentTypeDocumentStatusDocumentDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentTypeDocumentStatusDocumentDate]
    ON [dbo].[tblAcctHeader]([DocumentType] ASC, [DocumentStatus] ASC, [DocumentDate] ASC)
    INCLUDE([CaseNbr], [CompanyCode], [HeaderID]);


GO
PRINT N'Creating [dbo].[tblDoctorSchedule].[IX_tblDoctorSchedule_dateDoctorCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_dateDoctorCode]
    ON [dbo].[tblDoctorSchedule]([date] ASC, [DoctorCode] ASC);


GO
PRINT N'Altering [dbo].[vw_WebCaseSummary]...';


GO
ALTER VIEW vw_WebCaseSummary

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.ExtCaseNbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	tblCase.dateofinjury2,
	tblCase.dateofinjury3,
	tblCase.dateofinjury4,
	tblCase.notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
GO
PRINT N'Altering [dbo].[vw_WebCaseSummaryExt]...';


GO
ALTER VIEW vw_WebCaseSummaryExt

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.ExtCaseNbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	tblCase.dateofinjury2,
	tblCase.dateofinjury3,
	tblCase.dateofinjury4,
	tblCase.notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.TransportationRequired,
	tblCase.InterpreterRequired,
	tblCase.LanguageID,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.TreatingPhysicianDiagnosis,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,
	tblExaminee.note AS StateDirected,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,
	tblClient.phone1 AS ClientPhone,
	tblClient.email AS ClientEmail,
	tblClient.fax AS ClientFax,
	tblClient.notes AS ClientOffice,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix,

	--company
	tblCompany.extname AS InsCompanyName,
	tblCompany.addr1 AS InsCompanyAddress1,
	tblCompany.addr2 AS InsCompanyAddress2,
	tblCompany.city AS InsCompanyCity,
	tblCompany.state AS InsCompanyState,
	tblCompany.zip AS InsCompanyZip,

	--case manager
	tblRelatedParty.firstname AS CaseManagerFirstName,
	tblRelatedParty.lastname AS CaseManagerLastName,
	tblRelatedParty.address1 AS CaseManagerAddress1,
	tblRelatedParty.address2 AS CaseManagerAddress2,
	tblRelatedParty.city AS CaseManagerCity,
	tblRelatedParty.state AS CaseManagerState,
	tblRelatedParty.zip as CaseManagerZip,
	tblRelatedParty.companyname AS CaseManagerOffice,
	tblRelatedParty.phone as CaseManagerPhone,
	tblRelatedParty.fax as CaseManagerFax,
	tblRelatedParty.email as CaseManagerEmail,

	--language
	tblLanguage.Description as LanguageDescription

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
	LEFT OUTER  JOIN tblLanguage ON tblCase.LanguageID = tblLanguage.LanguageID
	LEFT OUTER JOIN tblCaseRelatedParty ON tblCase.casenbr = tblCaseRelatedParty.casenbr
	LEFT OUTER JOIN tblRelatedParty ON tblCaseRelatedParty.RPCode = tblRelatedParty.RPCode
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
GO
PRINT N'Altering [dbo].[proc_GetSuperUserComboItems]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetSuperUserComboItems]

AS

SELECT DISTINCT tblwebuseraccount.webuserid AS webID, tblCompany.intname company, tblCompany.intname + ' - ' + lastname + ', ' + firstname name 
	FROM tblclient 
	INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(company,'N/A') company, ISNULL(company,'N/A') + ' - ' +  lastname + ', ' + firstname name 
	FROM tblCCAddress 
	INNER JOIN tblwebuseraccount ON tblCCAddress.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(companyname,'N/A') company, ISNULL(companyname,'N/A') + ' - ' + lastname + ', ' + firstname  name 
	FROM tblDoctor 
	INNER JOIN tblwebuseraccount ON tblDoctor.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
	FROM tblTranscription 
	INNER JOIN tblwebuseraccount ON tblTranscription.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND tblWebUserAccount.UserType = 'TR' 
ORDER BY company, name
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_IMECase_Insert]...';


GO
ALTER PROCEDURE [proc_IMECase_Insert]
(
	@casenbr int = NULL output,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@BillingNote text = NULL
	)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCase]
	(
		[chartnbr],
		[doctorlocation],
		[clientcode],
		[marketercode],
		[schedulercode],
		[priority],
		[status],
		[casetype],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[schedcode],
		[ApptDate],
		[Appttime],
		[ApptMadeDate],
		[claimnbr],
		[dateofinjury],
		[dateofinjury2],
		[dateofinjury3],
		[dateofinjury4],
		[calledinby],
		[notes],
		[AttorneyNote],
		[schedulenotes],
		[requesteddoc],
		[reportverbal],
		[TransCode],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[DoctorName],
		[WCBNbr],
		[specialinstructions],
		[sreqspecialty],
		[doctorspecialty],
		[reccode],
		[Jurisdiction],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[HearingDate],
		[laststatuschg],
		[PublishOnWeb],
		[WebNotifyEmail],
		[DateReceived],
		[ClaimNbrExt],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID],
		[ReqEWAccreditationID],
		[ApptStatusId],
		[CaseApptId],
		[BillingNote]			
	)
	VALUES
	(
		@chartnbr,
		@doctorlocation,
		@clientcode,
		@marketercode,
		@schedulercode,
		@priority,
		@status,
		@casetype,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@schedcode,
		@ApptDate,
		@Appttime,
		@ApptMadeDate,
		@claimnbr,
		@dateofinjury,
		@dateofinjury2,
		@dateofinjury3,
		@dateofinjury4,
		@calledinby,
		@notes,
		@AttorneyNote,
		@schedulenotes,
		@requesteddoc,
		@reportverbal,
		@TransCode,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@DoctorName,
		@WCBNbr,
		@specialinstructions,
		@sreqspecialty,
		@doctorspecialty,
		@reccode,
		@Jurisdiction,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@HearingDate,
		@laststatuschg,
		@PublishOnWeb,
		@WebNotifyEmail,
		@DateReceived,
		@ClaimNbrExt,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID,		
		@ReqEWAccreditationID,
		@ApptStatusId,
		@CaseApptId,
		@BillingNote		
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_IMECase_Update]...';


GO
ALTER PROCEDURE [proc_IMECase_Update]
(
	@casenbr int,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@BillingNote text = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[chartnbr] = @chartnbr,
		[doctorlocation] = @doctorlocation,
		[clientcode] = @clientcode,
		[marketercode] = @marketercode,
		[schedulercode] = @schedulercode,
		[priority] = @priority,
		[status] = @status,
		[casetype] = @casetype,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[schedcode] = @schedcode,
		[ApptDate] = @ApptDate,
		[Appttime] = @Appttime,
		[ApptMadeDate] = @ApptMadeDate,
		[claimnbr] = @claimnbr,
		[dateofinjury] = @dateofinjury,
		[dateofinjury2] = @dateofinjury2,
		[dateofinjury3] = @dateofinjury3,
		[dateofinjury4] = @dateofinjury4,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[AttorneyNote] = @AttorneyNote,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[reportverbal] = @reportverbal,
		[TransCode] = @TransCode,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[DoctorName] = @DoctorName,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[reccode] = @reccode,
		[Jurisdiction] = @Jurisdiction,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[HearingDate] = @HearingDate,
		[laststatuschg] = @laststatuschg,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[DateReceived] = @DateReceived,
		[ClaimNbrExt] = @ClaimNbrExt,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[ApptStatusId] = @ApptStatusId,
		[CaseApptId] = @CaseApptId,
		[BillingNote] = @BillingNote
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO
























UPDATE tblControl SET CbxWaitInterval=500
GO

UPDATE tblServices SET CaseRecdDateOverride = 1 WHERE EWServiceTypeID IN 
(SELECT EWServiceTypeID FROM tblEWServiceType WHERE EWServiceTypeID IN (2, 3, 4, 5))
GO

insert into tblMessageToken 
values ('@DOISecond@',' ')
Go

insert into tblMessageToken 
values ('@DOIThird@',' ')
Go

insert into tblMessageToken 
values ('@DOIFourth@',' ')
Go

INSERT into tblMessageToken 
values ('@DOIList@','')
GO

INSERT INTO tblUserFunction
        ( FunctionCode, FunctionDesc )
VALUES  ( 'ViewFeeScheduleAbeton', -- FunctionCode - varchar(30)
          'Fee Schedule (Abeton) - View'  -- FunctionDesc - varchar(50)
          )
GO


UPDATE tblControl SET DBVersion='2.81'
GO

