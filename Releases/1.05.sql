CREATE TABLE [tblVenue] (
  [VenueID] INTEGER IDENTITY(1,1) NOT NULL,
  [County] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [State] VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS,
  CONSTRAINT [PK_tblVenue] PRIMARY KEY CLUSTERED ([VenueID])
)
GO

CREATE NONCLUSTERED INDEX [IX_tblVenue] ON [tblVenue]([State],[County])
GO


ALTER TABLE [tblCase]
  ADD [VenueID] INTEGER
GO

DROP VIEW [vwdocument]
GO


CREATE VIEW [dbo].[vwdocument]
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
                      dbo.tblCase.Jurisdiction AS JurisdictionCode, dbo.tblCase.LegalEvent, dbo.tblCase.PILegalEvent, dbo.tblCase.transcode, dbo.tblTranscription.transcompany, 
                      dbo.tblCase.DateReceived, dbo.tblCase.usddate3 AS caseusddate3, dbo.tblCase.usddate4 AS caseusddate4, dbo.tblCase.UsdBit1 AS caseusdboolean1, 
                      dbo.tblCase.UsdBit2 AS caseusdboolean2, dbo.tblCase.usddate5 AS caseusddate5, dbo.tblDoctor.usddate3 AS doctorusddate3, 
                      dbo.tblDoctor.usddate4 AS doctorusddate4, dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3, dbo.tblDoctor.usddate5 AS doctorusddate5, 
                      dbo.tblDoctor.usddate6 AS doctorusddate6, dbo.tblDoctor.usddate7 AS doctorusddate7, dbo.tblCase.ClaimNbrExt, dbo.tblCase.sreqspecialty AS RequestedSpecialty, 
                      dbo.tblQueues.statusdesc, dbo.tblCase.AttorneyNote, dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc, dbo.tblCase.ExternalDueDate, 
                      dbo.tblCase.InternalDueDate, dbo.tblLocation.ExtName AS LocationExtName, dbo.tblVenue.County AS Venue, dbo.tblOffice.description AS office, 
                      dbo.tblOffice.usdvarchar1, dbo.tblOffice.usdvarchar2
FROM         dbo.tblTranscription RIGHT OUTER JOIN
                      dbo.tblVenue RIGHT OUTER JOIN
                      dbo.tblOffice INNER JOIN
                      dbo.tblExaminee INNER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode ON dbo.tblOffice.officecode = dbo.tblCase.officecode ON 
                      dbo.tblVenue.VenueID = dbo.tblCase.VenueID LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_3 ON dbo.tblCase.DefParaLegal = tblCCAddress_3.cccode ON 
                      dbo.tblTranscription.transcode = dbo.tblCase.transcode LEFT OUTER JOIN
                      dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                      dbo.tblstate ON dbo.tblCase.Jurisdiction = dbo.tblstate.Statecode LEFT OUTER JOIN
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

DROP VIEW [vw_WebCaseSummary]
GO


CREATE VIEW vw_WebCaseSummary

AS

SELECT     dbo.tblCase.casenbr, dbo.tblCase.chartnbr, dbo.tblCase.doctorlocation, dbo.tblCase.clientcode, dbo.tblCase.Appttime, dbo.tblCase.dateofinjury, 
                      dbo.tblCase.notes, dbo.tblCase.DoctorName, dbo.tblCase.ClaimNbrExt, dbo.tblExaminee.lastname, dbo.tblExaminee.firstname, dbo.tblExaminee.addr1,
                       dbo.tblExaminee.addr2, dbo.tblExaminee.city, dbo.tblExaminee.state, dbo.tblExaminee.zip, dbo.tblExaminee.phone1, dbo.tblExaminee.phone2, 
                      dbo.tblExaminee.SSN, dbo.tblExaminee.sex, dbo.tblExaminee.DOB, dbo.tblExaminee.note, dbo.tblExaminee.county, dbo.tblExaminee.prefix, 
                      dbo.tblExaminee.fax, dbo.tblExaminee.email, dbo.tblExaminee.insured, dbo.tblExaminee.employer, dbo.tblExaminee.treatingphysician, 
                      dbo.tblExaminee.InsuredAddr1, dbo.tblExaminee.InsuredCity, dbo.tblExaminee.InsuredState, dbo.tblExaminee.InsuredZip, 
                      dbo.tblExaminee.InsuredSex, dbo.tblExaminee.InsuredRelationship, dbo.tblExaminee.InsuredPhone, dbo.tblExaminee.InsuredPhoneExt, 
                      dbo.tblExaminee.InsuredFax, dbo.tblExaminee.InsuredEmail, dbo.tblExaminee.ExamineeStatus, dbo.tblExaminee.TreatingPhysicianAddr1, 
                      dbo.tblExaminee.TreatingPhysicianCity, dbo.tblExaminee.TreatingPhysicianState, dbo.tblExaminee.TreatingPhysicianZip, 
                      dbo.tblExaminee.TreatingPhysicianPhone, dbo.tblExaminee.TreatingPhysicianPhoneExt, dbo.tblExaminee.TreatingPhysicianFax, 
                      dbo.tblExaminee.TreatingPhysicianEmail, dbo.tblExaminee.EmployerAddr1, dbo.tblExaminee.EmployerCity, dbo.tblExaminee.EmployerState, 
                      dbo.tblExaminee.EmployerZip, dbo.tblExaminee.EmployerPhone, dbo.tblExaminee.EmployerPhoneExt, dbo.tblExaminee.EmployerFax, 
                      dbo.tblExaminee.EmployerEmail, dbo.tblExaminee.Country, dbo.tblExaminee.policynumber, dbo.tblExaminee.EmployerContactFirstName, 
                      dbo.tblExaminee.EmployerContactLastName, dbo.tblExaminee.TreatingPhysicianLicenseNbr, dbo.tblExaminee.TreatingPhysicianTaxID, 
                      dbo.tblCaseType.code, dbo.tblCaseType.description, dbo.tblCaseType.instructionfilename, dbo.tblCaseType.WebID, 
                      dbo.tblCaseType.ShortDesc, dbo.tblServices.description AS servicedescription, dbo.tblServices.DaysToCommitDate, dbo.tblServices.CalcFrom, 
                      dbo.tblServices.ServiceType, dbo.tblOffice.description AS officedesc, dbo.tblClient.companycode, dbo.tblClient.clientnbrold, 
                      dbo.tblClient.lastname AS clientlname, dbo.tblClient.firstname AS clientfname, cc1.cccode, cc1.lastname AS defattlastname, 
                      cc1.firstname AS defattfirstname, cc1.company AS defattcompany, cc2.lastname AS plaintattlastname, cc2.firstname AS plaintattfirstname, 
                      cc2.company AS plaintattcompany, cc2.address1 AS plaintattadd1, cc2.address2 AS plaintattadd2, cc2.city AS plaintattcity, cc2.state AS plaintattstate, 
                      cc2.zip AS plaintattzip, cc2.phone AS plaintattphone, cc2.phoneextension AS plaintattphonext, cc2.fax AS plaintattfax, cc2.email AS plaintattemail, 
                      cc2.prefix AS plaintattprefix, cc1.address1 AS defattadd1, cc1.address2 AS defattadd2, cc1.city AS defattcity, cc1.state AS defattstate, 
                      cc1.zip AS defattzip, cc1.phone AS defattphone, cc1.phoneextension AS defattphonext, cc1.fax AS defattfax, cc1.email AS defattemail, 
                      cc1.prefix AS defattprefix, dbo.tblCase.ApptDate, dbo.tblCase.claimnbr, dbo.tblCase.WCBNbr, dbo.tblCase.specialinstructions, 
                      dbo.tblCase.HearingDate, dbo.tblCase.requesteddoc, dbo.tblCase.sreqspecialty, dbo.tblCase.schedulenotes
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode LEFT OUTER JOIN
                      dbo.tblCCAddress AS cc1 ON dbo.tblCase.defenseattorneycode = cc1.cccode LEFT OUTER JOIN
                      dbo.tblCCAddress AS cc2 ON dbo.tblCase.plaintiffattorneycode = cc2.cccode


GO

DROP PROCEDURE [proc_IMECase_Insert]
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
  @BillingNote
 )

 SET @Err = @@Error

 SELECT @casenbr = SCOPE_IDENTITY()

 RETURN @Err
END

GO

DROP PROCEDURE [proc_IMECase_Update]
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
  [BillingNote] = @BillingNote
 WHERE
  [casenbr] = @casenbr


 SET @Err = @@Error


 RETURN @Err
END

GO


SET IDENTITY_INSERT dbo.tblVenue ON

INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1,'Aleutians East','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2,'Aleutians West','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3,'Anchorage','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(4,'Bethel','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(5,'Bristol Bay','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(6,'Denali','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(7,'Dillingham','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(8,'Fairbanks North Star','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(9,'Haines','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(10,'Juneau','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(11,'Kenai Peninsula','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(12,'Ketchikan Gateway','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(13,'Kodiak Island','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(14,'Lake and Peninsula','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(15,'Matanuska Susitna','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(16,'Nome','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(17,'North Slope','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(18,'Northwest Arctic','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(19,'Prince Wales Ketchikan','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(20,'Sitka','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(21,'Skagway Hoonah Angoon','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(22,'Southeast Fairbanks','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(23,'Valdez Cordova','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(24,'Wade Hampton','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(25,'Wrangell Petersburg','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(26,'Yakutat','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(27,'Yukon Koyukuk','AK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(28,'Autauga','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(29,'Baldwin','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(30,'Barbour','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(31,'Bibb','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(32,'Blount','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(33,'Bullock','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(34,'Butler','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(35,'Calhoun','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(36,'Chambers','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(37,'Cherokee','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(38,'Chilton','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(39,'Choctaw','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(40,'Clarke','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(41,'Clay','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(42,'Cleburne','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(43,'Coffee','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(44,'Colbert','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(45,'Conecuh','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(46,'Coosa','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(47,'Covington','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(48,'Crenshaw','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(49,'Cullman','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(50,'Dale','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(51,'Dallas','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(52,'De Kalb','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(53,'Elmore','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(54,'Escambia','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(55,'Etowah','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(56,'Fayette','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(57,'Franklin','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(58,'Geneva','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(59,'Greene','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(60,'Hale','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(61,'Henry','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(62,'Houston','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(63,'Jackson','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(64,'Jefferson','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(65,'Lamar','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(66,'Lauderdale','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(67,'Lawrence','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(68,'Lee','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(69,'Limestone','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(70,'Lowndes','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(71,'Macon','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(72,'Madison','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(73,'Marengo','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(74,'Marion','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(75,'Marshall','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(76,'Mobile','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(77,'Monroe','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(78,'Montgomery','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(79,'Morgan','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(80,'Perry','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(81,'Pickens','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(82,'Pike','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(83,'Randolph','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(84,'Russell','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(85,'Saint Clair','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(86,'Shelby','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(87,'Sumter','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(88,'Talladega','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(89,'Tallapoosa','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(90,'Tuscaloosa','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(91,'Walker','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(92,'Washington','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(93,'Wilcox','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(94,'Winston','AL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(95,'Arkansas','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(96,'Ashley','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(97,'Baxter','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(98,'Benton','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(99,'Boone','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(100,'Bradley','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(101,'Calhoun','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(102,'Carroll','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(103,'Chicot','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(104,'Clark','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(105,'Clay','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(106,'Cleburne','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(107,'Cleveland','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(108,'Columbia','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(109,'Conway','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(110,'Craighead','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(111,'Crawford','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(112,'Crittenden','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(113,'Cross','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(114,'Dallas','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(115,'Desha','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(116,'Drew','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(117,'Faulkner','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(118,'Franklin','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(119,'Fulton','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(120,'Garland','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(121,'Grant','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(122,'Greene','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(123,'Hempstead','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(124,'Hot Spring','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(125,'Howard','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(126,'Independence','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(127,'Izard','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(128,'Jackson','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(129,'Jefferson','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(130,'Johnson','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(131,'Lafayette','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(132,'Lawrence','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(133,'Lee','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(134,'Lincoln','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(135,'Little River','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(136,'Logan','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(137,'Lonoke','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(138,'Madison','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(139,'Marion','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(140,'Miller','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(141,'Mississippi','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(142,'Monroe','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(143,'Montgomery','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(144,'Nevada','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(145,'Newton','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(146,'Ouachita','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(147,'Perry','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(148,'Phillips','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(149,'Pike','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(150,'Poinsett','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(151,'Polk','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(152,'Pope','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(153,'Prairie','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(154,'Pulaski','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(155,'Randolph','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(156,'Saint Francis','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(157,'Saline','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(158,'Scott','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(159,'Searcy','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(160,'Sebastian','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(161,'Sevier','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(162,'Sharp','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(163,'Stone','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(164,'Union','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(165,'Van Buren','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(166,'Washington','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(167,'White','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(168,'Woodruff','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(169,'Yell','AR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(170,'American Samoa','AS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(171,'Apache','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(172,'Cochise','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(173,'Coconino','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(174,'Gila','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(175,'Graham','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(176,'Greenlee','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(177,'La Paz','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(178,'Maricopa','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(179,'Mohave','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(180,'Navajo','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(181,'Pima','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(182,'Pinal','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(183,'Santa Cruz','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(184,'Yavapai','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(185,'Yuma','AZ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(186,'Alameda','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(187,'Alpine','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(188,'Amador','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(189,'Butte','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(190,'Calaveras','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(191,'Colusa','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(192,'Contra Costa','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(193,'Del Norte','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(194,'El Dorado','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(195,'Fresno','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(196,'Glenn','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(197,'Humboldt','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(198,'Imperial','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(199,'Inyo','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(200,'Kern','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(201,'Kings','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(202,'Lake','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(203,'Lassen','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(204,'Los Angeles','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(205,'Madera','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(206,'Marin','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(207,'Mariposa','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(208,'Mendocino','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(209,'Merced','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(210,'Modoc','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(211,'Mono','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(212,'Monterey','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(213,'Napa','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(214,'Nevada','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(215,'Orange','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(216,'Placer','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(217,'Plumas','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(218,'Riverside','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(219,'Sacramento','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(220,'San Benito','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(221,'San Bernardino','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(222,'San Diego','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(223,'San Francisco','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(224,'San Joaquin','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(225,'San Luis Obispo','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(226,'San Mateo','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(227,'Santa Barbara','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(228,'Santa Clara','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(229,'Santa Cruz','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(230,'Shasta','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(231,'Sierra','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(232,'Siskiyou','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(233,'Solano','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(234,'Sonoma','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(235,'Stanislaus','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(236,'Sutter','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(237,'Tehama','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(238,'Trinity','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(239,'Tulare','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(240,'Tuolumne','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(241,'Ventura','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(242,'Yolo','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(243,'Yuba','CA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(244,'Adams','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(245,'Alamosa','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(246,'Arapahoe','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(247,'Archuleta','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(248,'Baca','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(249,'Bent','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(250,'Boulder','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(251,'Broomfield','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(252,'Chaffee','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(253,'Cheyenne','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(254,'Clear Creek','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(255,'Conejos','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(256,'Costilla','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(257,'Crowley','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(258,'Custer','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(259,'Delta','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(260,'Denver','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(261,'Dolores','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(262,'Douglas','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(263,'Eagle','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(264,'El Paso','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(265,'Elbert','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(266,'Fremont','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(267,'Garfield','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(268,'Gilpin','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(269,'Grand','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(270,'Gunnison','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(271,'Hinsdale','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(272,'Huerfano','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(273,'Jackson','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(274,'Jefferson','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(275,'Kiowa','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(276,'Kit Carson','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(277,'La Plata','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(278,'Lake','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(279,'Larimer','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(280,'Las Animas','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(281,'Lincoln','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(282,'Logan','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(283,'Mesa','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(284,'Mineral','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(285,'Moffat','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(286,'Montezuma','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(287,'Montrose','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(288,'Morgan','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(289,'Otero','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(290,'Ouray','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(291,'Park','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(292,'Phillips','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(293,'Pitkin','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(294,'Prowers','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(295,'Pueblo','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(296,'Rio Blanco','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(297,'Rio Grande','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(298,'Routt','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(299,'Saguache','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(300,'San Juan','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(301,'San Miguel','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(302,'Sedgwick','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(303,'Summit','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(304,'Teller','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(305,'Washington','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(306,'Weld','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(307,'Yuma','CO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(308,'Fairfield','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(309,'Hartford','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(310,'Litchfield','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(311,'Middlesex','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(312,'New Haven','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(313,'New London','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(314,'Tolland','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(315,'Windham','CT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(316,'District of Columbia','DC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(317,'Kent','DE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(318,'New Castle','DE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(319,'Sussex','DE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(320,'Alachua','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(321,'Baker','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(322,'Bay','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(323,'Bradford','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(324,'Brevard','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(325,'Broward','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(326,'Calhoun','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(327,'Charlotte','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(328,'Citrus','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(329,'Clay','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(330,'Collier','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(331,'Columbia','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(332,'De Soto','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(333,'Dixie','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(334,'Duval','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(335,'Escambia','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(336,'Flagler','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(337,'Franklin','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(338,'Gadsden','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(339,'Gilchrist','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(340,'Glades','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(341,'Gulf','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(342,'Hamilton','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(343,'Hardee','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(344,'Hendry','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(345,'Hernando','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(346,'Highlands','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(347,'Hillsborough','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(348,'Holmes','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(349,'Indian River','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(350,'Jackson','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(351,'Jefferson','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(352,'Lafayette','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(353,'Lake','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(354,'Lee','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(355,'Leon','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(356,'Levy','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(357,'Liberty','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(358,'Madison','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(359,'Manatee','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(360,'Marion','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(361,'Martin','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(362,'Miami-Dade','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(363,'Monroe','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(364,'Nassau','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(365,'Okaloosa','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(366,'Okeechobee','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(367,'Orange','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(368,'Osceola','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(369,'Palm Beach','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(370,'Pasco','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(371,'Pinellas','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(372,'Polk','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(373,'Putnam','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(374,'Saint Johns','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(375,'Saint Lucie','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(376,'Santa Rosa','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(377,'Sarasota','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(378,'Seminole','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(379,'Sumter','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(380,'Suwannee','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(381,'Taylor','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(382,'Union','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(383,'Volusia','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(384,'Wakulla','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(385,'Walton','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(386,'Washington','FL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(387,'Federated States of Micro','FM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(388,'Appling','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(389,'Atkinson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(390,'Bacon','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(391,'Baker','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(392,'Baldwin','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(393,'Banks','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(394,'Barrow','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(395,'Bartow','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(396,'Ben Hill','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(397,'Berrien','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(398,'Bibb','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(399,'Bleckley','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(400,'Brantley','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(401,'Brooks','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(402,'Bryan','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(403,'Bulloch','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(404,'Burke','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(405,'Butts','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(406,'Calhoun','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(407,'Camden','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(408,'Candler','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(409,'Carroll','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(410,'Catoosa','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(411,'Charlton','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(412,'Chatham','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(413,'Chattahoochee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(414,'Chattooga','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(415,'Cherokee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(416,'Clarke','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(417,'Clay','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(418,'Clayton','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(419,'Clinch','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(420,'Cobb','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(421,'Coffee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(422,'Colquitt','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(423,'Columbia','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(424,'Cook','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(425,'Coweta','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(426,'Crawford','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(427,'Crisp','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(428,'Dade','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(429,'Dawson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(430,'Decatur','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(431,'Dekalb','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(432,'Dodge','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(433,'Dooly','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(434,'Dougherty','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(435,'Douglas','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(436,'Early','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(437,'Echols','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(438,'Effingham','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(439,'Elbert','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(440,'Emanuel','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(441,'Evans','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(442,'Fannin','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(443,'Fayette','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(444,'Floyd','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(445,'Forsyth','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(446,'Franklin','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(447,'Fulton','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(448,'Gilmer','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(449,'Glascock','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(450,'Glynn','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(451,'Gordon','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(452,'Grady','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(453,'Greene','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(454,'Gwinnett','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(455,'Habersham','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(456,'Hall','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(457,'Hancock','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(458,'Haralson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(459,'Harris','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(460,'Hart','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(461,'Heard','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(462,'Henry','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(463,'Houston','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(464,'Irwin','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(465,'Jackson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(466,'Jasper','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(467,'Jeff Davis','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(468,'Jefferson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(469,'Jenkins','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(470,'Johnson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(471,'Jones','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(472,'Lamar','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(473,'Lanier','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(474,'Laurens','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(475,'Lee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(476,'Liberty','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(477,'Lincoln','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(478,'Long','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(479,'Lowndes','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(480,'Lumpkin','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(481,'Macon','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(482,'Madison','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(483,'Marion','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(484,'McDuffie','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(485,'McIntosh','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(486,'Meriwether','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(487,'Miller','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(488,'Mitchell','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(489,'Monroe','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(490,'Montgomery','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(491,'Morgan','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(492,'Murray','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(493,'Muscogee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(494,'Newton','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(495,'Oconee','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(496,'Oglethorpe','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(497,'Paulding','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(498,'Peach','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(499,'Pickens','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(500,'Pierce','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(501,'Pike','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(502,'Polk','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(503,'Pulaski','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(504,'Putnam','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(505,'Quitman','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(506,'Rabun','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(507,'Randolph','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(508,'Richmond','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(509,'Rockdale','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(510,'Schley','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(511,'Screven','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(512,'Seminole','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(513,'Spalding','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(514,'Stephens','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(515,'Stewart','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(516,'Sumter','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(517,'Talbot','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(518,'Taliaferro','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(519,'Tattnall','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(520,'Taylor','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(521,'Telfair','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(522,'Terrell','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(523,'Thomas','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(524,'Tift','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(525,'Toombs','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(526,'Towns','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(527,'Treutlen','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(528,'Troup','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(529,'Turner','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(530,'Twiggs','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(531,'Union','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(532,'Upson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(533,'Walker','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(534,'Walton','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(535,'Ware','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(536,'Warren','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(537,'Washington','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(538,'Wayne','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(539,'Webster','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(540,'Wheeler','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(541,'White','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(542,'Whitfield','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(543,'Wilcox','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(544,'Wilkes','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(545,'Wilkinson','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(546,'Worth','GA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(547,'Guam','GU')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(548,'Hawaii','HI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(549,'Honolulu','HI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(550,'Kalawao','HI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(551,'Kauai','HI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(552,'Maui','HI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(553,'Adair','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(554,'Adams','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(555,'Allamakee','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(556,'Appanoose','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(557,'Audubon','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(558,'Benton','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(559,'Black Hawk','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(560,'Boone','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(561,'Bremer','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(562,'Buchanan','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(563,'Buena Vista','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(564,'Butler','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(565,'Calhoun','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(566,'Carroll','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(567,'Cass','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(568,'Cedar','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(569,'Cerro Gordo','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(570,'Cherokee','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(571,'Chickasaw','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(572,'Clarke','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(573,'Clay','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(574,'Clayton','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(575,'Clinton','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(576,'Crawford','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(577,'Dallas','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(578,'Davis','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(579,'Decatur','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(580,'Delaware','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(581,'Des Moines','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(582,'Dickinson','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(583,'Dubuque','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(584,'Emmet','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(585,'Fayette','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(586,'Floyd','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(587,'Franklin','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(588,'Fremont','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(589,'Greene','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(590,'Grundy','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(591,'Guthrie','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(592,'Hamilton','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(593,'Hancock','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(594,'Hardin','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(595,'Harrison','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(596,'Henry','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(597,'Howard','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(598,'Humboldt','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(599,'Ida','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(600,'Iowa','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(601,'Jackson','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(602,'Jasper','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(603,'Jefferson','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(604,'Johnson','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(605,'Jones','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(606,'Keokuk','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(607,'Kossuth','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(608,'Lee','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(609,'Linn','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(610,'Louisa','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(611,'Lucas','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(612,'Lyon','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(613,'Madison','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(614,'Mahaska','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(615,'Marion','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(616,'Marshall','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(617,'Mills','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(618,'Mitchell','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(619,'Monona','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(620,'Monroe','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(621,'Montgomery','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(622,'Muscatine','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(623,'Obrien','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(624,'Osceola','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(625,'Page','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(626,'Palo Alto','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(627,'Plymouth','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(628,'Pocahontas','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(629,'Polk','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(630,'Pottawattamie','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(631,'Poweshiek','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(632,'Ringgold','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(633,'Sac','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(634,'Scott','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(635,'Shelby','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(636,'Sioux','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(637,'Story','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(638,'Tama','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(639,'Taylor','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(640,'Union','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(641,'Van Buren','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(642,'Wapello','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(643,'Warren','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(644,'Washington','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(645,'Wayne','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(646,'Webster','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(647,'Winnebago','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(648,'Winneshiek','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(649,'Woodbury','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(650,'Worth','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(651,'Wright','IA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(652,'Ada','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(653,'Adams','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(654,'Bannock','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(655,'Bear Lake','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(656,'Benewah','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(657,'Bingham','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(658,'Blaine','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(659,'Boise','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(660,'Bonner','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(661,'Bonneville','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(662,'Boundary','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(663,'Butte','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(664,'Camas','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(665,'Canyon','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(666,'Caribou','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(667,'Cassia','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(668,'Clark','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(669,'Clearwater','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(670,'Custer','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(671,'Elmore','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(672,'Franklin','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(673,'Fremont','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(674,'Gem','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(675,'Gooding','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(676,'Idaho','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(677,'Jefferson','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(678,'Jerome','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(679,'Kootenai','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(680,'Latah','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(681,'Lemhi','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(682,'Lewis','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(683,'Lincoln','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(684,'Madison','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(685,'Minidoka','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(686,'Nez Perce','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(687,'Oneida','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(688,'Owyhee','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(689,'Payette','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(690,'Power','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(691,'Shoshone','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(692,'Teton','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(693,'Twin Falls','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(694,'Valley','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(695,'Washington','ID')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(696,'Adams','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(697,'Alexander','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(698,'Bond','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(699,'Boone','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(700,'Brown','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(701,'Bureau','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(702,'Calhoun','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(703,'Carroll','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(704,'Cass','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(705,'Champaign','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(706,'Christian','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(707,'Clark','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(708,'Clay','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(709,'Clinton','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(710,'Coles','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(711,'Cook','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(712,'Crawford','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(713,'Cumberland','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(714,'De Kalb','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(715,'Dewitt','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(716,'Douglas','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(717,'Du Page','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(718,'Edgar','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(719,'Edwards','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(720,'Effingham','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(721,'Fayette','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(722,'Ford','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(723,'Franklin','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(724,'Fulton','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(725,'Gallatin','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(726,'Greene','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(727,'Grundy','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(728,'Hamilton','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(729,'Hancock','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(730,'Hardin','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(731,'Henderson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(732,'Henry','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(733,'Iroquois','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(734,'Jackson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(735,'Jasper','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(736,'Jefferson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(737,'Jersey','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(738,'Jo Daviess','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(739,'Johnson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(740,'Kane','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(741,'Kankakee','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(742,'Kendall','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(743,'Knox','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(744,'La Salle','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(745,'Lake','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(746,'Lawrence','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(747,'Lee','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(748,'Livingston','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(749,'Logan','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(750,'Macon','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(751,'Macoupin','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(752,'Madison','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(753,'Marion','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(754,'Marshall','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(755,'Mason','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(756,'Massac','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(757,'McDonough','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(758,'McHenry','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(759,'McLean','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(760,'Menard','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(761,'Mercer','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(762,'Monroe','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(763,'Montgomery','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(764,'Morgan','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(765,'Moultrie','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(766,'Ogle','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(767,'Peoria','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(768,'Perry','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(769,'Piatt','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(770,'Pike','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(771,'Pope','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(772,'Pulaski','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(773,'Putnam','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(774,'Randolph','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(775,'Richland','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(776,'Rock Island','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(777,'Saint Clair','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(778,'Saline','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(779,'Sangamon','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(780,'Schuyler','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(781,'Scott','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(782,'Shelby','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(783,'Stark','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(784,'Stephenson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(785,'Tazewell','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(786,'Union','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(787,'Vermilion','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(788,'Wabash','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(789,'Warren','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(790,'Washington','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(791,'Wayne','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(792,'White','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(793,'Whiteside','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(794,'Will','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(795,'Williamson','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(796,'Winnebago','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(797,'Woodford','IL')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(798,'Adams','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(799,'Allen','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(800,'Bartholomew','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(801,'Benton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(802,'Blackford','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(803,'Boone','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(804,'Brown','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(805,'Carroll','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(806,'Cass','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(807,'Clark','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(808,'Clay','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(809,'Clinton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(810,'Crawford','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(811,'Daviess','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(812,'De Kalb','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(813,'Dearborn','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(814,'Decatur','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(815,'Delaware','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(816,'Dubois','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(817,'Elkhart','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(818,'Fayette','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(819,'Floyd','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(820,'Fountain','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(821,'Franklin','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(822,'Fulton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(823,'Gibson','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(824,'Grant','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(825,'Greene','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(826,'Hamilton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(827,'Hancock','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(828,'Harrison','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(829,'Hendricks','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(830,'Henry','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(831,'Howard','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(832,'Huntington','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(833,'Jackson','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(834,'Jasper','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(835,'Jay','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(836,'Jefferson','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(837,'Jennings','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(838,'Johnson','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(839,'Knox','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(840,'Kosciusko','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(841,'La Porte','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(842,'Lagrange','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(843,'Lake','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(844,'Lawrence','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(845,'Madison','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(846,'Marion','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(847,'Marshall','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(848,'Martin','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(849,'Miami','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(850,'Monroe','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(851,'Montgomery','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(852,'Morgan','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(853,'Newton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(854,'Noble','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(855,'Ohio','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(856,'Orange','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(857,'Owen','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(858,'Parke','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(859,'Perry','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(860,'Pike','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(861,'Porter','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(862,'Posey','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(863,'Pulaski','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(864,'Putnam','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(865,'Randolph','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(866,'Ripley','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(867,'Rush','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(868,'Scott','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(869,'Shelby','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(870,'Spencer','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(871,'St Joseph','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(872,'Starke','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(873,'Steuben','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(874,'Sullivan','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(875,'Switzerland','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(876,'Tippecanoe','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(877,'Tipton','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(878,'Union','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(879,'Vanderburgh','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(880,'Vermillion','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(881,'Vigo','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(882,'Wabash','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(883,'Warren','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(884,'Warrick','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(885,'Washington','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(886,'Wayne','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(887,'Wells','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(888,'White','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(889,'Whitley','IN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(890,'Allen','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(891,'Anderson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(892,'Atchison','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(893,'Barber','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(894,'Barton','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(895,'Bourbon','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(896,'Brown','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(897,'Butler','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(898,'Chase','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(899,'Chautauqua','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(900,'Cherokee','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(901,'Cheyenne','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(902,'Clark','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(903,'Clay','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(904,'Cloud','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(905,'Coffey','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(906,'Comanche','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(907,'Cowley','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(908,'Crawford','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(909,'Decatur','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(910,'Dickinson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(911,'Doniphan','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(912,'Douglas','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(913,'Edwards','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(914,'Elk','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(915,'Ellis','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(916,'Ellsworth','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(917,'Finney','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(918,'Ford','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(919,'Franklin','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(920,'Geary','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(921,'Gove','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(922,'Graham','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(923,'Grant','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(924,'Gray','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(925,'Greeley','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(926,'Greenwood','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(927,'Hamilton','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(928,'Harper','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(929,'Harvey','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(930,'Haskell','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(931,'Hodgeman','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(932,'Jackson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(933,'Jefferson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(934,'Jewell','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(935,'Johnson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(936,'Kearny','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(937,'Kingman','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(938,'Kiowa','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(939,'Labette','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(940,'Lane','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(941,'Leavenworth','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(942,'Lincoln','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(943,'Linn','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(944,'Logan','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(945,'Lyon','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(946,'Marion','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(947,'Marshall','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(948,'McPherson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(949,'Meade','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(950,'Miami','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(951,'Mitchell','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(952,'Montgomery','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(953,'Morris','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(954,'Morton','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(955,'Nemaha','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(956,'Neosho','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(957,'Ness','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(958,'Norton','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(959,'Osage','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(960,'Osborne','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(961,'Ottawa','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(962,'Pawnee','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(963,'Phillips','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(964,'Pottawatomie','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(965,'Pratt','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(966,'Rawlins','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(967,'Reno','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(968,'Republic','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(969,'Rice','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(970,'Riley','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(971,'Rooks','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(972,'Rush','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(973,'Russell','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(974,'Saline','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(975,'Scott','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(976,'Sedgwick','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(977,'Seward','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(978,'Shawnee','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(979,'Sheridan','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(980,'Sherman','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(981,'Smith','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(982,'Stafford','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(983,'Stanton','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(984,'Stevens','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(985,'Sumner','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(986,'Thomas','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(987,'Trego','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(988,'Wabaunsee','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(989,'Wallace','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(990,'Washington','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(991,'Wichita','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(992,'Wilson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(993,'Woodson','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(994,'Wyandotte','KS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(995,'Adair','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(996,'Allen','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(997,'Anderson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(998,'Ballard','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(999,'Barren','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1000,'Bath','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1001,'Bell','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1002,'Boone','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1003,'Bourbon','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1004,'Boyd','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1005,'Boyle','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1006,'Bracken','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1007,'Breathitt','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1008,'Breckinridge','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1009,'Bullitt','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1010,'Butler','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1011,'Caldwell','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1012,'Calloway','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1013,'Campbell','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1014,'Carlisle','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1015,'Carroll','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1016,'Carter','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1017,'Casey','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1018,'Christian','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1019,'Clark','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1020,'Clay','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1021,'Clinton','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1022,'Crittenden','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1023,'Cumberland','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1024,'Daviess','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1025,'Edmonson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1026,'Elliott','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1027,'Estill','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1028,'Fayette','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1029,'Fleming','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1030,'Floyd','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1031,'Franklin','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1032,'Fulton','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1033,'Gallatin','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1034,'Garrard','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1035,'Grant','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1036,'Graves','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1037,'Grayson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1038,'Green','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1039,'Greenup','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1040,'Hancock','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1041,'Hardin','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1042,'Harlan','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1043,'Harrison','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1044,'Hart','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1045,'Henderson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1046,'Henry','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1047,'Hickman','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1048,'Hopkins','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1049,'Jackson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1050,'Jefferson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1051,'Jessamine','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1052,'Johnson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1053,'Kenton','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1054,'Knott','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1055,'Knox','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1056,'Larue','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1057,'Laurel','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1058,'Lawrence','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1059,'Lee','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1060,'Leslie','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1061,'Letcher','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1062,'Lewis','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1063,'Lincoln','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1064,'Livingston','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1065,'Logan','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1066,'Lyon','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1067,'Madison','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1068,'Magoffin','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1069,'Marion','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1070,'Marshall','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1071,'Martin','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1072,'Mason','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1073,'McCracken','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1074,'McCreary','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1075,'McLean','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1076,'Meade','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1077,'Menifee','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1078,'Mercer','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1079,'Metcalfe','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1080,'Monroe','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1081,'Montgomery','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1082,'Morgan','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1083,'Muhlenberg','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1084,'Nelson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1085,'Nicholas','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1086,'Ohio','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1087,'Oldham','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1088,'Owen','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1089,'Owsley','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1090,'Pendleton','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1091,'Perry','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1092,'Pike','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1093,'Powell','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1094,'Pulaski','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1095,'Robertson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1096,'Rockcastle','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1097,'Rowan','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1098,'Russell','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1099,'Scott','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1100,'Shelby','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1101,'Simpson','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1102,'Spencer','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1103,'Taylor','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1104,'Todd','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1105,'Trigg','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1106,'Trimble','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1107,'Union','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1108,'Warren','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1109,'Washington','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1110,'Wayne','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1111,'Webster','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1112,'Whitley','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1113,'Wolfe','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1114,'Woodford','KY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1115,'Acadia','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1116,'Allen','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1117,'Ascension','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1118,'Assumption','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1119,'Avoyelles','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1120,'Beauregard','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1121,'Bienville','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1122,'Bossier','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1123,'Caddo','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1124,'Calcasieu','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1125,'Caldwell','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1126,'Cameron','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1127,'Catahoula','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1128,'Claiborne','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1129,'Concordia','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1130,'De Soto','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1131,'East Baton Rouge','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1132,'East Carroll','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1133,'East Feliciana','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1134,'Evangeline','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1135,'Franklin','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1136,'Grant','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1137,'Iberia','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1138,'Iberville','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1139,'Jackson','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1140,'Jefferson','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1141,'Jefferson Davis','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1142,'La Salle','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1143,'Lafayette','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1144,'Lafourche','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1145,'Lincoln','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1146,'Livingston','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1147,'Madison','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1148,'Morehouse','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1149,'Natchitoches','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1150,'Orleans','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1151,'Ouachita','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1152,'Plaquemines','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1153,'Pointe Coupee','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1154,'Rapides','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1155,'Red River','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1156,'Richland','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1157,'Sabine','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1158,'Saint Bernard','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1159,'Saint Charles','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1160,'Saint Helena','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1161,'Saint James','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1162,'Saint Landry','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1163,'Saint Martin','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1164,'Saint Mary','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1165,'Saint Tammany','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1166,'St John the Baptist','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1167,'Tangipahoa','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1168,'Tensas','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1169,'Terrebonne','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1170,'Union','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1171,'Vermilion','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1172,'Vernon','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1173,'Washington','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1174,'Webster','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1175,'West Baton Rouge','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1176,'West Carroll','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1177,'West Feliciana','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1178,'Winn','LA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1179,'Barnstable','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1180,'Berkshire','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1181,'Bristol','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1182,'Dukes','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1183,'Essex','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1184,'Franklin','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1185,'Hampden','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1186,'Hampshire','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1187,'Middlesex','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1188,'Nantucket','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1189,'Norfolk','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1190,'Plymouth','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1191,'Suffolk','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1192,'Worcester','MA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1193,'Allegany','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1194,'Anne Arundel','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1195,'Baltimore','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1196,'Baltimore City','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1197,'Calvert','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1198,'Caroline','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1199,'Carroll','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1200,'Cecil','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1201,'Charles','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1202,'Dorchester','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1203,'Frederick','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1204,'Garrett','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1205,'Harford','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1206,'Howard','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1207,'Kent','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1208,'Montgomery','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1209,'Prince Georges','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1210,'Queen Annes','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1211,'Saint Marys','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1212,'Somerset','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1213,'Talbot','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1214,'Washington','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1215,'Wicomico','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1216,'Worcester','MD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1217,'Androscoggin','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1218,'Aroostook','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1219,'Cumberland','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1220,'Franklin','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1221,'Hancock','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1222,'Kennebec','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1223,'Knox','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1224,'Lincoln','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1225,'Oxford','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1226,'Penobscot','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1227,'Piscataquis','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1228,'Sagadahoc','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1229,'Somerset','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1230,'Waldo','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1231,'Washington','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1232,'York','ME')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1233,'Marshall Islands','MH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1234,'Alcona','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1235,'Alger','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1236,'Allegan','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1237,'Alpena','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1238,'Antrim','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1239,'Arenac','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1240,'Baraga','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1241,'Barry','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1242,'Bay','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1243,'Benzie','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1244,'Berrien','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1245,'Branch','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1246,'Calhoun','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1247,'Cass','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1248,'Charlevoix','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1249,'Cheboygan','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1250,'Chippewa','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1251,'Clare','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1252,'Clinton','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1253,'Crawford','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1254,'Delta','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1255,'Dickinson','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1256,'Eaton','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1257,'Emmet','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1258,'Genesee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1259,'Gladwin','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1260,'Gogebic','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1261,'Grand Traverse','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1262,'Gratiot','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1263,'Hillsdale','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1264,'Houghton','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1265,'Huron','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1266,'Ingham','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1267,'Ionia','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1268,'Iosco','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1269,'Iron','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1270,'Isabella','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1271,'Jackson','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1272,'Kalamazoo','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1273,'Kalkaska','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1274,'Kent','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1275,'Keweenaw','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1276,'Lake','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1277,'Lapeer','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1278,'Leelanau','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1279,'Lenawee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1280,'Livingston','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1281,'Luce','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1282,'Mackinac','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1283,'Macomb','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1284,'Manistee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1285,'Marquette','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1286,'Mason','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1287,'Mecosta','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1288,'Menominee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1289,'Midland','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1290,'Missaukee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1291,'Monroe','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1292,'Montcalm','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1293,'Montmorency','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1294,'Muskegon','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1295,'Newaygo','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1296,'Oakland','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1297,'Oceana','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1298,'Ogemaw','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1299,'Ontonagon','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1300,'Osceola','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1301,'Oscoda','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1302,'Otsego','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1303,'Ottawa','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1304,'Presque Isle','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1305,'Roscommon','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1306,'Saginaw','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1307,'Saint Clair','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1308,'Saint Joseph','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1309,'Sanilac','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1310,'Schoolcraft','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1311,'Shiawassee','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1312,'Tuscola','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1313,'Van Buren','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1314,'Washtenaw','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1315,'Wayne','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1316,'Wexford','MI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1317,'Aitkin','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1318,'Anoka','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1319,'Becker','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1320,'Beltrami','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1321,'Benton','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1322,'Big Stone','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1323,'Blue Earth','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1324,'Brown','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1325,'Carlton','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1326,'Carver','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1327,'Cass','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1328,'Chippewa','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1329,'Chisago','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1330,'Clay','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1331,'Clearwater','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1332,'Cook','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1333,'Cottonwood','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1334,'Crow Wing','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1335,'Dakota','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1336,'Dodge','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1337,'Douglas','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1338,'Faribault','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1339,'Fillmore','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1340,'Freeborn','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1341,'Goodhue','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1342,'Grant','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1343,'Hennepin','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1344,'Houston','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1345,'Hubbard','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1346,'Isanti','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1347,'Itasca','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1348,'Jackson','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1349,'Kanabec','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1350,'Kandiyohi','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1351,'Kittson','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1352,'Koochiching','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1353,'Lac Qui Parle','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1354,'Lake','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1355,'Lake of the Woods','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1356,'Le Sueur','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1357,'Lincoln','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1358,'Lyon','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1359,'Mahnomen','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1360,'Marshall','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1361,'Martin','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1362,'McLeod','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1363,'Meeker','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1364,'Mille Lacs','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1365,'Morrison','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1366,'Mower','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1367,'Murray','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1368,'Nicollet','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1369,'Nobles','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1370,'Norman','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1371,'Olmsted','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1372,'Otter Tail','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1373,'Pennington','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1374,'Pine','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1375,'Pipestone','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1376,'Polk','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1377,'Pope','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1378,'Ramsey','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1379,'Red Lake','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1380,'Redwood','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1381,'Renville','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1382,'Rice','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1383,'Rock','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1384,'Roseau','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1385,'Saint Louis','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1386,'Scott','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1387,'Sherburne','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1388,'Sibley','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1389,'Stearns','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1390,'Steele','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1391,'Stevens','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1392,'Swift','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1393,'Todd','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1394,'Traverse','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1395,'Wabasha','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1396,'Wadena','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1397,'Waseca','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1398,'Washington','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1399,'Watonwan','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1400,'Wilkin','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1401,'Winona','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1402,'Wright','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1403,'Yellow Medicine','MN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1404,'Adair','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1405,'Andrew','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1406,'Atchison','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1407,'Audrain','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1408,'Barry','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1409,'Barton','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1410,'Bates','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1411,'Benton','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1412,'Bollinger','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1413,'Boone','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1414,'Buchanan','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1415,'Butler','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1416,'Caldwell','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1417,'Callaway','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1418,'Camden','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1419,'Cape Girardeau','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1420,'Carroll','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1421,'Carter','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1422,'Cass','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1423,'Cedar','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1424,'Chariton','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1425,'Christian','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1426,'Clark','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1427,'Clay','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1428,'Clinton','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1429,'Cole','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1430,'Cooper','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1431,'Crawford','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1432,'Dade','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1433,'Dallas','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1434,'Daviess','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1435,'Dekalb','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1436,'Dent','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1437,'Douglas','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1438,'Dunklin','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1439,'Franklin','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1440,'Gasconade','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1441,'Gentry','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1442,'Greene','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1443,'Grundy','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1444,'Harrison','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1445,'Henry','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1446,'Hickory','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1447,'Holt','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1448,'Howard','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1449,'Howell','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1450,'Iron','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1451,'Jackson','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1452,'Jasper','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1453,'Jefferson','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1454,'Johnson','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1455,'Knox','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1456,'Laclede','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1457,'Lafayette','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1458,'Lawrence','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1459,'Lewis','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1460,'Lincoln','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1461,'Linn','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1462,'Livingston','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1463,'Macon','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1464,'Madison','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1465,'Maries','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1466,'Marion','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1467,'McDonald','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1468,'Mercer','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1469,'Miller','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1470,'Mississippi','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1471,'Moniteau','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1472,'Monroe','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1473,'Montgomery','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1474,'Morgan','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1475,'New Madrid','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1476,'Newton','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1477,'Nodaway','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1478,'Oregon','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1479,'Osage','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1480,'Ozark','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1481,'Pemiscot','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1482,'Perry','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1483,'Pettis','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1484,'Phelps','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1485,'Pike','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1486,'Platte','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1487,'Polk','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1488,'Pulaski','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1489,'Putnam','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1490,'Ralls','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1491,'Randolph','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1492,'Ray','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1493,'Reynolds','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1494,'Ripley','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1495,'Saint Charles','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1496,'Saint Clair','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1497,'Saint Francois','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1498,'Saint Louis','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1499,'Saint Louis City','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1500,'Sainte Genevieve','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1501,'Saline','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1502,'Schuyler','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1503,'Scotland','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1504,'Scott','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1505,'Shannon','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1506,'Shelby','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1507,'Stoddard','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1508,'Stone','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1509,'Sullivan','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1510,'Taney','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1511,'Texas','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1512,'Vernon','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1513,'Warren','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1514,'Washington','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1515,'Wayne','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1516,'Webster','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1517,'Worth','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1518,'Wright','MO')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1519,'Northern Mariana Islands','MP')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1520,'Adams','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1521,'Alcorn','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1522,'Amite','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1523,'Attala','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1524,'Benton','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1525,'Bolivar','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1526,'Calhoun','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1527,'Carroll','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1528,'Chickasaw','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1529,'Choctaw','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1530,'Claiborne','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1531,'Clarke','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1532,'Clay','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1533,'Coahoma','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1534,'Copiah','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1535,'Covington','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1536,'De Soto','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1537,'Forrest','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1538,'Franklin','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1539,'George','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1540,'Greene','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1541,'Grenada','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1542,'Hancock','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1543,'Harrison','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1544,'Hinds','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1545,'Holmes','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1546,'Humphreys','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1547,'Issaquena','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1548,'Itawamba','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1549,'Jackson','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1550,'Jasper','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1551,'Jefferson','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1552,'Jefferson Davis','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1553,'Jones','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1554,'Kemper','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1555,'Lafayette','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1556,'Lamar','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1557,'Lauderdale','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1558,'Lawrence','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1559,'Leake','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1560,'Lee','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1561,'Leflore','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1562,'Lincoln','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1563,'Lowndes','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1564,'Madison','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1565,'Marion','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1566,'Marshall','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1567,'Monroe','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1568,'Montgomery','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1569,'Neshoba','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1570,'Newton','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1571,'Noxubee','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1572,'Oktibbeha','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1573,'Panola','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1574,'Pearl River','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1575,'Perry','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1576,'Pike','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1577,'Pontotoc','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1578,'Prentiss','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1579,'Quitman','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1580,'Rankin','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1581,'Scott','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1582,'Sharkey','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1583,'Simpson','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1584,'Smith','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1585,'Stone','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1586,'Sunflower','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1587,'Tallahatchie','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1588,'Tate','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1589,'Tippah','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1590,'Tishomingo','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1591,'Tunica','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1592,'Union','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1593,'Walthall','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1594,'Warren','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1595,'Washington','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1596,'Wayne','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1597,'Webster','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1598,'Wilkinson','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1599,'Winston','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1600,'Yalobusha','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1601,'Yazoo','MS')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1602,'Beaverhead','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1603,'Big Horn','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1604,'Blaine','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1605,'Broadwater','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1606,'Carbon','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1607,'Carter','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1608,'Cascade','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1609,'Chouteau','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1610,'Custer','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1611,'Daniels','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1612,'Dawson','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1613,'Deer Lodge','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1614,'Fallon','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1615,'Fergus','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1616,'Flathead','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1617,'Gallatin','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1618,'Garfield','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1619,'Glacier','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1620,'Golden Valley','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1621,'Granite','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1622,'Hill','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1623,'Jefferson','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1624,'Judith Basin','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1625,'Lake','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1626,'Lewis and Clark','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1627,'Liberty','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1628,'Lincoln','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1629,'Madison','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1630,'McCone','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1631,'Meagher','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1632,'Mineral','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1633,'Missoula','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1634,'Musselshell','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1635,'Park','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1636,'Petroleum','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1637,'Phillips','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1638,'Pondera','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1639,'Powder River','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1640,'Powell','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1641,'Prairie','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1642,'Ravalli','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1643,'Richland','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1644,'Roosevelt','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1645,'Rosebud','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1646,'Sanders','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1647,'Sheridan','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1648,'Silver Bow','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1649,'Stillwater','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1650,'Sweet Grass','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1651,'Teton','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1652,'Toole','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1653,'Treasure','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1654,'Valley','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1655,'Wheatland','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1656,'Wibaux','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1657,'Yellowstone','MT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1658,'Alamance','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1659,'Alexander','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1660,'Alleghany','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1661,'Anson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1662,'Ashe','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1663,'Avery','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1664,'Beaufort','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1665,'Bertie','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1666,'Bladen','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1667,'Brunswick','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1668,'Buncombe','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1669,'Burke','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1670,'Cabarrus','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1671,'Caldwell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1672,'Camden','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1673,'Carteret','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1674,'Caswell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1675,'Catawba','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1676,'Chatham','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1677,'Cherokee','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1678,'Chowan','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1679,'Clay','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1680,'Cleveland','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1681,'Columbus','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1682,'Craven','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1683,'Cumberland','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1684,'Currituck','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1685,'Dare','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1686,'Davidson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1687,'Davie','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1688,'Duplin','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1689,'Durham','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1690,'Edgecombe','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1691,'Forsyth','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1692,'Franklin','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1693,'Gaston','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1694,'Gates','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1695,'Graham','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1696,'Granville','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1697,'Greene','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1698,'Guilford','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1699,'Halifax','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1700,'Harnett','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1701,'Haywood','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1702,'Henderson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1703,'Hertford','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1704,'Hoke','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1705,'Hyde','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1706,'Iredell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1707,'Jackson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1708,'Johnston','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1709,'Jones','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1710,'Lee','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1711,'Lenoir','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1712,'Lincoln','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1713,'Macon','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1714,'Madison','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1715,'Martin','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1716,'McDowell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1717,'Mecklenburg','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1718,'Mitchell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1719,'Montgomery','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1720,'Moore','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1721,'Nash','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1722,'New Hanover','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1723,'Northampton','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1724,'Onslow','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1725,'Orange','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1726,'Pamlico','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1727,'Pasquotank','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1728,'Pender','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1729,'Perquimans','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1730,'Person','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1731,'Pitt','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1732,'Polk','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1733,'Randolph','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1734,'Richmond','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1735,'Robeson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1736,'Rockingham','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1737,'Rowan','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1738,'Rutherford','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1739,'Sampson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1740,'Scotland','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1741,'Stanly','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1742,'Stokes','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1743,'Surry','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1744,'Swain','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1745,'Transylvania','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1746,'Tyrrell','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1747,'Union','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1748,'Vance','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1749,'Wake','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1750,'Warren','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1751,'Washington','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1752,'Watauga','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1753,'Wayne','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1754,'Wilkes','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1755,'Wilson','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1756,'Yadkin','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1757,'Yancey','NC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1758,'Adams','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1759,'Barnes','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1760,'Benson','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1761,'Billings','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1762,'Bottineau','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1763,'Bowman','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1764,'Burke','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1765,'Burleigh','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1766,'Cass','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1767,'Cavalier','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1768,'Dickey','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1769,'Divide','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1770,'Dunn','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1771,'Eddy','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1772,'Emmons','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1773,'Foster','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1774,'Golden Valley','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1775,'Grand Forks','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1776,'Grant','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1777,'Griggs','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1778,'Hettinger','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1779,'Kidder','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1780,'Lamoure','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1781,'Logan','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1782,'McHenry','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1783,'McIntosh','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1784,'McKenzie','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1785,'McLean','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1786,'Mercer','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1787,'Morton','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1788,'Mountrail','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1789,'Nelson','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1790,'Oliver','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1791,'Pembina','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1792,'Pierce','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1793,'Ramsey','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1794,'Ransom','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1795,'Renville','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1796,'Richland','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1797,'Rolette','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1798,'Sargent','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1799,'Sheridan','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1800,'Sioux','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1801,'Slope','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1802,'Stark','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1803,'Steele','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1804,'Stutsman','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1805,'Towner','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1806,'Traill','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1807,'Walsh','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1808,'Ward','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1809,'Wells','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1810,'Williams','ND')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1811,'Adams','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1812,'Antelope','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1813,'Arthur','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1814,'Banner','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1815,'Blaine','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1816,'Boone','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1817,'Box Butte','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1818,'Boyd','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1819,'Brown','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1820,'Buffalo','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1821,'Burt','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1822,'Butler','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1823,'Cass','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1824,'Cedar','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1825,'Chase','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1826,'Cherry','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1827,'Cheyenne','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1828,'Clay','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1829,'Colfax','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1830,'Cuming','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1831,'Custer','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1832,'Dakota','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1833,'Dawes','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1834,'Dawson','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1835,'Deuel','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1836,'Dixon','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1837,'Dodge','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1838,'Douglas','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1839,'Dundy','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1840,'Fillmore','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1841,'Franklin','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1842,'Frontier','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1843,'Furnas','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1844,'Gage','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1845,'Garden','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1846,'Garfield','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1847,'Gosper','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1848,'Grant','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1849,'Greeley','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1850,'Hall','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1851,'Hamilton','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1852,'Harlan','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1853,'Hayes','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1854,'Hitchcock','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1855,'Holt','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1856,'Hooker','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1857,'Howard','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1858,'Jefferson','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1859,'Johnson','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1860,'Kearney','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1861,'Keith','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1862,'Keya Paha','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1863,'Kimball','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1864,'Knox','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1865,'Lancaster','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1866,'Lincoln','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1867,'Logan','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1868,'Loup','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1869,'Madison','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1870,'McPherson','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1871,'Merrick','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1872,'Morrill','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1873,'Nance','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1874,'Nemaha','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1875,'Nuckolls','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1876,'Otoe','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1877,'Pawnee','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1878,'Perkins','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1879,'Phelps','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1880,'Pierce','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1881,'Platte','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1882,'Polk','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1883,'Red Willow','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1884,'Richardson','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1885,'Rock','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1886,'Saline','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1887,'Sarpy','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1888,'Saunders','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1889,'Scotts Bluff','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1890,'Seward','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1891,'Sheridan','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1892,'Sherman','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1893,'Sioux','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1894,'Stanton','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1895,'Thayer','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1896,'Thomas','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1897,'Thurston','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1898,'Valley','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1899,'Washington','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1900,'Wayne','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1901,'Webster','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1902,'Wheeler','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1903,'York','NE')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1904,'Belknap','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1905,'Carroll','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1906,'Cheshire','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1907,'Coos','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1908,'Grafton','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1909,'Hillsborough','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1910,'Merrimack','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1911,'Rockingham','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1912,'Strafford','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1913,'Sullivan','NH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1914,'Atlantic','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1915,'Bergen','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1916,'Burlington','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1917,'Camden','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1918,'Cape May','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1919,'Cumberland','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1920,'Essex','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1921,'Gloucester','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1922,'Hudson','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1923,'Hunterdon','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1924,'Mercer','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1925,'Middlesex','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1926,'Monmouth','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1927,'Morris','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1928,'Ocean','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1929,'Passaic','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1930,'Salem','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1931,'Somerset','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1932,'Sussex','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1933,'Union','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1934,'Warren','NJ')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1935,'Bernalillo','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1936,'Catron','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1937,'Chaves','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1938,'Cibola','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1939,'Colfax','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1940,'Curry','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1941,'De Baca','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1942,'Dona Ana','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1943,'Eddy','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1944,'Grant','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1945,'Guadalupe','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1946,'Harding','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1947,'Hidalgo','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1948,'Lea','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1949,'Lincoln','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1950,'Los Alamos','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1951,'Luna','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1952,'McKinley','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1953,'Mora','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1954,'Otero','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1955,'Quay','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1956,'Rio Arriba','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1957,'Roosevelt','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1958,'San Juan','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1959,'San Miguel','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1960,'Sandoval','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1961,'Santa Fe','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1962,'Sierra','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1963,'Socorro','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1964,'Taos','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1965,'Torrance','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1966,'Union','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1967,'Valencia','NM')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1968,'Carson City','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1969,'Churchill','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1970,'Clark','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1971,'Douglas','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1972,'Elko','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1973,'Esmeralda','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1974,'Eureka','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1975,'Humboldt','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1976,'Lander','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1977,'Lincoln','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1978,'Lyon','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1979,'Mineral','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1980,'Nye','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1981,'Pershing','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1982,'Storey','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1983,'Washoe','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1984,'White Pine','NV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1985,'Albany','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1986,'Allegany','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1987,'Bronx','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1988,'Broome','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1989,'Cattaraugus','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1990,'Cayuga','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1991,'Chautauqua','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1992,'Chemung','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1993,'Chenango','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1994,'Clinton','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1995,'Columbia','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1996,'Cortland','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1997,'Delaware','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1998,'Dutchess','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(1999,'Erie','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2000,'Essex','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2001,'Franklin','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2002,'Fulton','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2003,'Genesee','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2004,'Greene','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2005,'Hamilton','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2006,'Herkimer','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2007,'Jefferson','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2008,'Kings','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2009,'Lewis','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2010,'Livingston','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2011,'Madison','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2012,'Monroe','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2013,'Montgomery','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2014,'Nassau','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2015,'New York','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2016,'Niagara','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2017,'Oneida','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2018,'Onondaga','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2019,'Ontario','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2020,'Orange','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2021,'Orleans','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2022,'Oswego','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2023,'Otsego','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2024,'Putnam','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2025,'Queens','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2026,'Rensselaer','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2027,'Richmond','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2028,'Rockland','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2029,'Saint Lawrence','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2030,'Saratoga','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2031,'Schenectady','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2032,'Schoharie','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2033,'Schuyler','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2034,'Seneca','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2035,'Steuben','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2036,'Suffolk','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2037,'Sullivan','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2038,'Tioga','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2039,'Tompkins','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2040,'Ulster','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2041,'Warren','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2042,'Washington','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2043,'Wayne','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2044,'Westchester','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2045,'Wyoming','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2046,'Yates','NY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2047,'Adams','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2048,'Allen','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2049,'Ashland','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2050,'Ashtabula','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2051,'Athens','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2052,'Auglaize','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2053,'Belmont','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2054,'Brown','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2055,'Butler','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2056,'Carroll','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2057,'Champaign','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2058,'Clark','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2059,'Clermont','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2060,'Clinton','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2061,'Columbiana','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2062,'Coshocton','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2063,'Crawford','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2064,'Cuyahoga','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2065,'Darke','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2066,'Defiance','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2067,'Delaware','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2068,'Erie','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2069,'Fairfield','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2070,'Fayette','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2071,'Franklin','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2072,'Fulton','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2073,'Gallia','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2074,'Geauga','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2075,'Greene','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2076,'Guernsey','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2077,'Hamilton','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2078,'Hancock','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2079,'Hardin','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2080,'Harrison','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2081,'Henry','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2082,'Highland','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2083,'Hocking','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2084,'Holmes','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2085,'Huron','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2086,'Jackson','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2087,'Jefferson','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2088,'Knox','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2089,'Lake','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2090,'Lawrence','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2091,'Licking','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2092,'Logan','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2093,'Lorain','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2094,'Lucas','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2095,'Madison','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2096,'Mahoning','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2097,'Marion','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2098,'Medina','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2099,'Meigs','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2100,'Mercer','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2101,'Miami','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2102,'Monroe','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2103,'Montgomery','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2104,'Morgan','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2105,'Morrow','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2106,'Muskingum','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2107,'Noble','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2108,'Ottawa','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2109,'Paulding','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2110,'Perry','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2111,'Pickaway','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2112,'Pike','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2113,'Portage','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2114,'Preble','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2115,'Putnam','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2116,'Richland','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2117,'Ross','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2118,'Sandusky','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2119,'Scioto','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2120,'Seneca','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2121,'Shelby','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2122,'Stark','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2123,'Summit','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2124,'Trumbull','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2125,'Tuscarawas','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2126,'Union','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2127,'Van Wert','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2128,'Vinton','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2129,'Warren','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2130,'Washington','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2131,'Wayne','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2132,'Williams','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2133,'Wood','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2134,'Wyandot','OH')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2135,'Adair','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2136,'Alfalfa','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2137,'Atoka','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2138,'Beaver','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2139,'Beckham','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2140,'Blaine','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2141,'Bryan','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2142,'Caddo','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2143,'Canadian','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2144,'Carter','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2145,'Cherokee','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2146,'Choctaw','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2147,'Cimarron','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2148,'Cleveland','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2149,'Coal','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2150,'Comanche','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2151,'Cotton','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2152,'Craig','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2153,'Creek','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2154,'Custer','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2155,'Delaware','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2156,'Dewey','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2157,'Ellis','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2158,'Garfield','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2159,'Garvin','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2160,'Grady','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2161,'Grant','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2162,'Greer','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2163,'Harmon','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2164,'Harper','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2165,'Haskell','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2166,'Hughes','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2167,'Jackson','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2168,'Jefferson','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2169,'Johnston','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2170,'Kay','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2171,'Kingfisher','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2172,'Kiowa','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2173,'Latimer','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2174,'Le Flore','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2175,'Lincoln','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2176,'Logan','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2177,'Love','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2178,'Major','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2179,'Marshall','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2180,'Mayes','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2181,'McClain','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2182,'McCurtain','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2183,'McIntosh','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2184,'Murray','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2185,'Muskogee','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2186,'Noble','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2187,'Nowata','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2188,'Okfuskee','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2189,'Oklahoma','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2190,'Okmulgee','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2191,'Osage','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2192,'Ottawa','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2193,'Pawnee','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2194,'Payne','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2195,'Pittsburg','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2196,'Pontotoc','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2197,'Pottawatomie','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2198,'Pushmataha','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2199,'Roger Mills','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2200,'Rogers','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2201,'Seminole','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2202,'Sequoyah','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2203,'Stephens','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2204,'Texas','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2205,'Tillman','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2206,'Tulsa','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2207,'Wagoner','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2208,'Washington','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2209,'Washita','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2210,'Woods','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2211,'Woodward','OK')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2212,'Baker','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2213,'Benton','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2214,'Clackamas','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2215,'Clatsop','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2216,'Columbia','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2217,'Coos','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2218,'Crook','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2219,'Curry','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2220,'Deschutes','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2221,'Douglas','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2222,'Gilliam','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2223,'Grant','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2224,'Harney','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2225,'Hood River','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2226,'Jackson','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2227,'Jefferson','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2228,'Josephine','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2229,'Klamath','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2230,'Lake','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2231,'Lane','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2232,'Lincoln','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2233,'Linn','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2234,'Malheur','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2235,'Marion','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2236,'Morrow','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2237,'Multnomah','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2238,'Polk','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2239,'Sherman','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2240,'Tillamook','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2241,'Umatilla','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2242,'Union','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2243,'Wallowa','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2244,'Wasco','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2245,'Washington','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2246,'Wheeler','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2247,'Yamhill','OR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2248,'Adams','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2249,'Allegheny','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2250,'Armstrong','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2251,'Beaver','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2252,'Bedford','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2253,'Berks','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2254,'Blair','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2255,'Bradford','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2256,'Bucks','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2257,'Butler','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2258,'Cambria','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2259,'Cameron','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2260,'Carbon','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2261,'Centre','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2262,'Chester','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2263,'Clarion','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2264,'Clearfield','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2265,'Clinton','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2266,'Columbia','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2267,'Crawford','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2268,'Cumberland','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2269,'Dauphin','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2270,'Delaware','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2271,'Elk','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2272,'Erie','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2273,'Fayette','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2274,'Forest','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2275,'Franklin','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2276,'Fulton','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2277,'Greene','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2278,'Huntingdon','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2279,'Indiana','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2280,'Jefferson','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2281,'Juniata','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2282,'Lackawanna','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2283,'Lancaster','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2284,'Lawrence','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2285,'Lebanon','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2286,'Lehigh','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2287,'Luzerne','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2288,'Lycoming','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2289,'McKean','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2290,'Mercer','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2291,'Mifflin','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2292,'Monroe','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2293,'Montgomery','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2294,'Montour','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2295,'Northampton','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2296,'Northumberland','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2297,'Perry','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2298,'Philadelphia','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2299,'Pike','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2300,'Potter','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2301,'Schuylkill','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2302,'Snyder','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2303,'Somerset','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2304,'Sullivan','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2305,'Susquehanna','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2306,'Tioga','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2307,'Union','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2308,'Venango','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2309,'Warren','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2310,'Washington','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2311,'Wayne','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2312,'Westmoreland','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2313,'Wyoming','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2314,'York','PA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2315,'Adjuntas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2316,'Aguada','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2317,'Aguadilla','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2318,'Aguas Buenas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2319,'Aibonito','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2320,'Anasco','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2321,'Arecibo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2322,'Arroyo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2323,'Barceloneta','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2324,'Barranquitas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2325,'Bayamon','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2326,'Cabo Rojo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2327,'Caguas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2328,'Camuy','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2329,'Canovanas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2330,'Carolina','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2331,'Catano','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2332,'Cayey','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2333,'Ceiba','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2334,'Ciales','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2335,'Cidra','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2336,'Coamo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2337,'Comerio','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2338,'Corozal','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2339,'Culebra','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2340,'Dorado','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2341,'Fajardo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2342,'Florida','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2343,'Guanica','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2344,'Guayama','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2345,'Guayanilla','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2346,'Guaynabo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2347,'Gurabo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2348,'Hatillo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2349,'Hormigueros','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2350,'Humacao','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2351,'Isabela','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2352,'Jayuya','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2353,'Juana Diaz','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2354,'Juncos','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2355,'Lajas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2356,'Lares','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2357,'Las Marias','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2358,'Las Piedras','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2359,'Loiza','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2360,'Luquillo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2361,'Manati','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2362,'Maricao','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2363,'Maunabo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2364,'Mayaguez','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2365,'Moca','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2366,'Morovis','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2367,'Naguabo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2368,'Naranjito','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2369,'Orocovis','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2370,'Patillas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2371,'Penuelas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2372,'Ponce','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2373,'Quebradillas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2374,'Rincon','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2375,'Rio Grande','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2376,'Sabana Grande','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2377,'Salinas','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2378,'San German','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2379,'San Juan','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2380,'San Lorenzo','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2381,'San Sebastian','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2382,'Santa Isabel','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2383,'Toa Alta','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2384,'Toa Baja','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2385,'Trujillo Alto','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2386,'Utuado','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2387,'Vega Alta','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2388,'Vega Baja','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2389,'Vieques','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2390,'Villalba','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2391,'Yabucoa','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2392,'Yauco','PR')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2393,'Palau','PW')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2394,'Bristol','RI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2395,'Kent','RI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2396,'Newport','RI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2397,'Providence','RI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2398,'Washington','RI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2399,'Abbeville','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2400,'Aiken','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2401,'Allendale','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2402,'Anderson','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2403,'Bamberg','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2404,'Barnwell','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2405,'Beaufort','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2406,'Berkeley','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2407,'Calhoun','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2408,'Charleston','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2409,'Cherokee','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2410,'Chester','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2411,'Chesterfield','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2412,'Clarendon','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2413,'Colleton','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2414,'Darlington','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2415,'Dillon','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2416,'Dorchester','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2417,'Edgefield','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2418,'Fairfield','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2419,'Florence','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2420,'Georgetown','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2421,'Greenville','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2422,'Greenwood','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2423,'Hampton','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2424,'Horry','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2425,'Jasper','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2426,'Kershaw','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2427,'Lancaster','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2428,'Laurens','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2429,'Lee','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2430,'Lexington','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2431,'Marion','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2432,'Marlboro','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2433,'McCormick','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2434,'Newberry','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2435,'Oconee','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2436,'Orangeburg','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2437,'Pickens','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2438,'Richland','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2439,'Saluda','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2440,'Spartanburg','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2441,'Sumter','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2442,'Union','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2443,'Williamsburg','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2444,'York','SC')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2445,'Aurora','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2446,'Beadle','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2447,'Bennett','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2448,'Bon Homme','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2449,'Brookings','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2450,'Brown','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2451,'Brule','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2452,'Buffalo','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2453,'Butte','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2454,'Campbell','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2455,'Charles Mix','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2456,'Clark','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2457,'Clay','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2458,'Codington','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2459,'Corson','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2460,'Custer','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2461,'Davison','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2462,'Day','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2463,'Deuel','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2464,'Dewey','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2465,'Douglas','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2466,'Edmunds','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2467,'Fall River','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2468,'Faulk','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2469,'Grant','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2470,'Gregory','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2471,'Haakon','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2472,'Hamlin','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2473,'Hand','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2474,'Hanson','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2475,'Harding','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2476,'Hughes','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2477,'Hutchinson','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2478,'Hyde','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2479,'Jackson','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2480,'Jerauld','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2481,'Jones','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2482,'Kingsbury','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2483,'Lake','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2484,'Lawrence','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2485,'Lincoln','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2486,'Lyman','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2487,'Marshall','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2488,'McCook','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2489,'McPherson','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2490,'Meade','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2491,'Mellette','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2492,'Miner','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2493,'Minnehaha','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2494,'Moody','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2495,'Pennington','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2496,'Perkins','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2497,'Potter','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2498,'Roberts','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2499,'Sanborn','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2500,'Shannon','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2501,'Spink','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2502,'Stanley','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2503,'Sully','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2504,'Todd','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2505,'Tripp','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2506,'Turner','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2507,'Union','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2508,'Walworth','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2509,'Yankton','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2510,'Ziebach','SD')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2511,'Anderson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2512,'Bedford','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2513,'Benton','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2514,'Bledsoe','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2515,'Blount','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2516,'Bradley','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2517,'Campbell','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2518,'Cannon','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2519,'Carroll','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2520,'Carter','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2521,'Cheatham','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2522,'Chester','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2523,'Claiborne','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2524,'Clay','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2525,'Cocke','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2526,'Coffee','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2527,'Crockett','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2528,'Cumberland','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2529,'Davidson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2530,'Decatur','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2531,'Dekalb','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2532,'Dickson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2533,'Dyer','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2534,'Fayette','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2535,'Fentress','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2536,'Franklin','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2537,'Gibson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2538,'Giles','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2539,'Grainger','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2540,'Greene','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2541,'Grundy','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2542,'Hamblen','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2543,'Hamilton','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2544,'Hancock','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2545,'Hardeman','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2546,'Hardin','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2547,'Hawkins','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2548,'Haywood','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2549,'Henderson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2550,'Henry','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2551,'Hickman','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2552,'Houston','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2553,'Humphreys','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2554,'Jackson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2555,'Jefferson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2556,'Johnson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2557,'Knox','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2558,'Lake','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2559,'Lauderdale','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2560,'Lawrence','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2561,'Lewis','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2562,'Lincoln','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2563,'Loudon','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2564,'Macon','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2565,'Madison','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2566,'Marion','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2567,'Marshall','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2568,'Maury','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2569,'McMinn','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2570,'McNairy','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2571,'Meigs','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2572,'Monroe','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2573,'Montgomery','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2574,'Moore','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2575,'Morgan','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2576,'Obion','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2577,'Overton','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2578,'Perry','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2579,'Pickett','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2580,'Polk','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2581,'Putnam','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2582,'Rhea','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2583,'Roane','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2584,'Robertson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2585,'Rutherford','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2586,'Scott','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2587,'Sequatchie','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2588,'Sevier','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2589,'Shelby','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2590,'Smith','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2591,'Stewart','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2592,'Sullivan','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2593,'Sumner','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2594,'Tipton','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2595,'Trousdale','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2596,'Unicoi','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2597,'Union','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2598,'Van Buren','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2599,'Warren','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2600,'Washington','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2601,'Wayne','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2602,'Weakley','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2603,'White','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2604,'Williamson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2605,'Wilson','TN')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2606,'Anderson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2607,'Andrews','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2608,'Angelina','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2609,'Aransas','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2610,'Archer','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2611,'Armstrong','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2612,'Atascosa','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2613,'Austin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2614,'Bailey','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2615,'Bandera','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2616,'Bastrop','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2617,'Baylor','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2618,'Bee','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2619,'Bell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2620,'Bexar','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2621,'Blanco','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2622,'Borden','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2623,'Bosque','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2624,'Bowie','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2625,'Brazoria','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2626,'Brazos','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2627,'Brewster','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2628,'Briscoe','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2629,'Brooks','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2630,'Brown','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2631,'Burleson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2632,'Burnet','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2633,'Caldwell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2634,'Calhoun','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2635,'Callahan','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2636,'Cameron','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2637,'Camp','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2638,'Carson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2639,'Cass','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2640,'Castro','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2641,'Chambers','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2642,'Cherokee','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2643,'Childress','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2644,'Clay','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2645,'Cochran','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2646,'Coke','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2647,'Coleman','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2648,'Collin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2649,'Collingsworth','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2650,'Colorado','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2651,'Comal','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2652,'Comanche','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2653,'Concho','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2654,'Cooke','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2655,'Coryell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2656,'Cottle','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2657,'Crane','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2658,'Crockett','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2659,'Crosby','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2660,'Culberson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2661,'Dallam','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2662,'Dallas','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2663,'Dawson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2664,'De Witt','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2665,'Deaf Smith','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2666,'Delta','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2667,'Denton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2668,'Dickens','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2669,'Dimmit','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2670,'Donley','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2671,'Duval','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2672,'Eastland','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2673,'Ector','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2674,'Edwards','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2675,'El Paso','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2676,'Ellis','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2677,'Erath','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2678,'Falls','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2679,'Fannin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2680,'Fayette','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2681,'Fisher','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2682,'Floyd','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2683,'Foard','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2684,'Fort Bend','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2685,'Franklin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2686,'Freestone','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2687,'Frio','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2688,'Gaines','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2689,'Galveston','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2690,'Garza','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2691,'Gillespie','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2692,'Glasscock','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2693,'Goliad','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2694,'Gonzales','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2695,'Gray','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2696,'Grayson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2697,'Gregg','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2698,'Grimes','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2699,'Guadalupe','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2700,'Hale','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2701,'Hall','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2702,'Hamilton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2703,'Hansford','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2704,'Hardeman','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2705,'Hardin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2706,'Harris','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2707,'Harrison','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2708,'Hartley','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2709,'Haskell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2710,'Hays','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2711,'Hemphill','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2712,'Henderson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2713,'Hidalgo','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2714,'Hill','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2715,'Hockley','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2716,'Hood','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2717,'Hopkins','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2718,'Houston','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2719,'Howard','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2720,'Hudspeth','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2721,'Hunt','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2722,'Hutchinson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2723,'Irion','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2724,'Jack','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2725,'Jackson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2726,'Jasper','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2727,'Jeff Davis','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2728,'Jefferson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2729,'Jim Hogg','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2730,'Jim Wells','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2731,'Johnson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2732,'Jones','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2733,'Karnes','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2734,'Kaufman','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2735,'Kendall','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2736,'Kenedy','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2737,'Kent','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2738,'Kerr','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2739,'Kimble','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2740,'King','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2741,'Kinney','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2742,'Kleberg','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2743,'Knox','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2744,'La Salle','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2745,'Lamar','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2746,'Lamb','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2747,'Lampasas','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2748,'Lavaca','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2749,'Lee','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2750,'Leon','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2751,'Liberty','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2752,'Limestone','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2753,'Lipscomb','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2754,'Live Oak','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2755,'Llano','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2756,'Loving','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2757,'Lubbock','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2758,'Lynn','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2759,'Madison','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2760,'Marion','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2761,'Martin','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2762,'Mason','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2763,'Matagorda','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2764,'Maverick','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2765,'McCulloch','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2766,'McLennan','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2767,'McMullen','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2768,'Medina','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2769,'Menard','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2770,'Midland','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2771,'Milam','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2772,'Mills','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2773,'Mitchell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2774,'Montague','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2775,'Montgomery','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2776,'Moore','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2777,'Morris','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2778,'Motley','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2779,'Nacogdoches','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2780,'Navarro','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2781,'Newton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2782,'Nolan','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2783,'Nueces','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2784,'Ochiltree','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2785,'Oldham','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2786,'Orange','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2787,'Palo Pinto','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2788,'Panola','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2789,'Parker','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2790,'Parmer','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2791,'Pecos','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2792,'Polk','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2793,'Potter','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2794,'Presidio','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2795,'Rains','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2796,'Randall','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2797,'Reagan','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2798,'Real','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2799,'Red River','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2800,'Reeves','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2801,'Refugio','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2802,'Roberts','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2803,'Robertson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2804,'Rockwall','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2805,'Runnels','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2806,'Rusk','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2807,'Sabine','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2808,'San Augustine','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2809,'San Jacinto','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2810,'San Patricio','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2811,'San Saba','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2812,'Schleicher','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2813,'Scurry','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2814,'Shackelford','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2815,'Shelby','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2816,'Sherman','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2817,'Smith','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2818,'Somervell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2819,'Starr','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2820,'Stephens','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2821,'Sterling','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2822,'Stonewall','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2823,'Sutton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2824,'Swisher','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2825,'Tarrant','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2826,'Taylor','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2827,'Terrell','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2828,'Terry','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2829,'Throckmorton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2830,'Titus','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2831,'Tom Green','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2832,'Travis','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2833,'Trinity','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2834,'Tyler','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2835,'Upshur','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2836,'Upton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2837,'Uvalde','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2838,'Val Verde','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2839,'Van Zandt','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2840,'Victoria','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2841,'Walker','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2842,'Waller','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2843,'Ward','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2844,'Washington','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2845,'Webb','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2846,'Wharton','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2847,'Wheeler','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2848,'Wichita','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2849,'Wilbarger','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2850,'Willacy','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2851,'Williamson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2852,'Wilson','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2853,'Winkler','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2854,'Wise','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2855,'Wood','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2856,'Yoakum','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2857,'Young','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2858,'Zapata','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2859,'Zavala','TX')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2860,'Beaver','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2861,'Box Elder','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2862,'Cache','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2863,'Carbon','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2864,'Daggett','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2865,'Davis','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2866,'Duchesne','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2867,'Emery','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2868,'Garfield','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2869,'Grand','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2870,'Iron','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2871,'Juab','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2872,'Kane','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2873,'Millard','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2874,'Morgan','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2875,'Piute','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2876,'Rich','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2877,'Salt Lake','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2878,'San Juan','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2879,'Sanpete','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2880,'Sevier','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2881,'Summit','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2882,'Tooele','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2883,'Uintah','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2884,'Utah','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2885,'Wasatch','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2886,'Washington','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2887,'Wayne','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2888,'Weber','UT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2889,'Accomack','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2890,'Albemarle','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2891,'Alexandria City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2892,'Alleghany','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2893,'Amelia','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2894,'Amherst','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2895,'Appomattox','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2896,'Arlington','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2897,'Augusta','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2898,'Bath','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2899,'Bedford','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2900,'Bedford City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2901,'Bland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2902,'Botetourt','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2903,'Bristol','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2904,'Brunswick','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2905,'Buchanan','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2906,'Buckingham','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2907,'Buena Vista City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2908,'Campbell','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2909,'Caroline','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2910,'Carroll','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2911,'Charles City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2912,'Charlotte','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2913,'Charlottesville City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2914,'Chesapeake City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2915,'Chesterfield','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2916,'Clarke','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2917,'Clifton Forge City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2918,'Colonial Heights City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2919,'Covington City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2920,'Craig','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2921,'Culpeper','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2922,'Cumberland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2923,'Danville City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2924,'Dickenson','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2925,'Dinwiddie','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2926,'Emporia City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2927,'Essex','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2928,'Fairfax','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2929,'Fairfax City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2930,'Falls Church City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2931,'Fauquier','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2932,'Floyd','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2933,'Fluvanna','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2934,'Franklin','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2935,'Franklin City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2936,'Frederick','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2937,'Fredericksburg City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2938,'Galax City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2939,'Giles','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2940,'Gloucester','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2941,'Goochland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2942,'Grayson','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2943,'Greene','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2944,'Greensville','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2945,'Halifax','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2946,'Hampton City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2947,'Hanover','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2948,'Harrisonburg City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2949,'Henrico','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2950,'Henry','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2951,'Highland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2952,'Hopewell City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2953,'Isle of Wight','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2954,'James City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2955,'King and Queen','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2956,'King George','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2957,'King William','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2958,'Lancaster','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2959,'Lee','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2960,'Lexington City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2961,'Loudoun','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2962,'Louisa','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2963,'Lunenburg','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2964,'Lynchburg City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2965,'Madison','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2966,'Manassas City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2967,'Manassas Park City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2968,'Martinsville City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2969,'Mathews','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2970,'Mecklenburg','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2971,'Middlesex','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2972,'Montgomery','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2973,'Nelson','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2974,'New Kent','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2975,'Newport News City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2976,'Norfolk City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2977,'Northampton','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2978,'Northumberland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2979,'Norton City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2980,'Nottoway','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2981,'Orange','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2982,'Page','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2983,'Patrick','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2984,'Petersburg City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2985,'Pittsylvania','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2986,'Poquoson City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2987,'Portsmouth City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2988,'Powhatan','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2989,'Prince Edward','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2990,'Prince George','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2991,'Prince William','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2992,'Pulaski','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2993,'Radford City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2994,'Rappahannock','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2995,'Richmond','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2996,'Richmond City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2997,'Roanoke','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2998,'Roanoke City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(2999,'Rockbridge','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3000,'Rockingham','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3001,'Russell','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3002,'Salem','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3003,'Scott','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3004,'Shenandoah','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3005,'Smyth','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3006,'Southampton','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3007,'Spotsylvania','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3008,'Stafford','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3009,'Staunton City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3010,'Suffolk City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3011,'Surry','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3012,'Sussex','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3013,'Tazewell','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3014,'Virginia Beach City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3015,'Warren','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3016,'Washington','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3017,'Waynesboro City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3018,'Westmoreland','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3019,'Williamsburg City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3020,'Winchester City','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3021,'Wise','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3022,'Wythe','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3023,'York','VA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3024,'Saint Croix','VI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3025,'Saint John','VI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3026,'Saint Thomas','VI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3027,'Addison','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3028,'Bennington','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3029,'Caledonia','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3030,'Chittenden','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3031,'Essex','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3032,'Franklin','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3033,'Grand Isle','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3034,'Lamoille','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3035,'Orange','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3036,'Orleans','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3037,'Rutland','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3038,'Washington','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3039,'Windham','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3040,'Windsor','VT')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3041,'Adams','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3042,'Asotin','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3043,'Benton','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3044,'Chelan','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3045,'Clallam','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3046,'Clark','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3047,'Columbia','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3048,'Cowlitz','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3049,'Douglas','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3050,'Ferry','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3051,'Franklin','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3052,'Garfield','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3053,'Grant','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3054,'Grays Harbor','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3055,'Island','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3056,'Jefferson','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3057,'King','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3058,'Kitsap','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3059,'Kittitas','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3060,'Klickitat','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3061,'Lewis','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3062,'Lincoln','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3063,'Mason','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3064,'Okanogan','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3065,'Pacific','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3066,'Pend Oreille','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3067,'Pierce','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3068,'San Juan','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3069,'Skagit','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3070,'Skamania','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3071,'Snohomish','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3072,'Spokane','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3073,'Stevens','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3074,'Thurston','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3075,'Wahkiakum','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3076,'Walla Walla','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3077,'Whatcom','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3078,'Whitman','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3079,'Yakima','WA')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3080,'Adams','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3081,'Ashland','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3082,'Barron','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3083,'Bayfield','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3084,'Brown','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3085,'Buffalo','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3086,'Burnett','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3087,'Calumet','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3088,'Chippewa','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3089,'Clark','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3090,'Columbia','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3091,'Crawford','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3092,'Dane','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3093,'Dodge','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3094,'Door','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3095,'Douglas','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3096,'Dunn','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3097,'Eau Claire','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3098,'Florence','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3099,'Fond du Lac','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3100,'Forest','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3101,'Grant','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3102,'Green','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3103,'Green Lake','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3104,'Iowa','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3105,'Iron','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3106,'Jackson','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3107,'Jefferson','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3108,'Juneau','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3109,'Kenosha','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3110,'Kewaunee','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3111,'La Crosse','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3112,'Lafayette','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3113,'Langlade','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3114,'Lincoln','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3115,'Manitowoc','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3116,'Marathon','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3117,'Marinette','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3118,'Marquette','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3119,'Menominee','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3120,'Milwaukee','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3121,'Monroe','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3122,'Oconto','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3123,'Oneida','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3124,'Outagamie','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3125,'Ozaukee','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3126,'Pepin','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3127,'Pierce','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3128,'Polk','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3129,'Portage','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3130,'Price','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3131,'Racine','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3132,'Richland','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3133,'Rock','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3134,'Rusk','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3135,'Saint Croix','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3136,'Sauk','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3137,'Sawyer','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3138,'Shawano','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3139,'Sheboygan','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3140,'Taylor','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3141,'Trempealeau','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3142,'Vernon','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3143,'Vilas','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3144,'Walworth','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3145,'Washburn','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3146,'Washington','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3147,'Waukesha','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3148,'Waupaca','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3149,'Waushara','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3150,'Winnebago','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3151,'Wood','WI')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3152,'Barbour','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3153,'Berkeley','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3154,'Boone','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3155,'Braxton','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3156,'Brooke','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3157,'Cabell','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3158,'Calhoun','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3159,'Clay','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3160,'Doddridge','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3161,'Fayette','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3162,'Gilmer','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3163,'Grant','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3164,'Greenbrier','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3165,'Hampshire','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3166,'Hancock','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3167,'Hardy','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3168,'Harrison','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3169,'Jackson','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3170,'Jefferson','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3171,'Kanawha','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3172,'Lewis','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3173,'Lincoln','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3174,'Logan','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3175,'Marion','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3176,'Marshall','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3177,'Mason','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3178,'McDowell','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3179,'Mercer','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3180,'Mineral','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3181,'Mingo','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3182,'Monongalia','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3183,'Monroe','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3184,'Morgan','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3185,'Nicholas','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3186,'Ohio','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3187,'Pendleton','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3188,'Pleasants','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3189,'Pocahontas','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3190,'Preston','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3191,'Putnam','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3192,'Raleigh','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3193,'Randolph','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3194,'Ritchie','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3195,'Roane','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3196,'Summers','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3197,'Taylor','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3198,'Tucker','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3199,'Tyler','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3200,'Upshur','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3201,'Wayne','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3202,'Webster','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3203,'Wetzel','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3204,'Wirt','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3205,'Wood','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3206,'Wyoming','WV')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3207,'Albany','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3208,'Big Horn','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3209,'Campbell','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3210,'Carbon','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3211,'Converse','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3212,'Crook','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3213,'Fremont','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3214,'Goshen','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3215,'Hot Springs','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3216,'Johnson','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3217,'Laramie','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3218,'Lincoln','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3219,'Natrona','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3220,'Niobrara','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3221,'Park','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3222,'Platte','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3223,'Sheridan','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3224,'Sublette','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3225,'Sweetwater','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3226,'Teton','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3227,'Uinta','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3228,'Washakie','WY')
INSERT INTO [tblvenue] ([VenueID],[County],[State])VALUES(3229,'Weston','WY')

SET IDENTITY_INSERT dbo.tblVenue OFF


update tblControl set DBVersion='1.05'
GO