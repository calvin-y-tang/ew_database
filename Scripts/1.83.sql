
DROP PROCEDURE [dbo].[spAvailableDoctors]
GO
CREATE PROCEDURE [dbo].[spAvailableDoctors]
    @startdate AS DATETIME ,
    @doctorcode AS INTEGER ,
    @locationcode AS INTEGER ,
    @city AS VARCHAR(50) ,
    @state AS VARCHAR(2) ,
    @vicinity AS VARCHAR(50) ,
    @county AS VARCHAR(50) ,
    @degree AS VARCHAR(50) ,
    @KeyWordIDs AS VARCHAR(100) ,
    @Specialties AS VARCHAR(200) ,
    @PanelExam AS BIT ,
    @ProvTypeCode AS INTEGER ,
    @EWAccreditationID AS INTEGER
AS 
    DECLARE @sColumns VARCHAR(2000)
    DECLARE @sFrom VARCHAR(2000)
    DECLARE @sWhere VARCHAR(2000)
    DECLARE @sGroupBy VARCHAR(2000)
    DECLARE @sHaving VARCHAR(2000)
    DECLARE @sSqlString NVARCHAR(4000)
    DECLARE @sOrderBy VARCHAR(1000)


    SET @sColumns = 'dbo.tblDoctor.lastname + '', '' + isnull(dbo.tblDoctor.firstname,'''') AS doctorname, dbo.tblDoctor.status, '
        + 'dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, MIN(dbo.tblDoctorSchedule.date) AS firstavail, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblDoctor.prepaid, dbo.tblLocation.vicinity, dbo.tblLocation.county, dbo.tblLocation.zip, dbo.tblDoctor.credentials AS degree, '
        + 'CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end AS sortorder, dbo.tbllocation.locationcode, dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype  ' 
    SET @sFrom = 'FROM         dbo.tblLocation INNER JOIN '
        + 'dbo.tblDoctorLocation ON dbo.tblLocation.locationcode = dbo.tblDoctorLocation.locationcode LEFT OUTER JOIN '
        + 'dbo.tblDoctorSchedule ON dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode AND '
        + 'dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSchedule.doctorcode LEFT OUTER JOIN '
        + 'dbo.tblDoctor ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctor.doctorcode ' 

    SET @sWhere = ''
	
    SET @sGroupBy = 'GROUP BY ALL dbo.tblDoctor.status, dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblLocation.vicinity, dbo.tblDoctor.prepaid, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblLocation.county, '
        + 'dbo.tblLocation.zip, dbo.tblDoctor.credentials, dbo.tblDoctorLocation.status,CASE WHEN (dbo.tblDoctorSchedule.date) is null then 1 else 0 end,dbo.tbllocation.locationcode,dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype ' 

    SET @sHaving = 'HAVING (dbo.tblDoctor.status = ''Active'') AND '
        + '(dbo.tblDoctorLocation.status = ''Active'') AND dbo.tbldoctor.OPType = ''DR'' '

	SET @sOrderBy = ''

	--Use different where and having clause for panel exam
    IF @PanelExam IS NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', MIN(dbo.tblDoctorSchedule.starttime) AS starttime ' 

            SET @sWhere = 'WHERE ( (dbo.tblDoctorSchedule.date >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'') OR '
                + '(dbo.tblDoctorSchedule.date IS NULL AND dbo.tblDoctorSchedule.status IS NULL)) '  

            SET @sOrderBy = 'ORDER BY dbo.tblDoctor.schedulepriority,CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end, MIN(dbo.tblDoctorSchedule.date), dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, '''') '
        END
    ELSE 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSchedule.starttime AS starttime, dbo.tbldoctorschedule.status, '
                + '(select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + 'a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') as apptcount '
            SET @sGroupBy = @sGroupBy
                + ', dbo.tblDoctorSchedule.starttime, dbo.tblDoctorSchedule.status '
            SET @sWhere = ' '  
            SET @sHaving = @sHaving
                + ' AND (dbo.tbldoctorschedule.starttime >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'')  '
                + ' and (select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + ' a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') > 1 '
            SET @sOrderBy = 'ORDER BY dbo.tblDoctorSchedule.starttime, dbo.tbllocation.location, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblSpecialty.description '
        END


	-- if specialties exist, add the appropriate statements to the select clause
    IF @Specialties IS NOT NULL 
        BEGIN
            SET @specialties = REPLACE(@Specialties, '*', '''')
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sFrom = @sFrom
                + ' INNER JOIN dbo.tblDoctorSpecialty ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSpecialty.doctorcode INNER JOIN '
                + ' dbo.tblSpecialty ON dbo.tblDoctorSpecialty.specialtycode = dbo.tblSpecialty.specialtycode '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorSpecialty.specialtycode in ('
                + @Specialties + ') ) '

        END
	-- if keywords exist, add the appropriate statements to the select clause
    IF @KeyWordIDs IS NOT NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sFrom = @sFrom
                + 'INNER JOIN dbo.tblDoctorKeyWord ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorKeyWord.doctorcode INNER JOIN '
                + 'dbo.tblKeyWord ON dbo.tblDoctorKeyWord.keywordID = dbo.tblKeyWord.keywordID '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorKeyWord.KeyWordID in (' + @KeywordIDs
                + ') ) '
        END




	--Filter data if parameter is supplied
    IF @doctorcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbldoctor.doctorcode = '
                + CAST(@doctorcode AS VARCHAR(10)) + ') ' 
        END

    IF @locationcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctorlocation.locationcode = '
                + CAST(@locationcode AS VARCHAR(10)) + ') ' 
        END
    IF @city IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.city = '''
                + @city + ''') ' 
        END
    IF @state IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.state = '''
                + @state + ''') ' 
        END

    IF @vicinity IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbllocation.vicinity = ''' + @vicinity + ''') ' 
        END

    IF @county IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.county = '''
                + @county + ''') ' 
        END

    IF @degree IS NOT NULL 
        BEGIN

            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.credentials = ''' + @degree + ''') ' 
        END

    IF @ProvtypeCode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.provtypecode = '
                + CAST(@ProvTypeCode AS VARCHAR(10)) + ') ' 
        END

	--Check for Accreditation        
    IF @EWAccreditationID IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + 'tblDoctor.DoctorCode in (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID='
                + CAST(@EWAccreditationID AS VARCHAR) + ')'
        END



-- build sql statement
    SET @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + @sGroupby + ' ' + @sHaving + ' '
        + @sOrderby

   --print '@scolumns ' + @scolumns
   --print '@sfrom ' + @sfrom
   --print '@swhere ' + @swhere
   --print '@sgroupby ' + @sgroupby
   --print '@shaving ' + @shaving
   --print '@sorderby ' + @sorderby
   --print 'sqlstring ' +  @ssqlstring

-- execute sql statement
    EXEC Sp_executesql @sSqlString


GO



/****** Object:  StoredProcedure [proc_GetProblemComboItems]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetProblemComboItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetProblemComboItems];
GO

CREATE PROCEDURE [proc_GetProblemComboItems]

AS

SELECT problemcode, description from tblProblem 
WHERE PublishOnWeb = 1
	AND Status = 'Active'
ORDER BY description

GO

/****** Object:  StoredProcedure [proc_IMECase_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
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
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL
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
		[InputSourceID],
		[ReqEWAccreditationID],
		[RptInitialDraftDate],
		[RptSentDate]				
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
		@InputSourceID,		
		@ReqEWAccreditationID,
		@RptInitialDraftDate,
		@RptSentDate
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_IMECase_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
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
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL
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
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[RptInitialDraftDate] =	@RptInitialDraftDate,
		[RptSentDate] =	@RptSentDate					
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO


--Changes by Gary
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetReferralsByClaimantAndClaim]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetReferralsByClaimantAndClaim];
GO

CREATE PROCEDURE [dbo].[proc_GetReferralsByClaimantAndClaim]

@WebUserID int,
@ClaimNbr varchar(50),
@Chartnbr int,
@CaseNbr int

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
		tblCase.claimnbr, 
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
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
			AND tblPublishOnWeb.tabletype = 'tblCase' 
			AND tblPublishOnWeb.PublishOnWeb = 1 
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		AND (tblCase.ClaimNbr = @ClaimNbr OR tblCase.ChartNbr = @ChartNbr)
		AND (tblCase.CaseNbr <> @CaseNbr)


	SET @Err = @@Error

	RETURN @Err
END

GO


UPDATE tblControl SET DBVersion='1.83'
GO
