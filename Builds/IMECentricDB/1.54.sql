


------------------------------------------------
--Web Portal Changes by Gary
------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetCompanyComboItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetCompanyComboItems];
GO

CREATE PROCEDURE [proc_GetCompanyComboItems]

AS

SELECT companycode, intname from tblCompany 

ORDER BY intname

GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebUser_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebUser_Insert];
GO

CREATE PROCEDURE [proc_WebUser_Insert]
(
	@WebUserID int = NULL output,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@LastLoginDate datetime = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@UseridEdited varchar(50) = NULL,
	@Active bit,
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
	@WebCompanyID int = NULL

)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblWebUser]
	(
		[UserID],
		[Password],
		[LastLoginDate],
		[DateAdded],
		[DateEdited],
		[UseridAdded],
		[UseridEdited],
		[Active],
		[DisplayClient],
		[ProviderSearch],
		[IMECentricCode],
		[UserType],
		[AutoPublishNewCases],
		[IsClientAdmin],
		[UpdateFlag],
		[LastPasswordChangeDate],
		[StatusID],
		[FailedLoginAttempts],
		[LockoutDate],
		[WebCompanyID]
	)
	VALUES
	(
		@UserID,
		@Password,
		@LastLoginDate,
		@DateAdded,
		@DateEdited,
		@UseridAdded,
		@UseridEdited,
		@Active,
		@DisplayClient,
		@ProviderSearch,
		@IMECentricCode,
		@UserType,
		@AutoPublishNewCases,
		@IsClientAdmin,
		@UpdateFlag,
		@LastPasswordChangeDate,
		@StatusID,
		@FailedLoginAttempts,
		@LockoutDate,
		@WebCompanyID
	)

	SET @Err = @@Error

	SELECT @WebUserID = SCOPE_IDENTITY()

	RETURN @Err
END
GO

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
	@Active bit,
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
	@WebCompanyID int = NULL
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
		[Active] = @Active,
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
		[WebCompanyID] = @WebCompanyID
	WHERE
		[WebUserID] = @WebUserID


	SET @Err = @@Error


	RETURN @Err
END
GO

--Add new language
INSERT INTO [tbllanguage] ([Description])
 select 'Arabic'
 where not exists (select description from tblLanguage where description='Arabic')
GO

----------------------------------------------------
--Adding new date fields to track status change
----------------------------------------------------

ALTER TABLE [tblCase]
  ADD [DateCompleted] DATETIME
GO

ALTER TABLE [tblCase]
  ADD [DateCancelled] DATETIME
GO

DROP VIEW dbo.vwcasesummary
GO
CREATE VIEW dbo.vwCaseSummary
AS
    SELECT TOP 100 PERCENT
            dbo.tblCase.casenbr ,
            dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS schedulername ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblCase.priority ,
            dbo.tblCase.ApptDate ,
            dbo.tblCase.status ,
            dbo.tblCase.dateadded ,
            dbo.tblCase.claimnbr ,
            dbo.tblCase.doctorlocation ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.shownoshow ,
            dbo.tblCase.transcode ,
            dbo.tblCase.rptstatus ,
            dbo.tblLocation.location ,
            dbo.tblCase.dateedited ,
            dbo.tblCase.useridedited ,
            dbo.tblCase.apptselect ,
            dbo.tblClient.email AS adjusteremail ,
            dbo.tblClient.fax AS adjusterfax ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.requesteddoc ,
            dbo.tblCase.invoicedate ,
            dbo.tblCase.invoiceamt ,
            dbo.tblCase.datedrchart ,
            dbo.tblCase.drchartselect ,
            dbo.tblCase.inqaselect ,
            dbo.tblCase.intransselect ,
            dbo.tblCase.billedselect ,
            dbo.tblCase.awaittransselect ,
            dbo.tblCase.chartprepselect ,
            dbo.tblCase.apptrptsselect ,
            dbo.tblCase.transreceived ,
            dbo.tblTranscription.transcompany ,
            dbo.tblCase.servicecode ,
            dbo.tblQueues.statusdesc ,
            dbo.tblCase.miscselect ,
            dbo.tblCase.useridadded ,
            dbo.tblServices.shortdesc AS service ,
            dbo.tblCase.doctorcode ,
            dbo.tblClient.companycode ,
            dbo.tblCase.voucheramt ,
            dbo.tblCase.voucherdate ,
            dbo.tblCase.officecode ,
            dbo.tblCase.QARep ,
            dbo.tblCase.schedulercode ,
            DATEDIFF(day, dbo.tblCase.laststatuschg, GETDATE()) AS IQ ,
            dbo.tblCase.laststatuschg ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.mastersubcase ,
            dbo.tblCase.mastercasenbr ,
            dbo.tblCase.CertMailNbr ,
            dbo.tblCase.WebNotifyEmail ,
            dbo.tblCase.PublishOnWeb ,
            CASE WHEN dbo.tblcase.panelnbr IS NULL
                 THEN dbo.tbldoctor.lastname + ', '
                      + ISNULL(dbo.tbldoctor.firstname, ' ')
                 ELSE dbo.tblcase.doctorname
            END AS doctorname ,
            tblcase.datemedsrecd ,
            tblcase.sinternalcasenbr ,
            tblcase.doctorspecialty ,
            tblcase.usddate1 ,
            tblqueues.functioncode ,
            tblcase.casetype ,
            tblcase.DateCompleted ,
            tblCase.DateCancelled
    FROM    dbo.tblCase
            INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            LEFT OUTER JOIN dbo.tblTranscription ON dbo.tblCase.transcode = dbo.tblTranscription.transcode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblCompany
            INNER JOIN dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
    ORDER BY dbo.tblCase.priority ,
            dbo.tblCase.ApptDate

GO



UPDATE tblControl SET DBVersion='1.54'
GO
