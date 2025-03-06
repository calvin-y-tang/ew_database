
---------------------------------------------
--New codes needed for Ricwel Brickstreet EDI
---------------------------------------------
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','CommericalID','20290511300')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','UPIN','1069475')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','Mode','T')
GO

---------------------------------------------
--Added internal case number to Liberty Export
---------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwLibertyExport]
AS
SELECT     dbo.tblCase.DateReceived, dbo.tblCase.claimnbr, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS ExamineeName, 
                      dbo.tblClient.lastname + '. ' + dbo.tblClient.firstname AS ClientName, dbo.tblCase.Jurisdiction, dbo.tblAcctHeader.apptdate, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS Doctorname, dbo.tblSpecialty.description AS Specialty, dbo.tblAcctHeader.documenttotal AS Charge, 
                      dbo.tblAcctHeader.documentnbr, dbo.tblAcctHeader.documenttype, dbo.tblCompany.extname AS Company, dbo.tblCase.sinternalcasenbr AS InternalCaseNbr,
                          (SELECT     TOP (1) CPTcode
                            FROM          dbo.tblAcctDetail
                            WHERE      (documentnbr = dbo.tblAcctHeader.documentnbr) AND (documenttype = dbo.tblAcctHeader.documenttype)
                            ORDER BY linenbr) AS CPTCode,
                          (SELECT     TOP (1) modifier
                            FROM          dbo.tblAcctDetail AS TblAcctDetail_1
                            WHERE      (documentnbr = dbo.tblAcctHeader.documentnbr) AND (documenttype = dbo.tblAcctHeader.documenttype)
                            ORDER BY linenbr) AS CPTModifier,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory
                            WHERE      (casenbr = dbo.tblCase.casenbr)
                            ORDER BY eventdate DESC) AS DateFinalized, dbo.tblAcctHeader.documentdate, dbo.tblAcctHeader.documentstatus, dbo.tblAcctHeader.casenbr, 
                      dbo.tblCase.servicecode, dbo.tblServices.description AS Service, dbo.tblCaseType.ShortDesc AS CaseType, dbo.tblClient.usdvarchar2 AS Market, 
                      dbo.tblCase.usdvarchar1 AS RequestedAs, dbo.tblCase.usdint1 AS ReferralNbr
FROM         dbo.tblCase INNER JOIN
                      dbo.tblAcctHeader ON dbo.tblCase.casenbr = dbo.tblAcctHeader.casenbr INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode
WHERE     (dbo.tblAcctHeader.documenttype = 'IN') AND (dbo.tblAcctHeader.documentstatus = 'Final')
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--------------------------------------------------------------------------------------
--Web Portal Changes for Ricwel by Gary
--------------------------------------------------------------------------------------

CREATE TABLE [dbo].[tblRelatedParty](
	[rpcode] [int] IDENTITY(1,1) NOT NULL,
	[rptype] [varchar](50) NULL,
	[prefix] [varchar](5) NULL,
	[lastname] [varchar](50) NULL,
	[firstname] [varchar](50) NULL,
	[companyname] [varchar](70) NULL,
	[address1] [varchar](50) NULL,
	[address2] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](2) NULL,
	[zip] [varchar](15) NULL,
	[phone] [varchar](15) NULL,
	[phoneextension] [varchar](15) NULL,
	[fax] [varchar](15) NULL,
	[email] [varchar](70) NULL,
	[status] [varchar](10) NULL,
	[useridadded] [varchar](15) NULL,
	[dateadded] [datetime] NULL,
	[useridedited] [varchar](15) NULL,
	[dateedited] [datetime] NULL,
	[country] [varchar](50) NULL
 CONSTRAINT [PK_RelatedParty] PRIMARY KEY CLUSTERED 
(
	[rpcode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tblCaseRelatedParty]
(
	[CaseRPID] [int] NOT NULL IDENTITY(1, 1),
	[CaseNbr] [int] NULL,
	[RPCode] [int] NULL,
	[CompanyCode] [int] NULL
) ON [PRIMARY]

GO


/****** Object:  StoredProcedure [proc_CaseHistory_LoadByCaseNbrAndWebUserID]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_CaseHistory_LoadByCaseNbrAndWebUserID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID];
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


/****** Object:  StoredProcedure [proc_CaseICD9_Delete]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICD9_Delete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseICD9_Delete];
GO

CREATE PROCEDURE [proc_CaseICD9_Delete]
(
 @casenbr int,
 @ICD9Code varchar(10)
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCaseICD9]
 WHERE
  [casenbr] = @casenbr AND
  [ICD9Code] = @ICD9Code
 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseICD9_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICD9_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseICD9_Insert];
GO

CREATE PROCEDURE [proc_CaseICD9_Insert]
(
 @seqno int = NULL output,
 @casenbr int,
 @ICD9Code varchar(10) = NULL,
 @Status varchar(50) = NULL,
 @Description varchar(200) = NULL,
 @DateAdded datetime = NULL,
 @UserIDAdded varchar(15) = NULL,
 @DateEdited datetime = NULL,
 @UserIDEdited varchar(15) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseICD9]
 (
  [casenbr], 
  [ICD9Code], 
  [Status],
  [Description], 
  [DateAdded], 
  [UserIDAdded], 
  [DateEdited], 
  [UserIDEdited]
 )
 VALUES
 (
  @casenbr, 
  @ICD9Code, 
  @Status,
  @Description, 
  @DateAdded, 
  @UserIDAdded, 
  @DateEdited, 
  @UserIDEdited
 )

 SET @Err = @@Error

 SELECT @seqno = SCOPE_IDENTITY()

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseICD9_LoadAll]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICD9_LoadAll]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseICD9_LoadAll];
GO

CREATE PROCEDURE [proc_CaseICD9_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseICD9]


 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseICD9_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICD9_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseICD9_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_CaseICD9_LoadByPrimaryKey]
(
 @casenbr int,
 @ICD9Code varchar(10)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseICD9]
 WHERE
  ([casenbr] = @casenbr) AND
  ([ICD9Code] = @ICD9Code)

 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseRelatedParty_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseRelatedParty_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseRelatedParty_Insert];
GO

CREATE PROCEDURE [proc_CaseRelatedParty_Insert]
(
 @CaseRPID int = NULL output,
 @CaseNbr int,
 @RPCode int,
 @CompanyCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCaseRelatedParty]
 (
  [CaseNbr], 
  [RPCode], 
  [CompanyCode]
 )
 VALUES
 (
  @CaseNbr, 
  @RPCode, 
  @CompanyCode
 )

 SET @Err = @@Error

 SELECT @CaseRPID = SCOPE_IDENTITY()

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseRelatedParty_LoadAll]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseRelatedParty_LoadAll]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseRelatedParty_LoadAll];
GO

CREATE PROCEDURE [proc_CaseRelatedParty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseRelatedParty]

 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_CaseRelatedParty_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseRelatedParty_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseRelatedParty_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_CaseRelatedParty_LoadByPrimaryKey]
(
 @CaseNbr int,
 @RPCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseRelatedParty]
 WHERE
  ([CaseNbr] = @CaseNbr)
 AND
  ([RPCode] = @RPCode)

 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_ExamineeCheckForDupe]    Script Date: 2/27/2008 11:16:39 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_ExamineeCheckForDupe]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_ExamineeCheckForDupe];
GO

CREATE PROCEDURE [proc_ExamineeCheckForDupe]

@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone1 varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int


SELECT TOP 1 chartnbr FROM tblExaminee WHERE chartnbr > 0 
 AND FirstName = COALESCE(@FirstName,FirstName) 
 AND LastName = COALESCE(@LastName,LastName) 
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE( REPLACE( REPLACE( REPLACE( REPLACE(@Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone1) 
 ORDER BY chartnbr
 
SET @Err = @@Error
RETURN @Err

GO


/****** Object:  StoredProcedure [proc_getActiveCases]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_getActiveCases]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_getActiveCases];
GO

CREATE PROCEDURE [proc_getActiveCases]
@WebUserID int

AS 

SELECT DISTINCT
 COUNT(DISTINCT CaseNbr) AS NbrofCases, 
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


/****** Object:  StoredProcedure [proc_GetCaseICD9sByCase]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetCaseICD9sByCase]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetCaseICD9sByCase];
GO

CREATE PROCEDURE [proc_GetCaseICD9sByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseICD9 

 WHERE casenbr = @CaseNbr

GO


/****** Object:  StoredProcedure [proc_GetReferralSearch]    Script Date: 2/27/2008 11:16:39 AM ******/
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


/****** Object:  StoredProcedure [proc_IMECase_DeleteComplete]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_DeleteComplete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_DeleteComplete];
GO

CREATE PROCEDURE [proc_IMECase_DeleteComplete]
(
 @casenbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

  --Delete publishonweb records
  DELETE FROM tblPublishOnWeb WHERE TableKey = @CaseNbr
  DELETE FROM tblPublishOnWeb WHERE TableKey IN (SELECT id FROM tblCaseHistory WHERE CaseNbr = @CaseNbr)
  DELETE FROM tblPublishOnWeb WHERE TableKey IN (SELECT seqno FROM tblCaseDocuments WHERE CaseNbr = @CaseNbr)

  --Delete casehistory records
  DELETE FROM tblCaseHistory WHERE CaseNbr = @CaseNbr

  --Delete casedocument records
  DELETE FROM tblCaseDocuments WHERE CaseNbr = @CaseNbr

  --Delete CaseIssue records
  DELETE FROM tblCaseIssue WHERE CaseNbr = @CaseNbr

  --Delete CaseProblem records
  DELETE FROM tblCaseProblem WHERE CaseNbr = @CaseNbr

  --Delete case record
  DELETE FROM tblCase WHERE CaseNbr = @CaseNbr

 SET @Err = @@Error

 RETURN @Err
END
GO

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

GO


/****** Object:  StoredProcedure [proc_RelatedPartyCheckForDupe]    Script Date: 2/27/2008 11:16:39 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedPartyCheckForDupe]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedPartyCheckForDupe];
GO

CREATE PROCEDURE [proc_RelatedPartyCheckForDupe]

@CompanyName varchar(100) = NULL,
@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

SELECT TOP 1 rpcode FROM tblRelatedParty WHERE rpcode > 0 
 AND CompanyName LIKE '%' + COALESCE(@CompanyName,CompanyName) + '%'
 AND FirstName LIKE '%' +  COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' +  COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone)
 ORDER BY rpcode
 
SET @Err = @@Error
RETURN @Err
 

GO


/****** Object:  StoredProcedure [proc_RelatedParty_Delete]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedParty_Delete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedParty_Delete];
GO

CREATE PROCEDURE [proc_RelatedParty_Delete]
(
 @rpcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblRelatedParty]
 WHERE
  [rpcode] = @rpcode
 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_RelatedParty_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedParty_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedParty_Insert];
GO

CREATE PROCEDURE [proc_RelatedParty_Insert]
(
 @rpcode int = NULL output,
 @prefix varchar(5) = NULL,
 @rptype varchar(50) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @companyname varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @country varchar(50) = NULL,
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
 INTO [tblRelatedParty]
 (
  [prefix],
  [lastname],
  [rptype],
  [firstname],
  [companyname],
  [address1],
  [address2],
  [city],
  [state],
  [zip],
  [country],
  [phone],
  [phoneextension],
  [fax],
  [email],
  [status],
  [useridadded],
  [dateadded],
  [useridedited],
  [dateedited]
 )
 VALUES
 (
  @prefix,
  @lastname,
  @rptype,
  @firstname,
  @companyname,
  @address1,
  @address2,
  @city,
  @state,
  @zip,
  @country,
  @phone,
  @phoneextension,
  @fax,
  @email,
  @status,
  @useridadded,
  @dateadded,
  @useridedited,
  @dateedited
 )

 SET @Err = @@Error

 SELECT @rpcode = SCOPE_IDENTITY()

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_RelatedParty_LoadAll]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedParty_LoadAll]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedParty_LoadAll];
GO

CREATE PROCEDURE [proc_RelatedParty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblRelatedParty]


 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_RelatedParty_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedParty_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedParty_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_RelatedParty_LoadByPrimaryKey]
(
 @rpcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblRelatedParty]
 WHERE
  ([rpcode] = @rpcode)

 SET @Err = @@Error

 RETURN @Err
END
GO

GO


/****** Object:  StoredProcedure [proc_RelatedParty_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_RelatedParty_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_RelatedParty_Update];
GO

CREATE PROCEDURE [proc_RelatedParty_Update]
(
 @rpcode int,
 @prefix varchar(5) = NULL,
 @lastname varchar(50) = NULL,
 @rptype varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @companyname varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @country varchar(50) = NULL,
 @phone varchar(15) = NULL,
 @phoneextension varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @status varchar(10) = NULL,
 @useridadded varchar(15) = NULL,
 @dateadded datetime = NULL,
 @useridedited varchar(15) = NULL,
 @dateedited datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblRelatedParty]
 SET
  [prefix] = @prefix,
  [lastname] = @lastname,
  [rptype] = @rptype,
  [firstname] = @firstname,
  [companyname] = @companyname,
  [address1] = @address1,
  [address2] = @address2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [country] = @country,
  [phone] = @phone,
  [phoneextension] = @phoneextension,
  [fax] = @fax,
  [email] = @email,
  [status] = @status,
  [useridadded] = @useridadded,
  [dateadded] = @dateadded,
  [useridedited] = @useridedited,
  [dateedited] = @dateedited
 WHERE
  [rpcode] = @rpcode


 SET @Err = @@Error


 RETURN @Err
END
GO



update tblControl set DBVersion='1.47'
GO
