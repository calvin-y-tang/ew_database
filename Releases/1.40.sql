---------------------------------------------------------------------
--Include Int Company Name in vwDoctorSchedule
---------------------------------------------------------------------

ALTER VIEW [dbo].[vwDoctorSchedule]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, 
                        CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter,
                        tblDoctorSchedule.duration, tblCompany.intname AS CompanyIntName
FROM          dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                        dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                        dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      (dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'Hold') OR
                        ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                        AS panelnote, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter,
                        tblDoctorSchedule.duration, tblCompany.intname AS CompanyIntName
FROM          dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                        dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                        dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                        dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      ((dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'scheduled') OR
                        (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime

GO

---------------------------------------------------------
--Changes for Web Portal
---------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetReferralSearch]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetReferralSearch];
GO

CREATE PROCEDURE [proc_GetReferralSearch]

@WebUserID int = 0

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode, 
		tblCase.casenbr, 
		tblCase.DoctorName AS provider, 
		tblCase.ApptDate, 
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty, 
		tblServices.shortdesc AS service, 
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, 
		tblWebQueues.description AS WebStatus, 
		tblQueues.WebStatusCode, 
		tblWebQueues.statuscode, 
		tblCase.claimnbr, 
		tblWebUserAccount.WebUserID,
        ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr 
        FROM tblCase 
        INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
        INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
        INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
        INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
        INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode 
        INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode 
        INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
			AND tblPublishOnWeb.tabletype = 'tblCase' 
			AND tblPublishOnWeb.PublishOnWeb = 1 
        INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType 

	WHERE tblWebUserAccount.WebUserID = COALESCE(@WebUserID,tblWebUserAccount.WebUserID)
        
SET @Err = @@Error
RETURN @Err
	
GO


--------------------------------------------------------------------
--Add a field to control ScheduleViewer capability
--------------------------------------------------------------------


IF NOT EXISTS ( SELECT  *
                FROM    syscolumns
                WHERE   id = OBJECT_ID('tblControl')
                        AND name = 'UseScheduleViewer' ) 
ALTER TABLE [tblControl]
  ADD [UseScheduleViewer] BIT DEFAULT 0
  
GO


---------------------------------------------------------------------
--Add a new field to tblCase to determine the source application
---------------------------------------------------------------------

ALTER TABLE [tblCase]
  ADD [InputSourceID] INT
  
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Insert];
GO

CREATE PROCEDURE [proc_IMECase_Insert]
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
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqdegree varchar(20) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL
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
		[claimnbr],
		[dateofinjury],
		[allegation],
		[calledinby],
		[notes],
		[schedulenotes],
		[requesteddoc],
		[datemedsrecd],
		[typemedsrecd],
		[transreceived],
		[shownoshow],
		[rptstatus],
		[reportverbal],
		[emailclient],
		[emaildoctor],
		[emailPattny],
		[faxclient],
		[faxdoctor],
		[faxPattny],
		[apptrptsselect],
		[chartprepselect],
		[apptselect],
		[awaittransselect],
		[intransselect],
		[inqaselect],
		[drchartselect],
		[datedrchart],
		[billedselect],
		[miscselect],
		[invoicedate],
		[invoiceamt],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[WCBNbr],
		[specialinstructions],
		[usdvarchar1],
		[usdvarchar2],
		[usddate1],
		[usddate2],
		[usdtext1],
		[usdtext2],
		[usdint1],
		[usdint2],
		[usdmoney1],
		[usdmoney2],
		[bComplete],
		[bhanddelivery],
		[sinternalcasenbr],
		[sreqdegree],
		[sreqspecialty],
		[doctorspecialty],
		[feecode],
		[voucherselect],
		[voucheramt],
		[voucherdate],
		[icd9code],
		[reccode],
		[billclientcode],
		[billcompany],
		[billcontact],
		[billaddr1],
		[billaddr2],
		[billcity],
		[billstate],
		[billzip],
		[billARKey],
		[billfax],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[ICD9Code2],
		[ICD9Code3],
		[ICD9Code4],
		[PanelNbr],
		[DoctorName],
		[HearingDate],
		[CertMailNbr],
		[laststatuschg],
		[Jurisdiction],
		[prevappt],
		[mastersubcase],
		[mastercasenbr],
		[PublishOnWeb],
		[WebNotifyEmail],
		[AssessmentToAddress],
		[OCF25Date],
		[DateForminDispute],
		[AssessingFacility],
		[referralmethod],
		[referraltype],
		[CSR1],
		[CSR2],
		[LegalEvent],
		[PILegalEvent],
		[Transcode],
		[PublishDocuments],
		[DateReceived],
		[usddate3],
		[usddate4],
		[usddate5],
		[UsdBit1],
		[UsdBit2],
		[ClaimNbrExt],
		[DefParaLegal],
		[AttorneyNote],
		[BillingNote],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID]		
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
		@claimnbr,
		@dateofinjury,
		@allegation,
		@calledinby,
		@notes,
		@schedulenotes,
		@requesteddoc,
		@datemedsrecd,
		@typemedsrecd,
		@transreceived,
		@shownoshow,
		@rptstatus,
		@reportverbal,
		@emailclient,
		@emaildoctor,
		@emailPattny,
		@faxclient,
		@faxdoctor,
		@faxPattny,
		@apptrptsselect,
		@chartprepselect,
		@apptselect,
		@awaittransselect,
		@intransselect,
		@inqaselect,
		@drchartselect,
		@datedrchart,
		@billedselect,
		@miscselect,
		@invoicedate,
		@invoiceamt,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@WCBNbr,
		@specialinstructions,
		@usdvarchar1,
		@usdvarchar2,
		@usddate1,
		@usddate2,
		@usdtext1,
		@usdtext2,
		@usdint1,
		@usdint2,
		@usdmoney1,
		@usdmoney2,
		@bComplete,
		@bhanddelivery,
		@sinternalcasenbr,
		@sreqdegree,
		@sreqspecialty,
		@doctorspecialty,
		@feecode,
		@voucherselect,
		@voucheramt,
		@voucherdate,
		@icd9code,
		@reccode,
		@billclientcode,
		@billcompany,
		@billcontact,
		@billaddr1,
		@billaddr2,
		@billcity,
		@billstate,
		@billzip,
		@billARKey,
		@billfax,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@ICD9Code2,
		@ICD9Code3,
		@ICD9Code4,
		@PanelNbr,
		@DoctorName,
		@HearingDate,
		@CertMailNbr,
		@laststatuschg,
		@Jurisdiction,
		@prevappt,
		@mastersubcase,
		@mastercasenbr,
		@PublishOnWeb,
		@WebNotifyEmail,
		@AssessmentToAddress,
		@OCF25Date,
		@DateForminDispute,
		@AssessingFacility,
		@referralmethod,
		@referraltype,
		@CSR1,
		@CSR2,
		@LegalEvent,
		@PILegalEvent,
		@Transcode,
		@PublishDocuments,
		@DateReceived,
		@usddate3,
		@usddate4,
		@usddate5,
		@UsdBit1,
		@UsdBit2,
		@ClaimNbrExt,
		@DefParaLegal,
		@AttorneyNote,
		@BillingNote,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID		
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Update];
GO

CREATE PROCEDURE [proc_IMECase_Update]
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
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqdegree varchar(20) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL
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
		[claimnbr] = @claimnbr,
		[dateofinjury] = @dateofinjury,
		[allegation] = @allegation,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[datemedsrecd] = @datemedsrecd,
		[typemedsrecd] = @typemedsrecd,
		[transreceived] = @transreceived,
		[shownoshow] = @shownoshow,
		[rptstatus] = @rptstatus,
		[reportverbal] = @reportverbal,
		[emailclient] = @emailclient,
		[emaildoctor] = @emaildoctor,
		[emailPattny] = @emailPattny,
		[faxclient] = @faxclient,
		[faxdoctor] = @faxdoctor,
		[faxPattny] = @faxPattny,
		[apptrptsselect] = @apptrptsselect,
		[chartprepselect] = @chartprepselect,
		[apptselect] = @apptselect,
		[awaittransselect] = @awaittransselect,
		[intransselect] = @intransselect,
		[inqaselect] = @inqaselect,
		[drchartselect] = @drchartselect,
		[datedrchart] = @datedrchart,
		[billedselect] = @billedselect,
		[miscselect] = @miscselect,
		[invoicedate] = @invoicedate,
		[invoiceamt] = @invoiceamt,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[usdvarchar1] = @usdvarchar1,
		[usdvarchar2] = @usdvarchar2,
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usdtext1] = @usdtext1,
		[usdtext2] = @usdtext2,
		[usdint1] = @usdint1,
		[usdint2] = @usdint2,
		[usdmoney1] = @usdmoney1,
		[usdmoney2] = @usdmoney2,
		[bComplete] = @bComplete,
		[bhanddelivery] = @bhanddelivery,
		[sinternalcasenbr] = @sinternalcasenbr,
		[sreqdegree] = @sreqdegree,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[feecode] = @feecode,
		[voucherselect] = @voucherselect,
		[voucheramt] = @voucheramt,
		[voucherdate] = @voucherdate,
		[icd9code] = @icd9code,
		[reccode] = @reccode,
		[billclientcode] = @billclientcode,
		[billcompany] = @billcompany,
		[billcontact] = @billcontact,
		[billaddr1] = @billaddr1,
		[billaddr2] = @billaddr2,
		[billcity] = @billcity,
		[billstate] = @billstate,
		[billzip] = @billzip,
		[billARKey] = @billARKey,
		[billfax] = @billfax,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[ICD9Code2] = @ICD9Code2,
		[ICD9Code3] = @ICD9Code3,
		[ICD9Code4] = @ICD9Code4,
		[PanelNbr] = @PanelNbr,
		[DoctorName] = @DoctorName,
		[HearingDate] = @HearingDate,
		[CertMailNbr] = @CertMailNbr,
		[laststatuschg] = @laststatuschg,
		[Jurisdiction] = @Jurisdiction,
		[prevappt] = @prevappt,
		[mastersubcase] = @mastersubcase,
		[mastercasenbr] = @mastercasenbr,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[AssessmentToAddress] = @AssessmentToAddress,
		[OCF25Date] = @OCF25Date,
		[DateForminDispute] = @DateForminDispute,
		[AssessingFacility] = @AssessingFacility,
		[referralmethod] = @referralmethod,
		[referraltype] = @referraltype,
		[CSR1] = @CSR1,
		[CSR2] = @CSR2,
		[LegalEvent] = @LegalEvent,
		[PILegalEvent] = @PILegalEvent,
		[Transcode] = @Transcode,
		[PublishDocuments] = @PublishDocuments,
		[DateReceived] = @DateReceived,
		[usddate3] = @usddate3,
		[usddate4] = @usddate4,
		[usddate5] = @usddate5,
		[UsdBit1] = @UsdBit1,
		[UsdBit2] = @UsdBit2,
		[ClaimNbrExt] = @ClaimNbrExt,
		[DefParaLegal] = @DefParaLegal,
		[AttorneyNote] = @AttorneyNote,
		[BillingNote] = @BillingNote,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID			
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO


update tblControl set DBVersion='1.40'
GO
