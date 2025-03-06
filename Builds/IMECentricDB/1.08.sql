-- Update Database to ver. 1.08. Generated on 5/6/2010

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwBMCCaseExport]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW [vwBMCCaseExport];
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBMCBillingHistoryExport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spBMCBillingHistoryExport]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBMCNetProfitExport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spBMCNetProfitExport]

GO

CREATE VIEW [dbo].[vwBMCCaseExport]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCompany.intname AS Company, dbo.tblCompany.addr1 AS Address, dbo.tblCompany.city, dbo.tblCompany.state, 
                      dbo.tblCompany.zip, dbo.tblExaminee.lastname, dbo.tblExaminee.firstname, dbo.tblQueues.statusdesc AS Status, 
                      dbo.tblSpecialty.description AS Specialty, dbo.tblServices.description AS Service, dbo.tblCase.dateadded AS IntakeDate, 
                      dbo.tblCase.ApptDate AS ServiceDate, dbo.tblCase.invoiceamt,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory
                            WHERE      (casenbr = dbo.tblCase.casenbr) AND (type = 'FinalRpt')
                            ORDER BY eventdate DESC) AS ReportDate, dbo.tblCase.DoctorName, dbo.tblCompany.companycode, 
                      dbo.tblClient.lastname + ',' + dbo.tblClient.firstname AS clientname, dbo.tblCase.claimnbr
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode


GO



CREATE PROCEDURE [dbo].[spBMCBillingHistoryExport](@mastercasenbr int)
AS SELECT     dbo.tblCase.casenbr, dbo.tblQueues.statusdesc, dbo.tblCase.status, dbo.tblCase.ApptDate, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname AS doctorname, 
                      dbo.tblCompany.intname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.marketercode, dbo.tblCase.clientcode, dbo.tblClient.companycode, dbo.tblDoctor.doctorcode, dbo.tblServices.servicecode, 
                      dbo.tblServices.description, dbo.tblCase.officecode, dbo.tblCase.casetype, dbo.tblCaseType.description AS casetypedesc, 
                      dbo.TblAcctHeader.documentdate AS InvoiceDate, dbo.TblAcctHeader.documenttotal AS invoiceAmt, dbo.tblacctheader.documentnbr,
dbo.tblExaminee.firstname, dbo.tblExaminee.lastname
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.TblAcctHeader ON dbo.tblCase.casenbr = dbo.TblAcctHeader.casenbr
WHERE     (dbo.Tblcase.mastercasenbr = @mastercasenbr) AND (dbo.TblAcctHeader.documenttype = 'IN') 
                      AND (dbo.TblAcctHeader.documentstatus = 'Final')
order BY dbo.tblCase.casenbr, dbo.tblacctheader.documentdate



GO


CREATE PROCEDURE [dbo].[spBMCNetProfitExport](@startdate datetime,
@enddate datetime)
AS
SELECT     dbo.tblCase.casenbr, dbo.tblQueues.statusdesc, dbo.tblCase.status, dbo.tblCase.ApptDate, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname AS doctorname, 
                      dbo.tblCompany.intname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.marketercode, dbo.tblCase.clientcode, dbo.tblClient.companycode, dbo.tblDoctor.doctorcode, dbo.tblServices.servicecode, 
                      dbo.tblServices.description, dbo.tblCase.officecode, dbo.tblCase.casetype, dbo.tblCaseType.description AS casetypedesc, 
                      MAX(dbo.TblAcctHeader.documentdate) AS InvoiceDate, SUM(dbo.TblAcctHeader.documenttotal) AS invoiceAmt,
                          (SELECT     SUM(a.documenttotal)
                            FROM          tblacctheader a
                            WHERE      a.documentstatus = 'Final' AND a.documenttype = 'VO' AND a.documentdate >= @startdate AND a.documentdate <= @enddate AND 
                                                   casenbr = tblcase.casenbr
                            GROUP BY a.casenbr) AS voucherAmt,
                          (SELECT     MAX(a.documentdate)
                            FROM          tblacctheader a
                            WHERE      a.documentstatus = 'Final' AND a.documenttype = 'VO' AND a.documentdate >= @startdate AND a.documentdate <= @enddate AND 
                                                   casenbr = tblcase.casenbr
                            GROUP BY a.casenbr) AS voucherdate, dbo.tblExaminee.firstname, dbo.tblExaminee.lastname, dbo.tblcase.claimnbr
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.TblAcctHeader ON dbo.tblCase.casenbr = dbo.TblAcctHeader.casenbr
WHERE     (dbo.TblAcctHeader.documentdate >= @startdate) AND (dbo.TblAcctHeader.documentdate <= @enddate) AND (dbo.TblAcctHeader.documenttype = 'IN') 
                      AND (dbo.TblAcctHeader.documentstatus = 'Final')
GROUP BY dbo.tblCase.casenbr, dbo.tblQueues.statusdesc, dbo.tblCase.status, dbo.tblCase.ApptDate, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname, 
                      dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname, dbo.tblCompany.intname, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname, 
                      dbo.tblCase.voucheramt, dbo.tblCase.voucherdate, dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.marketercode, dbo.tblCase.clientcode, dbo.tblClient.companycode, dbo.tblDoctor.doctorcode, dbo.tblServices.servicecode, 
                      dbo.tblServices.description, dbo.tblCase.officecode, dbo.tblCase.casetype, dbo.tblCaseType.description, dbo.TblAcctHeader.documenttype, 
                      dbo.TblAcctHeader.documentstatus, dbo.tblExaminee.firstname, dbo.tblExaminee.lastname, dbo.tblcase.claimnbr



GO

DROP VIEW [vwDaySheetWithOffice]
GO


CREATE  VIEW [dbo].[vwDaySheetWithOffice]
AS
SELECT     TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                      dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                      dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                      dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                      + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                      dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                      dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, tblcase.officecode, 
                      CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, tblservices.shortdesc, 
                      tblimedata.fax,case when (select top 1 type from tblrecordhistory where type = 'F' and casenbr = dbo.tblcase.casenbr) = 'F' then 'Films' else '' end as films
FROM         dbo.tblLocation INNER JOIN
                      dbo.tblDoctorSchedule INNER JOIN
                      dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                      dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                      dbo.tblCaseType INNER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode INNER JOIN
                      dbo.tblOffice ON dbo.tbloffice.officecode = dbo.tblcase.officecode INNER JOIN
                      dbo.tblIMEData ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode
WHERE     (dbo.tblcase.schedcode IS NOT NULL)

UNION
SELECT     TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                      dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                      dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                      dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                      + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                      dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                      dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                      AS panelnote, tblcase.officecode, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL 
                      END AS scheduledescription, tblservices.shortdesc, tblimedata.fax,case when (select top 1 type from tblrecordhistory where type = 'F' and casenbr = tblcase.casenbr) = 'F' then 'Films' else '' end as films
FROM         dbo.tblCaseType INNER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                      dbo.tblLocation INNER JOIN
                      dbo.tblDoctorSchedule INNER JOIN
                      dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                      dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode INNER JOIN
                      dbo.tblOffice ON dbo.tbloffice.officecode = dbo.tblcase.officecode INNER JOIN
                      dbo.tblIMEData ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode
WHERE     ((dbo.tblDoctorSchedule.status = 'open') OR
                      (dbo.tblDoctorSchedule.status = 'scheduled') OR
                      (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime

GO

DROP VIEW [vwcasetypeservice]
GO


-- filtered vwcasetypeservice to only pickup active services dml 05/04/10

CREATE VIEW [dbo].[vwcasetypeservice]
AS
SELECT     dbo.tblCaseTypeService.casetype, dbo.tblCaseTypeService.servicecode, dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, 
                      dbo.tblServiceOffice.officecode, dbo.tblServices.ServiceType, dbo.tblServices.ShowLegalTabOnCase
FROM         dbo.tblCaseTypeService INNER JOIN
                      dbo.tblServices ON dbo.tblCaseTypeService.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCaseTypeService.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServiceOffice ON dbo.tblCaseTypeService.servicecode = dbo.tblServiceOffice.servicecode AND 
                      dbo.tblCaseTypeService.officecode = dbo.tblServiceOffice.officecode
WHERE     (dbo.tblCaseType.status = 'Active') AND (dbo.tblServices.status = 'Active')

GO

DROP PROCEDURE [proc_Doctor_GetApptCount]
GO


CREATE PROCEDURE [proc_Doctor_GetApptCount]

@DoctorCode varchar(20) = NULL,
@LocationCode varchar(20) = NULL,
@ApptDate varchar(20)

AS

SET NOCOUNT ON
DECLARE @Err int
 
SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule 
INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3 
INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
WHERE tblDoctorSchedule.date = @ApptDate
AND tblDoctorSchedule.DoctorCode = COALESCE(@DoctorCode, tblDoctorSchedule.DoctorCode) 
AND tblDoctorSchedule.LocationCode = COALESCE(@LocationCode, tblDoctorSchedule.LocationCode)  
AND tblDoctorSchedule.status = 'open'
  
SET @Err = @@Error
RETURN @Err


GO

DROP PROCEDURE [proc_GetDoctorLocationsAndSchedule]
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
  INNER JOIN tblDoctorLocation ON tblLocation.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctor ON tblDoctorLocation.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3
  WHERE tblLocation.insidedr = 1
  AND tblDoctor.DoctorCode = COALESCE(@DoctorCode,tblDoctor.DoctorCode) 
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END


GO

DROP PROCEDURE [proc_GetDoctorLocationsAndScheduleWithSpec]
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
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open'
  INNER JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode 
  INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3
  INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
  AND tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.locationcode)
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
  AND tblDoctor.publishonweb = 1

 SET @Err = @@Error

 RETURN @Err
END


GO

DROP PROCEDURE [proc_ValidateUserNew]
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
  ISNULL(tblClient.DefOfficeCode,0) AS DefOfficeCode,
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

DROP PROCEDURE [proc_GetFirstAvailApptByLocation]
GO


CREATE PROCEDURE [proc_GetFirstAvailApptByLocation]

@LocationCode int

AS

SELECT top 1 CONVERT(VARCHAR(10), date, 110) + ' ' + CONVERT(VARCHAR(5), starttime, 114) startime 
 FROM tblDoctorSchedule 
 INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3 
 INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
 INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
 INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
 WHERE date >= getdate() 
 AND tblDoctorSchedule.LocationCode = @LocationCode  
 AND tblDoctorSchedule.status = 'open' 
 ORDER BY date, starttime


GO

DROP PROCEDURE [proc_GetFirstAvailApptByDoctor]
GO


CREATE PROCEDURE [proc_GetFirstAvailApptByDoctor]

@DoctorCode int

AS

SELECT top 1 CONVERT(VARCHAR(10), date, 110) + ' ' + CONVERT(VARCHAR(5), starttime, 114) startime 
 FROM tblDoctorSchedule 
 INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3 
 INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
 INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
 INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
 WHERE date >= getdate() 
 AND tblDoctorSchedule.doctorcode = @DoctorCode  
 AND tblDoctorSchedule.status = 'open' 
 ORDER BY date, starttime



GO


update tblControl set DBVersion='1.08'
GO