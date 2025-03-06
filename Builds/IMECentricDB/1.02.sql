-- Update Database to ver. 1.02. Generated on 4/17/2010
-- ## TargetDB: MSSQL2005; Delimiter: "GO";

CREATE TABLE [tblScanSetting] (
  [ScanSettingID] INTEGER IDENTITY(1,1) NOT NULL,
  [SettingName] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DataSource] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [HideUI] INTEGER DEFAULT ((1)) NOT NULL,
  [FileAppend] INTEGER DEFAULT ((0)) NOT NULL,
  [Feeder] INTEGER DEFAULT ((1)) NOT NULL,
  [PixelType] INTEGER DEFAULT ((0)) NOT NULL,
  [Resolution] INTEGER DEFAULT ((200)) NOT NULL,
  [AutoDeskew] INTEGER DEFAULT ((0)) NOT NULL,
  [BlankPageMode] INTEGER DEFAULT ((0)) NOT NULL,
  CONSTRAINT [PK_tblScanSetting] PRIMARY KEY CLUSTERED ([ScanSettingID])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_tblScanSetting] ON [tblScanSetting]([SettingName])
GO

CREATE TABLE [tblScanSettingWorkstation] (
  [WorkstationName] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [ScanSettingID] INTEGER NOT NULL,
  CONSTRAINT [PK_tblScanSettingWorkstation] PRIMARY KEY CLUSTERED ([WorkstationName],[ScanSettingID])
)
GO


ALTER TABLE [tblCaseDocuments]
  ADD [Source] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER TABLE [tblCaseDocuments]
  ADD [FileSize] BIGINT
GO

ALTER TABLE [tblCaseDocuments]
  ADD [Pages] INTEGER
GO


ALTER TABLE [tblLocation]
  ADD [ExtName] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

DROP VIEW [vwAcctingSummaryWithSecurity]
GO


---------------------------------------------------------------------------------
--Include Report Status in Accounting Summary View to be shown on Tracker screen
---------------------------------------------------------------------------------


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

DROP VIEW [vwapptlogbyappt]
GO


CREATE VIEW dbo.vwapptlogbyappt
AS
SELECT     TOP 100 PERCENT dbo.tblCase.ApptDate, dbo.tblCaseType.ShortDesc AS [Case Type], dbo.tblCase.DoctorName AS Doctor, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS client, dbo.tblCompany.intname AS Company, dbo.tblCase.doctorlocation, 
                      dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee, dbo.tblCase.marketercode, 
                      dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, dbo.tblCase.clientcode, 
                      dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone, 
                      dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description AS OfficeName, GETDATE() AS today, 
                      dbo.tblCase.QARep AS QARepcode, dbo.tblCase.HearingDate, dbo.tblCase.casetype, dbo.tblCase.PanelNbr, dbo.tblCase.mastersubcase,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = tblcase.casenbr AND type = 'Reschedule'
                            ORDER BY eventdate DESC) AS LastRescheduled, dbo.tblDoctor.ProvTypeCode, dbo.tblDoctor.phone AS DoctorPhone, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName, dbo.tblCase.ExternalDueDate, dbo.tblCase.InternalDueDate
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
WHERE     (dbo.tblCase.status <> 9)
GROUP BY dbo.tblCase.ApptDate, dbo.tblCaseType.ShortDesc, dbo.tblCase.DoctorName, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname, 
                      dbo.tblCompany.intname, dbo.tblCase.doctorlocation, dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname, 
                      dbo.tblCase.marketercode, dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, 
                      dbo.tblCase.clientcode, dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, 
                      ''), dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description, dbo.tblCase.QARep, 
                      dbo.tblCase.HearingDate, dbo.tblCase.casetype, dbo.tblCase.PanelNbr, dbo.tblCase.mastersubcase, dbo.tblDoctor.ProvTypeCode, 
                      dbo.tblDoctor.phone, dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname, dbo.tblCase.ExternalDueDate, dbo.tblCase.InternalDueDate


GO

DROP VIEW [vwapptlogbyapptDocs]
GO


CREATE VIEW dbo.vwapptlogbyapptDocs
AS
SELECT     TOP 100 PERCENT dbo.tblCase.ApptDate, dbo.tblCaseType.shortdesc AS [Case Type], tblcase.doctorname AS Doctor, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS client, dbo.tblCompany.intname AS Company, dbo.tblCase.doctorlocation, 
                      dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee, dbo.tblCase.marketercode, 
                      dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, dbo.tblCase.clientcode, 
                      dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone, 
                      dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description AS OfficeName, GETDATE() AS today, 
                      dbo.tblCase.QARep AS QARepcode, dbo.tblCase.HearingDate, dbo.tblCase.casetype, dbo.tblcase.panelnbr, dbo.tblcase.mastersubcase,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = tblcase.casenbr AND type = 'Reschedule'
                            ORDER BY eventdate DESC) AS LastRescheduled, dbo.tbldoctor.provtypecode, dbo.tblDoctor.phone AS DoctorPhone, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName, tblcase.externalduedate, tblcase.internalduedate
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
WHERE     (dbo.tblCase.status <> 9)
GROUP BY dbo.tblCase.ApptDate, dbo.tblCaseType.shortdesc, tblcase.doctorname, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname, 
                      dbo.tblCompany.intname, dbo.tblCase.doctorlocation, dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname, 
                      dbo.tblCase.marketercode, dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, 
                      dbo.tblCase.clientcode, dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, 
                      ''), dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description, dbo.tblCase.QARep, 
                      dbo.tblCase.HearingDate, dbo.tblCase.casetype, dbo.tblcase.panelnbr, dbo.tblcase.mastersubcase, dbo.tbldoctor.provtypecode, dbo.tblDoctor.phone, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname, tblcase.externalduedate, tblcase.internalduedate
UNION
SELECT     TOP 100 PERCENT dbo.tblCase.ApptDate, dbo.tblCaseType.shortdesc AS [Case Type], tblcase.doctorname AS Doctor, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS client, dbo.tblCompany.intname AS Company, dbo.tblCase.doctorlocation, 
                      dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee, dbo.tblCase.marketercode, 
                      dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, dbo.tblCase.clientcode, 
                      dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone, 
                      dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description AS OfficeName, GETDATE() AS today, 
                      dbo.tblCase.QARep AS QARepcode, dbo.tblCase.HearingDate, dbo.tblCase.casetype, tblcase.panelnbr, dbo.tblcase.mastersubcase,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = tblcase.casenbr AND type = 'Reschedule'
                            ORDER BY eventdate DESC) AS LastRescheduled, dbo.tbldoctor.provtypecode, dbo.tblDoctor.phone AS DoctorPhone, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName, tblcase.externalduedate, tblcase.internalduedate
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode INNER JOIN
                      dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr INNER JOIN
                      dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
WHERE     (dbo.tblCase.status <> 9)
GROUP BY dbo.tblCase.ApptDate, dbo.tblCaseType.shortdesc, tblcase.doctorname, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname, 
                      dbo.tblCompany.intname, dbo.tblCase.doctorlocation, dbo.tblLocation.location, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname, 
                      dbo.tblCase.marketercode, dbo.tblCase.schedulercode, dbo.tblExaminee.SSN, dbo.tblQueues.statusdesc, dbo.tblDoctor.doctorcode, 
                      dbo.tblCase.clientcode, dbo.tblCompany.companycode, dbo.tblCase.dateadded, ISNULL(dbo.tblClient.phone1, '') + ' ' + ISNULL(dbo.tblClient.phone1ext, 
                      ''), dbo.tblCase.Appttime, dbo.tblCase.casenbr, dbo.tblCase.priority, dbo.tblCase.commitdate, dbo.tblCase.status, dbo.tblCase.servicecode, 
                      dbo.tblServices.shortdesc, dbo.tblSpecialty.description, dbo.tblCase.officecode, dbo.tblOffice.description, dbo.tblCase.QARep, 
                      dbo.tblCase.HearingDate, dbo.tblCase.casetype, dbo.tblCase.panelnbr, dbo.tblcase.mastersubcase, dbo.tbldoctor.provtypecode, dbo.tblDoctor.phone, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname, tblcase.externalduedate, tblcase.internalduedate


GO

DROP VIEW [vwDocumentAccting]
GO



CREATE VIEW [dbo].[vwDocumentAccting]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.claimnbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblExaminee.SSN, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.extname AS company, dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext,
                       ' ') AS clientphone, dbo.tblLocation.addr1 AS doctoraddr1, dbo.tblLocation.addr2 AS doctoraddr2, 
                      dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, 
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



CREATE VIEW [dbo].[vwdocument]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.claimnbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblExaminee.SSN, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.extname AS company, dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext,
                       ' ') AS clientphone, dbo.tblLocation.addr1 AS doctoraddr1, dbo.tblLocation.addr2 AS doctoraddr2, 
                      dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, dbo.tblCase.ApptDate, dbo.tblCase.Appttime, 
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
                      dbo.tblCase.Jurisdiction AS JurisdictionCode, dbo.tblCase.LegalEvent, dbo.tblCase.PILegalEvent, dbo.tblCase.transcode, dbo.tblTranscription.transcompany, 
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
                      dbo.tblTranscription.transcode = dbo.tblCase.transcode LEFT OUTER JOIN
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

DROP PROCEDURE [spCaseDocuments]
GO



CREATE PROCEDURE [dbo].[spCaseDocuments](@casenbr integer)
AS
 SELECT casenbr, document, type, description, sfilename, dateadded, useridadded, PublishOnWeb, dateedited,
  useridedited, seqno, PublishedTo
 FROM dbo.tblCaseDocuments
 WHERE (casenbr = @casenbr) AND (type <> 'Report')
 ORDER BY dateadded DESC


GO