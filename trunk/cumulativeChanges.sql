---------------------------------------------------------------------------------
--Changes after DB Release 2.60
---------------------------------------------------------------------------------

ALTER TABLE [tblEWWebUser]
  ADD [ShowThirdPartyBilling] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblWebUser]
  ADD [ShowThirdPartyBilling] BIT DEFAULT 0 NOT NULL
GO


--------------------------BEGIN PROC 1--------------------------

/****** Object:  StoredProcedure [proc_EWWebUser_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWWebUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWWebUser_Update];
GO

CREATE PROCEDURE [proc_EWWebUser_Update]
(
	@EWWebUserID int,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@UserType varchar(2),
	@EWEntityID int,
	@ProviderSearch bit,
	@AutoPublishNewCases bit,
	@DisplayClient bit,
	@StatusID int = NULL,
	@LastLoginDate datetime = NULL,
	@FailedLoginAttempts int = NULL,
	@LockoutDate datetime = NULL,
	@LastPasswordChangeDate datetime = NULL,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@ShowThirdPartyBilling bit
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [EWWebUser]
	SET
		[UserID] = @UserID,
		[Password] = @Password,
		[UserType] = @UserType,
		[EWEntityID] = @EWEntityID,
		[ProviderSearch] = @ProviderSearch,
		[AutoPublishNewCases] = @AutoPublishNewCases,
		[DisplayClient] = @DisplayClient,
		[StatusID] = @StatusID,
		[LastLoginDate] = @LastLoginDate,
		[FailedLoginAttempts] = @FailedLoginAttempts,
		[LockoutDate] = @LockoutDate,
		[LastPasswordChangeDate] = @LastPasswordChangeDate,
		[DateAdded] = @DateAdded,
		[UseridAdded] = @UseridAdded,
		[DateEdited] = @DateEdited,
		[UseridEdited] =@UseridEdited,
		[ShowThirdPartyBilling] = @ShowThirdPartyBilling	
	WHERE
		[EWWebUserID] = @EWWebUserID


	SET @Err = @@Error


	RETURN @Err
END
GO

--------------------------END PROC 1----------------------------

GO

--------------------------BEGIN PROC 2--------------------------

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
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usddate3 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
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
		[usddate1],
		[usddate2],
		[usddate3],
		[calledinby],
		[notes],
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
		@usddate1,
		@usddate2,
		@usddate3,
		@calledinby,
		@notes,
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


--------------------------END PROC 2----------------------------

GO

--------------------------BEGIN PROC 3--------------------------

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
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usddate3 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
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
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usddate3] = @usddate3,
		[calledinby] = @calledinby,
		[notes] = @notes,
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

--------------------------END PROC 3----------------------------

GO

--------------------------BEGIN PROC 4--------------------------

/****** Object:  StoredProcedure [proc_WebUser_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebUser_Update];
GO

CREATE PROCEDURE [proc_WebUser_Update]
(
	@WebUserID int,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@LastLoginDate datetime = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@UseridEdited varchar(50) = NULL,
	@DisplayClient bit,
	@ProviderSearch bit,
	@IMECentricCode int,
	@UserType varchar(2),
	@AutoPublishNewCases bit,
	@IsClientAdmin bit,
	@UpdateFlag bit,
	@LastPasswordChangeDate datetime = NULL,
	@StatusID int = NULL,
	@FailedLoginAttempts int = NULL,
	@LockoutDate datetime = NULL,
	@ShowThirdPartyBilling bit
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblWebUser]
	SET
		[UserID] = @UserID,
		[Password] = @Password,
		[LastLoginDate] = @LastLoginDate,
		[DateAdded] = @DateAdded,
		[DateEdited] = @DateEdited,
		[UseridAdded] = @UseridAdded,
		[UseridEdited] = @UseridEdited,
		[DisplayClient] = @DisplayClient,
		[ProviderSearch] = @ProviderSearch,
		[IMECentricCode] = @IMECentricCode,
		[UserType] = @UserType,
		[AutoPublishNewCases] = @AutoPublishNewCases,
		[IsClientAdmin] = @IsClientAdmin,
		[UpdateFlag] = @UpdateFlag,
		[LastPasswordChangeDate] = @LastPasswordChangeDate,
		[StatusID] = @StatusID,
		[FailedLoginAttempts] = @FailedLoginAttempts,
		[LockoutDate] = @LockoutDate,
		[ShowThirdPartyBilling] = @ShowThirdPartyBilling
	WHERE
		[WebUserID] = @WebUserID


	SET @Err = @@Error


	RETURN @Err
END
GO

--------------------------END PROC 4----------------------------

GO


-- 10/14 MHL Issue 3423 Addition of tblFacilities to vwCaseOtherContacts
DROP VIEW [dbo].[vwCaseOtherContacts]
GO

CREATE VIEW [dbo].[vwCaseOtherContacts]
AS
SELECT CaseNbr, 'CC' AS Type, FirstName, LastName, Company, Email, Fax from vwCaseCC
UNION
SELECT C.CaseNbr, 'DefAttny', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON DefenseAttorneyCode=CCCode
UNION
SELECT C.CaseNbr, 'DefParalegal:', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON C.DefParaLegal=CCCode
UNION
SELECT casenbr, type, firstname, lastname, companyname, emailAddr, faxNbr from vwCaseOtherParty
UNION
SELECT C.CaseNbr, 'ExamLoc', L.ContactFirst, L.ContactLast, L.Location, L.Email, L.Fax FROM tblCase AS C INNER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
UNION
SELECT C.CaseNbr, 'Treat Phy', E.TreatingPhysician, '', '', E.TreatingPhysicianEmail, E.TreatingPhysicianFax FROM tblCase AS C INNER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
UNION
SELECT C.CaseNbr, '3rd Party', CL.FirstName, CL.LastName, COM.IntName, CL.Email, COALESCE(NULLIF(CL.BillFax,''), NULLIF(CL.Fax,'')) FROM tblCase AS C INNER JOIN tblClient AS CL ON C.BillClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT C.CaseNbr, 'Processor', CL.ProcessorFirstName, CL.ProcessorLastName, COM.IntName, CL.ProcessorEmail, CL.ProcessorFax FROM tblCase AS C INNER JOIN tblClient AS CL ON C.ClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT TRO.CaseNbr, 'Facility', TF.ContactFirst, TF.ContactLast, TF.Name, TF.Email, TF.Fax FROM tblCase AS C INNER JOIN tblRecordsObtainment AS TRO ON TRO.CaseNbr = C.CaseNbr INNER JOIN tblFacility AS TF ON TF.FacilityID = TRO.FacilityID

GO



ALTER TABLE [tblCase]
  ADD [PhotoRcvd] BIT DEFAULT 0 NOT NULL
GO


10/28 MHL Issue 3304 Add Case Cancelled Trigger and Change Cancellation to Appointment Cancellation.

UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation' 
WHERE [ExceptionID] = 1;

UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation with a Pre-Invoice Client' 
WHERE [ExceptionID] = 2;

UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation with a Pre-Pay Doctor' 
WHERE [ExceptionID] = 3;

INSERT INTO [dbo].[tblExceptionList]
([Description], [Status], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited])
VALUES ('Case Cancellation', 'Active', GetDate(), 'Admin', GetDate(), 'Admin')


-- 11/3 DMR Issue 3452 
Update tblCompany set PhotoRqd = 0 where PhotoRqd is null

Update tblCase set PhotoRqd = 0 where PhotoRqd is null 

Update tblClient 
   set PhotoRqd = null 
  from tblClient cl 
          inner join tblCompany co on cl.CompanyCode = co.CompanyCode 
where cl.PhotoRqd = co.PhotoRqd


DROP VIEW [vwClientDefaults]
GO

CREATE VIEW [dbo].[vwClientDefaults]
AS
    SELECT  tblClient.marketercode AS clientmarketer ,
            dbo.tblCompany.intname ,
            dbo.tblClient.reportphone ,
            dbo.tblClient.priority ,
            dbo.tblClient.clientcode ,
            dbo.tblClient.fax ,
            dbo.tblClient.email ,
            dbo.tblClient.phone1 ,
            dbo.tblClient.documentemail AS emailclient ,
            dbo.tblClient.documentfax AS faxclient ,
            dbo.tblClient.documentmail AS mailclient ,
            ISNULL(dbo.tblClient.casetype, tblCompany.CaseType) AS CaseType ,
            dbo.tblClient.feeschedule ,
            dbo.tblCompany.credithold ,
            dbo.tblCompany.preinvoice ,
            dbo.tblClient.billaddr1 ,
            dbo.tblClient.billaddr2 ,
            dbo.tblClient.billcity ,
            dbo.tblClient.billstate ,
            dbo.tblClient.billzip ,
            dbo.tblClient.billattn ,
            dbo.tblClient.ARKey ,
            dbo.tblClient.addr1 ,
            dbo.tblClient.addr2 ,
            dbo.tblClient.city ,
            dbo.tblClient.state ,
            dbo.tblClient.zip ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname ,
            dbo.tblClient.prefix AS clientprefix ,
            dbo.tblClient.suffix AS clientsuffix ,
            dbo.tblClient.lastname ,
            dbo.tblClient.firstname ,
            dbo.tblClient.billfax ,
            dbo.tblClient.QARep ,
            ISNULL(dbo.tblClient.photoRqd, tblCompany.photoRqd) AS photoRqd ,
            dbo.tblClient.CertifiedMail ,
            dbo.tblClient.PublishOnWeb ,
            dbo.tblClient.UseNotificationOverrides ,
            dbo.tblClient.CSR1 ,
            dbo.tblClient.CSR2 ,
            dbo.tblClient.AutoReschedule ,
            dbo.tblClient.DefOfficeCode ,
            ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer ,
            dbo.tblCompany.Jurisdiction
    FROM    dbo.tblClient
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode



GO

-- End Issue 3452 

-- 11/3 MHL Issue 3444 Add tblcasetrans column for voucher/invoice selection, update view

ALTER TABLE tblCaseTrans
  ADD CreateInvoiceVoucher bit DEFAULT(0);

GO

DROP VIEW vwCaseTrans
GO
CREATE VIEW vwCaseTrans

AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DocumentNbr ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode,
			tblCaseTrans.CreateInvoiceVoucher
    FROM    TblCaseTrans
    WHERE   ( documentnbr IS NULL )


GO


ALTER TABLE tblIMEData
 ADD ShowCaseNotification BIT NOT NULL DEFAULT 0
GO

ALTER TABLE tblIMEData
 ADD UseICDRequest BIT NOT NULL DEFAULT 0
GO

ALTER TABLE tblControl
 ADD AllowCompanyCPTOverride BIT NOT NULL DEFAULT 0
GO

INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'CustomMEIProgram' ,
                'Custom - MEI Program'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CustomMEIProgram' )

GO
INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'CustomFMSProgram' ,
                'Custom - FMS Program'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CustomFMSProgram' )

GO
INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'RptDrDistribution' ,
                'Report - Doctor Distribution'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'RptDrDistribution' )

GO

DELETE FROM tblUserFunction
 WHERE FunctionCode='edituserdefined'
DELETE FROM tblGroupFunction
 WHERE FunctionCode='edituserdefined'
DELETE FROM tblUserOfficeFunction
 WHERE FunctionCode='edituserdefined'
GO



IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblAddendumCodes]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblAddendumCodes
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblAnnouncement]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblAnnouncement
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblBillStatus]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblBillStatus
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseAndClient]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseAndClient
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseTypeJurisdictionTerms]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseTypeJurisdictionTerms
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseTypeServiceDocument]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseTypeServiceDocument
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCCaddresstemp]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCCaddresstemp
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCompanyccEnvelope]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCompanyccEnvelope
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblDoctorImport]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblDoctorImport
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblFRCategoryBak]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblFRCategoryBak
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblGPCaseType]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblGPCaseType
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblGPOffice]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblGPOffice
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblInterfaceLog]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblInterfaceLog
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblMRU]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblMRU
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionCase]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionCase
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionDescription]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionDescription
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionHeading]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionHeading
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionInstruction]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionInstruction
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionIssue]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionIssue
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionProblem]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionProblem
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionResponse]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionResponse
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblRating]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblRating
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReferralmethod]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReferralmethod
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReferralType]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReferralType
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblRegion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblRegion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReport]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReport
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReportQuestion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReportQuestion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblSpecialtyXref]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblSpecialtyXref
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTreatingPhysician]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTreatingPhysician
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempCustomers]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempCustomers
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempInvoices]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempInvoices
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempVendors]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempVendors
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempVouchers]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempVouchers
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblWebApptRequestReceived]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblWebApptRequestReceived
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblFRModifier]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblFRModifier
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblProviderPercent]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblProviderPercent

GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[spCase_GetDocumentPath]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [spCase_GetDocumentPath];
GO

CREATE PROCEDURE [dbo].[spCase_GetDocumentPath]
 @CaseNbr int,
 @DocType varchar(25) = NULL,
 @DocPath varchar(90) OUTPUT
AS
BEGIN
 DECLARE @BasePath varchar(70), @CaseAddedDate datetime, @DateCode varchar(7)

 -- STEP 1: Get The Case Added Date
 SELECT @CaseAddedDate = dateadded 
 FROM tblCase
 WHERE CaseNbr = @CaseNbr

 -- RETURN Error 99 if no case found
 IF (ISDATE(@CaseAddedDate) = 0) 
 BEGIN
  RETURN 99
 END
 
 -- STEP 2. Get The Document Base Path
 IF @DocType = 'invoice' OR @DocType = 'voucher'
  BEGIN
   SELECT @BasePath = dirAcctDocument 
   FROM tblIMEData 
  END
 IF @DocType = 'trans' 
  BEGIN
   SELECT @BasePath = dirTranscription 
	FROM tblIMEData  
  END
 ELSE IF (@BasePath IS NULL)
  BEGIN
   SELECT @BasePath = dirdocument 
	FROM tblIMEData  
  END

 -- RETURN Error 98, no base path found
 IF (@BasePath IS NULL)
 BEGIN
  RETURN 98
 END

 -- STEP 3. Get The Date Code (use YY-MM of case added), pad with zero if neccessary
 SET @DateCode = CONVERT(varchar(4), YEAR(@CaseAddedDate)) + '-'
 IF (MONTH(@CaseAddedDate) < 10)
 BEGIN
  SET @DateCode = @DateCode + '0'
 END
 SET @DateCode = @DateCode + CONVERT(varchar(2), MONTH(@CaseAddedDate))
 
 -- Step 4. Combine The Base Directory with the date code (Base Directory (with trailing \) + Date Code + \ + CaseNbr + \) 
 SET @DocPath = @BasePath + @DateCode + '\' + CONVERT(varchar(20), @CaseNbr) + '\'

END


GO

ALTER TABLE [tblCompany]
  ADD Prompt3rdPartyBill BIT NOT NULL DEFAULT 0
GO




DROP VIEW vwCaseAppt
GO
CREATE VIEW vwCaseAppt
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
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(100)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS Specialties,
          CA.DateReceived, 
          FZ.Name AS FeeZoneName,
		  C.OfficeCode
     FROM tblCaseAppt AS CA
	 INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
     LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID

GO


DROP VIEW vwPDFCaseData
GO
CREATE VIEW vwPDFCaseData
AS
    SELECT  C.CaseNbr ,
			C.PanelNbr ,
			C.OfficeCode ,
            C.ClaimNbr ,
            C.Jurisdiction ,
            C.WCBNbr ,
            
			C.DoctorCode AS CaseDoctorCode ,
            C.DoctorLocation AS CaseLocationCode ,
			C.DoctorSpecialty AS CaseDoctorSpecialty ,
            C.DoctorName ,
            C.ApptDate ,
            C.ApptTime ,

			C.MasterCaseNbr ,
			C.MasterSubCase ,
			B.BlankValue AS MasterCaseDoctorName ,
			B.BlankValue AS MasterCaseDoctorNPINbr ,
			B.BlankValue AS MasterCaseDoctorLicense ,
			B.BlankValue AS MasterCaseDoctorLicQualID ,
            
			C.DateOfInjury AS DOIValue ,
			B.BlankValue AS DOI ,
			B.BlankValue AS InjuryCurrentDateMM ,
			B.BlankValue AS InjuryCurrentDateDD ,
			B.BlankValue AS InjuryCurrentDateYYYY ,
			CASE WHEN C.DateOfInjury IS NULL THEN '' ELSE '431' END AS InjuryCurrentDateQual ,

			B.BlankValue AS ICD9Code1a ,
			B.BlankValue AS ICD9Code1b ,
			B.BlankValue AS ICD9Code1c ,
			B.BlankValue AS ICD9Code2a ,
			B.BlankValue AS ICD9Code2b ,
			B.BlankValue AS ICD9Code2c ,
			B.BlankValue AS ICD9Code3a ,
			B.BlankValue AS ICD9Code3b ,
			B.BlankValue AS ICD9Code3c ,
			B.BlankValue AS ICD9Code4a ,
			B.BlankValue AS ICD9Code4b ,
			B.BlankValue AS ICD9Code4c ,

            C.ICDCodeA AS ICD9Code1 ,
            C.ICDCodeB AS ICD9Code2 ,
            C.ICDCodeC AS ICD9Code3 ,
            C.ICDCodeD AS ICD9Code4 ,
			C.ICDCodeA ,
			C.ICDCodeB ,
			C.ICDCodeC ,
			C.ICDCodeD ,
			C.ICDCodeE ,
			C.ICDCodeF ,
			C.ICDCodeG ,
			C.ICDCodeH ,
			C.ICDCodeI ,
			C.ICDCodeJ ,
			C.ICDCodeK ,
			C.ICDCodeL ,

			C.ICDFormat ,
			B.BlankValue AS ICDIndicator ,


			B.BlankValueLong AS ProblemList ,
            
			CO.ExtName AS Company ,
            
			CL.FirstName + ' ' + CL.LastName AS ClientName ,
			B.BlankValue AS ReferringProvider,	--Fill by system option

            CL.Addr1 AS ClientAddr1 ,
            CL.Addr2 AS ClientAddr2 ,
            CL.City + ', ' + CL.State + '  ' + CL.Zip AS ClientCityStateZip ,
            B.BlankValue AS ClientFullAddress ,
            CL.Phone1 + ' ' + ISNULL(CL.Phone1ext, ' ') AS ClientPhone , --Need Extension?
            CL.Fax AS ClientFax ,
            CL.Email AS ClientEmail ,
			CL.Phone1 AS ClientPhoneAreaCode ,
			CL.Phone1 AS ClientPhoneNumber ,
			CL.Fax AS ClientFaxAreaCode ,
			CL.Fax AS ClientFaxNumber ,

            EE.LastName AS ExamineeLastName ,
            EE.FirstName AS ExamineeFirstName ,
            EE.MiddleInitial AS ExamineeMiddleInitial ,
			B.BlankValue AS ExamineeNameLFMI ,
			B.BlankValue AS ExamineeNameFMIL ,

            EE.SSN AS ExamineeSSN ,
            EE.SSN AS ExamineeSSNLast4Digits ,

            EE.Addr1 AS ExamineeAddr1 ,
            EE.Addr2 AS ExamineeAddr2 ,
            EE.City + ', ' + EE.State + '  ' + EE.Zip AS ExamineeCityStateZip ,
            EE.City AS ExamineeCity ,
            EE.State AS ExamineeState ,
            EE.Zip AS ExamineeZip ,
			B.BlankValue AS ExamineeAddress ,
			B.BlankValue AS ExamineeFullAddress ,
            EE.County AS ExamineeCounty ,

            EE.Phone1 AS ExamineePhone ,
            EE.Phone1 AS ExamineePhoneAreaCode ,
            EE.Phone1 AS ExamineePhoneNumber ,

            EE.DOB AS ExamineeDOBValue ,
			B.BlankValue AS ExamineeDOB ,
			B.BlankValue AS ExamineeDOBMM ,
			B.BlankValue AS ExamineeDOBDD ,
			B.BlankValue AS ExamineeDOBYYYY ,

            EE.Sex AS ExamineeSex ,
			EE.Sex AS ExamineeSexM ,
			EE.Sex AS ExamineeSexF ,
            EE.Employer ,
            EE.EmployerAddr1 ,
            EE.EmployerCity ,
            EE.EmployerState ,
            EE.EmployerZip ,
			B.BlankValue AS EmployerFullAddress ,

            EE.EmployerPhone ,
            EE.EmployerPhone AS EmployerPhoneAreaCode ,
            EE.EmployerPhone AS EmployerPhoneNumber ,

            EE.EmployerFax ,
            EE.EmployerEmail ,

            EE.TreatingPhysicianAddr1 ,
            EE.TreatingPhysicianCity ,
            EE.TreatingPhysicianState ,
            EE.TreatingPhysicianZip ,
			B.BlankValue AS TreatingPhysicianFullAddress ,

            EE.TreatingPhysicianPhone ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneAreaCode ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneNumber ,
            EE.TreatingPhysicianFax ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxAreaCode ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxNumber ,

            EE.TreatingPhysicianLicenseNbr ,
            EE.TreatingPhysician ,
            EE.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            PA.FirstName + ' ' + PA.LastName AS PAttorneyName ,
            PA.Address1 AS PAttorneyAddr1 ,
            PA.Address2 AS PAttorneyAddr2 ,
            PA.City + ', ' + PA.State + '  ' + PA.Zip AS PAttorneyCityStateZip ,
			B.BlankValue AS PAttorneyFullAddress ,

            PA.Phone + ' ' + ISNULL(PA.Phoneextension, '') AS PAttorneyPhone , --Need Extension?
			PA.Phone AS PAttorneyPhoneAreaCode ,
			PA.Phone AS PAttorneyPhoneNumber ,
            PA.Fax AS PAttorneyFax ,
			PA.Fax AS PAttorneyFaxAreaCode ,
			PA.Fax AS PAttorneyFaxNumber ,
            PA.Email AS PAttorneyEmail ,

			CT.EWBusLineID ,
			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr

    FROM    tblCase AS C
            INNER JOIN tblExaminee AS EE ON EE.chartNbr = C.chartNbr
            INNER JOIN tblClient AS CL ON C.clientCode = CL.clientCode
            INNER JOIN tblCompany AS CO ON CL.companyCode = CO.companyCode
			INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
            LEFT OUTER JOIN tblCCAddress AS PA ON C.plaintiffAttorneyCode = PA.ccCode
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO


DROP VIEW vwLibertyExport
GO
CREATE VIEW vwLibertyExport
AS
    SELECT  tblCase.DateReceived ,
            tblCase.ClaimNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + '. ' + tblClient.FirstName AS ClientName ,
            tblCase.Jurisdiction ,
            tblAcctHeader.ApptDate ,
            tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctorname ,
            tblSpecialty.Description AS Specialty ,
            tblAcctHeader.DocumentTotal AS Charge ,
            tblAcctHeader.DocumentNbr ,
            tblAcctHeader.DocumentType ,
            tblCompany.ExtName AS Company ,
            tblCase.SInternalCaseNbr AS InternalCaseNbr ,
            ( SELECT TOP ( 1 )
                        CPTCode
              FROM      tblAcctDetail
              WHERE     ( DocumentNbr = tblAcctHeader.DocumentNbr )
                        AND ( DocumentType = tblAcctHeader.DocumentType )
              ORDER BY  LineNbr
            ) AS CPTCode ,
            ( SELECT TOP ( 1 )
                        Modifier
              FROM      tblAcctDetail AS TblAcctDetail_1
              WHERE     ( DocumentNbr = tblAcctHeader.DocumentNbr )
                        AND ( DocumentType = tblAcctHeader.DocumentType )
              ORDER BY  LineNbr
            ) AS CPTModifier ,
            ( SELECT TOP ( 1 )
                        EventDate
              FROM      tblCaseHistory
              WHERE     ( CaseNbr = tblCase.CaseNbr )
              ORDER BY  EventDate DESC
            ) AS DateFinalized ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.CaseNbr ,
            tblCase.ServiceCode ,
            tblServices.Description AS Service ,
            tblCaseType.ShortDesc AS CaseType ,
            tblClient.USDVarchar2 AS Market ,
            tblCase.USDVarChar1 AS RequestedAs ,
            tblCase.USDInt1 AS ReferralNbr ,
			tblEWFacility.LegalName AS EWFacilityLegalName,
			tblEWFacility.Address AS EWFacilityAddress,
			tblEWFacility.City AS EWFacilityCity,
			tblEWFacility.State AS EWFacilityState,
			tblEWFacility.Zip AS EWFacilityZip
    FROM    tblCase
            INNER JOIN tblAcctHeader ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
			INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblAcctHeader.EWFacilityID
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
    WHERE   ( tblAcctHeader.DocumentType = 'IN' )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO


ALTER TABLE tblIMEData
 ADD UsePeerBill BIT NOT NULL DEFAULT 0
GO

UPDATE tblIMEData SET UsePeerBill=(SELECT UsePeerBill FROM tblControl)
GO

UPDATE tblDoctor SET PrintOnCheckAs = CompanyName WHERE (OPType = 'OP') 
	AND (LEN(RTRIM(LTRIM(PrintOnCheckAs))) = 0 or PrintOnCheckAs IS NULL)

GO


ALTER TABLE tblCase
 ADD CertMailNbr2 VARCHAR(30)
GO 


DROP VIEW vwDocument
GO
CREATE VIEW [dbo].[vwDocument]
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblApptStatus.Name AS ApptStatus ,

            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,

            tblCase.DoctorCode ,
            tblCase.DoctorLocation ,


            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
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
            tblExaminee.InsuredState ,
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
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
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
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
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

			--tblCase.ICDCodeA AS ICD9Code ,
			--tblCase.ICDCodeB AS ICD9Code2 ,
			--tblCase.ICDCodeC AS ICD9Code3 ,
			--tblCase.ICDCodeD AS ICD9Code4 ,
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
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
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

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
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
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
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
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,


            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCaseType.description AS CaseTypeDesc ,

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode

            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblApptStatus ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID

GO
ALTER TABLE tblGPInvoiceEDIStatus ADD [ICN] [varchar](32) NULL
GO



ALTER TABLE [tblAcctHeader]
  ADD [HeaderID] INTEGER IDENTITY(1,1) NOT NULL
GO

ALTER TABLE [tblAcctDetail]
  ADD [DetailID] INTEGER IDENTITY(1,1) NOT NULL
GO

ALTER TABLE [tblAcctDetail]
  ADD [HeaderID] INTEGER
GO

ALTER TABLE [tblCaseTrans]
  ADD [HeaderID] INTEGER
GO

ALTER TABLE [tblAcctHeader]
  ADD [RelatedHeaderID] INTEGER
GO

ALTER TABLE [tblClaimInfo]
  ADD [InvHeaderID] INTEGER
GO

ALTER TABLE [tblGPInvoice]
  ADD [InvHeaderID] INTEGER
GO

ALTER TABLE [tblGPVoucher]
  ADD [VoHeaderID] INTEGER
GO

ALTER TABLE [tblRecordsObtainment]
  ADD [InvHeaderID] INTEGER
GO

ALTER TABLE [tblInvoiceAttachments]
  ADD [HeaderID] INTEGER
GO

ALTER TABLE [tblGPInvoiceEDIStatus]
  ADD [InvHeaderID] INTEGER
GO





DROP VIEW vwExportSummaryWithSecurity
GO
CREATE VIEW vwExportSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblUserOfficeFunction.UserID ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID
                                                AND tblUserOfficeFunction.OfficeCode = tblCase.OfficeCode
                                                AND tblQueues.FunctionCode = tblUserOfficeFunction.FunctionCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )

GO


DROP VIEW vwDocumentAccting
GO
CREATE VIEW [dbo].[vwDocumentAccting]
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblAcctingTrans.SeqNO ,
            tblAcctingTrans.DocumentNbr ,
            tblAcctingTrans.type AS DocumentType ,

            tblAcctingTrans.ApptDate ,
            tblAcctingTrans.ApptTime ,
            tblAcctingTrans.CaseApptID ,
			tblAcctingTrans.ApptStatusID ,

            CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END AS DoctorCode ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END AS DoctorLocation ,



            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
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
            tblExaminee.InsuredState ,
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
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
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
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
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

			--tblCase.ICDCodeA AS ICD9Code ,
			--tblCase.ICDCodeB AS ICD9Code2 ,
			--tblCase.ICDCodeC AS ICD9Code3 ,
			--tblCase.ICDCodeD AS ICD9Code4 ,
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
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
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

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
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
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
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
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,

			
            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCaseType.description AS CaseTypeDesc ,

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode
            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
            LEFT OUTER JOIN tblDoctor ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode
			
            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode

GO



UPDATE AD
 SET HeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblAcctDetail AS AD ON AD.DocumentNbr = AH.DocumentNbr AND AD.DocumentType = AH.DocumentType
 WHERE AD.HeaderID IS NULL

UPDATE Vo
 SET RelatedHeaderID=Inv.HeaderID
 FROM tblAcctHeader AS Vo
 INNER JOIN tblAcctHeader AS Inv ON inv.DocumentNbr=vo.RelatedDocumentNbr AND Vo.DocumentType='VO' AND Inv.DocumentType='IN'
 WHERE Vo.RelatedHeaderID IS NULL

UPDATE CT
 SET HeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblCaseTrans AS CT ON CT.DocumentNbr = AH.DocumentNbr AND CT.Type = AH.DocumentType
 WHERE CT.HeaderID IS NULL

DELETE FROM tblClaimInfo
 WHERE InvoiceNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='IN')

UPDATE C
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblClaimInfo AS C ON C.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE C.InvHeaderID IS NULL
 
DELETE FROM tblGPInvoice
 WHERE InvoiceNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='IN')

DELETE FROM tblGPVoucher
 WHERE VoucherNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='VO')

UPDATE I
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPInvoice AS I ON I.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE I.InvHeaderID IS NULL

UPDATE V
 SET VoHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPVoucher AS V ON V.VoucherNbr = AH.DocumentNbr AND AH.DocumentType='VO'
 WHERE V.VoHeaderID IS NULL

UPDATE RO
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblRecordsObtainment AS RO ON Ro.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE RO.InvHeaderID IS NULL

UPDATE I
 SET HeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblInvoiceAttachments AS I ON I.DocumentNbr = AH.DocumentNbr AND AH.DocumentType=I.DocumentType
 WHERE I.HeaderID IS NULL

UPDATE I
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPInvoiceEDIStatus AS I ON I.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE I.InvHeaderID IS NULL

GO




DROP VIEW vwPDFInvData
GO
CREATE VIEW vwPDFInvData
AS
    SELECT  AH.CaseNbr AS InvCaseNbr ,
            AT.ApptDate AS InvApptDate,
            AT.ApptTime AS InvApptTime,
            AT.DrOpCode AS InvDoctorCode ,
            AT.DoctorLocation AS InvLocationCode ,
			AH.CompanyCode AS InvCompanyCode ,

			AH.HeaderID ,
			AH.DocumentNbr ,
            AH.DocumentDate AS DocumentDateValue ,
			B.BlankValue AS DocumentDate ,
            AH.DocumentType ,
            AH.TaxTotal ,
            AH.DocumentTotal ,
            AH.EWFacilityID ,
            ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID)) AS RemitEWFacilityID ,

			B.BlankValue AS InvoiceAmtDollars,
			B.BlankValue AS InvoiceAmtCents,
			B.BlankValue AS InvoicePaymentCreditAmtDollars,
			B.BlankValue AS InvoicePaymentCreditAmtCents,
			B.BlankValue AS InvoiceBalanceDueDollars,
			B.BlankValue AS InvoiceBalanceDueCents,
            
			F.GPFacility ,
			F.LegalName AS BillingProviderName ,
			F.FedTaxID AS BillingProviderTaxID ,
            F.AcctingPhone AS BillingProviderPhone ,
			F.AcctingPhone AS BillingProviderPhoneAreaCode ,
			F.AcctingPhone AS BillingProviderPhoneNumber ,

			F.GPFacility+'-'+CAST(AH.DocumentNbr AS VARCHAR(20)) AS InvoiceNbr ,

			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN FRemit.Address ELSE FRemit.RemitAddress END AS BillingProviderAddress ,
			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN
			 ISNULL(FRemit.City, '') + ', ' + ISNULL(FRemit.State, '') + ' ' + ISNULL(FRemit.Zip, '')
			ELSE
			  ISNULL(FRemit.RemitCity, '') + ', ' + ISNULL(FRemit.RemitState, '') + ' ' + ISNULL(FRemit.RemitZip, '')
			END AS BillingProviderCityStateZip ,

			CO.ExtName AS InvCoExtName,
            
			CL.BillAddr1 AS InvClBillAddr1,
            CL.BillAddr2 AS InvClBillAddr2,
            CL.BillCity AS InvClBillCity ,
            CL.BillState AS InvClBillState ,
            CL.BillZip AS InvClBillZip ,
            CL.Addr1 AS InvClAddr1 ,
            CL.Addr2 AS InvClAddr2 ,
            CL.City AS InvClCity ,
            CL.State AS InvClState ,
            CL.Zip AS InvClZip ,
			
			B.BlankValueLong AS Payor

    FROM    tblAcctHeader AS AH
            LEFT OUTER JOIN tblAcctingTrans AS AT ON AT.SeqNO = AH.SeqNo
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = AH.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = AH.CompanyCode
            LEFT OUTER JOIN tblEWFacility AS F ON F.EWFacilityID = AH.EWFacilityID
			LEFT OUTER JOIN tblEWFacility AS FRemit ON ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID))=FRemit.EWFacilityID
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

DROP VIEW vwPDFInvDetData
GO
CREATE VIEW vwPDFInvDetData
AS
	SELECT	
			AD1.LineNbr AS InvLineNbr1 ,
	        AD1.Date AS InvServiceDate1 ,
			B.BlankValue AS InvServiceDate1MM,
			B.BlankValue AS InvServiceDate1DD,
			B.BlankValue AS InvServiceDate1YY,
			B.BlankValue AS InvServiceDateTo1MM,
			B.BlankValue AS InvServiceDateTo1DD,
			B.BlankValue AS InvServiceDateTo1YY,
	        AD1.CPTCode AS InvCPT1,
	        AD1.Modifier AS InvModifier1,
	        AD1.Modifier2 AS InvModifier1b ,
	        AD1.Modifier3 AS InvModifier1c ,
	        AD1.Modifier4 AS InvModifier1d ,
			B.BlankValue AS InvICD1,
			B.BlankValue AS InvDiagnosisPointer1,
	        AD1.Location AS InvPlaceOfService1,
			'2' AS InvTypeOfService1,
	        AD1.SuppInfo AS SupplementalInfo1,
	        AD1.Unit AS InvUnit1,
	        AD1.ExtendedAmount AS InvDetAmt1,
	        B.BlankValue AS InvDetAmt1Dollars,
			B.BlankValue AS InvDetAmt1Cents,
			AD1.DrOpCode AS DrOpCode1,
			DR1.NPINbr AS DoctorNPINbr1,


			AD2.LineNbr AS InvLineNbr2 ,
	        AD2.Date AS InvServiceDate2 ,
			B.BlankValue AS InvServiceDate2MM,
			B.BlankValue AS InvServiceDate2DD,
			B.BlankValue AS InvServiceDate2YY,
			B.BlankValue AS InvServiceDateTo2MM,
			B.BlankValue AS InvServiceDateTo2DD,
			B.BlankValue AS InvServiceDateTo2YY,
	        AD2.CPTCode AS InvCPT2,
	        AD2.Modifier AS InvModifier2,
	        AD2.Modifier2 AS InvModifier2b ,
	        AD2.Modifier3 AS InvModifier2c ,
	        AD2.Modifier4 AS InvModifier2d ,
			B.BlankValue AS InvICD2,
			B.BlankValue AS InvDiagnosisPointer2,
	        AD2.Location AS InvPlaceOfService2,
			'2' AS InvTypeOfService2,
	        AD2.SuppInfo AS SupplementalInfo2,
	        AD2.Unit AS InvUnit2,
	        AD2.ExtendedAmount AS InvDetAmt2,
	        B.BlankValue AS InvDetAmt2Dollars,
			B.BlankValue AS InvDetAmt2Cents,
			AD2.DrOpCode AS DrOpCode2,
			DR2.NPINbr AS DoctorNPINbr2,


			AD3.LineNbr AS InvLineNbr3 ,
	        AD3.Date AS InvServiceDate3 ,
			B.BlankValue AS InvServiceDate3MM,
			B.BlankValue AS InvServiceDate3DD,
			B.BlankValue AS InvServiceDate3YY,
			B.BlankValue AS InvServiceDateTo3MM,
			B.BlankValue AS InvServiceDateTo3DD,
			B.BlankValue AS InvServiceDateTo3YY,
	        AD3.CPTCode AS InvCPT3,
	        AD3.Modifier AS InvModifier3,
	        AD3.Modifier2 AS InvModifier3b ,
	        AD3.Modifier3 AS InvModifier3c ,
	        AD3.Modifier4 AS InvModifier3d ,
			B.BlankValue AS InvICD3,
			B.BlankValue AS InvDiagnosisPointer3,
	        AD3.Location AS InvPlaceOfService3,
			'2' AS InvTypeOfService3,
	        AD3.SuppInfo AS SupplementalInfo3,
	        AD3.Unit AS InvUnit3,
	        AD3.ExtendedAmount AS InvDetAmt3,
	        B.BlankValue AS InvDetAmt3Dollars,
			B.BlankValue AS InvDetAmt3Cents,
			AD3.DrOpCode AS DrOpCode3,
			DR3.NPINbr AS DoctorNPINbr3,


			AD4.LineNbr AS InvLineNbr4 ,
	        AD4.Date AS InvServiceDate4 ,
			B.BlankValue AS InvServiceDate4MM,
			B.BlankValue AS InvServiceDate4DD,
			B.BlankValue AS InvServiceDate4YY,
			B.BlankValue AS InvServiceDateTo4MM,
			B.BlankValue AS InvServiceDateTo4DD,
			B.BlankValue AS InvServiceDateTo4YY,
	        AD4.CPTCode AS InvCPT4,
	        AD4.Modifier AS InvModifier4,
	        AD4.Modifier2 AS InvModifier4b ,
	        AD4.Modifier3 AS InvModifier4c ,
	        AD4.Modifier4 AS InvModifier4d ,
			B.BlankValue AS InvICD4,
			B.BlankValue AS InvDiagnosisPointer4,
	        AD4.Location AS InvPlaceOfService4,
			'2' AS InvTypeOfService4,
	        AD4.SuppInfo AS SupplementalInfo4,
	        AD4.Unit AS InvUnit4,
	        AD4.ExtendedAmount AS InvDetAmt4,
	        B.BlankValue AS InvDetAmt4Dollars,
			B.BlankValue AS InvDetAmt4Cents,
			AD4.DrOpCode AS DrOpCode4,
			DR4.NPINbr AS DoctorNPINbr4,


			AD5.LineNbr AS InvLineNbr5 ,
	        AD5.Date AS InvServiceDate5 ,
			B.BlankValue AS InvServiceDate5MM,
			B.BlankValue AS InvServiceDate5DD,
			B.BlankValue AS InvServiceDate5YY,
			B.BlankValue AS InvServiceDateTo5MM,
			B.BlankValue AS InvServiceDateTo5DD,
			B.BlankValue AS InvServiceDateTo5YY,
	        AD5.CPTCode AS InvCPT5,
	        AD5.Modifier AS InvModifier5,
	        AD5.Modifier2 AS InvModifier5b ,
	        AD5.Modifier3 AS InvModifier5c ,
	        AD5.Modifier4 AS InvModifier5d ,
			B.BlankValue AS InvICD5,
			B.BlankValue AS InvDiagnosisPointer5,
	        AD5.Location AS InvPlaceOfService5,
			'2' AS InvTypeOfService5,
	        AD5.SuppInfo AS SupplementalInfo5,
	        AD5.Unit AS InvUnit5,
	        AD5.ExtendedAmount AS InvDetAmt5,
	        B.BlankValue AS InvDetAmt5Dollars,
			B.BlankValue AS InvDetAmt5Cents,
			AD5.DrOpCode AS DrOpCode5,
			DR5.NPINbr AS DoctorNPINbr5,


			AD6.LineNbr AS InvLineNbr6 ,
	        AD6.Date AS InvServiceDate6 ,
			B.BlankValue AS InvServiceDate6MM,
			B.BlankValue AS InvServiceDate6DD,
			B.BlankValue AS InvServiceDate6YY,
			B.BlankValue AS InvServiceDateTo6MM,
			B.BlankValue AS InvServiceDateTo6DD,
			B.BlankValue AS InvServiceDateTo6YY,
	        AD6.CPTCode AS InvCPT6,
	        AD6.Modifier AS InvModifier6,
	        AD6.Modifier2 AS InvModifier6b ,
	        AD6.Modifier3 AS InvModifier6c ,
	        AD6.Modifier4 AS InvModifier6d ,
			B.BlankValue AS InvICD6,
			B.BlankValue AS InvDiagnosisPointer6,
	        AD6.Location AS InvPlaceOfService6,
			'2' AS InvTypeOfService6,
	        AD6.SuppInfo AS SupplementalInfo6,
	        AD6.Unit AS InvUnit6,
	        AD6.ExtendedAmount AS InvDetAmt6,
	        B.BlankValue AS InvDetAmt6Dollars,
			B.BlankValue AS InvDetAmt6Cents,
			AD6.DrOpCode AS DrOpCode6,
			DR6.NPINbr AS DoctorNPINbr6,

			B.BlankValue AS InvICDDiagnosisPointer,
			AD1.HeaderID AS InvDetHeaderID

	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD2 ON AD2.HeaderID = AD1.HeaderID AND AD2.LineNbr=2
	LEFT OUTER JOIN tblAcctDetail AS AD3 ON AD3.HeaderID = AD1.HeaderID AND AD3.LineNbr=3
	LEFT OUTER JOIN tblAcctDetail AS AD4 ON AD4.HeaderID = AD1.HeaderID AND AD4.LineNbr=4
	LEFT OUTER JOIN tblAcctDetail AS AD5 ON AD5.HeaderID = AD1.HeaderID AND AD5.LineNbr=5
	LEFT OUTER JOIN tblAcctDetail AS AD6 ON AD6.HeaderID = AD1.HeaderID AND AD6.LineNbr=6
	LEFT OUTER JOIN tblDoctor AS DR1 ON AD1.DrOpCode=DR1.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR2 ON AD2.DrOpCode=DR2.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR3 ON AD3.DrOpCode=DR3.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR4 ON AD4.DrOpCode=DR4.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR5 ON AD5.DrOpCode=DR5.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR6 ON AD6.DrOpCode=DR6.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
GO


DROP VIEW vwAcctingSummary
GO
CREATE VIEW vwAcctingSummary
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            --DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,
			AH.DocumentStatus ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			--C.PanelNbr ,
            C.OfficeCode ,
            C.Notes ,
            --C.QARep ,
            --C.LastStatusChg ,
            C.BillingNote ,
   --         C.CaseType,
			--C.Status AS CaseStatusCode ,
   --         C.Priority ,
   --         C.MasterSubCase ,

            --C.MarketerCode ,
            --C.SchedulerCode ,
            --C.RequestedDoc ,
            --C.InvoiceDate ,
            --C.InvoiceAmt ,
            --C.DateDrChart ,
            --C.TransReceived ,
            C.ServiceCode ,
            --C.ShownoShow ,
            --C.TransCode ,
            --C.rptStatus ,

            --C.DateAdded ,
            --C.DateEdited ,
            --C.UserIDEdited ,
            --C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                     + ISNULL(ATDr.firstName, '')
            END AS DrOpName ,


            COM.CompanyCode ,
            COM.Notes AS CompanyNotes ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            CL.Notes AS ClientNotes ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
            ATDr.Notes AS DoctorNotes ,
            ISNULL(ATL.LocationCode, CaseL.LocationCode) AS DoctorLocation ,
            ISNULL(ATL.Location, CaseL.Location) AS Location ,

   --         ATQ.StatusDesc ,
			--CaseQ.StatusDesc AS CaseStatusDesc ,
            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc ,
            --tblApptStatus.Name AS Result ,


            --AT.blnSelect AS billedSelect ,
            --C.ApptSelect ,
            --C.drchartSelect ,
            --C.inqaSelect ,
            --C.inTransSelect ,
            --C.awaitTransSelect ,
            --C.chartprepSelect ,
            --C.ApptrptsSelect ,
            --C.miscSelect ,
            --C.voucherSelect
			0 AS LastCol
    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS CaseL ON C.DoctorLocation = CaseL.LocationCode
            LEFT OUTER JOIN tblLocation ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO



DROP VIEW vwAcctingSummaryWithSecurity
GO
CREATE VIEW vwAcctingSummaryWithSecurity
AS
    Select 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.Notes ,
            C.QARep ,
            C.LastStatusChg ,
            C.BillingNote ,
            C.CaseType,
			C.Status AS CaseStatusCode ,
            C.Priority ,
            C.MasterSubCase ,

            C.MarketerCode ,
            C.SchedulerCode ,
            C.RequestedDoc ,
            C.InvoiceDate ,
            C.InvoiceAmt ,
            C.DateDrChart ,
            C.TransReceived ,
            C.ServiceCode ,
            C.ShownoShow ,
            C.TransCode ,
            C.rptStatus ,

            C.DateAdded ,
            C.DateEdited ,
            C.UserIDEdited ,
            C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,
            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                     WHEN ''
                     THEN ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                     WHEN '' THEN ISNULL(C.DoctorName, '')
                     WHEN 'OP' THEN ATDr.CompanyName
                   END
              ELSE Case AT.DrOpType
                     WHEN 'DR' THEN ISNULL(C.DoctorName, '')
                     WHEN '' THEN ISNULL(C.DoctorName, '')
                     WHEN 'OP' THEN ATDr.CompanyName
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
					 ELSE
                      ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END AS DrOpName ,

            COM.CompanyCode ,
            COM.Notes AS CompanyNotes ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            CL.Notes AS ClientNotes ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
            ATDr.Notes AS DoctorNotes ,
            tblLocation.LocationCode AS DoctorLocation ,
            tblLocation.Location ,

            ATQ.StatusDesc ,
            ATQ.FunctionCode ,
			CaseQ.StatusDesc AS CaseStatusDesc ,
            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc ,
            tblApptStatus.Name AS Result ,
            tblUserOfficeFunction.UserID ,

            AT.blnSelect AS billedSelect ,
            C.ApptSelect ,
            C.drchartSelect ,
            C.inqaSelect ,
            C.inTransSelect ,
            C.awaitTransSelect ,
            C.chartprepSelect ,
            C.ApptrptsSelect ,
            C.miscSelect ,
            C.voucherSelect

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
            INNER JOIN tblUserOffice ON C.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID
                                                AND tblUserOffice.OfficeCode = tblUserOfficeFunction.OfficeCode
                                                AND ATQ.FunctionCode = tblUserOfficeFunction.FunctionCode
            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation ON AT.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )

GO





DROP VIEW vwEDIExportSummaryWithSecurity
GO

CREATE VIEW vwEDIExportSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctingTrans.SeqNO ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblUserOfficeFunction.UserID ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID
                                                AND tblUserOfficeFunction.OfficeCode = tblCase.OfficeCode
                                                AND tblQueues.FunctionCode = tblUserOfficeFunction.FunctionCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO


DROP VIEW vwAcctDocuments
GO
CREATE VIEW vwAcctDocuments
AS
    SELECT  tblCase.CaseNbr ,
            tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            CASE WHEN tblDoctor.Credentials IS NOT NULL
                 THEN tblDoctor.FirstName + ' ' + tblDoctor.LastName + ', '
                      + tblDoctor.Credentials
                 ELSE tblDoctor.[Prefix] + ' ' + tblDoctor.FirstName + ' '
                      + tblDoctor.LastName
            END AS DoctorName ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblAcctHeader.ClientCode AS InvClientCode ,
            tblAcctHeader.CompanyCode AS InvCompanyCode ,
            InvCl.LastName + ', ' + InvCl.FirstName AS InvClientName ,
            InvCom.IntName AS InvCompanyName ,
            tblCase.Priority ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS adjusteremail ,
            tblClient.Fax AS adjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.BatchNbr ,
            tblCase.ServiceCode ,
            tblAcctHeader.OfficeCode ,
            tblDoctor.DoctorCode ,
            tblAcctHeader.ApptDate ,
            tblCase.CaseType
    FROM    tblAcctHeader
            INNER JOIN tblCase ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
            LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode
GO




DROP VIEW vwRegisterTotal
GO
CREATE VIEW vwRegisterTotal
AS
    SELECT  Casenbr ,
            HeaderID ,
            documenttype ,
            documentnbr ,
            ExamineeName ,
            DoctorName ,
            ClientCode ,
            CompanyCode ,
            ClientName ,
            CompanyName ,
            InvClientCode ,
            InvCompanyCode ,
            InvClientName ,
            InvCompanyName ,
            priority ,
            DateAdded ,
            Claimnbr ,
            DoctorLocation ,
            ApptTime ,
            DateEdited ,
            useridEdited ,
            adjusteremail ,
            adjusterFax ,
            marketerCode ,
            useridAdded ,
            documentDate ,
            INBatchSelect ,
            VOBatchSelect ,
            taxCode ,
            taxtotal ,
            documenttotal ,
            documentstatus ,
            batchnbr ,
            serviceCode ,
            officeCode ,
            DoctorCode ,
            apptDate ,
            Casetype
    FROM    vwAcctDocuments
GO


DROP VIEW vwRegister
GO
CREATE VIEW vwRegister
AS
    SELECT  tblAcctDetail.extendedamount ,
            tblproduct.INglacct ,
            tblproduct.VOglacct ,
            tblAcctDetail.longdesc ,
			vwAcctDocuments.HeaderID ,
            vwAcctDocuments.Casenbr ,
            vwAcctDocuments.documenttype ,
            vwAcctDocuments.documentnbr ,
            vwAcctDocuments.ExamineeName ,
            vwAcctDocuments.DoctorName ,
            vwAcctDocuments.ClientCode ,
            vwAcctDocuments.CompanyCode ,
            vwAcctDocuments.ClientName ,
            vwAcctDocuments.CompanyName ,
            vwAcctDocuments.InvClientCode ,
            vwAcctDocuments.InvCompanyCode ,
            vwAcctDocuments.InvClientName ,
            vwAcctDocuments.InvCompanyName ,
            vwAcctDocuments.priority ,
            vwAcctDocuments.DateAdded ,
            vwAcctDocuments.Claimnbr ,
            vwAcctDocuments.DoctorLocation ,
            vwAcctDocuments.ApptTime ,
            vwAcctDocuments.DateEdited ,
            vwAcctDocuments.useridEdited ,
            vwAcctDocuments.adjusteremail ,
            vwAcctDocuments.adjusterFax ,
            vwAcctDocuments.marketerCode ,
            vwAcctDocuments.useridAdded ,
            vwAcctDocuments.documentDate ,
            vwAcctDocuments.INBatchSelect ,
            vwAcctDocuments.VOBatchSelect ,
            vwAcctDocuments.taxCode ,
            vwAcctDocuments.taxtotal ,
            vwAcctDocuments.documenttotal ,
            vwAcctDocuments.documentstatus ,
            vwAcctDocuments.batchnbr ,
            vwAcctDocuments.serviceCode ,
            vwAcctDocuments.officeCode ,
            vwAcctDocuments.DoctorCode ,
            vwAcctDocuments.apptDate ,
            vwAcctDocuments.Casetype
    FROM    tblAcctDetail
            INNER JOIN tblproduct ON tblAcctDetail.prodcode = tblproduct.prodcode
            INNER JOIN vwAcctDocuments ON tblAcctDetail.HeaderID = vwAcctDocuments.HeaderID
GO

DROP VIEW vwAcctRegisterTax
GO
CREATE  VIEW vwAcctRegisterTax
AS
    SELECT  x.taxcode ,
            x.HeaderID ,
            x.DocumentNbr ,
            x.DocumentType ,
            SUM(taxamount) AS taxamount
    FROM    ( SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode1 AS taxcode ,
                        SUM(TaxAmount1) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode1 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
              UNION
              SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode2 AS taxcode ,
                        SUM(TaxAmount2) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode2 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
              UNION
              SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode3 AS taxcode ,
                        SUM(TaxAmount3) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode3 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
            ) AS x
    GROUP BY x.taxcode ,
            x.HeaderID ,
            x.DocumentNbr ,
            x.DocumentType
    HAVING  SUM(taxamount) <> 0
            AND x.taxcode <> ''

GO

DROP PROCEDURE dbo.spRptFlashReport
GO
CREATE PROCEDURE [dbo].[spRptFlashReport]
@Month int,
@Year int,
@sReport varchar (20) ,
@EWFacilityID int
AS 
if @sReport = 'CurrentBilled'
begin
set nocount on

create table #lineItems
(DocumentType varchar(2),
 DocumentNbr int not null,
 LineNbr int,
 Description varchar(100),
 ReportCategory varchar(25),
 Revenue money not null,
 Expense money not null,
 ExtendedAmount money not null)

insert into #lineItems
select  tblAcctHeader.DocumentType,
        tblAcctHeader.DocumentNbr,
        tblAcctDetail.LineNbr,
        '',
        ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory,
        case when tblacctheader.documenttype = 'IN'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Revenue,
        case when tblacctheader.documenttype = 'VO'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Expense,
        isnull(tblacctdetail.ExtendedAmount, 0) as ExtendedAmount
from    tblAcctHeader
        inner join tblAcctDetail on tblAcctHeader.HeaderID = tblAcctDetail.HeaderID
        left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
        left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType
                                         and TblAcctDetail.prodcode = tblFRCategory.ProductCode
        left outer JOIN tblEWFlashCategory ON tblFRCategory.EWFlashCategoryID = tblEWFlashCategory.EWFlashCategoryID
where   ( tblAcctHeader.documentstatus = 'Final' )
        and ( tblAcctHeader.EWFacilityID = @EWFacilityID
              or @EWFacilityID = -1
            )
        and month(tblAcctHeader.DocumentDate) = @month
        and year(tblAcctHeader.DocumentDate) = @year

select ReportCategory, sum(FRUnits)as sumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin from 
(
select
  ReportCategory,
  case
    when (select count(*) from #lineItems as counter
   where counter.DocumentType=#lineItems.DocumentType
   and counter.DocumentNbr=#lineItems.DocumentNbr
   and counter.ReportCategory=#lineItems.ReportCategory
   and counter.LineNbr<=#lineItems.LineNbr) = 1 then
      case  
        when DocumentType = 'IN' then
          case when ExtendedAmount < 0 then -1 else 1 end
        else 0
      end
    else 0 
  end as FRUnits,
  Revenue, Expense,
  case
    when DocumentType = 'IN' then ExtendedAmount
    else -ExtendedAmount
  end as Amount
from #lineItems
) as lines
group by ReportCategory
order by ReportCategory

drop table #lineItems

end

if @sReport = 'CurrentScheduled'
begin
SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
     ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
        ) AS a
GROUP BY ReportCategory

end

if @sReport = 'FutureScheduled'
begin
if @month = 12 begin
 select @month = 1
 select @year = @year + 1
end
else
begin
 select @month = @month + 1
end

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
        ) AS a
GROUP BY ReportCategory

end

GO



DROP VIEW vwDocumentAccting
GO
CREATE VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblAcctingTrans.SeqNO ,
            AH.DocumentNbr ,
            tblAcctingTrans.type AS DocumentType ,

            tblAcctingTrans.ApptDate ,
            tblAcctingTrans.ApptTime ,
            tblAcctingTrans.CaseApptID ,
			tblAcctingTrans.ApptStatusID ,

            CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END AS DoctorCode ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END AS DoctorLocation ,

            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
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
            tblExaminee.InsuredState ,
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
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
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
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
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
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
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

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
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
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
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
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,

			
            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCaseType.description AS CaseTypeDesc ,

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode
            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = tblAcctingTrans.SeqNO
            LEFT OUTER JOIN tblDoctor ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode
			
            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
GO


DROP VIEW vwExportSummary
GO
CREATE VIEW vwExportSummary
AS
    SELECT  tblCase.casenbr ,
            TblAcctHeader.documenttype ,
            TblAcctHeader.documentnbr ,
            tblacctingtrans.statuscode ,
            TblAcctHeader.HCAIBranchID ,
            TblAcctHeader.HCAIInsurerID ,
            TblAcctHeader.Message ,
            tblQueues.statusdesc ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblCase.ApptDate ,
            tblCase.dateadded ,
            tblCase.claimnbr ,
            tblCase.doctorlocation ,
            tblCase.Appttime ,
            tblCase.dateedited ,
            tblCase.useridedited ,
			tblcase.schedulenotes ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.useridadded ,
            TblAcctHeader.documentdate ,
            TblAcctHeader.INBatchSelect ,
            TblAcctHeader.VOBatchSelect ,
            TblAcctHeader.taxcode ,
            TblAcctHeader.taxtotal ,
            TblAcctHeader.documenttotal ,
            TblAcctHeader.documentstatus ,
            tblCase.clientcode ,
            tblCase.doctorcode ,
            TblAcctHeader.batchnbr ,
            tblCase.officecode ,
            tblCase.schedulercode ,
            tblClient.companycode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.mastersubcase ,
            tblqueues_1.statusdesc AS CaseStatus ,
            tblacctingtrans.SeqNO
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblQueues tblqueues_1 ON tblcase.status = tblQueues_1.statuscode
            INNER JOIN TblAcctHeader ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblCompany
            INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode
    WHERE   ( tblacctingtrans.statuscode <> 20 )
            AND ( TblAcctHeader.batchnbr IS NULL )
            AND ( TblAcctHeader.documentstatus = 'Final' )

GO


DROP VIEW [vwInvoiceAttachmentGuidance]
GO
-- new view that will used to provide guidance on required attachment types 
-- based on CPT codes that may be posted to invoice.
CREATE VIEW [dbo].[vwInvoiceAttachmentGuidance]
AS
     -- Attachment Type 06 for CPT:98770-98774
          SELECT CaseNbr, '06 - Initial Assessment' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '98770' AND Detail.CPTCode <= '98774'

     UNION

     -- Attachment Type 09 for CPT: 99081 and CPT:99214-99215
          SELECT CaseNbr, '09 - Progress Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode IN ('99081', '99214', '99215')
     UNION

     -- Attachment Type DG for CPT:95804-95830
          SELECT CaseNbr, 'DG - Description for Code Not Available' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '95804' AND Detail.CPTCode <= '95830'

     UNION

     -- Attachment Type J1 for CPT:99201-99205
          SELECT CaseNbr, 'J1 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99201' AND Detail.CPTCode <= '99205'

     UNION

     -- Attachment Type J2 for ALL BR codes, CPT:97545, CPT:97546, CPT:99080 
          SELECT CaseNbr, 'J2 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (Detail.CPTCode IN ('97545', '97546', '99080') OR Detail.CPTCode LIKE '%BR')

     UNION

     -- Attachment Type J7 for CPT:99241-99245
          SELECT CaseNbr, 'J7 - Consultation Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99241' AND Detail.CPTCode <= '99245'

     UNION

     -- Attachment Type LA for CPT:80047-89398 CPT:G0430-G0434
          SELECT CaseNbr, 'LA - Laboratory Results' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '80047' AND Detail.CPTCode <= '89398') 
                    OR 
                    (Detail.CPTCode >= 'G0430' AND Detail.CPTCode <= 'G0434') 
                    )

     UNION

     -- Attachment Type OB for CPT:10021-69999
          SELECT CaseNbr, 'OB - Operative Note' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '10021' AND Detail.CPTCode <= '69999'

     UNION

     -- Attachment Type OZ for CPT:00100-01999
          SELECT CaseNbr, 'OZ - Support Data for Claim' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '00100' AND Detail.CPTCode <= '01999'

     UNION

     -- Attachment Type RR for CPT:70000-79999
          SELECT CaseNbr, 'RR - Radiology Reports' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '70000' AND Detail.CPTCode <= '79999'

     UNION

     -- Attachment Type RT for CPT:95831-95852, CPT: 96100�96117
          SELECT CaseNbr, 'RT - Report of Tests and Analysis Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '95831' AND Detail.CPTCode <= '95852') 
                    OR 
                    (Detail.CPTCode >= '96100' AND Detail.CPTCode <= '96117') 
                    )

GO

DROP VIEW vwCaseTrans
GO
CREATE VIEW vwCaseTrans

AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DocumentNbr ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode,
			tblCaseTrans.CreateInvoiceVoucher
    FROM    tblCaseTrans
    WHERE   HeaderID IS NULL
GO


ALTER TABLE tblDoctorCheckRequest
 ADD GPCheckReqNo INT
GO

CREATE TRIGGER tblDoctorCheckRequest_AfterInsert_TRG 
  ON tblDoctorCheckRequest
AFTER INSERT
AS
  UPDATE tblDoctorCheckRequest
  SET tblDoctorCheckRequest.GPCheckReqNo = i.CheckRequestID
  FROM Inserted AS i
  WHERE tblDoctorCheckRequest.CheckRequestID = i.CheckRequestID
GO

UPDATE tblDoctorCheckRequest
 SET GPCheckReqNo=CheckRequestID
 WHERE GPCheckReqNo IS NULL
GO


DROP VIEW vwOfficeIMEData
DROP VIEW vwQBInvoiceExport
DROP VIEW vwAcctingVOSummary
DROP VIEW vwVoucherRegisterTax
GO


-- MHL Issue 3484 add bool option to override date recd

ALTER TABLE tblServices 
ADD CaseRecdDateOverride bit null;

GO


ALTER TABLE tblCompany
  ADD GPCustomerID VARCHAR(15)
GO


CREATE TRIGGER tblCompany_AfterInsert_TRG 
  ON tblCompany
AFTER INSERT
AS
  UPDATE tblCompany
   SET tblCompany.GPCustomerID=(SELECT TOP 1 FacilityID FROM tblControl)+'-'+CAST(tblCompany.CompanyCode AS VARCHAR)
   FROM Inserted
   WHERE tblCompany.CompanyCode = Inserted.CompanyCode
GO

UPDATE tblCompany SET GPCustomerID=(SELECT TOP 1 FacilityID FROM tblControl)+'-'+CAST(CompanyCode AS VARCHAR)
GO


ALTER TABLE [tblAcctDetail]
  DROP CONSTRAINT [PK_TblInvoiceDetail]
GO

ALTER TABLE [tblAcctHeader]
  DROP CONSTRAINT [PK_TblAcctHeader]
GO

ALTER TABLE [tblAcctHeader]
  ADD CONSTRAINT [PK_tblAcctHeader] PRIMARY KEY ([HeaderID])
GO

ALTER TABLE [tblAcctDetail]
  ADD CONSTRAINT [PK_tblAcctDetail] PRIMARY KEY ([DetailID])
GO

CREATE NONCLUSTERED INDEX [IdxtblAcctHeader_BY_EWFacilityIDDocumentTypeDocumentNbr] ON [tblAcctHeader]([EWFacilityID],[DocumentType],[DocumentNbr])
GO

CREATE INDEX [IdxtblAcctDetail_BY_HeaderIDLineNbr] ON [tblAcctDetail]([HeaderID],[LineNbr])
GO

ALTER TABLE [dbo].[tblClaimInfo] DROP CONSTRAINT [PK_tblClaimInfo]
GO
ALTER TABLE [dbo].[tblClaimInfo] ALTER COLUMN [InvHeaderID] [int] NOT NULL
GO
ALTER TABLE [dbo].[tblClaimInfo] ADD CONSTRAINT [PK_tblClaimInfo] PRIMARY KEY CLUSTERED  ([InvHeaderID])
GO

ALTER TABLE [tblGPInvoice]
  ALTER COLUMN [InvHeaderID] INTEGER NOT NULL
GO

ALTER TABLE [tblGPInvoiceEDIStatus]
  ALTER COLUMN [InvHeaderID] INTEGER NOT NULL
GO

ALTER TABLE [tblGPVoucher]
  ALTER COLUMN [VoHeaderID] INTEGER NOT NULL
GO


INSERT INTO tblUserSecurity
        ( UserID, GroupCode, OfficeCode )
SELECT DISTINCT UserID ,
       GroupCode ,
       -1 FROM tblUserSecurity
GO
DELETE FROM tblUserSecurity WHERE OfficeCode<>-1
GO
UPDATE tblUserSecurity SET OfficeCode=1
GO

ALTER TABLE tblUserSecurity
  DROP CONSTRAINT PK_usersecurity
GO

DROP INDEX IX_tblusersecurity_officecode ON tblUserSecurity
GO

ALTER TABLE tblUserSecurity
  ADD CONSTRAINT [PK_tblUserSecurity] PRIMARY KEY (UserID, GroupCode)
GO


DROP VIEW vw_EDIFileAttachments
GO
CREATE VIEW vw_EDIFileAttachments
AS
    SELECT  CaseDocs.[Description] ,
            CaseDocs.sFilename ,
            CaseDocs.SeqNo ,
            CaseDocs.CaseNbr ,
            Header.DocumentNbr ,
            Header.DocumentType ,
			Header.HeaderID ,
            InvAttach.InvAttachID ,
            InvAttach.AttachType ,
            CaseDocs.[Type]
    FROM    tblCaseDocuments CaseDocs
            LEFT OUTER JOIN tblAcctHeader Header ON ( ( Header.CaseNbr = CaseDocs.CaseNbr )
                                                      AND ( Header.DocumentType = 'IN' )
                                                    )
            LEFT OUTER JOIN tblInvoiceAttachments InvAttach ON ( ( InvAttach.HeaderID = Header.HeaderID )
                                                              AND ( InvAttach.SeqNo = CaseDocs.SeqNo )
                                                              )
    WHERE   ( CaseDocs.[Type] IN ( 'document', 'report' ) ) 

GO

DROP VIEW vwUserSecurity
GO
CREATE VIEW vwUserSecurity
AS
    SELECT  DISTINCT
            tblUserSecurity.UserID ,
            tblGroupFunction.FunctionCode
    FROM    tblUserSecurity
            INNER JOIN tblGroupFunction ON tblUserSecurity.GroupCode = tblGroupFunction.GroupCode
GO

DROP VIEW vwExportSummaryWithSecurity
GO
CREATE VIEW vwExportSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            vwUserSecurity.UserID ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN vwUserSecurity ON tblUserOffice.UserID = vwUserSecurity.UserID
                                                AND tblQueues.FunctionCode = vwUserSecurity.FunctionCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO


DROP VIEW vwstatusappt
GO
CREATE VIEW vwStatusAppt
AS
    SELECT TOP ( 100 ) PERCENT
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblClient.LastName + ', ' + tblClient.FirstName AS clientname ,
            tblUser.LastName + ', ' + tblUser.FirstName AS schedulername ,
            tblCompany.IntName AS companyname ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS clientemail ,
            tblClient.Fax AS clientfax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblServices.ShortDesc AS service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblCase.QARep ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            vwUserSecurity.UserID ,
            tblCase.ServiceCode ,
            tblCase.CaseType
    FROM    tblCase
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany
            INNER JOIN tblClient ON tblCompany.CompanyCode = tblClient.CompanyCode ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN vwUserSecurity ON tblUserOffice.UserID = vwUserSecurity.UserID
                                         AND tblQueues.FunctionCode = vwUserSecurity.FunctionCode

GO

DROP VIEW vwCaseSummaryWithSecurity
GO 
CREATE VIEW vwCaseSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.MiscSelect ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.VoucherAmt ,
            tblCase.VoucherDate ,
            tblCase.OfficeCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            tblCase.PanelNbr ,
            tblCase.CommitDate ,
            tblCase.MasterSubCase ,
            tblCase.MasterCaseNbr ,
            tblCase.CertMailNbr ,
            tblCase.WebNotifyEmail ,
            tblCase.PublishOnWeb ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS DoctorName ,
            tblCase.DateMedsRecd ,
            tblCase.SInternalCaseNbr ,
            tblCase.DoctorSpecialty ,
            tblCase.USDDate1 ,
            tblQueues.FunctionCode ,
            vwUserSecurity.UserID ,
            tblCase.CaseType ,
            tblCase.ForecastDate ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
			tblCase.ReExam ,
			tblCase.ReExamDate ,
			tblCase.ReExamProcessed,
			tblCase.ReExamNoticePrinted
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN vwUserSecurity ON tblUserOffice.UserID = vwUserSecurity.UserID
                                                AND tblQueues.FunctionCode = vwUserSecurity.FunctionCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
GO


DROP VIEW vwEDIExportSummaryWithSecurity
GO
CREATE VIEW vwEDIExportSummaryWithSecurity
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctingTrans.SeqNO ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            vwUserSecurity.UserID ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
            INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN vwUserSecurity ON tblUserOffice.UserID = vwUserSecurity.UserID
                                                AND tblQueues.FunctionCode = vwUserSecurity.FunctionCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO


DROP VIEW vwAcctingSummaryWithSecurity
GO
CREATE VIEW vwAcctingSummaryWithSecurity
AS
    Select 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.Notes ,
            C.QARep ,
            C.LastStatusChg ,
            C.BillingNote ,
            C.CaseType,
			C.Status AS CaseStatusCode ,
            C.Priority ,
            C.MasterSubCase ,

            C.MarketerCode ,
            C.SchedulerCode ,
            C.RequestedDoc ,
            C.InvoiceDate ,
            C.InvoiceAmt ,
            C.DateDrChart ,
            C.TransReceived ,
            C.ServiceCode ,
            C.ShownoShow ,
            C.TransCode ,
            C.rptStatus ,

            C.DateAdded ,
            C.DateEdited ,
            C.UserIDEdited ,
            C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,
            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                     WHEN ''
                     THEN ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                     WHEN '' THEN ISNULL(C.DoctorName, '')
                     WHEN 'OP' THEN ATDr.CompanyName
                   END
              ELSE Case AT.DrOpType
                     WHEN 'DR' THEN ISNULL(C.DoctorName, '')
                     WHEN '' THEN ISNULL(C.DoctorName, '')
                     WHEN 'OP' THEN ATDr.CompanyName
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
					 ELSE
                      ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END AS DrOpName ,

            COM.CompanyCode ,
            COM.Notes AS CompanyNotes ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            CL.Notes AS ClientNotes ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
            ATDr.Notes AS DoctorNotes ,
            tblLocation.LocationCode AS DoctorLocation ,
            tblLocation.Location ,

            ATQ.StatusDesc ,
            ATQ.FunctionCode ,
			CaseQ.StatusDesc AS CaseStatusDesc ,
            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc ,
            tblApptStatus.Name AS Result ,
            vwUserSecurity.UserID ,

            AT.blnSelect AS billedSelect ,
            C.ApptSelect ,
            C.drchartSelect ,
            C.inqaSelect ,
            C.inTransSelect ,
            C.awaitTransSelect ,
            C.chartprepSelect ,
            C.ApptrptsSelect ,
            C.miscSelect ,
            C.voucherSelect

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
            INNER JOIN tblUserOffice ON C.OfficeCode = tblUserOffice.OfficeCode
            INNER JOIN vwUserSecurity ON tblUserOffice.UserID = vwUserSecurity.UserID
                                                AND ATQ.FunctionCode = vwUserSecurity.FunctionCode
            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation ON AT.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO


DROP VIEW vwcasemonitordetail
GO
CREATE VIEW vwCaseMonitorDetail
AS  SELECT  tblCase.status,
            tblCase.priority,
            tblCase.marketercode,
            tblCase.DoctorLocation,
            tblCase.DoctorCode,
            tblClient.CompanyCode,
            CASE WHEN tblCase.priority = 'Normal'
                      OR tblCase.priority IS NULL THEN 1
                 ELSE 0
            END AS Normal,
            CASE WHEN tblCase.priority <> 'Normal' THEN 1
                 ELSE 0
            END AS Rush,
            tblCase.OfficeCode,
            tblCase.schedulercode,
            tblCase.QARep AS QARepCode,
            tblCase.servicecode,
            tblCase.casetype
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
    WHERE   ( tblCase.status <> 8 )
            AND ( tblCase.status <> 9 )
GO

DROP PROC dbo.spFrmMainForm
GO
CREATE PROC dbo.spFrmMainForm
    @sForm varchar(50),
    @iOfficeCode int,
    @sFilterType varchar(50),
    @sFilterValue varchar(50),
    @sUserID varchar(50)
as 
    declare @sColumns varchar(1000)
    declare @sFrom varchar(1000)
    declare @sWhere varchar(1000)
    declare @sGroupBy varchar(1000)
    declare @sHaving varchar(100)
    declare @sSqlString nvarchar(2000)


    if ( @sForm = 'Case Monitor' ) 
        begin
            set @scolumns = 'COUNT(*) AS casecount, SUM(vwCaseMonitorDetail.Rush) AS rushcount, SUM(vwCaseMonitorDetail.Normal) AS normalcount, '
                + 'vwCaseMonitorDetail.status, MAX(tblQueues.displayorder) AS displayorder, tblQueues.statusdesc, tblQueues.formtoopen, '
                + 'tblQueues.functioncode, tblUserOffice.userid ' 
            set @sFrom = 'FROM tblQueues INNER JOIN '
                + 'vwCaseMonitorDetail ON tblQueues.statuscode = vwCaseMonitorDetail.status INNER JOIN '
                + 'tblUserOffice ON tblUserOffice.officecode = vwCaseMonitorDetail.officecode '
            set @sWhere = 'Where tbluseroffice.userid = ''' + @sUserid
                + ''''  

            set @sWhere = @sWhere
                + ' and tblQueues.functioncode in (select distinct functioncode from tblUserSecurity where tblUserSecurity.userid = '''
                + @sUserid + ''')'

            set @sGroupBy = 'vwCaseMonitorDetail.status, tblQueues.statusdesc, tblQueues.formtoopen, tblQueues.functioncode, tblUserOffice.userid '
            set @sHaving = ''

        end
    else 
        begin
            set @scolumns = 'COUNT(*) AS casecount, tblQueues.statusdesc, tblQueues.formtoopen, tblqueues.functioncode,max(tblQueues.displayorder) as displayorder, '
                + ' tblacctingtrans.statuscode as status, tblqueues.functioncode '
            set @sFrom = 'FROM tblacctingtrans INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode '
                + 'INNER JOIN tblCase ON tblacctingtrans.casenbr = tblCase.casenbr '
                + 'INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode  INNER JOIN tbluseroffice on tbluseroffice.officecode = tblcase.officecode '
            set @sGroupBy = 'tblacctingtrans.statuscode, tblQueues.statusdesc, tblQueues.formtoopen, tblqueues.functioncode '
            set @sHaving = 'HAVING  tblacctingtrans.statuscode <> 20'
            set @sWhere = 'Where tbluseroffice.userid = ''' + @sUserid
                + '''' 

        end

-- add officecode to sql statement, if needed

    if ( @iofficecode <> '-1' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.officecode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.officecode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.officecode'
                        end
                end 
            else 
                begin
                    set @scolumns = @scolumns + ', tblcase.officecode' 
--  set @sFrom = @sFrom + ' INNER JOIN tblCase ON tblacctingtrans.casenbr = tblCase.casenbr'
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblcase.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.officecode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblcase.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.officecode'
                        end
                end
        end

-- add companycode to sql statement, if needed

    if ( @sFilterType = 'Company' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.companycode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.companycode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.companycode = '
                                + @sfiltervalue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.companycode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', tblclient.companycode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblclient.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',tblclient.companycode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblclient.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',tblclient.companycode'
                        end
                end
    
        end
  
-- add doctor to sql statement, if needed

    if ( @sFilterType = 'Doctor' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.doctorcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.doctorcode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.doctorcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.doctorcode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.doctorcode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', tblacctingtrans.dropcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblacctingtrans.dropcode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',tblacctingtrans.dropcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblacctingtrans.dropcode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',tblacctingtrans.dropcode'
                        end
                end
        end
-- add DoctorLocation to sql statement, if needed

    if ( @sFilterType = 'Location' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.DoctorLocation' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.DoctorLocation' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.DoctorLocation'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', tblcase.DoctorLocation' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblcase.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.DoctorLocation' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblcase.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.DoctorLocation'
                        end
                end

        end

-- add marketercode to sql statement, if needed  
    if ( @sfiltertype = 'Marketer' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.Marketercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.marketercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.marketercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.marketercode = '''
                                + @sFilterValue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.marketercode' 
                        end
                end 
            else 
                begin
                    set @scolumns = @scolumns + ', tblcase.Marketercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblcase.marketercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.marketercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblcase.marketercode = '''
                                + @sFilterValue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.marketercode' 
                        end
                end 

        end

-- add schedulercode to sql statement, if needed  
    if ( @sfiltertype = 'Scheduler' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.Schedulercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.Schedulercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.Schedulercode' 
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', tblcase.Schedulercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblcase.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.Schedulercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblcase.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',tblcase.Schedulercode' 
                        end
                end
        end

-- add QARepcode to sql statement, if needed  
    if ( @sfiltertype = 'QARep' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.QARepcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.QARepcode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.QARepcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.QARepcode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.QARepcode' 
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', tblcase.QARep' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblcase.QARep = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy + ',tblcase.QARep' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblcase.QARep = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy + ',tblcase.QARep' 
                        end
                end

        end
-- add servce to sql statement, if needed

    if ( @sFilterType = 'Service' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.serviceCode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.serviceCode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.serviceCode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.serviceCode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.serviceCode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', tblCase.serviceCode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblCase.serviceCode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',tblCase.serviceCode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblCase.serviceCode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',tblCase.serviceCode'
                        end
                end
        END
        
-- add case type to sql statement, if needed

    if ( @sFilterType = 'CaseType' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', vwCaseMonitorDetail.caseType' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where vwCaseMonitorDetail.caseType = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.caseType' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and vwCaseMonitorDetail.caseType = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',vwCaseMonitorDetail.caseType'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', tblCase.caseType' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where tblCase.caseType = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',tblCase.caseType' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and tblCase.caseType = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',tblCase.caseType'
                        end
                end
        end

-- build sql statement
    set @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + 'GROUP BY ' + @sGroupby + ' '
        + @sHaving + ' ' + 'ORDER BY MAX(dbo.tblQueues.displayorder)'

--print 'sqlstring ' +  @ssqlstring
 
-- execute sql statement
    Exec Sp_executesql @sSqlString

GO


DROP VIEW vwStatusNew
GO
CREATE VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,CASE WHEN tblcase.panelnbr IS NULL
                 THEN tbldoctor.lastname + ', '
                      + ISNULL(tbldoctor.firstname, ' ')
                 ELSE tblcase.doctorname
            END AS doctorname
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,ISNULL(Scheduler.LastName,'') + CASE WHEN ISNULL(Scheduler.LastName,'')='' OR ISNULL(Scheduler.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Scheduler.FirstName, '') AS schedulername
           ,ISNULL(Marketer.LastName,'') + CASE WHEN ISNULL(Marketer.LastName,'')='' OR ISNULL(Marketer.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Marketer.FirstName, '') AS marketername
           ,tblCompany.intname AS companyname
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.status
           ,tblCase.dateadded
           ,tblCase.requesteddoc
           ,tblCase.doctorcode
           ,tblCase.marketercode
           ,tblQueues.statusdesc
           ,tblServices.shortdesc AS service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep AS QARepCode
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,vwUserSecurity.UserID
           ,vwUserSecurity.FunctionCode
           ,tblCase.casetype
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            INNER JOIN tblUserOffice ON tblUserOffice.officecode = tblCase.officecode
			INNER JOIN vwUserSecurity ON vwUserSecurity.UserID = tblUserOffice.UserID
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblUser AS Scheduler ON tblCase.schedulercode = Scheduler.UserID
            LEFT OUTER JOIN tblUser AS Marketer ON Marketer.UserID = tblCase.marketercode
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
    WHERE   (vwUserSecurity.FunctionCode = 'ViewCase')

GO



ALTER TABLE [tblClaimInfo]
  DROP COLUMN [InvoiceNbr]
GO

ALTER TABLE [tblGPInvoice]
  DROP COLUMN [InvoiceNbr]
GO

ALTER TABLE [tblGPInvoiceEDIStatus]
  DROP COLUMN [InvoiceNbr]
GO

ALTER TABLE [tblGPVoucher]
  DROP COLUMN [VoucherNbr]
GO

ALTER TABLE [tblInvoiceAttachments]
  DROP COLUMN [DocumentNbr]
GO

ALTER TABLE [tblInvoiceAttachments]
  DROP COLUMN [DocumentType]
GO

ALTER TABLE [tblRecordsObtainment]
  DROP COLUMN [InvoiceNbr]
GO

ALTER TABLE [tblAcctHeader]
  DROP COLUMN [RelatedDocumentNbr]
GO

ALTER TABLE [tblCaseTrans]
  DROP COLUMN [DocumentNbr]
GO

DROP INDEX [tblAcctingTrans].[IdxtblAcctingTrans_BY_documentnbrtype]
GO

ALTER TABLE [tblAcctDetail]
  DROP COLUMN [DocumentNbr]
GO

ALTER TABLE [tblAcctDetail]
  DROP COLUMN [DocumentType]
GO

ALTER TABLE [tblAcctingTrans]
  DROP COLUMN [DocumentNbr]
GO

ALTER TABLE [tblAcctingTrans]
  DROP COLUMN [DocumentDate]
GO

ALTER TABLE [tblAcctingTrans]
  DROP COLUMN [DocumentAmount]
GO


DROP VIEW vwRecordsToInvoice
GO
CREATE VIEW vwRecordsToInvoice
AS
    SELECT  tblRecordsObtainment.CaseNbr ,
            tblObtainmentType.Description ,
            tblProduct.Description AS Product ,
            tblFacility.Name AS Facility ,
            tblRecordsObtainment.ObtainmentTypeID ,
            tblRecordsObtainment.Fee ,
            tblRecordsObtainment.RecordsID ,
            tblObtainmentType.ProdCode
    FROM    tblRecordsObtainment
            INNER JOIN tblObtainmentType ON tblRecordsObtainment.ObtainmentTypeID = tblObtainmentType.ObtainmentTypeID
            LEFT OUTER JOIN tblFacility ON tblRecordsObtainment.FacilityID = tblFacility.FacilityID
            LEFT OUTER JOIN tblProduct ON tblObtainmentType.ProdCode = tblProduct.ProdCode
    WHERE   ( tblRecordsObtainment.InvHeaderID IS NULL )
            AND ( tblRecordsObtainment.ObtainmentTypeID <> 1 )
            AND ( tblRecordsObtainment.Fee <> 0 )
GO

DROP VIEW vwLibertyExport
GO
CREATE VIEW vwLibertyExport
AS
    SELECT  tblCase.DateReceived ,
            tblCase.ClaimNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + '. ' + tblClient.FirstName AS ClientName ,
            tblCase.Jurisdiction ,
            tblAcctHeader.ApptDate ,
            tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctorname ,
            tblSpecialty.Description AS Specialty ,
            tblAcctHeader.DocumentTotal AS Charge ,
            tblAcctHeader.DocumentNbr ,
            tblAcctHeader.DocumentType ,
            tblCompany.ExtName AS Company ,
            tblCase.SInternalCaseNbr AS InternalCaseNbr ,
            ( SELECT TOP ( 1 )
                        CPTCode
              FROM      tblAcctDetail
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTCode ,
            ( SELECT TOP ( 1 )
                        Modifier
              FROM      tblAcctDetail AS TblAcctDetail_1
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTModifier ,
            ( SELECT TOP ( 1 )
                        EventDate
              FROM      tblCaseHistory
              WHERE     ( CaseNbr = tblCase.CaseNbr )
              ORDER BY  EventDate DESC
            ) AS DateFinalized ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.CaseNbr ,
            tblCase.ServiceCode ,
            tblServices.Description AS Service ,
            tblCaseType.ShortDesc AS CaseType ,
            tblClient.USDVarchar2 AS Market ,
            tblCase.USDVarChar1 AS RequestedAs ,
            tblCase.USDInt1 AS ReferralNbr ,
			tblEWFacility.LegalName AS EWFacilityLegalName,
			tblEWFacility.Address AS EWFacilityAddress,
			tblEWFacility.City AS EWFacilityCity,
			tblEWFacility.State AS EWFacilityState,
			tblEWFacility.Zip AS EWFacilityZip
    FROM    tblCase
            INNER JOIN tblAcctHeader ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
			INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblAcctHeader.EWFacilityID
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
    WHERE   ( tblAcctHeader.DocumentType = 'IN' )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO

DROP VIEW vwCaseTrans
GO
CREATE VIEW vwCaseTrans
AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode,
			tblCaseTrans.CreateInvoiceVoucher
    FROM    tblCaseTrans
    WHERE   HeaderID IS NULL
GO


DROP TABLE tblUserOfficeFunction
GO
DROP PROC sp_buildUserOfficeTables
GO

ALTER TABLE tblUserSecurity
  DROP CONSTRAINT DF_tblUserSecurity_officecode
GO

ALTER TABLE tblUserSecurity
  DROP COLUMN OfficeCode
GO


DECLARE @tableName VARCHAR(MAX) = 'tblControl'
DECLARE @columnName VARCHAR(MAX) = 'UsePeerBill'
DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name 
FROM SYS.DEFAULT_CONSTRAINTS
WHERE PARENT_OBJECT_ID = OBJECT_ID(@tableName) 
AND PARENT_COLUMN_ID = (
    SELECT column_id FROM sys.columns
    WHERE NAME = @columnName AND object_id = OBJECT_ID(@tableName))
IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE '+@tableName+' DROP CONSTRAINT ' + @ConstraintName)
GO

ALTER TABLE tblControl
 DROP COLUMN UsePeerBill
GO


EXEC sp_rename '[tblAcctHeader].[RelatedHeaderID]', 'RelatedInvHeaderID', 'COLUMN'
GO

EXEC sp_rename '[tblDoctorCheckRequest].[GPCheckReqNo]', 'GPCheckReqNbr', 'COLUMN'
GO

EXEC sp_rename '[tblInvoiceAttachments].[HeaderID]', 'InvHeaderID', 'COLUMN'
GO

DROP TRIGGER [tblDoctorCheckRequest_AfterInsert_TRG]
GO

CREATE TRIGGER tblDoctorCheckRequest_AfterInsert_TRG 
  ON tblDoctorCheckRequest
AFTER INSERT
AS
  UPDATE tblDoctorCheckRequest
  SET tblDoctorCheckRequest.GPCheckReqNbr = i.CheckRequestID
  FROM Inserted AS i
  WHERE tblDoctorCheckRequest.CheckRequestID = i.CheckRequestID
GO

DROP VIEW vw_EDIFileAttachments
GO
CREATE VIEW vw_EDIFileAttachments
AS
    SELECT  CaseDocs.[Description] ,
            CaseDocs.sFilename ,
            CaseDocs.SeqNo ,
            CaseDocs.CaseNbr ,
            Header.DocumentNbr ,
            Header.DocumentType ,
			Header.HeaderID ,
            InvAttach.InvAttachID ,
            InvAttach.AttachType ,
            CaseDocs.[Type]
    FROM    tblCaseDocuments CaseDocs
            LEFT OUTER JOIN tblAcctHeader Header ON ( ( Header.CaseNbr = CaseDocs.CaseNbr )
                                                      AND ( Header.DocumentType = 'IN' )
                                                    )
            LEFT OUTER JOIN tblInvoiceAttachments InvAttach ON ( ( InvAttach.InvHeaderID = Header.HeaderID )
                                                              AND ( InvAttach.SeqNo = CaseDocs.SeqNo )
                                                              )
    WHERE   ( CaseDocs.[Type] IN ( 'document', 'report' ) ) 
GO

-- Issue 3478 MHL 02/08 Add Examinee Reimbursement table and correlated table in tblimedata

CREATE TABLE tblTempVendorVoucher
(
TempVendorVoucherID	Int	IDENTITY NOT NULL,
TempVendorVoucherNo	VarChar(15)	NOT NULL,
CaseNbr	Int	NOT NULL,
VendorID	Int	NOT NULL,
VendorType	VarChar(3)	NOT NULL,
DateAdded	DateTime	NOT NULL,
UserIDAdded	VarChar(20)	NOT NULL,
DateEdited	DateTime	NOT NULL,
UserIDEdited	VarChar(20)	NOT NULL,
ProdCode	Int	NOT NULL,
Amount	Money	NOT NULL,
Comment	VarChar(30)	NULL,
EWFacilityID	Int	NOT NULL,
BatchNbr	Int	NULL,
ExportDate	DateTime	NULL,
PayeeName	Varchar(64)	NOT NULL,
AddressLine1	Varchar(50)	NOT NULL,
AddressLine2	Varchar(50)	NULL,
AddressLine3	Varchar(50)	NULL,
City	Varchar(35)	NOT NULL,
State	Char(2)	NOT NULL,
Zip	VarChar(12)	NOT NULL,
PRIMARY KEY (TempVendorVoucherID)
);

ALTER Table tblIMEDATA
ADD ExamineeReimbDefProdCode Int	NULL;



ALTER TABLE tblEWParentCompany ADD
 [FolderID] [int] NULL,
 [SLADocumentFileName] [varchar](80) NULL
GO

DROP VIEW [dbo].[vwClientDefaults]
GO
CREATE VIEW [dbo].[vwClientDefaults]
AS
    SELECT  tblClient.marketercode AS clientmarketer ,
            dbo.tblCompany.intname ,
			ISNULL(dbo.tblCompany.EWCompanyID, 0) AS EWCompanyID, 
            dbo.tblClient.reportphone ,
            dbo.tblClient.priority ,
            dbo.tblClient.clientcode ,
            dbo.tblClient.fax ,
            dbo.tblClient.email ,
            dbo.tblClient.phone1 ,
            dbo.tblClient.documentemail AS emailclient ,
            dbo.tblClient.documentfax AS faxclient ,
            dbo.tblClient.documentmail AS mailclient ,
            ISNULL(dbo.tblClient.casetype, tblCompany.CaseType) AS CaseType ,
            dbo.tblClient.feeschedule ,
            dbo.tblCompany.credithold ,
            dbo.tblCompany.preinvoice ,
            dbo.tblClient.billaddr1 ,
            dbo.tblClient.billaddr2 ,
            dbo.tblClient.billcity ,
            dbo.tblClient.billstate ,
            dbo.tblClient.billzip ,
            dbo.tblClient.billattn ,
            dbo.tblClient.ARKey ,
            dbo.tblClient.addr1 ,
            dbo.tblClient.addr2 ,
            dbo.tblClient.city ,
            dbo.tblClient.state ,
            dbo.tblClient.zip ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname ,
            dbo.tblClient.prefix AS clientprefix ,
            dbo.tblClient.suffix AS clientsuffix ,
            dbo.tblClient.lastname ,
            dbo.tblClient.firstname ,
            dbo.tblClient.billfax ,
            dbo.tblClient.QARep ,
            ISNULL(dbo.tblClient.photoRqd, tblCompany.photoRqd) AS photoRqd ,
            dbo.tblClient.CertifiedMail ,
            dbo.tblClient.PublishOnWeb ,
            dbo.tblClient.UseNotificationOverrides ,
            dbo.tblClient.CSR1 ,
            dbo.tblClient.CSR2 ,
            dbo.tblClient.AutoReschedule ,
            dbo.tblClient.DefOfficeCode ,
            ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer ,
            dbo.tblCompany.Jurisdiction
    FROM    dbo.tblClient
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode

GO
 
-- Issue 3685 MHL Add Create Cover Letter value and utilize
 ALTER TABLE tblCase
ADD CreateCvrLtr bit null
GO

ALTER TABLE tblClient
ADD CreateCvrLtr bit null
GO

ALTER TABLE tblCompany
ADD CreateCvrLtr bit null
GO

UPDATE tblCase SET CreateCvrLtr = 1
UPDATE tblClient SET CreateCvrLtr = 1
UPDATE tblCompany SET CreateCvrLtr = 1


GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW [dbo].[vwClientDefaults]

GO
CREATE VIEW [dbo].[vwClientDefaults]
AS
    SELECT  tblClient.marketercode AS clientmarketer ,
            dbo.tblCompany.intname ,
			ISNULL(dbo.tblCompany.EWCompanyID, 0) AS EWCompanyID, 
            dbo.tblClient.reportphone ,
            dbo.tblClient.priority ,
            dbo.tblClient.clientcode ,
            dbo.tblClient.fax ,
            dbo.tblClient.email ,
            dbo.tblClient.phone1 ,
            dbo.tblClient.documentemail AS emailclient ,
            dbo.tblClient.documentfax AS faxclient ,
            dbo.tblClient.documentmail AS mailclient ,
            ISNULL(dbo.tblClient.casetype, tblCompany.CaseType) AS CaseType ,
            dbo.tblClient.feeschedule ,
            dbo.tblCompany.credithold ,
            dbo.tblCompany.preinvoice ,
            dbo.tblClient.billaddr1 ,
            dbo.tblClient.billaddr2 ,
            dbo.tblClient.billcity ,
            dbo.tblClient.billstate ,
            dbo.tblClient.billzip ,
            dbo.tblClient.billattn ,
            dbo.tblClient.ARKey ,
            dbo.tblClient.addr1 ,
            dbo.tblClient.addr2 ,
            dbo.tblClient.city ,
            dbo.tblClient.state ,
            dbo.tblClient.zip ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname ,
            dbo.tblClient.prefix AS clientprefix ,
            dbo.tblClient.suffix AS clientsuffix ,
            dbo.tblClient.lastname ,
            dbo.tblClient.firstname ,
            dbo.tblClient.billfax ,
            dbo.tblClient.QARep ,
            ISNULL(dbo.tblClient.photoRqd, tblCompany.photoRqd) AS photoRqd ,
            dbo.tblClient.CertifiedMail ,
            dbo.tblClient.PublishOnWeb ,
            dbo.tblClient.UseNotificationOverrides ,
            dbo.tblClient.CSR1 ,
            dbo.tblClient.CSR2 ,
            dbo.tblClient.AutoReschedule ,
            dbo.tblClient.DefOfficeCode ,
            ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer ,
            dbo.tblCompany.Jurisdiction ,
			dbo.tblClient.CreateCvrLtr|dbo.tblCompany.CreateCvrLtr As CreateCvrLtr
    FROM    dbo.tblClient
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode


GO


-- Issue 2598 DMR New Notes Fields

ALTER TABLE tblCompany
  ADD SpecialReqNotes Text NULL
GO

ALTER TABLE tblClient
  ADD SpecialReqNotes Text NULL
GO

ALTER TABLE tblDoctor
  ADD QANotes Text NULL,
  MedRecordReqNotes Text NULL
GO

-- Issue 3681 DMR New Field


ALTER TABLE tblDoctor
  ADD DrAcctingNote Text NULL
GO


-- Issue 3681 DMR Update view

DROP VIEW [vwAcctingSummary]
GO


CREATE VIEW [dbo].[vwAcctingSummary]
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            --DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,
			AH.DocumentStatus ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			--C.PanelNbr ,
            C.OfficeCode ,
            C.Notes ,
            --C.QARep ,
            --C.LastStatusChg ,
            C.BillingNote ,
   --         C.CaseType,
			--C.Status AS CaseStatusCode ,
   --         C.Priority ,
   --         C.MasterSubCase ,

            --C.MarketerCode ,
            --C.SchedulerCode ,
            --C.RequestedDoc ,
            --C.InvoiceDate ,
            --C.InvoiceAmt ,
            --C.DateDrChart ,
            --C.TransReceived ,
            C.ServiceCode ,
            --C.ShownoShow ,
            --C.TransCode ,
            --C.rptStatus ,

            --C.DateAdded ,
            --C.DateEdited ,
            --C.UserIDEdited ,
            --C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                     + ISNULL(ATDr.firstName, '')
            END AS DrOpName ,


            COM.CompanyCode ,
            COM.Notes AS CompanyNotes ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            CL.Notes AS ClientNotes ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
            ATDr.Notes AS DoctorNotes ,
			      ATDr.DrAcctingNote , 
            ISNULL(ATL.LocationCode, CaseL.LocationCode) AS DoctorLocation ,
            ISNULL(ATL.Location, CaseL.Location) AS Location ,

   --         ATQ.StatusDesc ,
			--CaseQ.StatusDesc AS CaseStatusDesc ,
            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc ,
            --tblApptStatus.Name AS Result ,


            --AT.blnSelect AS billedSelect ,
            --C.ApptSelect ,
            --C.drchartSelect ,
            --C.inqaSelect ,
            --C.inTransSelect ,
            --C.awaitTransSelect ,
            --C.chartprepSelect ,
            --C.ApptrptsSelect ,
            --C.miscSelect ,
            --C.voucherSelect
			0 AS LastCol
    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS CaseL ON C.DoctorLocation = CaseL.LocationCode
            LEFT OUTER JOIN tblLocation ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )

GO



