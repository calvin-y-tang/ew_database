
CREATE TABLE [tblAnnouncement] (
  [AnnouncementID] INTEGER IDENTITY(1,1) NOT NULL,
  [AnnounceTitle] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Text] TEXT COLLATE SQL_Latin1_General_CP1_CI_AS,
  [dateadded] SMALLDATETIME,
  [useridadded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [expiredate] SMALLDATETIME,
  [DocumentPath] VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [isActive] BIT DEFAULT ((1)) NOT NULL
)
GO

CREATE TABLE [tblWebUserAccount] (
  [WebUserID] INTEGER NOT NULL,
  [UserCode] INTEGER NOT NULL,
  [IsUser] BIT DEFAULT ((1)) NOT NULL,
  [DateAdded] DATETIME DEFAULT (getdate()),
  [IsActive] BIT DEFAULT ((1)) NOT NULL,
  [UserType] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS
)
GO


ALTER TABLE [tblUserOfficeFunction]
  ALTER COLUMN [functioncode] VARCHAR(30)
GO


ALTER TABLE [tblCaseDocuments]
  ADD [Viewed] BIT DEFAULT ((0)) NOT NULL
GO


ALTER TABLE [tblCaseHistory]
  ADD [Viewed] BIT DEFAULT ((0)) NOT NULL
GO


ALTER TABLE [tblControl]
  ADD [AppTitle] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER TABLE [tblControl]
  ADD [DBVersion] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS
GO


ALTER TABLE [tblWebUser]
  ADD [IsChangePassword] BIT DEFAULT ((0)) NOT NULL
GO

ALTER TABLE [tblWebUser]
  ADD [IsClientAdmin] BIT DEFAULT ((0)) NOT NULL
GO

ALTER TABLE [tblWebUser]
  ADD [UpdateFlag] BIT DEFAULT ((0)) NOT NULL
GO


ALTER TABLE [tblRecordHistory]
  ALTER COLUMN [Inches] DECIMAL(18,2)
GO


ALTER TABLE [tblUserFunction]
  ALTER COLUMN [functioncode] VARCHAR(30) NOT NULL
GO


CREATE PROCEDURE [proc_CaseProblem_Insert]
(
 @casenbr int,
 @problemcode int,
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
  [dateadded],
  [useridadded]
 )
 VALUES
 (
  @casenbr,
  @problemcode,
  @dateadded,
  @useridadded
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetReferralSearch] 

@WebUserID int = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

 SELECT DISTINCT
  tblWebQueues.statuscode, 
  tblCase.casenbr, 
  tblCase.DoctorName AS provider, 
  tblCase.ApptDate, 
  tblCase.chartnbr, 
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


CREATE PROCEDURE [proc_CaseProblem_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseProblem]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseProblem_LoadByPrimaryKey]
(
 @casenbr int,
 @problemcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [casenbr],
  [problemcode],
  [dateadded],
  [useridadded]
 FROM [tblcaseproblem]
 WHERE
  ([casenbr] = @casenbr) AND
  ([problemcode] = @problemcode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [dbo].[proc_GetAdminReferralSummaryNew]

@WebStatus varchar(50)

AS

SET NOCOUNT OFF
DECLARE @Err int

  SELECT TOP 100 PERCENT 
  tblCase.casenbr, 
  tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
  tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
  tblCompany.extname AS companyname, 
  tblCase.ApptDate,
  tblCase.claimnbr, 
  tblServices.description AS service, 
  tblCase.DoctorName AS provider, 
  tblWebQueues.description AS WebStatus,
  tblWebQueues.statuscode, 
  ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr,
  tblClient.clientcode
  FROM tblCase
  INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
  INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
  INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
  INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
  INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
  LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
  WHERE (tblWebQueues.statuscode = @WebStatus)
  AND (tblCase.Casenbr IN
   (SELECT DISTINCT TableKey FROM tblPublishOnWeb
   WHERE tblPublishOnWeb.TableType = 'tblCase' 
   AND tblPublishOnWeb.PublishOnWeb = 1 AND TableKey > 0))
  AND (tblCase.status <> 0)

SET @Err = @@Error
RETURN @Err


GO


CREATE PROCEDURE [proc_CaseProblem_Update]
(
 @casenbr int,
 @problemcode int,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcaseproblem]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded
 WHERE
  [casenbr] = @casenbr
 AND [problemcode] = @problemcode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [dbo].[proc_GetReferralSummaryNew]

@WebStatus varchar(50),
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
  tblCompany.extname AS companyname, 
  tblCase.ApptDate, 
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
  WHERE (tblWebQueues.statuscode = @WebStatus)
  AND (tblCase.status <> 0)

 SET @Err = @@Error

 RETURN @Err
END



GO


CREATE PROCEDURE [proc_Client_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tbldoctordocumentsInsert]
(
 @doctorcode int,
 @recid int,
 @type varchar(30) = NULL,
 @description varchar(50) = NULL,
 @expiredate datetime = NULL,
 @pathfilename varchar(120) = NULL,
 @dateadded datetime,
 @useridadded varchar(20) = NULL,
 @PublishOnWeb bit = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tbldoctordocuments]
 (
  [doctorcode],
  [recid],
  [type],
  [description],
  [expiredate],
  [pathfilename],
  [dateadded],
  [useridadded],
  [PublishOnWeb]
 )
 VALUES
 (
  @doctorcode,
  @recid,
  @type,
  @description,
  @expiredate,
  @pathfilename,
  @dateadded,
  @useridadded,
  @PublishOnWeb
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Client_LoadByPrimaryKey]
(
 @clientcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]
 WHERE
  ([clientcode] = @clientcode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tbldoctordocumentsUpdate]
(
 @doctorcode int,
 @recid int,
 @type varchar(30) = NULL,
 @description varchar(50) = NULL,
 @expiredate datetime = NULL,
 @pathfilename varchar(120) = NULL,
 @PublishOnWeb bit = NULL,
 @DateEdited datetime = NULL,
 @UserIDEdited varchar(30) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tbldoctordocuments]
 SET
  [type] = @type,
  [description] = @description,
  [expiredate] = @expiredate,
  [pathfilename] = @pathfilename,
  [PublishOnWeb] = @PublishOnWeb,
  [DateEdited] = @DateEdited,
  [UserIDEdited] = @UserIDEdited
 WHERE
  [doctorcode] = @doctorcode
 AND [recid] = @recid


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_UpdateViewed]

@casenbr int

AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE tblCaseHistory SET viewed = 1 WHERE casenbr = @casenbr AND PublishOnWeb = 1

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetCaseIssuesByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseIssue 
 INNER JOIN tblIssue ON tblCaseIssue.issuecode = tblIssue.issuecode 
 WHERE casenbr = @CaseNbr

GO


CREATE PROCEDURE [proc_Company_LoadByPrimaryKey]
(
 @companycode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCompany]
 WHERE
  ([companycode] = @companycode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetCaseProblemsByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseProblem 
 INNER JOIN tblProblem ON tblCaseProblem.Problemcode = tblProblem.Problemcode 
 WHERE casenbr = @CaseNbr

GO


CREATE PROCEDURE [proc_Doctor_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblDoctor]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetClientSubordinates]

@WebUserID int

AS 

SELECT DISTINCT lastname + ', ' + firstname name, clientcode FROM tblclient 
WHERE clientcode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = @WebUserID) ORDER BY name

GO


CREATE PROCEDURE [proc_Doctor_LoadByPrimaryKey]
(
 @DoctorCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblDoctor]
 WHERE
  ([DoctorCode] = @DoctorCode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetSuperUserComboItems]

AS

SELECT DISTINCT tblwebuseraccount.webuserid AS webID, tblCompany.extname company, firstname + ' ' + lastname + ' - ' + tblCompany.extname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 
ORDER BY company, name




GO


CREATE PROCEDURE [proc_Examinee_Delete]
(
 @chartnbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblExaminee]
 WHERE
  [chartnbr] = @chartnbr
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblWebUserAccountUpdate]
(
 @WebUserID int,
 @UserCode int,
 @DateAdded datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebUserAccount]
 SET
  [DateAdded] = @DateAdded
 WHERE
  [WebUserID] = @WebUserID
 AND [UserCode] = @UserCode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblActionsInsert]
(
 @ActionID uniqueidentifier,
 @action_AddedDate datetime,
 @action_UserGUID uniqueidentifier = NULL,
 @action_command varchar(15),
 @action_param1 varchar(255),
 @action_param2 varchar(255) = NULL,
 @action_param3 varchar(255) = NULL,
 @action_param4 varchar(255) = NULL,
 @action_param5 text = NULL,
 @action_ResponseDate datetime = NULL,
 @action_ResponseCode int = NULL,
 @action_ResponseMessage text = NULL,
 @action_localID int = NULL,
 @action_localIDType int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int
 IF @ActionID IS NULL
   SET @ActionID = NEWID()

 SET @Err = @@Error

 IF (@Err <> 0)
     RETURN @Err


 INSERT
 INTO [tblActions]
 (
  [ActionID],
  [action_AddedDate],
  [action_UserGUID],
  [action_command],
  [action_param1],
  [action_param2],
  [action_param3],
  [action_param4],
  [action_param5],
  [action_ResponseDate],
  [action_ResponseCode],
  [action_ResponseMessage],
  [action_localID],
  [action_localIDType]
 )
 VALUES
 (
  @ActionID,
  @action_AddedDate,
  @action_UserGUID,
  @action_command,
  @action_param1,
  @action_param2,
  @action_param3,
  @action_param4,
  @action_param5,
  @action_ResponseDate,
  @action_ResponseCode,
  @action_ResponseMessage,
  @action_localID,
  @action_localIDType
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Specialty_LoadByPrimaryKey]
(
 @specialtycode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblSpecialty]
 WHERE
  ([specialtycode] = @specialtycode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Examinee_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblExaminee]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblClientInsert]
(
 @companycode int = NULL,
 @clientcode int,
 @clientnbrold varchar(10) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @title varchar(50) = NULL,
 @prefix varchar(10) = NULL,
 @suffix varchar(50) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @phone1 varchar(15) = NULL,
 @phone1ext varchar(15) = NULL,
 @phone2 varchar(15) = NULL,
 @phone2ext varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @marketercode varchar(15) = NULL,
 @priority varchar(10) = NULL,
 @casetype varchar(20) = NULL,
 @feeschedule int = NULL,
 @status varchar(10) = NULL,
 @reportphone bit = NULL,
 @documentemail bit = NULL,
 @documentfax bit = NULL,
 @documentmail bit = NULL,
 @lastappt datetime = NULL,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(15) = NULL,
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
 @notes text = NULL,
 @billaddr1 varchar(50) = NULL,
 @billaddr2 varchar(50) = NULL,
 @billcity varchar(50) = NULL,
 @billstate varchar(2) = NULL,
 @billzip varchar(10) = NULL,
 @billattn varchar(70) = NULL,
 @ARKey varchar(50) = NULL,
 @billfax varchar(15) = NULL,
 @QARep varchar(15) = NULL,
 @photoRqd bit = NULL,
 @CertifiedMail bit = NULL,
 @Country varchar(50) = NULL,
 @PublishOnWeb bit = NULL,
 @WebGUID uniqueidentifier = NULL,
 @WebLastSynchDate datetime = NULL,
 @ProcessorFirstName varchar(30) = NULL,
 @ProcessorLastName varchar(50) = NULL,
 @ProcessorPhone varchar(15) = NULL,
 @ProcessorPhoneExt varchar(10) = NULL,
 @ProcessorFax varchar(15) = NULL,
 @ProcessorEmail varchar(200) = NULL,
 @DefOfficeCode int = NULL,
 @WebUserID int = NULL,
 @DocumentPublish bit = NULL 
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblClient]
 (
  [companycode],
  [clientcode],
  [clientnbrold],
  [lastname],
  [firstname],
  [title],
  [prefix],
  [suffix],
  [addr1],
  [addr2],
  [city],
  [state],
  [zip],
  [phone1],
  [phone1ext],
  [phone2],
  [phone2ext],
  [fax],
  [email],
  [marketercode],
  [priority],
  [casetype],
  [feeschedule],
  [status],
  [reportphone],
  [documentemail],
  [documentfax],
  [documentmail],
  [lastappt],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited],
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
  [notes],
  [billaddr1],
  [billaddr2],
  [billcity],
  [billstate],
  [billzip],
  [billattn],
  [ARKey],
  [billfax],
  [QARep],
  [photoRqd],
  [CertifiedMail],
  [Country],
  [PublishOnWeb],
  [WebGUID],
  [WebLastSynchDate],
  [ProcessorFirstName],
  [ProcessorLastName],
  [ProcessorPhone],
  [ProcessorPhoneExt],
  [ProcessorFax],
  [ProcessorEmail],
  [DefOfficeCode],
  [WebUserID],
  [DocumentPublish]  
 )
 VALUES
 (
  @companycode,
  @clientcode,
  @clientnbrold,
  @lastname,
  @firstname,
  @title,
  @prefix,
  @suffix,
  @addr1,
  @addr2,
  @city,
  @state,
  @zip,
  @phone1,
  @phone1ext,
  @phone2,
  @phone2ext,
  @fax,
  @email,
  @marketercode,
  @priority,
  @casetype,
  @feeschedule,
  @status,
  @reportphone,
  @documentemail,
  @documentfax,
  @documentmail,
  @lastappt,
  @dateadded,
  @useridadded,
  @dateedited,
  @useridedited,
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
  @notes,
  @billaddr1,
  @billaddr2,
  @billcity,
  @billstate,
  @billzip,
  @billattn,
  @ARKey,
  @billfax,
  @QARep,
  @photoRqd,
  @CertifiedMail,
  @Country,
  @PublishOnWeb,
  @WebGUID,
  @WebLastSynchDate,
  @ProcessorFirstName,
  @ProcessorLastName,
  @ProcessorPhone,
  @ProcessorPhoneExt,
  @ProcessorFax,
  @ProcessorEmail,
  @DefOfficeCode,
  @WebUserID,
  @DocumentPublish  
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblWebUserAccountInsert]
(
 @WebUserID int,
 @UserCode int,
 @IsUser bit = 1,
 @UserType char(2) = null,
 @DateAdded datetime = null
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebUserAccount]
 (
  [WebUserID],
  [UserCode],
  [IsUser],
  [UserType],
  [DateAdded]
 )
 VALUES
 (
  @WebUserID,
  @UserCode,
  @IsUser,
  @UserType,
  getdate()
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUser_Delete]
(
 @WebUserID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebUser]
 WHERE
  [WebUserID] = @WebUserID
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetProviderSearch]

AS

SET NOCOUNT OFF
DECLARE @Err int


 SELECT DISTINCT 
  tblLocation.locationcode,
  tbldoctor.lastname, 
  tblDoctor.firstname, 
  tbldoctor.credentials, 
        tblSpecialty.description specialty,
        tblSpecialty.specialtycode,
        tblLocation.zip, 
        tblLocation.city,
        tblLocation.location, 
        tblLocation.state, 
        tbldoctor.prepaid, 
        tblLocation.county,
        tblLocation.phone,
        tblDoctor.ProvTypeCode,
        tblDoctor.doctorcode, 
        ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
        FROM tblDoctor
        LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
        LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
        LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
        LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
        LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode
        LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
        WHERE (tblDoctor.status = 'Active') AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1) AND (tblLocation.locationcode is not null)

SET @Err = @@Error
RETURN @Err
 



GO


CREATE PROCEDURE [proc_WebUser_Insert]
(
 @WebUserID int = NULL output,
 @UserID varchar(100) = NULL,
 @Password varchar(100) = NULL,
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
 @IsChangePassword bit,
 @IsClientAdmin bit,
 @UpdateFlag bit
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
  [IsChangePassword],
  [IsClientAdmin],
  [UpdateFlag]
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
  @IsChangePassword,
  @IsClientAdmin,
  @UpdateFlag
 )

 SET @Err = @@Error

 SELECT @WebUserID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Examinee_LoadByPrimaryKey]
(
 @chartnbr int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblExaminee]
 WHERE
  ([chartnbr] = @chartnbr)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetProblemComboItems]

AS

SELECT problemcode, description from tblProblem 
WHERE PublishOnWeb = 1
ORDER BY description



GO


CREATE PROCEDURE [proc_GetSuperUserSelUserListItems]

@WebUserID int

AS

SELECT DISTINCT cast(clientcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
tblCompany.extname company, firstname + ' ' + lastname + ' - ' + tblCompany.extname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.clientcode = tblwebuseraccount.usercode and isuser = 0 
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
 WHERE tblwebuseraccount.WebUserID = @WebUserID
UNION
SELECT DISTINCT cast(cccode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.cccode = tblwebuseraccount.usercode and isuser = 0
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
UNION
SELECT DISTINCT cast(doctorcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.doctorcode = tblwebuseraccount.usercode and isuser = 0 
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
UNION
SELECT DISTINCT cast(transcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.transcode = tblwebuseraccount.usercode and isuser = 0 
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
ORDER BY company, name






GO


CREATE PROCEDURE [proc_WebUser_LoadByPrimaryKey]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]
 WHERE
  ([WebUserID] = @WebUserID)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_AdminGetUserGrid]

AS

SET NOCOUNT OFF
DECLARE @Err int

  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, tblCompany.extname company, firstname + ' ' + lastname + ' - ' +  tblCompany.extname name
        FROM tblclient
        INNER JOIN tblwebuser ON tblclient.clientcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'CL')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'        
        INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name
        FROM tblCCAddress
        INNER JOIN tblwebuser ON tblCCAddress.cccode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'AT' OR tblWebUser.UserType = 'CC')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')        

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name
        FROM tblDoctor
        INNER JOIN tblwebuser ON tblDoctor.doctorcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'DR' OR tblWebUser.UserType = 'OP')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')           

  UNION
  SELECT DISTINCT transcompany, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
        FROM tblTranscription
        INNER JOIN tblwebuser ON tblTranscription.transcode = tblwebuser.IMECentricCode AND tblWebUser.UserType = 'TR'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.transcode
   AND tblWebUserAccount.UserType = 'TR'         

SET @Err = @@Error
RETURN @Err
 



GO


CREATE PROCEDURE [proc_GetIssueComboItems]

AS

SELECT issuecode,description from tblIssue 
WHERE PublishOnWeb = 1
ORDER BY description



GO


CREATE PROCEDURE [proc_Examinee_Update]
(
 @chartnbr int,
 @oldchartnbr varchar(15) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @middleinitial varchar(5) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @phone1 varchar(15) = NULL,
 @phone2 varchar(15) = NULL,
 @SSN varchar(15) = NULL,
 @sex varchar(10) = NULL,
 @DOB datetime = NULL,
 @dateadded datetime = NULL,
 @dateedited datetime = NULL,
 @useridadded varchar(15) = NULL,
 @useridedited varchar(15) = NULL,
 @note text = NULL,
 @county varchar(50) = NULL,
 @prefix varchar(10) = NULL,
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
 @fax varchar(15) = NULL,
 @email varchar(50) = NULL,
 @insured varchar(50) = NULL,
 @employer varchar(70) = NULL,
 @treatingphysician varchar(70) = NULL,
 @InsuredAddr1 varchar(70) = NULL,
 @InsuredCity varchar(70) = NULL,
 @InsuredState varchar(5) = NULL,
 @InsuredZip varchar(10) = NULL,
 @InsuredSex varchar(10) = NULL,
 @InsuredRelationship varchar(20) = NULL,
 @InsuredPhone varchar(15) = NULL,
 @InsuredPhoneExt varchar(10) = NULL,
 @InsuredFax varchar(15) = NULL,
 @InsuredEmail varchar(70) = NULL,
 @ExamineeStatus varchar(30) = NULL,
 @TreatingPhysicianAddr1 varchar(70) = NULL,
 @TreatingPhysicianCity varchar(70) = NULL,
 @TreatingPhysicianState varchar(5) = NULL,
 @TreatingPhysicianZip varchar(10) = NULL,
 @TreatingPhysicianPhone varchar(15) = NULL,
 @TreatingPhysicianPhoneExt varchar(10) = NULL,
 @TreatingPhysicianFax varchar(15) = NULL,
 @TreatingPhysicianEmail varchar(70) = NULL,
 @EmployerAddr1 varchar(70) = NULL,
 @EmployerCity varchar(70) = NULL,
 @EmployerState varchar(5) = NULL,
 @EmployerZip varchar(10) = NULL,
 @EmployerPhone varchar(15) = NULL,
 @EmployerPhoneExt varchar(10) = NULL,
 @EmployerFax varchar(15) = NULL,
 @EmployerEmail varchar(70) = NULL,
 @Country varchar(50) = NULL,
 @policynumber varchar(70) = NULL,
 @EmployerContactFirstName varchar(50) = NULL,
 @EmployerContactLastName varchar(50) = NULL,
 @TreatingPhysicianLicenseNbr varchar(50) = NULL,
 @TreatingPhysicianTaxID varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblExaminee]
 SET
  [oldchartnbr] = @oldchartnbr,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [middleinitial] = @middleinitial,
  [addr1] = @addr1,
  [addr2] = @addr2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone1] = @phone1,
  [phone2] = @phone2,
  [SSN] = @SSN,
  [sex] = @sex,
  [DOB] = @DOB,
  [dateadded] = @dateadded,
  [dateedited] = @dateedited,
  [useridadded] = @useridadded,
  [useridedited] = @useridedited,
  [note] = @note,
  [county] = @county,
  [prefix] = @prefix,
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
  [fax] = @fax,
  [email] = @email,
  [insured] = @insured,
  [employer] = @employer,
  [treatingphysician] = @treatingphysician,
  [InsuredAddr1] = @InsuredAddr1,
  [InsuredCity] = @InsuredCity,
  [InsuredState] = @InsuredState,
  [InsuredZip] = @InsuredZip,
  [InsuredSex] = @InsuredSex,
  [InsuredRelationship] = @InsuredRelationship,
  [InsuredPhone] = @InsuredPhone,
  [InsuredPhoneExt] = @InsuredPhoneExt,
  [InsuredFax] = @InsuredFax,
  [InsuredEmail] = @InsuredEmail,
  [ExamineeStatus] = @ExamineeStatus,
  [TreatingPhysicianAddr1] = @TreatingPhysicianAddr1,
  [TreatingPhysicianCity] = @TreatingPhysicianCity,
  [TreatingPhysicianState] = @TreatingPhysicianState,
  [TreatingPhysicianZip] = @TreatingPhysicianZip,
  [TreatingPhysicianPhone] = @TreatingPhysicianPhone,
  [TreatingPhysicianPhoneExt] = @TreatingPhysicianPhoneExt,
  [TreatingPhysicianFax] = @TreatingPhysicianFax,
  [TreatingPhysicianEmail] = @TreatingPhysicianEmail,
  [EmployerAddr1] = @EmployerAddr1,
  [EmployerCity] = @EmployerCity,
  [EmployerState] = @EmployerState,
  [EmployerZip] = @EmployerZip,
  [EmployerPhone] = @EmployerPhone,
  [EmployerPhoneExt] = @EmployerPhoneExt,
  [EmployerFax] = @EmployerFax,
  [EmployerEmail] = @EmployerEmail,
  [Country] = @Country,
  [policynumber] = @policynumber,
  [EmployerContactFirstName] = @EmployerContactFirstName,
  [EmployerContactLastName] = @EmployerContactLastName,
  [TreatingPhysicianLicenseNbr] = @TreatingPhysicianLicenseNbr,
  [TreatingPhysicianTaxID] = @TreatingPhysicianTaxID
 WHERE
  [chartnbr] = @chartnbr


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUser_Update]
(
 @WebUserID int,
 @UserID varchar(100) = NULL,
 @Password varchar(100) = NULL,
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
 @IsChangePassword bit,
 @IsClientAdmin bit,
 @UpdateFlag bit
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
  [IsChangePassword] = @IsChangePassword,
  [IsClientAdmin] = @IsClientAdmin,
  [UpdateFlag] = @UpdateFlag
 WHERE
  [WebUserID] = @WebUserID


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_IMECase_Delete]
(
 @casenbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCase]
 WHERE
  [casenbr] = @casenbr
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblCompanyInsert]
(
 @companycode int,
 @extname varchar(70) = NULL,
 @intname varchar(70) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @marketercode varchar(15) = NULL,
 @priority varchar(10) = NULL,
 @phone varchar(15) = NULL,
 @status varchar(10) = NULL,
 @dateadded datetime = NULL,
 @useridadded varchar(20) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(20) = NULL,
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
 @credithold bit = NULL,
 @feecode int = NULL,
 @notes text = NULL,
 @preinvoice bit = NULL,
 @invoicedocument varchar(15) = NULL,
 @QARep varchar(15) = NULL,
 @photoRqd bit = NULL,
 @Country varchar(50) = NULL,
 @PublishOnWeb bit = NULL,
 @WebGUID uniqueidentifier = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCompany]
 (
  [companycode],
  [extname],
  [intname],
  [addr1],
  [addr2],
  [city],
  [state],
  [zip],
  [marketercode],
  [priority],
  [phone],
  [status],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited],
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
  [credithold],
  [feecode],
  [notes],
  [preinvoice],
  [invoicedocument],
  [QARep],
  [photoRqd],
  [Country],
  [PublishOnWeb],
  [WebGUID]
 )
 VALUES
 (
  @companycode,
  @extname,
  @intname,
  @addr1,
  @addr2,
  @city,
  @state,
  @zip,
  @marketercode,
  @priority,
  @phone,
  @status,
  @dateadded,
  @useridadded,
  @dateedited,
  @useridedited,
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
  @credithold,
  @feecode,
  @notes,
  @preinvoice,
  @invoicedocument,
  @QARep,
  @photoRqd,
  @Country,
  @PublishOnWeb,
  @WebGUID
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblAnnouncementDelete]
(
 @AnnouncementID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblAnnouncement]
 WHERE
  [AnnouncementID] = @AnnouncementID
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUserAccount_Delete]
(
 @WebUserID int,
 @UserCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebUserAccount]
 WHERE
  [WebUserID] = @WebUserID AND
  [UserCode] = @UserCode
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Doctor_GetActiveDoctors]

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT doctorcode, ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
  FROM tblDoctor WHERE (status = 'Active') AND (OPType = 'DR') AND (PublishOnWeb = 1) ORDER BY lastname, firstname

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetCaseTypeComboItems]

AS

SELECT [code], [description] FROM [tblCaseType] 
WHERE PublishOnWeb = 1
ORDER BY [description]








GO


CREATE PROCEDURE [proc_tblExamineeUpdate]
(
 @chartnbr int,
 @oldchartnbr varchar(15) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @middleinitial varchar(5) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @phone1 varchar(15) = NULL,
 @phone2 varchar(15) = NULL,
 @SSN varchar(15) = NULL,
 @sex varchar(10) = NULL,
 @DOB datetime = NULL,
 @dateadded datetime = NULL,
 @dateedited datetime = NULL,
 @useridadded varchar(15) = NULL,
 @useridedited varchar(15) = NULL,
 @note text = NULL,
 @county varchar(50) = NULL,
 @prefix varchar(10) = NULL,
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
 @fax varchar(15) = NULL,
 @email varchar(50) = NULL,
 @insured varchar(50) = NULL,
 @employer varchar(70) = NULL,
 @treatingphysician varchar(70) = NULL,
 @InsuredAddr1 varchar(70) = NULL,
 @InsuredCity varchar(70) = NULL,
 @InsuredState varchar(5) = NULL,
 @InsuredZip varchar(10) = NULL,
 @InsuredSex varchar(10) = NULL,
 @InsuredRelationship varchar(20) = NULL,
 @InsuredPhone varchar(15) = NULL,
 @InsuredPhoneExt varchar(10) = NULL,
 @InsuredFax varchar(15) = NULL,
 @InsuredEmail varchar(70) = NULL,
 @ExamineeStatus varchar(30) = NULL,
 @TreatingPhysicianAddr1 varchar(70) = NULL,
 @TreatingPhysicianCity varchar(70) = NULL,
 @TreatingPhysicianState varchar(5) = NULL,
 @TreatingPhysicianZip varchar(10) = NULL,
 @TreatingPhysicianPhone varchar(15) = NULL,
 @TreatingPhysicianPhoneExt varchar(10) = NULL,
 @TreatingPhysicianFax varchar(15) = NULL,
 @TreatingPhysicianEmail varchar(70) = NULL,
 @EmployerAddr1 varchar(70) = NULL,
 @EmployerCity varchar(70) = NULL,
 @EmployerState varchar(5) = NULL,
 @EmployerZip varchar(10) = NULL,
 @EmployerPhone varchar(15) = NULL,
 @EmployerPhoneExt varchar(10) = NULL,
 @EmployerFax varchar(15) = NULL,
 @EmployerEmail varchar(70) = NULL,
 @Country varchar(50) = NULL,
 @policynumber varchar(70) = NULL,
 @EmployerContactFirstName varchar(50) = NULL,
 @EmployerContactLastName varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblExaminee]
 SET
  [oldchartnbr] = @oldchartnbr,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [middleinitial] = @middleinitial,
  [addr1] = @addr1,
  [addr2] = @addr2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone1] = @phone1,
  [phone2] = @phone2,
  [SSN] = @SSN,
  [sex] = @sex,
  [DOB] = @DOB,
  [dateadded] = @dateadded,
  [dateedited] = @dateedited,
  [useridadded] = @useridadded,
  [useridedited] = @useridedited,
  [note] = @note,
  [county] = @county,
  [prefix] = @prefix,
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
  [fax] = @fax,
  [email] = @email,
  [insured] = @insured,
  [employer] = @employer,
  [treatingphysician] = @treatingphysician,
  [InsuredAddr1] = @InsuredAddr1,
  [InsuredCity] = @InsuredCity,
  [InsuredState] = @InsuredState,
  [InsuredZip] = @InsuredZip,
  [InsuredSex] = @InsuredSex,
  [InsuredRelationship] = @InsuredRelationship,
  [InsuredPhone] = @InsuredPhone,
  [InsuredPhoneExt] = @InsuredPhoneExt,
  [InsuredFax] = @InsuredFax,
  [InsuredEmail] = @InsuredEmail,
  [ExamineeStatus] = @ExamineeStatus,
  [TreatingPhysicianAddr1] = @TreatingPhysicianAddr1,
  [TreatingPhysicianCity] = @TreatingPhysicianCity,
  [TreatingPhysicianState] = @TreatingPhysicianState,
  [TreatingPhysicianZip] = @TreatingPhysicianZip,
  [TreatingPhysicianPhone] = @TreatingPhysicianPhone,
  [TreatingPhysicianPhoneExt] = @TreatingPhysicianPhoneExt,
  [TreatingPhysicianFax] = @TreatingPhysicianFax,
  [TreatingPhysicianEmail] = @TreatingPhysicianEmail,
  [EmployerAddr1] = @EmployerAddr1,
  [EmployerCity] = @EmployerCity,
  [EmployerState] = @EmployerState,
  [EmployerZip] = @EmployerZip,
  [EmployerPhone] = @EmployerPhone,
  [EmployerPhoneExt] = @EmployerPhoneExt,
  [EmployerFax] = @EmployerFax,
  [EmployerEmail] = @EmployerEmail,
  [Country] = @Country,
  [policynumber] = @policynumber,
  [EmployerContactFirstName] = @EmployerContactFirstName,
  [EmployerContactLastName] = @EmployerContactLastName
 WHERE
  [chartnbr] = @chartnbr


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUserAccount_Insert]
(
 @WebUserID int,
 @UserCode int,
 @IsUser bit,
 @DateAdded datetime = NULL,
 @IsActive bit,
 @UserType char(2) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebUserAccount]
 (
  [WebUserID],
  [UserCode],
  [IsUser],
  [DateAdded],
  [IsActive],
  [UserType]
 )
 VALUES
 (
  @WebUserID,
  @UserCode,
  @IsUser,
  @DateAdded,
  @IsActive,
  @UserType
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Doctor_GetDocuments]

@DoctorCode int

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblDoctorDocuments 
  INNER JOIN tblDoctor ON tblDoctorDocuments.doctorcode = tblDoctor.doctorcode 
  WHERE tblDoctorDocuments.doctorcode = @DoctorCode
  AND tblDoctorDocuments.publishonweb = 1 ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblWebUserInsert]
(
 @WebUserID int = NULL output,
 @UserID varchar(100) = NULL,
 @Password varchar(100) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL
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
  [DateAdded]
 )
 VALUES
 (
  @UserID,
  @Password,
  @LastLoginDate,
  @DateAdded
 )

 SET @Err = @@Error

 SELECT @WebUserID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_IMECase_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCase]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUserAccount_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUserAccount]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_IMECase_LoadByPrimaryKey]
(
 @casenbr int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCase]
 WHERE
  ([casenbr] = @casenbr)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddressCheckForDupe]

@Company varchar(100) = NULL,
@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

SELECT cccode FROM tblCCAddress WHERE cccode > 0 
 AND Company = COALESCE(@Company,Company)
 AND FirstName = COALESCE(@FirstName,FirstName)
 AND LastName = COALESCE(@LastName,LastName)
 AND Phone = COALESCE(@Phone,Phone)

SET @Err = @@Error
RETURN @Err
 



GO


CREATE PROCEDURE [proc_Doctor_GetApptCount]

@ApptEvt char(3) = '',
@DoctorCode varchar(20) = '',
@LocationCode varchar(20) = '',
@ApptDate varchar(20) = ''

AS

SET NOCOUNT ON
DECLARE @Err int
 
    IF @ApptEvt = 'Doc'
  BEGIN
   SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule WHERE date = @ApptDate AND DoctorCode = @DoctorCode AND status = 'open'
            AND tblDoctorSchedule.locationcode IN (select distinct locationcode from tblLocation where tblLocation.insidedr = 1)
  END 
    IF @ApptEvt = 'Loc'
  BEGIN
   SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule WHERE date = @ApptDate AND LocationCode = @LocationCode AND status = 'open'
            AND tblDoctorSchedule.locationcode IN (select distinct locationcode from tblLocation where tblLocation.insidedr = 1)
  END 
 ELSE
  BEGIN
   SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule WHERE date = @ApptDate AND status = 'open'
            AND tblDoctorSchedule.locationcode IN (select distinct locationcode from tblLocation where tblLocation.insidedr = 1)
  END  
  
SET @Err = @@Error
RETURN @Err


GO


CREATE PROCEDURE [proc_WebUserAccount_LoadByPrimaryKey]
(
 @WebUserID int,
 @UserCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [WebUserID],
  [UserCode],
  [IsUser],
  [DateAdded],
  [IsActive],
  [UserType]
 FROM [tblWebUserAccount]
 WHERE
  ([WebUserID] = @WebUserID) AND
  ([UserCode] = @UserCode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUser_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_ExamineeCheckForDupe]

@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone1 varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int


SELECT chartnbr FROM tblExaminee WHERE chartnbr > 0 
 AND FirstName = COALESCE(@FirstName,FirstName)
 AND LastName = COALESCE(@LastName,LastName)
 AND Phone1 = COALESCE(@Phone1,Phone1)

SET @Err = @@Error
RETURN @Err
 



GO


CREATE PROCEDURE [proc_WebUser_CheckIfSupervisor]

@WebUserID int

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT Count(UserCode) FROM tblWebUserAccount WHERE WebUserID = @WebUserID


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebUserAccount_Update]
(
 @WebUserID int,
 @UserCode int,
 @IsUser bit,
 @DateAdded datetime = NULL,
 @IsActive bit,
 @UserType char(2) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebUserAccount]
 SET
  [IsUser] = @IsUser,
  [DateAdded] = @DateAdded,
  [IsActive] = @IsActive,
  [UserType] = @UserType
 WHERE
  [WebUserID] = @WebUserID
 AND [UserCode] = @UserCode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblAnnouncementInsert]
(
 @AnnouncementID int = NULL output,
 @AnnounceTitle varchar(100) = NULL,
 @Text text = NULL,
 @dateadded smalldatetime = NULL,
 @useridadded varchar(30) = NULL,
 @expiredate smalldatetime = NULL,
 @DocumentPath varchar(255),
 @isActive bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblAnnouncement]
 (
  [AnnounceTitle],
  [Text],
  [dateadded],
  [useridadded],
  [expiredate],
  [DocumentPath],
  [isActive]
 )
 VALUES
 (
  @AnnounceTitle,
  @Text,
  @dateadded,
  @useridadded,
  @expiredate,
  @DocumentPath,
  @isActive
 )

 SET @Err = @@Error

 SELECT @AnnouncementID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_getActiveAdminCases]

AS SELECT DISTINCT
 COUNT(*) AS NbrofCases, 
 tblWebQueues.statuscode AS WebStatus, 
 tblWebQueues.description AS WebDescription, 
    tblWebQueues.displayorder
FROM tblCase
 INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
 INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
WHERE (tblCase.status <> 0)
AND tblCase.casenbr IN (SELECT DISTINCT TableKey FROM tblPublishOnWeb
  WHERE tblPublishOnWeb.TableType = 'tblCase' 
  AND tblPublishOnWeb.PublishOnWeb = 1) 
GROUP BY 
 tblWebQueues.statuscode, 
 tblWebQueues.description, 
 tblWebQueues.displayorder
ORDER BY 
 tblWebQueues.displayorder


GO


CREATE PROCEDURE [proc_WebUserSubordinate_Delete]

@WebUserID int

AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE FROM tblWebUserAccount WHERE WebUserID = @WebUserID AND IsUser = 0

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetExamineeComboItems]

AS

SELECT DISTINCT chartnbr, lastname, firstname, lastname + ', ' + firstname AS ExamineeName 
FROM tblExaminee 

WHERE (NOT (tblExaminee.lastname IS NULL)) AND (NOT (tblExaminee.firstname IS NULL)) 
 AND (NOT (tblExaminee.lastname = '')) AND (NOT (tblExaminee.firstname = '')) 
ORDER BY tblExaminee.lastname



GO


CREATE PROCEDURE [proc_Issue_LoadByPrimaryKey]
(
 @issuecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblIssue]
 WHERE
  ([issuecode] = @issuecode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_getActiveCases]
@WebUserID int

AS 

SELECT DISTINCT
 COUNT(*) AS NbrofCases, 
 tblWebQueues.statuscode AS WebStatus, 
 tblWebQueues.description AS WebDescription, 
    tblWebQueues.displayorder
FROM tblCase
 INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
 INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
 INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
  AND tblPublishOnWeb.tabletype = 'tblCase'
  AND tblPublishOnWeb.PublishOnWeb = 1 
 INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
  AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType 
  AND tblWebUserAccount.WebUserID = @WebUserID
WHERE (tblCase.status <> 0)
GROUP BY 
 tblWebQueues.statuscode, 
 tblWebQueues.description, 
 tblWebQueues.displayorder
ORDER BY 
 tblWebQueues.displayorder


GO


CREATE PROCEDURE [proc_GetServiceComboItems]

AS

SELECT [servicecode], [description] FROM [tblServices] 
WHERE PublishOnWeb = 1
ORDER BY [description]



GO


CREATE PROCEDURE [proc_GetExamineeComboItemsByWebUserIDNew]

@WebUserID int

AS

SELECT DISTINCT tblExaminee.chartnbr, lastname + ', ' + firstname AS ExamineeName 
FROM tblExaminee
INNER JOIN tblCase ON tblExaminee.chartnbr = tblCase.chartnbr 
INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
 AND tblPublishOnWeb.tabletype = 'tblCase'
 AND tblPublishOnWeb.PublishOnWeb = 1 
INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
 AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType 
 AND tblWebUserAccount.WebUserID = @WebUserID 
ORDER BY ExamineeName


GO


CREATE PROCEDURE [proc_ProviderType_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblProviderType ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Queues_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblQueues]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblAnnouncementUpdate]
(
 @AnnouncementID int,
 @AnnounceTitle varchar(100) = NULL,
 @Text text = NULL,
 @expiredate smalldatetime = NULL,
 @DocumentPath varchar(255),
 @isActive bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblAnnouncement]
 SET
  [AnnounceTitle] = @AnnounceTitle,
  [Text] = @Text,
  [expiredate] = @expiredate,
  [DocumentPath] = @DocumentPath,
  [isActive] = @isActive
 WHERE
  [AnnouncementID] = @AnnouncementID


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_SetLoginDateByWebUserID]

@WebUserID int

AS

UPDATE tblWebUser SET LastLoginDate = getDate() WHERE WebUserID = @WebUserID

GO


CREATE PROCEDURE [proc_Keyword_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblKeyword WHERE PublishOnWeb = 1 ORDER BY keyword

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Queues_LoadByPrimaryKey]
(
 @statuscode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblQueues]
 WHERE
  ([statuscode] = @statuscode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Problem_LoadByPrimaryKey]
(
 @problemcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblProblem]
 WHERE
  ([problemcode] = @problemcode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_AdminCheckDupeWebUser]

@WebUserID varchar(30)

AS

SELECT * FROM tblWebUser
WHERE UserID = @WebUserID


GO


CREATE PROCEDURE [proc_GetSpecialtyComboItems]

AS

SELECT [specialtycode], [description] FROM [tblSpecialty] 
WHERE PublishOnWeb = 1
ORDER BY [description]



GO


CREATE PROCEDURE [proc_WebQueues_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebQueues]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Services_LoadByPrimaryKey]
(
 @servicecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblServices]
 WHERE
  ([servicecode] = @servicecode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblCCAddressUpdate]
(
 @cccode int,
 @prefix varchar(5) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @company varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @phone varchar(15) = NULL,
 @phoneextension varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @status varchar(10) = NULL,
 @useridadded varchar(15) = NULL,
 @dateadded datetime = NULL,
 @useridedited varchar(15) = NULL,
 @dateedited datetime = NULL,
 @officecode int = NULL,
 @WebUserID int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCCAddress]
 SET
  [prefix] = @prefix,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [company] = @company,
  [address1] = @address1,
  [address2] = @address2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone] = @phone,
  [phoneextension] = @phoneextension,
  [fax] = @fax,
  [email] = @email,
  [status] = @status,
  [useridadded] = @useridadded,
  [dateadded] = @dateadded,
  [useridedited] = @useridedited,
  [dateedited] = @dateedited,
  [officecode] = @officecode,
  [WebUserID] = @WebUserID
 WHERE
  [cccode] = @cccode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetRecordStatusComboItems]

AS

SELECT [reccode], [description] FROM [tblRecordStatus] 
WHERE PublishOnWeb = 1
ORDER BY [description]



GO


CREATE PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin bit = 0

AS

IF @IsAdmin = 1
 BEGIN
  SELECT DISTINCT *
  FROM tblCaseHistory 
  WHERE casenbr = @CaseNbr AND tblCaseHistory.PublishOnWeb = 1
 END
ELSE
 BEGIN
  SELECT DISTINCT * FROM tblCaseHistory 
   INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
   AND (tblPublishOnWeb.PublishOnWeb = 1)
   AND (tblPublishOnWeb.UserCode IN 
    (SELECT UserCode 
     FROM tblWebUserAccount 
     WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
     AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
   AND (casenbr = @CaseNbr)
   AND (tblCaseHistory.PublishOnWeb = 1) 
 END


GO


CREATE PROCEDURE [proc_GetClientDetailsByUserIDNew] 

@WebUserID int 

AS 

SELECT tblWebUser.WebUserID, 
tblClient.*,
tblCompany.extname 
FROM tblCompany 
INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode 
INNER JOIN tblWebUserAccount ON tblClient.WebUserID = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1
INNER JOIN tblWebUser ON tblWebUserAccount.WebUserID = tblWebUser.WebUserID 
WHERE tblWebUser.WebUserID= @WebUserID

GO


CREATE PROCEDURE [proc_Location_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblLocation]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleByDate]

@DoctorCode varchar(50) = NULL,
@LocationCode varchar(50) = NULL,
@ApptDate varchar(20) = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT 
  schedcode, 
  tblDoctor.doctorcode, 
  starttime, 
  duration 
  FROM tblDoctor 
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open' 
  INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode 
  WHERE tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.LocationCode) 
  AND tblDoctorLocation.locationcode IN (SELECT DISTINCT locationcode FROM tblLocation WHERE tblLocation.insidedr = 1) 
  AND tblDoctor.doctorcode = COALESCE(@DoctorCode,tblDoctor.DoctorCode)
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
  ORDER BY starttime 

 SET @Err = @@Error

 RETURN @Err
END



GO


CREATE PROCEDURE [proc_tblWebUserUpdate]

@WebUserID int,
@UserIDEdited varchar(15),
@Password varchar(100)

AS

UPDATE tblWebUser 
 SET 
  tblWebUser.Password = @Password, 
  DateEdited = getdate(), 
  UserIDEdited = @UserIDEdited 
 WHERE WebUserID = @WebUserID



GO


CREATE PROCEDURE [proc_GetCaseDetails] 

@caseNbr int 

AS 

SELECT DISTINCT
 tblCase.casenbr, 
 tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, 
 tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
 tblCompany.extname AS companyname, 
 tblCase.ApptDate, 
 tblCase.claimnbr, 
 tblCase.claimnbrext, 
 tblCase.invoicedate,
 tblCase.invoiceamt,
 tblLocation.location,
 datediff(day,apptdate,eventdate) RPTAT,
 tblServices.description AS service, 
 isnull(tblCase.DoctorName, tblCase.requesteddoc) AS provider, 
 tblWebQueues.description AS WebStatus, 
 tblQueues.statusdesc AS Status, 
 tblWebQueues.statuscode, 
 ISNULL(tblCase.sinternalcasenbr, tblCase.casenbr) AS webcontrolnbr
FROM tblCase 
 INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
 INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
 LEFT JOIN tblCaseHistory ON tblCase.casenbr = tblCaseHistory.casenbr AND tblCaseHistory.type = 'FinalRpt'
 LEFT JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
 LEFT JOIN tblCompany 
 INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode 
 LEFT JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
WHERE tblCase.casenbr = @caseNbr


GO


CREATE PROCEDURE [proc_Location_LoadByPrimaryKey]
(
 @locationcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblLocation]
 WHERE
  ([locationcode] = @locationcode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID] 

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin int = 0

AS

IF @IsAdmin = 1
 BEGIN
  SELECT DISTINCT tblCaseDocuments.*, 
  tblPublishOnWeb.PublishasPDF 
  FROM tblCaseDocuments 
   INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey  
  WHERE casenbr = @CaseNbr AND tblCaseDocuments.PublishOnWeb = 1
 END
ELSE
 BEGIN
  SELECT DISTINCT tblCaseDocuments.*, 
  tblPublishOnWeb.PublishasPDF 
  FROM tblCaseDocuments 
  INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments' 
   AND (tblPublishOnWeb.PublishOnWeb = 1)
   AND (tblPublishOnWeb.UserCode IN 
    (SELECT UserCode 
     FROM tblWebUserAccount 
     WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
     AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
   AND (casenbr = @CaseNbr)
   AND (tblCaseDocuments.PublishOnWeb = 1) 
 END




GO


CREATE PROCEDURE [proc_AdminWebUserUpdate]

@WebUserID int,
@UserID varchar(100),
@Password varchar(100),
@DateEdited smalldatetime,
@UserIDEdited varchar(30),
@Email varchar(70),
@UserType as varchar(2)



AS

SET NOCOUNT OFF
DECLARE @Err int

UPDATE tblWebUser SET 
[UserID] = @UserID,
Password = @Password,
DateEdited = @DateEdited,
UserIDEdited = @UserIDEdited

WHERE WebUserID = @WebUserID

IF @UserType = 'CL'
BEGIN
 UPDATE tblClient SET email = @Email WHERE tblClient.WebUserID = @WebUserID
END
ELSE IF @UserType IN ('OP', 'DR')
BEGIN
 UPDATE tblDoctor SET emailAddr = @Email WHERE tblDoctor.WebUserID = @WebUserID
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 UPDATE tblCCAddress SET email = @Email WHERE tblCCAddress.WebUserID = @WebUserID
END
ELSE IF @UserType = 'TR'
BEGIN
 UPDATE tblTranscription SET email = @Email WHERE tblTranscription.WebUserID = @WebUserID
END

SET @Err = @@Error
RETURN @Err
 



GO


CREATE PROCEDURE [proc_tblDistributionListInsert]
(
 @DistListID int = NULL output,
 @Name varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblDistributionList]
 (
  [Name]
 )
 VALUES
 (
  @Name
 )

 SET @Err = @@Error

 SELECT @DistListID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_WebQueues_LoadByPrimaryKey]
(
 @statuscode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebQueues]
 WHERE
  ([statuscode] = @statuscode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblDistributionListDelete]
(
 @DistListID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblDistributionList]
 WHERE
  [DistListID] = @DistListID
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndType]
(
 @casenbr int,
 @histType varchar(20)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]
 WHERE
  ([casenbr] = @casenbr)
 AND
  ([type] = @histType)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetReferralDocsNew] 

@CaseID int,
@WebUserID int,
@SortExpression varchar(50) = 'dateadded' 

AS

DECLARE @tmpSQL NVARCHAR(4000)

SET @tmpSQL = 'SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF FROM tblCaseDocuments '
 + 'INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
 + 'WHERE tblCaseDocuments.seqno IN '
 + '(SELECT DISTINCT TableKey FROM tblPublishOnWeb '

  IF @WebUserID <> 999999
   BEGIN
    SET @tmpSQL = @tmpSQL + 'WHERE (tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.PublishOnWeb = 1 '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.UserCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = ' + CAST(@WebUserID AS VARCHAR(20)) + ' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))) ' 
    SET @tmpSQL = @tmpSQL + 'AND (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (tblCaseDocuments.PublishOnWeb = 1) '
    SET @tmpSQL = @tmpSQL + 'ORDER BY tblCaseDocuments.' + @SortExpression
   END
  ELSE
   BEGIN
    SET @tmpSQL = @tmpSQL + 'WHERE tblPublishOnWeb.TableType = ''tblCaseDocuments'' '
    SET @tmpSQL = @tmpSQL + 'AND tblPublishOnWeb.PublishOnWeb = 1 '
    SET @tmpSQL = @tmpSQL + ') ' 
    SET @tmpSQL = @tmpSQL + 'AND (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (tblCaseDocuments.PublishOnWeb = 1) '
    SET @tmpSQL = @tmpSQL + 'ORDER BY tblCaseDocuments.' + @SortExpression
   END
 
EXECUTE SP_EXECUTESQL @tmpSQL

GO


CREATE PROCEDURE [proc_GetPrefixComboItems]

AS

SELECT DISTINCT [sprefix] FROM [tblnameprefix] ORDER BY [sprefix]




GO


CREATE PROCEDURE [proc_GetReferralDocs] 

@CaseID int,
@SortExpression varchar(50) = 'dateadded' 

AS

DECLARE @tmpSQL NVARCHAR(4000)

SET @tmpSQL = 'SELECT DISTINCT tblCaseDocuments.casenbr, tblCaseDocuments.description,  0 as PublishasPDF, '
 + 'tblCaseDocuments.dateadded, tblCaseDocuments.UserIDAdded, tblCaseDocuments.sFileName, tblCaseDocuments.Viewed, tblCaseDocuments.seqno FROM tblCaseDocuments '
 + 'WHERE (casenbr = ' + CAST(@CaseID as varchar(30)) + ') AND (PublishOnWeb = 1) '
 + 'ORDER BY ' + @SortExpression
 
EXECUTE SP_EXECUTESQL @tmpSQL

GO


CREATE PROCEDURE proc_GetLatLon

@zip varchar(7), 
@lat float OUTPUT, 
@lon float OUTPUT 

AS
SELECT @lat = fLatitude, @lon = fLongitude
FROM tblZipCode
WHERE sZip = @zip

GO


CREATE PROCEDURE [proc_GetWebCompanyByCompanyID]

@CompanyID int

AS

SELECT * FROM tblWebCompany WHERE CompanyID = @CompanyID



GO



CREATE PROCEDURE proc_GetZipDistanceInMiles

@zip0 varchar(7), 
@zip1 varchar(7)

AS
DECLARE @lat0 float
DECLARE @lon0 float
DECLARE @lat1 float
DECLARE @lon1 float
DECLARE @lonDiff float
DECLARE @x float
DECLARE @radDist float
DECLARE @miles float
/* PRINT "ERROR: An error occurred getting the ytd_sales." */

set @lat0=0
set @lon0=0

EXEC proc_GetLatLon
  @zip = @zip0, 
  @lat = @lat0 OUTPUT,
  @lon = @lon0 OUTPUT

set @lat1=0
set @lon1=0

EXEC proc_GetLatLon
  @zip = @zip1, 
  @lat = @lat1 OUTPUT,
  @lon = @lon1 OUTPUT
IF (@lat0 = 0 OR @lat1 = 0 OR @lon0 = 0 or @lon1 = 0)
 BEGIN
  SET @miles = -1
  /* Return @miles */
  SELECT  miles = @miles
 END
IF (@lat0 = @lat1 AND @lon0 = @lon1)
 BEGIN
  SET @miles = 0
  /* Return @miles */
  SELECT  miles = @miles
 END
SET @lat0 = @lat0 * PI() / 180
SET @lon0 = @lon0 * PI()/ 180
SET @lat1 = @lat1 * PI() / 180
SET @lon1 = @lon1 * PI() / 180
SET @lonDiff = ABS(@lon0 - @lon1)
SET @x = SIN(@lat0) * SIN(@lat1) + COS(@lat0) * COS(@lat1) * COS(@lonDiff)
SET @radDist = ATAN(-@x / SQRT (-@x * @x + 1)) + 2 * ATAN(1)
SET @miles = @radDist * 3958.754 /* miles */
SELECT  miles = @miles




GO


CREATE PROCEDURE [proc_tblCaseNotesInsert]
(
 @casenbr int,
 @eventdate datetime,
 @eventdesc varchar(50) = NULL,
 @userid varchar(15) = NULL,
 @otherinfo varchar(1000) = NULL,
 @id int = NULL output,
 @duration int = NULL,
 @type varchar(20) = NULL,
 @status int = NULL,
 @PublishOnWeb bit = NULL,
 @WebSynchDate datetime = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(30) = NULL,
 @dateadded datetime = NULL,
 @WebGUID uniqueidentifier = NULL,
 @clientcode int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseNotes]
 (
  [casenbr],
  [eventdate],
  [eventdesc],
  [userid],
  [otherinfo],
  [duration],
  [type],
  [status],
  [PublishOnWeb],
  [WebSynchDate],
  [dateedited],
  [useridedited],
  [dateadded],
  [WebGUID],
  [clientcode]
 )
 VALUES
 (
  @casenbr,
  @eventdate,
  @eventdesc,
  @userid,
  @otherinfo,
  @duration,
  @type,
  @status,
  @PublishOnWeb,
  @WebSynchDate,
  @dateedited,
  @useridedited,
  @dateadded,
  @WebGUID,
  @clientcode
 )

 SET @Err = @@Error

 SELECT @id = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblUserAnnouncementDelete]
(
 @AnnouncementID int,
 @UserID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblUserAnnouncement]
 WHERE
  [AnnouncementID] = @AnnouncementID AND
  [UserID] = @UserID
  
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetStateComboItems]

AS

SELECT DISTINCT [Statecode], [StateName] FROM [tblstate] ORDER BY [StateName]




GO


CREATE PROCEDURE [proc_tblUserAnnouncementInsert]
(
 @UserAnnouncementID int = NULL output,
 @AnnouncementID int,
 @UserID int,
 @Dismiss bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblUserAnnouncement]
 (
  [AnnouncementID],
  [UserID],
  [Dismiss]
 )
 VALUES
 (
  @AnnouncementID,
  @UserID,
  @Dismiss
 )

 SET @Err = @@Error

 SELECT @UserAnnouncementID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblUserAnnouncementUpdate]
(
 @UserAnnouncementID int,
 @AnnouncementID int,
 @UserID int,
 @Dismiss bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblUserAnnouncement]
 SET
  [AnnouncementID] = @AnnouncementID,
  [UserID] = @UserID,
  [Dismiss] = @Dismiss
 WHERE
  [UserAnnouncementID] = @UserAnnouncementID


 SET @Err = @@Error


 RETURN @Err
END


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
 @WebGUID uniqueidentifier = NULL
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
  [WebGUID]
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
  @WebGUID
 )

 SET @Err = @@Error

 SELECT @casenbr = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblDistributionListUpdate]
(
 @DistListID int,
 @Name varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblDistributionList]
 SET
  [Name] = @Name
 WHERE
  [DistListID] = @DistListID


 SET @Err = @@Error


 RETURN @Err
END


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
 @WebGUID uniqueidentifier = NULL
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
  [WebGUID] = @WebGUID
 WHERE
  [casenbr] = @casenbr


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_tblUploadDocumentsInsert]
(
 @UploadDocID int = NULL output,
 @requestnbr int = NULL,
 @casenbr int = NULL,
 @description varchar(70) = NULL,
 @FileName varchar(100) = NULL,
 @DateAdded datetime = NULL,
 @UserIDAdded varchar(50) = NULL,
 @LastWebSynchDate datetime = NULL,
 @clientcode int = NULL,
 @PublishTo char(2)
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblUploadDocuments]
 (
  [requestnbr],
  [casenbr],
  [description],
  [FileName],
  [DateAdded],
  [UserIDAdded],
  [LastWebSynchDate],
  [clientcode],
  [PublishTo]
 )
 VALUES
 (
  @requestnbr,
  @casenbr,
  @description,
  @FileName,
  @DateAdded,
  @UserIDAdded,
  @LastWebSynchDate,
  @clientcode,
  @PublishTo
 )

 SET @Err = @@Error

 SELECT @UploadDocID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_ClientDefDocument_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClientDefDocument]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_ClientDefDocument_LoadByPrimaryKey]
(
 @clientcode int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [clientcode],
  [documentcode],
  [documentqueue],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited]
 FROM [tblclientdefdocument]
 WHERE
  ([clientcode] = @clientcode) AND
  ([documentcode] = @documentcode) AND
  ([documentqueue] = @documentqueue)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [dbo].[proc_GetDoctorLocationsAndSchedule]

@DoctorCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblLocation.locationcode, 
  tblLocation.location, 
  tblLocation.location as locname, 
  tblLocation.addr1 + '  ' + tblLocation.city + '  ' + tblLocation.state + ' ' + ISNULL(tblDoctor.zip, '') as locaddress,
  ISNULL(tblDoctor.County, '') + ' County ' as loccounty
  FROM tbllocation
  INNER JOIN tblDoctorLocation ON tblLocation.locationcode = tblDoctorLocation.locationcode
  INNER JOIN tblDoctor ON tblDoctorLocation.doctorcode = tblDoctor.doctorcode
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode
  WHERE tblLocation.insidedr = 1
  AND tblDoctor.DoctorCode = COALESCE(@DoctorCode,tblDoctor.DoctorCode) 
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END



GO


CREATE PROCEDURE [proc_ClientDefDocument_LoadByClientCode]
(
 @clientcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *
 FROM [tblclientdefdocument]
 WHERE
  ([clientcode] = @clientcode) 

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [dbo].[proc_GetDoctorLocationsAndScheduleWithSpec]

@LocationCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblDoctor.doctorcode, 
  ISNULL(tblDoctor.prefix, '') + ' ' + tblDoctor.firstname + ' ' + tblDoctor.lastname + ' ' + ISNULL(tblDoctor.credentials,'') as doctorname, 
  tblSpecialty.description specialty 
  FROM tblDoctor 
  INNER JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode 
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode 
  INNER JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode 
  INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode 
  WHERE tblDoctorLocation.locationcode IN (select distinct locationcode from tblLocation where tblLocation.insidedr = 1) 
  AND tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.locationcode)
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END



GO


CREATE PROCEDURE [proc_CaseDefDocument_Delete]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcasedefdocument]
 WHERE
  [casenbr] = @casenbr AND
  [documentcode] = @documentcode AND
  [documentqueue] = @documentqueue
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetSuperUserAvailUserListItems]

@WebUserID int

AS

SELECT DISTINCT cast(clientcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
tblCompany.extname company, firstname + ' ' + lastname + ' - ' + tblCompany.extname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT cast(cccode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(doctorcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(transcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'TR' 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
ORDER BY company, name




GO


CREATE PROCEDURE [proc_CaseDefDocument_Insert]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int,
 @dateadded datetime = NULL,
 @useridadded varchar(20) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(20) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblcasedefdocument]
 (
  [casenbr],
  [documentcode],
  [documentqueue],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited]
 )
 VALUES
 (
  @casenbr,
  @documentcode,
  @documentqueue,
  @dateadded,
  @useridadded,
  @dateedited,
  @useridedited
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDefDocument_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDefDocument]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDefDocument_Update]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int,
 @dateadded datetime = NULL,
 @useridadded varchar(20) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(20) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcasedefdocument]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited
 WHERE
  [casenbr] = @casenbr
 AND [documentcode] = @documentcode
 AND [documentqueue] = @documentqueue


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_User_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblUser]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDefDocument_LoadByPrimaryKey]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblcasedefdocument]
 WHERE
  ([casenbr] = @casenbr) AND
  ([documentcode] = @documentcode) AND
  ([documentqueue] = @documentqueue)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Examinee_Insert]
(
 @chartnbr int = NULL output,
 @oldchartnbr varchar(15) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @middleinitial varchar(5) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @phone1 varchar(15) = NULL,
 @phone2 varchar(15) = NULL,
 @SSN varchar(15) = NULL,
 @sex varchar(10) = NULL,
 @DOB datetime = NULL,
 @dateadded datetime = NULL,
 @dateedited datetime = NULL,
 @useridadded varchar(15) = NULL,
 @useridedited varchar(15) = NULL,
 @note text = NULL,
 @county varchar(50) = NULL,
 @prefix varchar(10) = NULL,
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
 @fax varchar(15) = NULL,
 @email varchar(50) = NULL,
 @insured varchar(50) = NULL,
 @employer varchar(70) = NULL,
 @treatingphysician varchar(70) = NULL,
 @InsuredAddr1 varchar(70) = NULL,
 @InsuredCity varchar(70) = NULL,
 @InsuredState varchar(5) = NULL,
 @InsuredZip varchar(10) = NULL,
 @InsuredSex varchar(10) = NULL,
 @InsuredRelationship varchar(20) = NULL,
 @InsuredPhone varchar(15) = NULL,
 @InsuredPhoneExt varchar(10) = NULL,
 @InsuredFax varchar(15) = NULL,
 @InsuredEmail varchar(70) = NULL,
 @ExamineeStatus varchar(30) = NULL,
 @TreatingPhysicianAddr1 varchar(70) = NULL,
 @TreatingPhysicianCity varchar(70) = NULL,
 @TreatingPhysicianState varchar(5) = NULL,
 @TreatingPhysicianZip varchar(10) = NULL,
 @TreatingPhysicianPhone varchar(15) = NULL,
 @TreatingPhysicianPhoneExt varchar(10) = NULL,
 @TreatingPhysicianFax varchar(15) = NULL,
 @TreatingPhysicianEmail varchar(70) = NULL,
 @EmployerAddr1 varchar(70) = NULL,
 @EmployerCity varchar(70) = NULL,
 @EmployerState varchar(5) = NULL,
 @EmployerZip varchar(10) = NULL,
 @EmployerPhone varchar(15) = NULL,
 @EmployerPhoneExt varchar(10) = NULL,
 @EmployerFax varchar(15) = NULL,
 @EmployerEmail varchar(70) = NULL,
 @Country varchar(50) = NULL,
 @policynumber varchar(70) = NULL,
 @EmployerContactFirstName varchar(50) = NULL,
 @EmployerContactLastName varchar(50) = NULL,
 @TreatingPhysicianLicenseNbr varchar(50) = NULL,
 @TreatingPhysicianTaxID varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblExaminee]
 (
  [oldchartnbr],
  [lastname],
  [firstname],
  [middleinitial],
  [addr1],
  [addr2],
  [city],
  [state],
  [zip],
  [phone1],
  [phone2],
  [SSN],
  [sex],
  [DOB],
  [dateadded],
  [dateedited],
  [useridadded],
  [useridedited],
  [note],
  [county],
  [prefix],
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
  [fax],
  [email],
  [insured],
  [employer],
  [treatingphysician],
  [InsuredAddr1],
  [InsuredCity],
  [InsuredState],
  [InsuredZip],
  [InsuredSex],
  [InsuredRelationship],
  [InsuredPhone],
  [InsuredPhoneExt],
  [InsuredFax],
  [InsuredEmail],
  [ExamineeStatus],
  [TreatingPhysicianAddr1],
  [TreatingPhysicianCity],
  [TreatingPhysicianState],
  [TreatingPhysicianZip],
  [TreatingPhysicianPhone],
  [TreatingPhysicianPhoneExt],
  [TreatingPhysicianFax],
  [TreatingPhysicianEmail],
  [EmployerAddr1],
  [EmployerCity],
  [EmployerState],
  [EmployerZip],
  [EmployerPhone],
  [EmployerPhoneExt],
  [EmployerFax],
  [EmployerEmail],
  [Country],
  [policynumber],
  [EmployerContactFirstName],
  [EmployerContactLastName],
  [TreatingPhysicianLicenseNbr],
  [TreatingPhysicianTaxID]
 )
 VALUES
 (
  @oldchartnbr,
  @lastname,
  @firstname,
  @middleinitial,
  @addr1,
  @addr2,
  @city,
  @state,
  @zip,
  @phone1,
  @phone2,
  @SSN,
  @sex,
  @DOB,
  @dateadded,
  @dateedited,
  @useridadded,
  @useridedited,
  @note,
  @county,
  @prefix,
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
  @fax,
  @email,
  @insured,
  @employer,
  @treatingphysician,
  @InsuredAddr1,
  @InsuredCity,
  @InsuredState,
  @InsuredZip,
  @InsuredSex,
  @InsuredRelationship,
  @InsuredPhone,
  @InsuredPhoneExt,
  @InsuredFax,
  @InsuredEmail,
  @ExamineeStatus,
  @TreatingPhysicianAddr1,
  @TreatingPhysicianCity,
  @TreatingPhysicianState,
  @TreatingPhysicianZip,
  @TreatingPhysicianPhone,
  @TreatingPhysicianPhoneExt,
  @TreatingPhysicianFax,
  @TreatingPhysicianEmail,
  @EmployerAddr1,
  @EmployerCity,
  @EmployerState,
  @EmployerZip,
  @EmployerPhone,
  @EmployerPhoneExt,
  @EmployerFax,
  @EmployerEmail,
  @Country,
  @policynumber,
  @EmployerContactFirstName,
  @EmployerContactLastName,
  @TreatingPhysicianLicenseNbr,
  @TreatingPhysicianTaxID
 )

 SET @Err = @@Error

 SELECT @chartnbr = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_DoctorSchedule_Delete]
(
 @schedcode int,
 @locationcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblDoctorSchedule]
 WHERE
  [schedcode] = @schedcode AND
  [locationcode] = @locationcode
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_DoctorSchedule_Insert]
(
 @schedcode int = NULL output,
 @locationcode int,
 @date datetime,
 @starttime datetime,
 @description varchar(50) = NULL,
 @status varchar(15) = NULL,
 @duration int = NULL,
 @casenbr1 int = NULL,
 @casenbr1desc varchar(70) = NULL,
 @casenbr2 int = NULL,
 @casenbr2desc varchar(70) = NULL,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(15) = NULL,
 @doctorcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblDoctorSchedule]
 (
  [locationcode],
  [date],
  [starttime],
  [description],
  [status],
  [duration],
  [casenbr1],
  [casenbr1desc],
  [casenbr2],
  [casenbr2desc],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited],
  [doctorcode]
 )
 VALUES
 (
  @locationcode,
  @date,
  @starttime,
  @description,
  @status,
  @duration,
  @casenbr1,
  @casenbr1desc,
  @casenbr2,
  @casenbr2desc,
  @dateadded,
  @useridadded,
  @dateedited,
  @useridedited,
  @doctorcode
 )

 SET @Err = @@Error

 SELECT @schedcode = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetWebUserData]

@WebUserID int,
@UserType varchar(2)

AS

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblClient.firstname + ' ' + tblClient.lastname AS FullName,
  tblClient.email,
  tblCompany.extName AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP'
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblCCAddress.firstname + ' ' + tblCCAddress.lastname AS FullName,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblTranscription.transcompany AS FullName,
  tblTranscription.Email,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode
 WHERE tblWebUser.WebUserID = @WebUserID 
END


GO


CREATE PROCEDURE [proc_GetWebUserPassword]

@UserID varchar(30),
@WebUserEmail varchar(100)

AS

SELECT 'tblClient' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblClient.clientcode AS IMECentricCode FROM tblWebUser 
 INNER JOIN tblClient ON tblWebUser.IMECentricCode = tblClient.clientcode AND tblClient.email = @WebUserEmail
 WHERE tblWebUser.UserID = @UserID
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblCCAddress.cccode AS IMECentricCode FROM tblWebUser 
 INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.email = @WebUserEmail
 WHERE tblWebUser.UserID = @UserID
UNION
SELECT 'tblDoctor' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblDoctor.doctorcode AS IMECentricCode FROM tblWebUser 
 INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.emailAddr = @WebUserEmail
 WHERE tblWebUser.UserID = @UserID
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblTranscription.transcode AS IMECentricCode FROM tblWebUser 
 INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode AND tblTranscription.email = @WebUserEmail
 WHERE tblWebUser.UserID = @UserID

GO


CREATE PROCEDURE [proc_DoctorSchedule_Update]
(
 @schedcode int,
 @locationcode int,
 @date datetime,
 @starttime datetime,
 @description varchar(50) = NULL,
 @status varchar(15) = NULL,
 @duration int = NULL,
 @casenbr1 int = NULL,
 @casenbr1desc varchar(70) = NULL,
 @casenbr2 int = NULL,
 @casenbr2desc varchar(70) = NULL,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(15) = NULL,
 @doctorcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblDoctorSchedule]
 SET
  [date] = @date,
  [starttime] = @starttime,
  [description] = @description,
  [status] = @status,
  [duration] = @duration,
  [casenbr1] = @casenbr1,
  [casenbr1desc] = @casenbr1desc,
  [casenbr2] = @casenbr2,
  [casenbr2desc] = @casenbr2desc,
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited,
  [doctorcode] = @doctorcode
 WHERE
  [schedcode] = @schedcode
 AND [locationcode] = @locationcode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_DoctorSchedule_LoadByPrimaryKey]
(
 @schedcode int,
 @locationcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *, DATEADD(minute, dbo.tblDoctorSchedule.duration, dbo.tblDoctorSchedule.starttime) AS EndTime
 FROM [tblDoctorSchedule]
 WHERE
  ([schedcode] = @schedcode) AND
  ([locationcode] = @locationcode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_DoctorSchedule_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *, DATEADD(minute, dbo.tblDoctorSchedule.duration, dbo.tblDoctorSchedule.starttime) AS EndTime

 FROM [tblDoctorSchedule]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetWebUserUserName]

@WebUserEmail varchar(70)

AS

SELECT 'tblClient' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblClient.clientcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblClient ON tblWebUser.IMECentricCode = tblClient.clientcode AND tblClient.email = @WebUserEmail
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblCCAddress.cccode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.email = @WebUserEmail
UNION
SELECT 'tblDoctor' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblDoctor.doctorcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.emailAddr = @WebUserEmail
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblTranscription.transcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode AND tblTranscription.email = @WebUserEmail

GO


CREATE PROCEDURE [proc_GetSuperUserGridItems]

AS

SELECT DISTINCT tblWebUser.*, tblCompany.extname as company, firstname + ' ' + lastname + ' - ' + tblCompany.extname name 
 FROM tblclient 
 INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
UNION
SELECT DISTINCT tblWebUser.*, company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblWebUser ON tblCCAddress.cccode = tblWebUser.IMECentricCode AND (tblWebUser.UserType = 'AT' OR tblWebUser.UserType = 'CC')
UNION
SELECT DISTINCT tblWebUser.*, companyname as company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblWebUser ON tblDoctor.doctorcode = tblWebUser.IMECentricCode AND (tblWebUser.UserType = 'DR' OR tblWebUser.UserType = 'OP')
UNION
SELECT DISTINCT tblWebUser.*, transcompany as company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblWebUser ON tblTranscription.transcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'TR' 
ORDER BY company, name




GO


CREATE PROCEDURE [proc_Announcement_Delete]
(
 @AnnouncementID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblAnnouncement]
 WHERE
  [AnnouncementID] = @AnnouncementID
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_ValidateUserNew]

@UserID varchar(100),
@Password varchar(30)

AS

DECLARE @UserType CHAR(2)

SET @UserType = (SELECT UserType FROM tblWebUser WHERE UserID = @UserID AND Password = @Password)

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.lastname,
  tblClient.firstname,
  tblClient.clientcode,
  tblClient.email,
  tblCompany.extName AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblClient.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblCCAddress.lastname,
  tblCCAddress.firstname,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblTranscription.transcompany AS lastname,
  tblTranscription.email,
  tblWebUser.WebUserID AS firstname,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.Transcode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END


GO


CREATE PROCEDURE [proc_Announcement_Insert]
(
 @AnnouncementID int = NULL output,
 @AnnounceTitle varchar(100) = NULL,
 @Text text = NULL,
 @dateadded smalldatetime = NULL,
 @useridadded varchar(30) = NULL,
 @expiredate smalldatetime = NULL,
 @DocumentPath varchar(255) = NULL,
 @isActive bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblAnnouncement]
 (
  [AnnounceTitle],
  [Text],
  [dateadded],
  [useridadded],
  [expiredate],
  [DocumentPath],
  [isActive]
 )
 VALUES
 (
  @AnnounceTitle,
  @Text,
  @dateadded,
  @useridadded,
  @expiredate,
  @DocumentPath,
  @isActive
 )

 SET @Err = @@Error

 SELECT @AnnouncementID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Announcement_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblAnnouncement]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_AdminGetWebUserDataByWebUserID]

@WebUserID int,
@UserType varchar(2)

AS

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.firstname + ' ' + tblClient.lastname AS FullName,
  tblClient.email,
  tblCompany.extName AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'  
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode AND OPType = 'OP'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*,
  tblCCAddress.firstname + ' ' + tblCCAddress.lastname AS FullName,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblTranscription.transcompany AS FullName,
  tblTranscription.Email,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END


GO


CREATE PROCEDURE [proc_Announcement_LoadByPrimaryKey]
(
 @AnnouncementID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblAnnouncement]
 WHERE
  ([AnnouncementID] = @AnnouncementID)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Announcement_Update]
(
 @AnnouncementID int,
 @AnnounceTitle varchar(100) = NULL,
 @Text text = NULL,
 @dateadded smalldatetime = NULL,
 @useridadded varchar(30) = NULL,
 @expiredate smalldatetime = NULL,
 @DocumentPath varchar(255) = NULL,
 @isActive bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblAnnouncement]
 SET
  [AnnounceTitle] = @AnnounceTitle,
  [Text] = @Text,
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [expiredate] = @expiredate,
  [DocumentPath] = @DocumentPath,
  [isActive] = @isActive
 WHERE
  [AnnouncementID] = @AnnouncementID


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseType_LoadByPrimaryKey]
(
 @Code int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseType]
 WHERE
  ([Code] = @Code)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_Delete]
(
 @seqno int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCaseDocuments]
 WHERE
  [seqno] = @seqno
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDocuments]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_IMEData_LoadByPrimaryKey]
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT top 1 * from tblIMEData

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_User_LoadByPrimaryKey]
(
 @userid varchar(15)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblUser]
 WHERE
  ([userid] = @userid) 

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_LoadByPrimaryKey]
(
 @seqno int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseDocuments]
 WHERE
  ([seqno] = @seqno)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_Update]
(
 @casenbr int,
 @document varchar(20),
 @type varchar(20) = NULL,
 @reporttype varchar(20) = NULL,
 @description varchar(200) = NULL,
 @sfilename varchar(200) = NULL,
 @dateadded datetime,
 @useridadded varchar(20) = NULL,
 @PublishOnWeb bit = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(30) = NULL,
 @seqno int,
 @PublishedTo varchar(50) = NULL,
 @Viewed bit,
 @FileMoved bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCaseDocuments]
 SET
  [casenbr] = @casenbr,
  [document] = @document,
  [type] = @type,
  [reporttype] = @reporttype,
  [description] = @description,
  [sfilename] = @sfilename,
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [PublishOnWeb] = @PublishOnWeb,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited,
  [PublishedTo] = @PublishedTo,
  [Viewed] = @Viewed,
  [FileMoved] = @FileMoved
 WHERE
  [seqno] = @seqno


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_ValidateAdminUser] 

@UserID varchar(100),
@Password varchar(30)

AS

SELECT 

tblWebUser.WebUserID

FROM tblWebUser

WHERE tblWebUser.UserID = @UserID AND tblWebUser.Password = @Password

GO


CREATE PROCEDURE [proc_Company_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCompany]
 
 ORDER BY ExtName


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Office_LoadByPrimaryKey]
(
 @Officecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblOffice]
 WHERE
  ([Officecode] = @Officecode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_Delete]
(
 @id int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCaseHistory]
 WHERE
  [id] = @id
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Office_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblOffice]
 WHERE ISNULL(Status,'') = 'Active'
 
 ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_Insert]
(
 @id int = NULL output,
 @casenbr int,
 @eventdate datetime,
 @eventdesc varchar(50) = NULL,
 @userid varchar(15) = NULL,
 @otherinfo varchar(1000) = NULL,
 @duration int = NULL,
 @type varchar(20) = NULL,
 @status int = NULL,
 @PublishOnWeb bit = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(30) = NULL,
 @dateadded datetime = NULL,
 @SubCaseID int = NULL,
 @Highlight bit = NULL,
 @Viewed bit,
 @PublishedTo varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseHistory]
 (
  [casenbr],
  [eventdate],
  [eventdesc],
  [userid],
  [otherinfo],
  [duration],
  [type],
  [status],
  [PublishOnWeb],
  [dateedited],
  [useridedited],
  [dateadded],
  [SubCaseID],
  [Highlight],
  [Viewed],
  [PublishedTo]
 )
 VALUES
 (
  @casenbr,
  @eventdate,
  @eventdesc,
  @userid,
  @otherinfo,
  @duration,
  @type,
  @status,
  @PublishOnWeb,
  @dateedited,
  @useridedited,
  @dateadded,
  @SubCaseID,
  @Highlight,
  @Viewed,
  @PublishedTo
 )

 SET @Err = @@Error

 SELECT @id = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseType_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseType]
 WHERE PublishOnWeb = 1
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Services_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblServices]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_LoadByPrimaryKey]
(
 @id int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseHistory]
 WHERE
  ([id] = @id)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Specialty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblSpecialty]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseHistory_Update]
(
 @id int,
 @casenbr int,
 @eventdate datetime,
 @eventdesc varchar(50) = NULL,
 @userid varchar(15) = NULL,
 @otherinfo varchar(1000) = NULL,
 @duration int = NULL,
 @type varchar(20) = NULL,
 @status int = NULL,
 @PublishOnWeb bit = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(30) = NULL,
 @dateadded datetime = NULL,
 @SubCaseID int = NULL,
 @Highlight bit = NULL,
 @Viewed bit,
 @PublishedTo varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCaseHistory]
 SET
  [casenbr] = @casenbr,
  [eventdate] = @eventdate,
  [eventdesc] = @eventdesc,
  [userid] = @userid,
  [otherinfo] = @otherinfo,
  [duration] = @duration,
  [type] = @type,
  [status] = @status,
  [PublishOnWeb] = @PublishOnWeb,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited,
  [dateadded] = @dateadded,
  [SubCaseID] = @SubCaseID,
  [Highlight] = @Highlight,
  [Viewed] = @Viewed,
  [PublishedTo] = @PublishedTo
 WHERE
  [id] = @id


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Issue_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblIssue]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_PublishOnWeb_Delete]
(
 @PublishID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblPublishOnWeb]
 WHERE
  [PublishID] = @PublishID
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_Problem_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblProblem]
 ORDER BY [description]

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseDocuments_Insert]
(
 @casenbr int,
 @document varchar(20),
 @type varchar(20) = NULL,
 @reporttype varchar(20) = NULL,
 @description varchar(200) = NULL,
 @sfilename varchar(200) = NULL,
 @dateadded datetime,
 @useridadded varchar(20) = NULL,
 @PublishOnWeb bit = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(30) = NULL,
 @seqno int = NULL output,
 @PublishedTo varchar(50) = NULL,
 @Viewed bit,
 @FileMoved bit
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseDocuments]
 (
  [casenbr],
  [document],
  [type],
  [reporttype],
  [description],
  [sfilename],
  [dateadded],
  [useridadded],
  [PublishOnWeb],
  [dateedited],
  [useridedited],
  [PublishedTo],
  [Viewed],
  [FileMoved]
 )
 VALUES
 (
  @casenbr,
  @document,
  @type,
  @reporttype,
  @description,
  @sfilename,
  @dateadded,
  @useridadded,
  @PublishOnWeb,
  @dateedited,
  @useridedited,
  @PublishedTo,
  @Viewed,
  @FileMoved
 )

 SET @Err = @@Error

 SELECT @seqno = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_PublishOnWeb_Insert]
(
 @PublishID int = NULL output,
 @TableType varchar(50) = NULL,
 @TableKey int = NULL,
 @UserID varchar(50) = NULL,
 @UserType varchar(50) = NULL,
 @UserCode int = NULL,
 @PublishOnWeb bit,
 @Notify bit,
 @PublishasPDF bit,
 @DateAdded datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @DateEdited datetime = NULL,
 @UseridEdited varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblPublishOnWeb]
 (
  [TableType],
  [TableKey],
  [UserID],
  [UserType],
  [UserCode],
  [PublishOnWeb],
  [Notify],
  [PublishasPDF],
  [DateAdded],
  [UseridAdded],
  [DateEdited],
  [UseridEdited]
 )
 VALUES
 (
  @TableType,
  @TableKey,
  @UserID,
  @UserType,
  @UserCode,
  @PublishOnWeb,
  @Notify,
  @PublishasPDF,
  @DateAdded,
  @UseridAdded,
  @DateEdited,
  @UseridEdited
 )

 SET @Err = @@Error

 SELECT @PublishID = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_PublishOnWeb_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblPublishOnWeb]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_PublishOnWeb_LoadByPrimaryKey]
(
 @PublishID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblPublishOnWeb]
 WHERE
  ([PublishID] = @PublishID)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_PublishOnWeb_Update]
(
 @PublishID int,
 @TableType varchar(50) = NULL,
 @TableKey int = NULL,
 @UserID varchar(50) = NULL,
 @UserType varchar(50) = NULL,
 @UserCode int = NULL,
 @PublishOnWeb bit,
 @Notify bit,
 @PublishasPDF bit,
 @DateAdded datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @DateEdited datetime = NULL,
 @UseridEdited varchar(50) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblPublishOnWeb]
 SET
  [TableType] = @TableType,
  [TableKey] = @TableKey,
  [UserID] = @UserID,
  [UserType] = @UserType,
  [UserCode] = @UserCode,
  [PublishOnWeb] = @PublishOnWeb,
  [Notify] = @Notify,
  [PublishasPDF] = @PublishasPDF,
  [DateAdded] = @DateAdded,
  [UseridAdded] = @UseridAdded,
  [DateEdited] = @DateEdited,
  [UseridEdited] = @UseridEdited
 WHERE
  [PublishID] = @PublishID


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddress_Delete]
(
 @CCCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCCAddress]
 WHERE
  [CCCode] = @CCCode
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddress_Insert]
(
 @cccode int = NULL output,
 @prefix varchar(5) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @company varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @phone varchar(15) = NULL,
 @phoneextension varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @status varchar(10) = NULL,
 @useridadded varchar(15) = NULL,
 @dateadded datetime = NULL,
 @useridedited varchar(15) = NULL,
 @dateedited datetime = NULL,
 @officecode int = NULL,
 @WebUserID int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCCAddress]
 (
  [prefix],
  [lastname],
  [firstname],
  [company],
  [address1],
  [address2],
  [city],
  [state],
  [zip],
  [phone],
  [phoneextension],
  [fax],
  [email],
  [status],
  [useridadded],
  [dateadded],
  [useridedited],
  [dateedited],
  [officecode],
  [WebUserID]
 )
 VALUES
 (
  @prefix,
  @lastname,
  @firstname,
  @company,
  @address1,
  @address2,
  @city,
  @state,
  @zip,
  @phone,
  @phoneextension,
  @fax,
  @email,
  @status,
  @useridadded,
  @dateadded,
  @useridedited,
  @dateedited,
  @officecode,
  @WebUserID
 )

 SET @Err = @@Error

 SELECT @cccode = SCOPE_IDENTITY()

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddress_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCCAddress]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddress_LoadByPrimaryKey]
(
 @CCCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCCAddress]
 WHERE
  ([CCCode] = @CCCode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CCAddress_Update]
(
 @cccode int,
 @prefix varchar(5) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @company varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @phone varchar(15) = NULL,
 @phoneextension varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @status varchar(10) = NULL,
 @useridadded varchar(15) = NULL,
 @dateadded datetime = NULL,
 @useridedited varchar(15) = NULL,
 @dateedited datetime = NULL,
 @officecode int = NULL,
 @WebUserID int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCCAddress]
 SET
  [prefix] = @prefix,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [company] = @company,
  [address1] = @address1,
  [address2] = @address2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone] = @phone,
  [phoneextension] = @phoneextension,
  [fax] = @fax,
  [email] = @email,
  [status] = @status,
  [useridadded] = @useridadded,
  [dateadded] = @dateadded,
  [useridedited] = @useridedited,
  [dateedited] = @dateedited,
  [officecode] = @officecode,
  [WebUserID] = @WebUserID
 WHERE
  [cccode] = @cccode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseIssue_Delete]
(
 @casenbr int,
 @issuecode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcaseissue]
 WHERE
  [casenbr] = @casenbr AND
  [issuecode] = @issuecode
 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetFirstAvailApptByLocation]

@LocationCode int

AS

SELECT top 1 starttime FROM tblDoctorSchedule 
WHERE date >= getdate() 
AND LocationCode = @LocationCode  
AND status = 'open' 
ORDER BY date



GO


CREATE PROCEDURE [proc_CaseIssue_Insert]
(
 @casenbr int,
 @issuecode int,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblcaseissue]
 (
  [casenbr],
  [issuecode],
  [dateadded],
  [useridadded]
 )
 VALUES
 (
  @casenbr,
  @issuecode,
  @dateadded,
  @useridadded
 )

 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_GetFirstAvailApptByDoctor]

@DoctorCode int

AS

SELECT top 1 starttime FROM tblDoctorSchedule 
WHERE date >= getdate() 
AND doctorcode = @DoctorCode  
AND status = 'open' 
ORDER BY date





GO


CREATE PROCEDURE [proc_CaseIssue_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseIssue]


 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseVerifyAccess]

@CaseNbr int,
@WebUserID int

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

        SELECT COUNT(casenbr) from tblcase
        INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
        AND tblPublishOnWeb.tabletype = 'tblCase' AND tblPublishOnWeb.PublishOnWeb = 1
        INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
        AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
        AND casenbr = @CaseNbr
        AND tblWebUserAccount.WebUserID = @WebUserID

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseIssue_LoadByPrimaryKey]
(
 @casenbr int,
 @issuecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [casenbr],
  [issuecode],
  [dateadded],
  [useridadded]
 FROM [tblcaseissue]
 WHERE
  ([casenbr] = @casenbr) AND
  ([issuecode] = @issuecode)

 SET @Err = @@Error

 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseIssue_Update]
(
 @casenbr int,
 @issuecode int,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcaseissue]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded
 WHERE
  [casenbr] = @casenbr
 AND [issuecode] = @issuecode


 SET @Err = @@Error


 RETURN @Err
END


GO


CREATE PROCEDURE [proc_CaseProblem_Delete]
(
 @casenbr int,
 @problemcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblcaseproblem]
 WHERE
  [casenbr] = @casenbr AND
  [problemcode] = @problemcode
 SET @Err = @@Error

 RETURN @Err
END


GO

DROP VIEW [vwAcctingSummaryWithSecurity]
GO

CREATE VIEW [dbo].[vwAcctingSummaryWithSecurity]
AS
SELECT     TOP 100 PERCENT dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblacctingtrans.DrOpType, 
                      dbo.tblCase.PanelNbr, CASE isnull(dbo.tblcase.panelnbr, 0) 
                      WHEN 0 THEN CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + isnull(dbo.tbldoctor.firstname, '') 
                      WHEN '' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + isnull(dbo.tbldoctor.firstname, '') WHEN '' THEN isNULL(dbo.tblcase.doctorname, '') 
                      WHEN 'OP' THEN dbo.tbldoctor.companyname END ELSE CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN isNULL(dbo.tblcase.doctorname, '') 
                      WHEN '' THEN isNULL(dbo.tblcase.doctorname, '') WHEN 'OP' THEN dbo.tbldoctor.companyname END END AS doctorname, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, 
                      ISNULL(tblLocation_1.locationcode, dbo.tblCase.doctorlocation) AS doctorlocation, dbo.tblAcctingTrans.blnselect AS billedselect, 
                      dbo.tblCase.servicecode, dbo.tblQueues.statusdesc, dbo.tblCase.miscselect, dbo.tblcase.marketercode, dbo.tblacctingtrans.statuscode, 
                      dbo.tblCase.voucherselect, dbo.tblacctingtrans.documentnbr, dbo.tblacctingtrans.documentdate, dbo.tblacctingtrans.documentamount, 
                      dbo.tblServices.description AS servicedesc, dbo.tblCase.officecode, dbo.tblDoctor.companyname AS otherpartyname, dbo.tblDoctor.doctorcode, 
                      dbo.tblCase.casenbr, dbo.tblacctingtrans.SeqNO, dbo.tblCase.clientcode, dbo.tblCompany.companycode, dbo.tblCase.schedulercode, 
                      dbo.tblCase.QARep, dbo.tblacctingtrans.type, DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ, dbo.tblCase.laststatuschg, 
                      ISNULL(dbo.tblacctingtrans.apptdate, dbo.tblCase.ApptDate) AS apptdate, ISNULL(tblLocation_1.location, dbo.tblLocation.location) AS location, 
                      dbo.tblacctingtrans.appttime, dbo.tblacctingtrans.result, dbo.tblCase.mastersubcase, dbo.tblqueues.functioncode, dbo.tblUserofficefunction.userid, 
                      dbo.tblcase.billingnote, dbo.tblCase.rptStatus
FROM         dbo.tblCase INNER JOIN
                      dbo.tblacctingtrans ON dbo.tblCase.casenbr = dbo.tblacctingtrans.casenbr INNER JOIN
                      dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode INNER JOIN
                      dbo.tbluserofficefunction ON dbo.tblUserOffice.userid = dbo.tbluserofficefunction.userid AND 
                      dbo.tblUserOffice.officecode = dbo.tbluserofficefunction.officecode AND 
                      dbo.tblqueues.functioncode = dbo.tbluserofficefunction.functioncode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblLocation tblLocation_1 ON dbo.tblacctingtrans.doctorlocation = tblLocation_1.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblacctingtrans.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr LEFT OUTER JOIN
                      dbo.tblCompany INNER JOIN
                      dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
WHERE     (dbo.tblacctingtrans.statuscode <> 20)



GO

DROP VIEW [vwdoctorschedulesummary]
GO

CREATE VIEW [dbo].[vwdoctorschedulesummary]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblLocation.location, dbo.tblDoctorSchedule.date, 
                        COUNT(dbo.tblDoctorSchedule.status) AS [Count], dbo.tblDoctorSchedule.status, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, 
                        dbo.tblDoctorOffice.officecode, dbo.tblDoctorSchedule.locationcode
FROM          dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                        dbo.tblLocation ON dbo.tblDoctorSchedule.locationcode = dbo.tblLocation.locationcode INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblDoctor.doctorcode = dbo.tblDoctorOffice.doctorcode
GROUP BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.status, dbo.tblLocation.location, 
                        dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctorOffice.officecode, dbo.tblDoctorSchedule.locationcode
HAVING       (dbo.tblDoctorSchedule.status <> 'Off')
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctor.lastname, dbo.tblLocation.location

GO

DROP VIEW [vwDocumentAccting]
GO

CREATE VIEW dbo.vwDocumentAccting
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.claimnbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblExaminee.SSN, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.extname AS company, dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext,
                       ' ') AS clientphone, dbo.tblClient.phone2 + ' ' + ISNULL(dbo.tblClient.phone2ext, ' ') AS clientphone2, dbo.tblLocation.addr1 AS doctoraddr1, 
                      dbo.tblLocation.addr2 AS doctoraddr2, dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, 
                      dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblExaminee.phone1 AS examineephone, dbo.tblExaminee.sex, 
                      dbo.tblExaminee.DOB, dbo.tblLocation.Phone AS doctorphone, dbo.tblClient.addr1 AS clientaddr1, dbo.tblClient.addr2 AS clientaddr2, 
                      dbo.tblClient.city + ', ' + dbo.tblClient.state + '  ' + dbo.tblClient.zip AS clientcitystatezip, dbo.tblClient.fax AS clientfax, dbo.tblClient.email AS clientemail, 
                      dbo.tblUser.firstname + ' ' + dbo.tblUser.lastname AS scheduler, dbo.tblCase.marketercode AS marketer, dbo.tblCase.dateadded AS datecalledin, 
                      dbo.tblCase.dateofinjury AS DOI, dbo.tblCase.allegation, dbo.tblCase.notes, dbo.tblCase.casetype, 
                      'Dear ' + dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineesalutation, dbo.tblCase.status, dbo.tblCase.calledinby, dbo.tblCase.chartnbr, 
                      'Dear ' + dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientsalutation, 
                      'Dear ' + dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorsalutation, dbo.tblLocation.insidedr, 
                      dbo.tblLocation.email AS doctoremail, dbo.tblLocation.fax AS doctorfax, dbo.tblLocation.faxdrschedule, dbo.tblLocation.medrcdletter, dbo.tblLocation.drletter, 
                      dbo.tblCase.reportverbal, dbo.tblCase.datemedsrecd AS medsrecd, tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname, 
                      'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' ' + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation, tblCCAddress_2.company AS Pattorneycompany, 
                      tblCCAddress_2.address1 AS Pattorneyaddr1, tblCCAddress_2.address2 AS Pattorneyaddr2, 
                      tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  ' + tblCCAddress_2.zip AS Pattorneycitystatezip, 
                      tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone, tblCCAddress_2.fax AS Pattorneyfax, 
                      tblCCAddress_2.email AS Pattorneyemail, tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname, 'Dear ' + ISNULL(tblCCAddress_1.firstname, 
                      '') + ' ' + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation, tblCCAddress_1.company AS Dattorneycompany, tblCCAddress_1.address1 AS Dattorneyaddr1, 
                      tblCCAddress_1.address2 AS Dattorneyaddr2, tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  ' + tblCCAddress_1.zip AS Dattorneycitystatezip, 
                      tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension, '') AS Dattorneyphone, tblCCAddress_1.fax AS Dattorneyfax, 
                      tblCCAddress_1.email AS Dattorneyemail, tblCCAddress_1.fax, dbo.tblCase.typemedsrecd, dbo.tblCase.plaintiffattorneycode, dbo.tblCase.defenseattorneycode, 
                      dbo.tblCase.servicecode, dbo.tblCase.faxPattny, dbo.tblCase.faxdoctor, dbo.tblCase.faxclient, dbo.tblCase.emailclient, dbo.tblCase.emaildoctor, 
                      dbo.tblCase.emailPattny, dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.commitdate, dbo.tblCase.WCBNbr, dbo.tblCase.specialinstructions, 
                      dbo.tblCase.priority, dbo.tblServices.description AS servicedesc, dbo.tblCase.usdvarchar1 AS caseusdvarchar1, dbo.tblCase.usdvarchar2 AS caseusdvarchar2, 
                      dbo.tblCase.usddate1 AS caseusddate1, dbo.tblCase.usddate2 AS caseusddate2, dbo.tblCase.usdtext1 AS caseusdtext1, dbo.tblCase.usdtext2 AS caseusdtext2, 
                      dbo.tblCase.usdint1 AS caseusdint1, dbo.tblCase.usdint2 AS caseusdint2, dbo.tblCase.usdmoney1 AS caseusdmoney1, dbo.tblCase.usdmoney2 AS caseusdmoney2, 
                      dbo.tblClient.title AS clienttitle, dbo.tblClient.prefix AS clientprefix, dbo.tblClient.suffix AS clientsuffix, dbo.tblClient.usdvarchar1 AS clientusdvarchar1, 
                      dbo.tblClient.usdvarchar2 AS clientusdvarchar2, dbo.tblClient.usddate1 AS clientusddate1, dbo.tblClient.usddate2 AS clientusddate2, 
                      dbo.tblClient.usdtext1 AS clientusdtext1, dbo.tblClient.usdtext2 AS clientusdtext2, dbo.tblClient.usdint1 AS clientusdint1, dbo.tblClient.usdint2 AS clientusdint2, 
                      dbo.tblClient.usdmoney1 AS clientusdmoney1, dbo.tblClient.usdmoney2 AS clientusdmoney2, dbo.tblDoctor.notes AS doctornotes, dbo.tblDoctor.prefix AS doctorprefix, 
                      dbo.tblDoctor.addr1 AS doctorcorrespaddr1, dbo.tblDoctor.addr2 AS doctorcorrespaddr2, 
                      dbo.tblDoctor.city + ', ' + dbo.tblDoctor.state + '  ' + dbo.tblDoctor.zip AS doctorcorrespcitystatezip, dbo.tblDoctor.phone + ' ' + ISNULL(dbo.tblDoctor.phoneExt, ' ') 
                      AS doctorcorrespphone, dbo.tblDoctor.faxNbr AS doctorcorrespfax, dbo.tblDoctor.emailAddr AS doctorcorrespemail, dbo.tblDoctor.qualifications, dbo.tblDoctor.prepaid, 
                      dbo.tblDoctor.county AS doctorcorrespcounty, dbo.tblLocation.county AS doctorcounty, dbo.tblLocation.vicinity AS doctorvicinity, 
                      dbo.tblExaminee.county AS examineecounty, dbo.tblExaminee.prefix AS examineeprefix, dbo.tblExaminee.usdvarchar1 AS examineeusdvarchar1, 
                      dbo.tblExaminee.usdvarchar2 AS examineeusdvarchar2, dbo.tblExaminee.usddate1 AS examineeusddate1, dbo.tblExaminee.usddate2 AS examineeusddate2, 
                      dbo.tblExaminee.usdtext1 AS examineeusdtext1, dbo.tblExaminee.usdtext2 AS examineeusdtext2, dbo.tblExaminee.usdint1 AS examineeusdint1, 
                      dbo.tblExaminee.usdint2 AS examineeusdint2, dbo.tblExaminee.usdmoney1 AS examineeusdmoney1, dbo.tblExaminee.usdmoney2 AS examineeusdmoney2, 
                      dbo.tblDoctor.usdvarchar1 AS doctorusdvarchar1, dbo.tblDoctor.usdvarchar2 AS doctorusdvarchar2, dbo.tblDoctor.usddate1 AS doctorusddate1, 
                      dbo.tblDoctor.usddate2 AS doctorusddate2, dbo.tblDoctor.usdtext1 AS doctorusdtext1, dbo.tblDoctor.usdtext2 AS doctorusdtext2, 
                      dbo.tblDoctor.usdint1 AS doctorusdint1, dbo.tblDoctor.usdint2 AS doctorusdint2, dbo.tblDoctor.usdmoney1 AS doctorusdmoney1, 
                      dbo.tblDoctor.usdmoney2 AS doctorusdmoney2, dbo.tblCase.schedulenotes, dbo.tblCase.requesteddoc, dbo.tblCompany.usdvarchar1 AS companyusdvarchar1, 
                      dbo.tblCompany.usdvarchar2 AS companyusdvarchar2, dbo.tblCompany.usddate1 AS companyusddate1, dbo.tblCompany.usddate2 AS companyusddate2, 
                      dbo.tblCompany.usdtext1 AS companyusdtext1, dbo.tblCompany.usdtext2 AS companyusdtext2, dbo.tblCompany.usdint1 AS companyusdint1, 
                      dbo.tblCompany.usdint2 AS companyusdint2, dbo.tblCompany.usdmoney1 AS companyusdmoney1, dbo.tblCompany.usdmoney2 AS companyusdmoney2, 
                      dbo.tblDoctor.WCNbr AS doctorwcnbr, dbo.tblCaseType.description AS casetypedesc, dbo.tblLocation.location, dbo.tblCase.sinternalcasenbr AS internalcasenbr, 
                      dbo.tblDoctor.credentials AS doctordegree, dbo.tblSpecialty.description AS specialtydesc, dbo.tblExaminee.note AS chartnotes, dbo.tblExaminee.fax AS examineefax, 
                      dbo.tblExaminee.email AS examineeemail, dbo.tblExaminee.insured AS examineeinsured, dbo.tblCase.clientcode, dbo.tblCase.feecode, dbo.tblClient.companycode, 
                      dbo.tblClient.notes AS clientnotes, dbo.tblCompany.notes AS companynotes, dbo.tblClient.billaddr1, dbo.tblClient.billaddr2, dbo.tblClient.billcity, dbo.tblClient.billstate, 
                      dbo.tblClient.billzip, dbo.tblClient.billattn, dbo.tblClient.ARKey, dbo.tblCase.icd9code, dbo.tblDoctor.remitattn, dbo.tblDoctor.remitaddr1, dbo.tblDoctor.remitaddr2, 
                      dbo.tblDoctor.remitcity, dbo.tblDoctor.remitstate, dbo.tblDoctor.remitzip, dbo.tblCase.doctorspecialty, dbo.tblServices.shortdesc, 
                      dbo.tblDoctor.licensenbr AS doctorlicense, dbo.tblLocation.notes AS doctorlocationnotes, 
                      dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontact, 
                      'Dear ' + dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontactsalutation, dbo.tblRecordStatus.description AS medsstatus, 
                      dbo.tblExaminee.employer, dbo.tblExaminee.treatingphysician, dbo.tblExaminee.city AS examineecity, dbo.tblExaminee.state AS examineestate, 
                      dbo.tblExaminee.zip AS examineezip, dbo.tblDoctor.SSNTaxID AS DoctorTaxID, dbo.tblCase.billclientcode AS casebillclientcode, 
                      dbo.tblCase.billaddr1 AS casebilladdr1, dbo.tblCase.billaddr2 AS casebilladdr2, dbo.tblCase.billcity AS casebillcity, dbo.tblCase.billstate AS casebillstate, 
                      dbo.tblCase.billzip AS casebillzip, dbo.tblCase.billARKey AS casebillarkey, dbo.tblCase.billcompany AS casebillcompany, dbo.tblCase.billcontact AS casebillcontact, 
                      dbo.tblSpecialty.specialtycode, dbo.tblDoctorLocation.correspondence AS doctorcorrespondence, dbo.tblExaminee.lastname AS examineelastname, 
                      dbo.tblExaminee.firstname AS examineefirstname, dbo.tblCase.billfax AS casebillfax, dbo.tblClient.billfax AS clientbillfax, dbo.tblCase.officecode, 
                      dbo.tblDoctor.lastname AS doctorlastname, dbo.tblDoctor.firstname AS doctorfirstname, dbo.tblDoctor.middleinitial AS doctormiddleinitial, 
                      ISNULL(LEFT(dbo.tblDoctor.firstname, 1), '') + ISNULL(LEFT(dbo.tblDoctor.middleinitial, 1), '') + ISNULL(LEFT(dbo.tblDoctor.lastname, 1), '') AS doctorinitials, 
                      dbo.tblCase.QARep, dbo.tblClient.lastname AS clientlastname, dbo.tblClient.firstname AS clientfirstname, tblCCAddress_1.prefix AS dattorneyprefix, 
                      tblCCAddress_1.lastname AS dattorneylastname, tblCCAddress_1.firstname AS dattorneyfirstname, tblCCAddress_2.prefix AS pattorneyprefix, 
                      tblCCAddress_2.lastname AS pattorneylastname, tblCCAddress_2.firstname AS pattorneyfirstname, dbo.tblLocation.contactprefix AS doctorlocationcontactprefix, 
                      dbo.tblLocation.contactfirst AS doctorlocationcontactfirstname, dbo.tblLocation.contactlast AS doctorlocationcontactlastname, 
                      dbo.tblExaminee.middleinitial AS examineemiddleinitial, dbo.tblCase.ICD9Code2, dbo.tblCase.ICD9Code3, dbo.tblCase.ICD9Code4, dbo.tblExaminee.InsuredAddr1, 
                      dbo.tblExaminee.InsuredCity, dbo.tblExaminee.InsuredState, dbo.tblExaminee.InsuredZip, dbo.tblExaminee.InsuredSex, dbo.tblExaminee.InsuredRelationship, 
                      dbo.tblExaminee.InsuredPhone, dbo.tblExaminee.InsuredPhoneExt, dbo.tblExaminee.InsuredFax, dbo.tblExaminee.InsuredEmail, dbo.tblExaminee.ExamineeStatus, 
                      dbo.tblExaminee.TreatingPhysicianAddr1, dbo.tblExaminee.TreatingPhysicianCity, dbo.tblExaminee.TreatingPhysicianState, dbo.tblExaminee.TreatingPhysicianZip, 
                      dbo.tblExaminee.TreatingPhysicianPhone, dbo.tblExaminee.TreatingPhysicianPhoneExt, dbo.tblExaminee.TreatingPhysicianFax, 
                      dbo.tblExaminee.TreatingPhysicianEmail, dbo.tblExaminee.TreatingPhysicianLicenseNbr, dbo.tblExaminee.TreatingPhysicianTaxID, dbo.tblExaminee.EmployerAddr1, 
                      dbo.tblExaminee.EmployerCity, dbo.tblExaminee.EmployerState, dbo.tblExaminee.EmployerZip, dbo.tblExaminee.EmployerPhone, 
                      dbo.tblExaminee.EmployerPhoneExt, dbo.tblExaminee.EmployerFax, dbo.tblExaminee.EmployerEmail, dbo.tblExaminee.Country, dbo.tblDoctor.UPIN, 
                      dbo.tblDoctor.schedulepriority, dbo.tblDoctor.feecode AS drfeecode, dbo.tblCase.PanelNbr, dbo.tblstate.StateName AS Jurisdiction, dbo.tblCase.photoRqd, 
                      dbo.tblCase.CertMailNbr, dbo.tblCase.HearingDate, dbo.tblCase.DoctorName, dbo.tblLocation.state AS doctorstate, dbo.tblClient.state AS clientstate, 
                      dbo.tblDoctor.state AS doctorcorrespstate, tblCCAddress_1.state AS dattorneystate, tblCCAddress_2.state AS pattorneystate, dbo.tblacctingtrans.apptdate, 
                      dbo.tblacctingtrans.DrOpCode AS doctorcode, dbo.tblacctingtrans.doctorlocation, dbo.tblacctingtrans.documentnbr, dbo.tblacctingtrans.type AS documenttype, 
                      dbo.tblacctingtrans.appttime, dbo.tblCase.prevappt, dbo.tblLocation.state, dbo.tblClient.state AS Expr1, dbo.tblDoctor.state AS Expr2, tblCCAddress_1.state AS Expr3, 
                      tblCCAddress_2.state AS Expr4, dbo.tblLocation.city AS doctorcity, dbo.tblLocation.zip AS doctorzip, dbo.tblClient.city AS clientcity, dbo.tblClient.zip AS clientzip, 
                      dbo.tblExaminee.policynumber, tblCCAddress_2.city AS pattorneycity, tblCCAddress_2.zip AS pattorneyzip, dbo.tblCase.mastercasenbr, 
                      dbo.tblDoctorSchedule.duration AS ApptDuration, dbo.tblDoctor.companyname AS PracticeName, dbo.tblCase.AssessmentToAddress, dbo.tblCase.OCF25Date, 
                      dbo.tblCase.AssessingFacility, dbo.tblCase.DateForminDispute, dbo.tblExaminee.EmployerContactFirstName, dbo.tblExaminee.EmployerContactLastName, 
                      dbo.tblDoctor.NPINbr AS DoctorNPINbr, dbo.tblProviderType.description AS DoctorProviderType, dbo.tblDoctor.ProvTypeCode, dbo.tblCase.DateReceived, 
                      dbo.tblCase.usddate3 AS caseusddate3, dbo.tblCase.usddate4 AS caseusddate4, dbo.tblCase.usddate5 AS caseusddate5, dbo.tblCase.UsdBit1 AS caseusdboolean1, 
                      dbo.tblCase.UsdBit2 AS caseusdboolean2, dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3, dbo.tblDoctor.usddate5 AS doctorusddate5, 
                      dbo.tblDoctor.usddate6 AS doctorusddate6, dbo.tblDoctor.usddate7 AS doctorusddate7, dbo.tblDoctor.usddate3 AS doctorusddate3, 
                      dbo.tblDoctor.usddate4 AS doctorusddate4, dbo.tblacctingtrans.SeqNO, dbo.tblOffice.usdvarchar1 AS officeusdvarchar1, 
                      dbo.tblOffice.usdvarchar2 AS officeusdvarchar2, dbo.tblCase.ClaimNbrExt, dbo.tblCase.sreqspecialty AS RequestedSpecialty, 
                      tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname, 'Dear ' + ISNULL(tblCCAddress_3.firstname, '') 
                      + ' ' + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation, tblCCAddress_3.company AS DParaLegalcompany, 
                      tblCCAddress_3.address1 AS DParaLegaladdr1, tblCCAddress_3.address2 AS DParaLegaladdr2, 
                      tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  ' + tblCCAddress_3.zip AS DParaLegalcitystatezip, 
                      tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension, '') AS DParaLegalphone, tblCCAddress_3.email AS DParaLegalemail, 
                      tblCCAddress_3.fax AS DParaLegalfax, dbo.tblCase.AttorneyNote, dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc, dbo.tblCase.ExternalDueDate, 
                      dbo.tblCase.InternalDueDate, dbo.tblLocation.ExtName AS LocationExtName
FROM         dbo.tblExaminee INNER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblacctingtrans ON dbo.tblCase.casenbr = dbo.tblacctingtrans.casenbr INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_3 ON dbo.tblCase.DefParaLegal = tblCCAddress_3.cccode LEFT OUTER JOIN
                      dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                      dbo.tblDoctor LEFT OUTER JOIN
                      dbo.tblProviderType ON dbo.tblDoctor.ProvTypeCode = dbo.tblProviderType.ProvTypeCode ON 
                      dbo.tblacctingtrans.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblacctingtrans.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblstate ON dbo.tblCase.Jurisdiction = dbo.tblstate.Statecode LEFT OUTER JOIN
                      dbo.tblDoctorLocation ON dbo.tblCase.doctorlocation = dbo.tblDoctorLocation.locationcode AND 
                      dbo.tblCase.doctorcode = dbo.tblDoctorLocation.doctorcode LEFT OUTER JOIN
                      dbo.tblRecordStatus ON dbo.tblCase.reccode = dbo.tblRecordStatus.reccode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_1 ON dbo.tblCase.defenseattorneycode = tblCCAddress_1.cccode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode

GO

DROP VIEW [vwdocument]
GO

CREATE VIEW dbo.vwdocument
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.claimnbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblExaminee.SSN, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.extname AS company, dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext,
                       ' ') AS clientphone, dbo.tblClient.phone2 + ' ' + ISNULL(dbo.tblClient.phone2ext, ' ') AS clientphone2, dbo.tblLocation.addr1 AS doctoraddr1, 
                      dbo.tblLocation.addr2 AS doctoraddr2, dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, dbo.tblCase.ApptDate, 
                      dbo.tblCase.Appttime, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblExaminee.phone1 AS examineephone, 
                      dbo.tblExaminee.sex, dbo.tblExaminee.DOB, dbo.tblLocation.Phone AS doctorphone, dbo.tblClient.addr1 AS clientaddr1, dbo.tblClient.addr2 AS clientaddr2, 
                      dbo.tblClient.city + ', ' + dbo.tblClient.state + '  ' + dbo.tblClient.zip AS clientcitystatezip, dbo.tblClient.fax AS clientfax, dbo.tblClient.email AS clientemail, 
                      dbo.tblUser.firstname + ' ' + dbo.tblUser.lastname AS scheduler, dbo.tblCase.marketercode AS marketer, dbo.tblCase.dateadded AS datecalledin, 
                      dbo.tblCase.dateofinjury AS DOI, dbo.tblCase.allegation, dbo.tblCase.notes, dbo.tblCase.casetype, 
                      'Dear ' + dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineesalutation, dbo.tblCase.status, dbo.tblCase.calledinby, dbo.tblCase.chartnbr, 
                      'Dear ' + dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientsalutation, 
                      'Dear ' + dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorsalutation, dbo.tblLocation.insidedr, 
                      dbo.tblLocation.email AS doctoremail, dbo.tblLocation.fax AS doctorfax, dbo.tblLocation.faxdrschedule, dbo.tblLocation.medrcdletter, dbo.tblLocation.drletter, 
                      dbo.tblCase.reportverbal, dbo.tblCase.datemedsrecd AS medsrecd, tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname, 
                      'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' ' + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation, tblCCAddress_2.company AS Pattorneycompany, 
                      tblCCAddress_2.address1 AS Pattorneyaddr1, tblCCAddress_2.address2 AS Pattorneyaddr2, 
                      tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  ' + tblCCAddress_2.zip AS Pattorneycitystatezip, 
                      tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone, tblCCAddress_2.fax AS Pattorneyfax, 
                      tblCCAddress_2.email AS Pattorneyemail, tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname, 'Dear ' + ISNULL(tblCCAddress_1.firstname, 
                      '') + ' ' + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation, tblCCAddress_1.company AS Dattorneycompany, tblCCAddress_1.address1 AS Dattorneyaddr1, 
                      tblCCAddress_1.address2 AS Dattorneyaddr2, tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  ' + tblCCAddress_1.zip AS Dattorneycitystatezip, 
                      tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension, '') AS Dattorneyphone, tblCCAddress_1.fax AS Dattorneyfax, 
                      tblCCAddress_1.email AS Dattorneyemail, tblCCAddress_1.fax, tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname, 
                      'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' ' + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation, 
                      tblCCAddress_3.company AS DParaLegalcompany, tblCCAddress_3.address1 AS DParaLegaladdr1, tblCCAddress_3.address2 AS DParaLegaladdr2, 
                      tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  ' + tblCCAddress_3.zip AS DParaLegalcitystatezip, 
                      tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension, '') AS DParaLegalphone, tblCCAddress_3.email AS DParaLegalemail, 
                      tblCCAddress_3.fax AS DParaLegalfax, dbo.tblCase.typemedsrecd, dbo.tblCase.plaintiffattorneycode, dbo.tblCase.defenseattorneycode, dbo.tblCase.servicecode, 
                      dbo.tblCase.faxPattny, dbo.tblCase.faxdoctor, dbo.tblCase.faxclient, dbo.tblCase.emailclient, dbo.tblCase.emaildoctor, dbo.tblCase.emailPattny, 
                      dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.commitdate, dbo.tblCase.WCBNbr, dbo.tblCase.specialinstructions, dbo.tblCase.priority, 
                      dbo.tblServices.description AS servicedesc, dbo.tblCase.usdvarchar1 AS caseusdvarchar1, dbo.tblCase.usdvarchar2 AS caseusdvarchar2, 
                      dbo.tblCase.usddate1 AS caseusddate1, dbo.tblCase.usddate2 AS caseusddate2, dbo.tblCase.usdtext1 AS caseusdtext1, dbo.tblCase.usdtext2 AS caseusdtext2, 
                      dbo.tblCase.usdint1 AS caseusdint1, dbo.tblCase.usdint2 AS caseusdint2, dbo.tblCase.usdmoney1 AS caseusdmoney1, dbo.tblCase.usdmoney2 AS caseusdmoney2, 
                      dbo.tblClient.title AS clienttitle, dbo.tblClient.prefix AS clientprefix, dbo.tblClient.suffix AS clientsuffix, dbo.tblClient.usdvarchar1 AS clientusdvarchar1, 
                      dbo.tblClient.usdvarchar2 AS clientusdvarchar2, dbo.tblClient.usddate1 AS clientusddate1, dbo.tblClient.usddate2 AS clientusddate2, 
                      dbo.tblClient.usdtext1 AS clientusdtext1, dbo.tblClient.usdtext2 AS clientusdtext2, dbo.tblClient.usdint1 AS clientusdint1, dbo.tblClient.usdint2 AS clientusdint2, 
                      dbo.tblClient.usdmoney1 AS clientusdmoney1, dbo.tblClient.usdmoney2 AS clientusdmoney2, dbo.tblDoctor.notes AS doctornotes, dbo.tblDoctor.prefix AS doctorprefix, 
                      dbo.tblDoctor.addr1 AS doctorcorrespaddr1, dbo.tblDoctor.addr2 AS doctorcorrespaddr2, 
                      dbo.tblDoctor.city + ', ' + dbo.tblDoctor.state + '  ' + dbo.tblDoctor.zip AS doctorcorrespcitystatezip, dbo.tblDoctor.phone + ' ' + ISNULL(dbo.tblDoctor.phoneExt, ' ') 
                      AS doctorcorrespphone, dbo.tblDoctor.faxNbr AS doctorcorrespfax, dbo.tblDoctor.emailAddr AS doctorcorrespemail, dbo.tblDoctor.qualifications, dbo.tblDoctor.prepaid, 
                      dbo.tblDoctor.county AS doctorcorrespcounty, dbo.tblLocation.county AS doctorcounty, dbo.tblLocation.vicinity AS doctorvicinity, 
                      dbo.tblExaminee.county AS examineecounty, dbo.tblExaminee.prefix AS examineeprefix, dbo.tblExaminee.usdvarchar1 AS examineeusdvarchar1, 
                      dbo.tblExaminee.usdvarchar2 AS examineeusdvarchar2, dbo.tblExaminee.usddate1 AS examineeusddate1, dbo.tblExaminee.usddate2 AS examineeusddate2, 
                      dbo.tblExaminee.usdtext1 AS examineeusdtext1, dbo.tblExaminee.usdtext2 AS examineeusdtext2, dbo.tblExaminee.usdint1 AS examineeusdint1, 
                      dbo.tblExaminee.usdint2 AS examineeusdint2, dbo.tblExaminee.usdmoney1 AS examineeusdmoney1, dbo.tblExaminee.usdmoney2 AS examineeusdmoney2, 
                      dbo.tblDoctor.usdvarchar1 AS doctorusdvarchar1, dbo.tblDoctor.usdvarchar2 AS doctorusdvarchar2, dbo.tblDoctor.usddate1 AS doctorusddate1, 
                      dbo.tblDoctor.usddate2 AS doctorusddate2, dbo.tblDoctor.usdtext1 AS doctorusdtext1, dbo.tblDoctor.usdtext2 AS doctorusdtext2, 
                      dbo.tblDoctor.usdint1 AS doctorusdint1, dbo.tblDoctor.usdint2 AS doctorusdint2, dbo.tblDoctor.usdmoney1 AS doctorusdmoney1, 
                      dbo.tblDoctor.usdmoney2 AS doctorusdmoney2, dbo.tblCase.schedulenotes, dbo.tblCase.requesteddoc, dbo.tblCompany.usdvarchar1 AS companyusdvarchar1, 
                      dbo.tblCompany.usdvarchar2 AS companyusdvarchar2, dbo.tblCompany.usddate1 AS companyusddate1, dbo.tblCompany.usddate2 AS companyusddate2, 
                      dbo.tblCompany.usdtext1 AS companyusdtext1, dbo.tblCompany.usdtext2 AS companyusdtext2, dbo.tblCompany.usdint1 AS companyusdint1, 
                      dbo.tblCompany.usdint2 AS companyusdint2, dbo.tblCompany.usdmoney1 AS companyusdmoney1, dbo.tblCompany.usdmoney2 AS companyusdmoney2, 
                      dbo.tblDoctor.WCNbr AS doctorwcnbr, dbo.tblCaseType.description AS casetypedesc, dbo.tblLocation.location, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.sinternalcasenbr AS internalcasenbr, dbo.tblDoctor.credentials AS doctordegree, dbo.tblSpecialty.description AS specialtydesc, 
                      dbo.tblExaminee.note AS chartnotes, dbo.tblExaminee.fax AS examineefax, dbo.tblExaminee.email AS examineeemail, dbo.tblExaminee.insured AS examineeinsured, 
                      dbo.tblCase.clientcode, dbo.tblCase.doctorcode, dbo.tblCase.feecode, dbo.tblClient.companycode, dbo.tblClient.notes AS clientnotes, 
                      dbo.tblCompany.notes AS companynotes, dbo.tblClient.billaddr1, dbo.tblClient.billaddr2, dbo.tblClient.billcity, dbo.tblClient.billstate, dbo.tblClient.billzip, 
                      dbo.tblClient.billattn, dbo.tblClient.ARKey, dbo.tblCase.icd9code, dbo.tblDoctor.remitattn, dbo.tblDoctor.remitaddr1, dbo.tblDoctor.remitaddr2, dbo.tblDoctor.remitcity, 
                      dbo.tblDoctor.remitstate, dbo.tblDoctor.remitzip, dbo.tblCase.doctorspecialty, dbo.tblServices.shortdesc, dbo.tblDoctor.licensenbr AS doctorlicense, 
                      dbo.tblLocation.notes AS doctorlocationnotes, dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontact, 
                      'Dear ' + dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontactsalutation, dbo.tblRecordStatus.description AS medsstatus, 
                      dbo.tblExaminee.employer, dbo.tblExaminee.treatingphysician, dbo.tblExaminee.city AS examineecity, dbo.tblExaminee.state AS examineestate, 
                      dbo.tblExaminee.zip AS examineezip, dbo.tblDoctor.SSNTaxID AS DoctorTaxID, dbo.tblCase.billclientcode AS casebillclientcode, 
                      dbo.tblCase.billaddr1 AS casebilladdr1, dbo.tblCase.billaddr2 AS casebilladdr2, dbo.tblCase.billcity AS casebillcity, dbo.tblCase.billstate AS casebillstate, 
                      dbo.tblCase.billzip AS casebillzip, dbo.tblCase.billARKey AS casebillarkey, dbo.tblCase.billcompany AS casebillcompany, dbo.tblCase.billcontact AS casebillcontact, 
                      dbo.tblSpecialty.specialtycode, dbo.tblDoctorLocation.correspondence AS doctorcorrespondence, dbo.tblExaminee.lastname AS examineelastname, 
                      dbo.tblExaminee.firstname AS examineefirstname, dbo.tblCase.billfax AS casebillfax, dbo.tblClient.billfax AS clientbillfax, dbo.tblCase.officecode, 
                      dbo.tblDoctor.lastname AS doctorlastname, dbo.tblDoctor.firstname AS doctorfirstname, dbo.tblDoctor.middleinitial AS doctormiddleinitial, 
                      ISNULL(LEFT(dbo.tblDoctor.firstname, 1), '') + ISNULL(LEFT(dbo.tblDoctor.middleinitial, 1), '') + ISNULL(LEFT(dbo.tblDoctor.lastname, 1), '') AS doctorinitials, 
                      dbo.tblCase.QARep, dbo.tblClient.lastname AS clientlastname, dbo.tblClient.firstname AS clientfirstname, tblCCAddress_1.prefix AS dattorneyprefix, 
                      tblCCAddress_1.lastname AS dattorneylastname, tblCCAddress_1.firstname AS dattorneyfirstname, tblCCAddress_2.prefix AS pattorneyprefix, 
                      tblCCAddress_2.lastname AS pattorneylastname, tblCCAddress_2.firstname AS pattorneyfirstname, dbo.tblLocation.contactprefix AS doctorlocationcontactprefix, 
                      dbo.tblLocation.contactfirst AS doctorlocationcontactfirstname, dbo.tblLocation.contactlast AS doctorlocationcontactlastname, 
                      dbo.tblExaminee.middleinitial AS examineemiddleinitial, dbo.tblCase.ICD9Code2, dbo.tblCase.ICD9Code3, dbo.tblCase.ICD9Code4, dbo.tblExaminee.InsuredAddr1, 
                      dbo.tblExaminee.InsuredCity, dbo.tblExaminee.InsuredState, dbo.tblExaminee.InsuredZip, dbo.tblExaminee.InsuredSex, dbo.tblExaminee.InsuredRelationship, 
                      dbo.tblExaminee.InsuredPhone, dbo.tblExaminee.InsuredPhoneExt, dbo.tblExaminee.InsuredFax, dbo.tblExaminee.InsuredEmail, dbo.tblExaminee.ExamineeStatus, 
                      dbo.tblExaminee.TreatingPhysicianAddr1, dbo.tblExaminee.TreatingPhysicianCity, dbo.tblExaminee.TreatingPhysicianState, dbo.tblExaminee.TreatingPhysicianZip, 
                      dbo.tblExaminee.TreatingPhysicianPhone, dbo.tblExaminee.TreatingPhysicianPhoneExt, dbo.tblExaminee.TreatingPhysicianFax, 
                      dbo.tblExaminee.TreatingPhysicianEmail, dbo.tblExaminee.TreatingPhysicianLicenseNbr, dbo.tblExaminee.EmployerAddr1, dbo.tblExaminee.EmployerCity, 
                      dbo.tblExaminee.EmployerState, dbo.tblExaminee.EmployerZip, dbo.tblExaminee.EmployerPhone, dbo.tblExaminee.EmployerPhoneExt, 
                      dbo.tblExaminee.EmployerFax, dbo.tblExaminee.EmployerEmail, dbo.tblExaminee.TreatingPhysicianTaxID, dbo.tblExaminee.Country, dbo.tblDoctor.UPIN, 
                      dbo.tblDoctor.schedulepriority, dbo.tblDoctor.feecode AS drfeecode, dbo.tblCase.PanelNbr, dbo.tblstate.StateName AS Jurisdiction, dbo.tblCase.photoRqd, 
                      dbo.tblCase.CertMailNbr, dbo.tblCase.HearingDate, dbo.tblCase.DoctorName, dbo.tblLocation.state AS doctorstate, dbo.tblClient.state AS clientstate, 
                      dbo.tblDoctor.state AS doctorcorrespstate, tblCCAddress_1.state AS dattorneystate, tblCCAddress_2.state AS pattorneystate, dbo.tblCase.prevappt, 
                      dbo.tblCase.mastersubcase, dbo.tblCase.mastercasenbr, dbo.tblLocation.city AS doctorcity, dbo.tblLocation.zip AS doctorzip, dbo.tblClient.city AS clientcity, 
                      dbo.tblClient.zip AS clientzip, dbo.tblExaminee.policynumber, tblCCAddress_2.city AS pattorneycity, tblCCAddress_2.zip AS pattorneyzip, 
                      dbo.tblDoctorSchedule.duration AS ApptDuration, dbo.tblDoctor.companyname AS PracticeName, dbo.tblCase.AssessmentToAddress, dbo.tblCase.OCF25Date, 
                      dbo.tblCase.AssessingFacility, dbo.tblCase.DateForminDispute, dbo.tblExaminee.EmployerContactLastName, dbo.tblExaminee.EmployerContactFirstName, 
                      dbo.tblDoctor.NPINbr AS DoctorNPINbr, dbo.tblCase.PublishOnWeb, dbo.tblProviderType.description AS DoctorProviderType, dbo.tblDoctor.ProvTypeCode, 
                      dbo.tblCase.Jurisdiction AS JurisdictionCode, dbo.tblCase.LegalEvent, dbo.tblCase.PILegalEvent, dbo.tblCase.Transcode, dbo.tblTranscription.transcompany, 
                      dbo.tblCase.DateReceived, dbo.tblCase.usddate3 AS caseusddate3, dbo.tblCase.usddate4 AS caseusddate4, dbo.tblCase.UsdBit1 AS caseusdboolean1, 
                      dbo.tblCase.UsdBit2 AS caseusdboolean2, dbo.tblCase.usddate5 AS caseusddate5, dbo.tblDoctor.usddate3 AS doctorusddate3, 
                      dbo.tblDoctor.usddate4 AS doctorusddate4, dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3, dbo.tblDoctor.usddate5 AS doctorusddate5, 
                      dbo.tblDoctor.usddate6 AS doctorusddate6, dbo.tblDoctor.usddate7 AS doctorusddate7, dbo.tblOffice.usdvarchar1 AS officeusdvarchar1, 
                      dbo.tblOffice.usdvarchar2 AS officeusdvarchar2, dbo.tblCase.ClaimNbrExt, dbo.tblCase.sreqspecialty AS RequestedSpecialty, dbo.tblQueues.statusdesc, 
                      dbo.tblCase.AttorneyNote, dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc, dbo.tblCase.ExternalDueDate, dbo.tblCase.InternalDueDate, 
                      dbo.tblLocation.ExtName AS LocationExtName
FROM         dbo.tblstate RIGHT OUTER JOIN
                      dbo.tblTranscription RIGHT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_3 RIGHT OUTER JOIN
                      dbo.tblExaminee INNER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode ON tblCCAddress_3.cccode = dbo.tblCase.DefParaLegal ON 
                      dbo.tblTranscription.Transcode = dbo.tblCase.Transcode LEFT OUTER JOIN
                      dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode ON dbo.tblstate.Statecode = dbo.tblCase.Jurisdiction LEFT OUTER JOIN
                      dbo.tblDoctorLocation ON dbo.tblCase.doctorlocation = dbo.tblDoctorLocation.locationcode AND 
                      dbo.tblCase.doctorcode = dbo.tblDoctorLocation.doctorcode LEFT OUTER JOIN
                      dbo.tblRecordStatus ON dbo.tblCase.reccode = dbo.tblRecordStatus.reccode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblProviderType RIGHT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblProviderType.ProvTypeCode = dbo.tblDoctor.ProvTypeCode ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_1 ON dbo.tblCase.defenseattorneycode = tblCCAddress_1.cccode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode

GO

IF EXISTS 
(
    SELECT * FROM [information_schema].[routines]
    WHERE   routine_name = 'proc_tblCaseInsert' 
)
DROP PROCEDURE [proc_tblCaseInsert]
GO

CREATE PROCEDURE [dbo].[proc_tblCaseInsert]
(
 @casenbr int = NULL output,
 @chartnbr int = NULL,
 @doctorlocation varchar(10) = NULL,
 @clientcode int = NULL,
 @marketercode varchar(15) = NULL,
 @schedulercode varchar(15) = NULL,
 @priority varchar(10) = NULL,
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
 @claimnbrext varchar(50) = NULL,
 @dateofinjury datetime = NULL,
 @allegation text = NULL,
 @calledinby varchar(50) = NULL,
 @notes text = NULL,
 @schedulenotes text = NULL,
 @requesteddoc varchar(50) = NULL,
 @datemedsrecd datetime = NULL,
 @typemedsrecd varchar(50) = NULL,
 @transcode varchar(10) = NULL,
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
 @sinternalcasenbr varchar(20) = NULL,
 @sreqdegree varchar(20) = NULL,
 @sreqspecialty varchar(50) = NULL,
 @doctorspecialty varchar(50) = NULL,
 @feecode int = NULL,
 @voucherselect bit = NULL,
 @voucheramt money = NULL,
 @voucherdate datetime = NULL,
 @icd9code varchar(15) = NULL,
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
 @ICD9Code2 varchar(15) = NULL,
 @ICD9Code3 varchar(15) = NULL,
 @ICD9Code4 varchar(15) = NULL,
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
 @WebGUID uniqueidentifier = NULL,
 @WebLastSynchDate datetime = NULL,
 @WebNotifyEmail varchar(200) = NULL,
 @AssessmentToAddress varchar(50) = NULL,
 @OCF25Date smalldatetime = NULL,
 @DateForminDispute smalldatetime = NULL,
 @AssessingFacility varchar(100) = NULL,
 @PublishDocuments bit = NULL,
 @DateReceived datetime = NULL
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
  [claimnbrext],
  [dateofinjury],
  [allegation],
  [calledinby],
  [notes],
  [schedulenotes],
  [requesteddoc],
  [datemedsrecd],
  [typemedsrecd],
  [transcode],
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
  [WebGUID],
  [WebLastSynchDate],
  [WebNotifyEmail],
  [AssessmentToAddress],
  [OCF25Date],
  [DateForminDispute],
  [AssessingFacility],
  [PublishDocuments],
  [DateReceived]
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
  @claimnbrext,
  @dateofinjury,
  @allegation,
  @calledinby,
  @notes,
  @schedulenotes,
  @requesteddoc,
  @datemedsrecd,
  @typemedsrecd,
  @transcode,
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
  @WebGUID,
  @WebLastSynchDate,
  @WebNotifyEmail,
  @AssessmentToAddress,
  @OCF25Date,
  @DateForminDispute,
  @AssessingFacility,
  @PublishDocuments,
  @DateReceived
 )

 SET @Err = @@Error
 
 SELECT @casenbr = SCOPE_IDENTITY()

 RETURN @Err
END


GO

DROP PROCEDURE [spExamineeCases]
GO


CREATE PROCEDURE dbo.spExamineeCases(@ChartNbr integer,
@userid varchar(30))
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ApptDate, dbo.tblCase.chartnbr, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblLocation.location, dbo.tblQueues.statusdesc, 
                      ISNULL(tblSpecialty_2.description, tblSpecialty_1.description) AS specialtydesc, tblSpecialty_1.description, dbo.tblServices.shortdesc, 
                      dbo.tblCase.mastersubcase, ISNULL(dbo.tblCase.mastercasenbr, dbo.tblCase.casenbr) AS mastercasenbr, dbo.tblCase.DoctorName
FROM         dbo.tblSpecialty tblSpecialty_2 RIGHT OUTER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblSpecialty tblSpecialty_1 ON dbo.tblCase.sreqspecialty = tblSpecialty_1.specialtycode ON 
                      tblSpecialty_2.specialtycode = dbo.tblCase.doctorspecialty LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode
WHERE     (dbo.tblCase.chartnbr = @chartnbr) AND (dbo.tblUserOffice.userid = @userid)
ORDER BY ISNULL(dbo.tblCase.mastercasenbr, dbo.tblCase.casenbr) DESC, dbo.tblCase.mastersubcase, dbo.tblCase.ApptDate DESC

GO
IF EXISTS 
(
    SELECT * FROM [information_schema].[routines]
    WHERE   routine_name = 'proc_tblCaseUpdate' 
)
DROP PROCEDURE [proc_tblCaseUpdate]
GO

CREATE PROCEDURE [dbo].[proc_tblCaseUpdate]
(
 @casenbr int,
 @chartnbr int = NULL,
 @doctorlocation varchar(10) = NULL,
 @clientcode int = NULL,
 @marketercode varchar(15) = NULL,
 @schedulercode varchar(15) = NULL,
 @priority varchar(10) = NULL,
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
 @transcode varchar(10) = NULL,
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
 @sinternalcasenbr varchar(20) = NULL,
 @sreqdegree varchar(20) = NULL,
 @sreqspecialty varchar(50) = NULL,
 @doctorspecialty varchar(50) = NULL,
 @feecode int = NULL,
 @voucherselect bit = NULL,
 @voucheramt money = NULL,
 @voucherdate datetime = NULL,
 @icd9code varchar(15) = NULL,
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
 @ICD9Code2 varchar(15) = NULL,
 @ICD9Code3 varchar(15) = NULL,
 @ICD9Code4 varchar(15) = NULL,
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
 @WebGUID uniqueidentifier = NULL,
 @WebLastSynchDate datetime = NULL,
 @WebNotifyEmail varchar(200) = NULL,
 @AssessmentToAddress varchar(50) = NULL,
 @OCF25Date smalldatetime = NULL,
 @DateForminDispute smalldatetime = NULL,
 @AssessingFacility varchar(100) = NULL,
 @PublishDocuments bit = NULL,
 @DateReceived datetime = NULL
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
  [transcode] = @transcode,
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
  [WebGUID] = @WebGUID,
  [WebLastSynchDate] = @WebLastSynchDate,
  [WebNotifyEmail] = @WebNotifyEmail,
  [AssessmentToAddress] = @AssessmentToAddress,
  [OCF25Date] = @OCF25Date,
  [DateForminDispute] = @DateForminDispute,
  [AssessingFacility] = @AssessingFacility,
  [PublishDocuments] = @PublishDocuments,
  [DateReceived] = @DateReceived
 WHERE
  [casenbr] = @casenbr


 SET @Err = @@Error


 RETURN @Err
END


GO
IF EXISTS 
(
    SELECT * FROM [information_schema].[routines]
    WHERE   routine_name = 'proc_tblSyncLogsUpdate' 
)
DROP PROCEDURE [proc_tblSyncLogsUpdate]
GO


CREATE PROCEDURE [proc_tblSyncLogsUpdate]
(
 @SyncLogID int,
 @Log_DateAdded datetime,
 @Log_Severity int,
 @Log_RelatedID int = NULL,
 @Log_Message text,
 @Log_Resolved bit,
 @log_ResolvedUserid varchar(50) = NULL,
 @log_ResolvedDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblSyncLogs]
 SET
  [Log_DateAdded] = @Log_DateAdded,
  [Log_Severity] = @Log_Severity,
  [Log_RelatedID] = @Log_RelatedID,
  [Log_Message] = @Log_Message,
  [Log_Resolved] = @Log_Resolved,
  [log_ResolvedUserid] = @log_ResolvedUserid,
  [log_ResolvedDate] = @log_ResolvedDate
 WHERE
  [SyncLogID] = @SyncLogID


 SET @Err = @@Error


 RETURN @Err
END


GO
IF EXISTS 
(
    SELECT * FROM [information_schema].[routines]
    WHERE   routine_name = 'proc_tblClientUpdate' 
)
DROP PROCEDURE [proc_tblClientUpdate]
GO

CREATE PROCEDURE [dbo].[proc_tblClientUpdate]
(
 @companycode int = NULL,
 @clientcode int,
 @clientnbrold varchar(10) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @title varchar(50) = NULL,
 @prefix varchar(10) = NULL,
 @suffix varchar(50) = NULL,
 @addr1 varchar(50) = NULL,
 @addr2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(10) = NULL,
 @phone1 varchar(15) = NULL,
 @phone1ext varchar(15) = NULL,
 @phone2 varchar(15) = NULL,
 @phone2ext varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @marketercode varchar(15) = NULL,
 @priority varchar(10) = NULL,
 @casetype varchar(20) = NULL,
 @feeschedule int = NULL,
 @status varchar(10) = NULL,
 @reportphone bit = NULL,
 @documentemail bit = NULL,
 @documentfax bit = NULL,
 @documentmail bit = NULL,
 @lastappt datetime = NULL,
 @dateadded datetime = NULL,
 @useridadded varchar(15) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(15) = NULL,
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
 @notes text = NULL,
 @billaddr1 varchar(50) = NULL,
 @billaddr2 varchar(50) = NULL,
 @billcity varchar(50) = NULL,
 @billstate varchar(2) = NULL,
 @billzip varchar(10) = NULL,
 @billattn varchar(70) = NULL,
 @ARKey varchar(50) = NULL,
 @billfax varchar(15) = NULL,
 @QARep varchar(15) = NULL,
 @photoRqd bit = NULL,
 @CertifiedMail bit = NULL,
 @Country varchar(50) = NULL,
 @PublishOnWeb bit = NULL,
 @WebGUID uniqueidentifier = NULL,
 @WebLastSynchDate datetime = NULL,
 @ProcessorFirstName varchar(30) = NULL,
 @ProcessorLastName varchar(50) = NULL,
 @ProcessorPhone varchar(15) = NULL,
 @ProcessorPhoneExt varchar(10) = NULL,
 @ProcessorFax varchar(15) = NULL,
 @ProcessorEmail varchar(200) = NULL,
 @DefOfficeCode int = NULL,
 @WebUserID int = NULL,
 @DocumentPublish bit = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblClient]
 SET
  [companycode] = @companycode,
  [clientnbrold] = @clientnbrold,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [title] = @title,
  [prefix] = @prefix,
  [suffix] = @suffix,
  [addr1] = @addr1,
  [addr2] = @addr2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone1] = @phone1,
  [phone1ext] = @phone1ext,
  [phone2] = @phone2,
  [phone2ext] = @phone2ext,
  [fax] = @fax,
  [email] = @email,
  [marketercode] = @marketercode,
  [priority] = @priority,
  [casetype] = @casetype,
  [feeschedule] = @feeschedule,
  [status] = @status,
  [reportphone] = @reportphone,
  [documentemail] = @documentemail,
  [documentfax] = @documentfax,
  [documentmail] = @documentmail,
  [lastappt] = @lastappt,
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited,
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
  [notes] = @notes,
  [billaddr1] = @billaddr1,
  [billaddr2] = @billaddr2,
  [billcity] = @billcity,
  [billstate] = @billstate,
  [billzip] = @billzip,
  [billattn] = @billattn,
  [ARKey] = @ARKey,
  [billfax] = @billfax,
  [QARep] = @QARep,
  [photoRqd] = @photoRqd,
  [CertifiedMail] = @CertifiedMail,
  [Country] = @Country,
  [PublishOnWeb] = @PublishOnWeb,
  [WebGUID] = @WebGUID,
  [WebLastSynchDate] = @WebLastSynchDate,
  [ProcessorFirstName] = @ProcessorFirstName,
  [ProcessorLastName] = @ProcessorLastName,
  [ProcessorPhone] = @ProcessorPhone,
  [ProcessorPhoneExt] = @ProcessorPhoneExt,
  [ProcessorFax] = @ProcessorFax,
  [ProcessorEmail] = @ProcessorEmail,
  [DefOfficeCode] = @DefOfficeCode,
  [WebUserID] = @WebUserID,
  [DocumentPublish] = @DocumentPublish  
 WHERE
  [clientcode] = @clientcode


 SET @Err = @@Error


 RETURN @Err
END
GO

update tblControl set DBVersion='1.03'
GO
