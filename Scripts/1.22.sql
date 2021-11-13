

--------------------------------------------------
--Schema changes for Intra-Company Referral
--------------------------------------------------

CREATE TABLE [tblEWFacilityLocal] (
  [EWFacilityID] INTEGER NOT NULL,
  [ClientCode] INTEGER,
  [DoctorCode] INTEGER,
  CONSTRAINT [PK_tblEWFacilityLocal] PRIMARY KEY ([EWFacilityID])
)
GO


ALTER TABLE [tblCase]
  ADD [EWReferralType] INTEGER DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblCase]
  ADD [EWReferralEWFacilityID] INTEGER
GO

DROP VIEW [vwdocument]
GO

CREATE VIEW [dbo].[vwdocument]
AS  SELECT  dbo.tblCase.casenbr,
            dbo.tblCase.claimnbr,
            dbo.tblExaminee.addr1 AS examineeaddr1,
            dbo.tblExaminee.addr2 AS examineeaddr2,
            dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  '
            + dbo.tblExaminee.zip AS examineecitystatezip,
            dbo.tblExaminee.SSN,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname,
            dbo.tblCompany.extname AS company,
            dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext, ' ') AS clientphone,
            dbo.tblClient.phone2 + ' ' + ISNULL(dbo.tblClient.phone2ext, ' ') AS clientphone2,
            dbo.tblLocation.addr1 AS doctoraddr1,
            dbo.tblLocation.addr2 AS doctoraddr2,
            dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  '
            + dbo.tblLocation.zip AS doctorcitystatezip,
            dbo.tblCase.ApptDate,
            dbo.tblCase.Appttime,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename,
            dbo.tblExaminee.phone1 AS examineephone,
            dbo.tblExaminee.sex,
            dbo.tblExaminee.DOB,
            dbo.tblLocation.Phone AS doctorphone,
            dbo.tblClient.addr1 AS clientaddr1,
            dbo.tblClient.addr2 AS clientaddr2,
            dbo.tblClient.city + ', ' + dbo.tblClient.state + '  '
            + dbo.tblClient.zip AS clientcitystatezip,
            dbo.tblClient.fax AS clientfax,
            dbo.tblClient.email AS clientemail,
            dbo.tblUser.firstname + ' ' + dbo.tblUser.lastname AS scheduler,
            dbo.tblCase.marketercode AS marketer,
            dbo.tblCase.dateadded AS datecalledin,
            dbo.tblCase.dateofinjury AS DOI,
            dbo.tblCase.allegation,
            dbo.tblCase.notes,
            dbo.tblCase.casetype,
            'Dear ' + dbo.tblExaminee.firstname + ' '
            + dbo.tblExaminee.lastname AS examineesalutation,
            dbo.tblCase.status,
            dbo.tblCase.calledinby,
            dbo.tblCase.chartnbr,
            'Dear ' + dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientsalutation,
            'Dear ' + dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname
            + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorsalutation,
            dbo.tblLocation.insidedr,
            dbo.tblLocation.email AS doctoremail,
            dbo.tblLocation.fax AS doctorfax,
            dbo.tblLocation.faxdrschedule,
            dbo.tblLocation.medrcdletter,
            dbo.tblLocation.drletter,
            dbo.tblCase.reportverbal,
            dbo.tblCase.datemedsrecd AS medsrecd,
            tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname,
            'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' '
            + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation,
            tblCCAddress_2.company AS Pattorneycompany,
            tblCCAddress_2.address1 AS Pattorneyaddr1,
            tblCCAddress_2.address2 AS Pattorneyaddr2,
            tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  '
            + tblCCAddress_2.zip AS Pattorneycitystatezip,
            tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone,
            tblCCAddress_2.fax AS Pattorneyfax,
            tblCCAddress_2.email AS Pattorneyemail,
            tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname,
            'Dear ' + ISNULL(tblCCAddress_1.firstname, '') + ' '
            + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation,
            tblCCAddress_1.company AS Dattorneycompany,
            tblCCAddress_1.address1 AS Dattorneyaddr1,
            tblCCAddress_1.address2 AS Dattorneyaddr2,
            tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  '
            + tblCCAddress_1.zip AS Dattorneycitystatezip,
            tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension,
                                                '') AS Dattorneyphone,
            tblCCAddress_1.fax AS Dattorneyfax,
            tblCCAddress_1.email AS Dattorneyemail,
            tblCCAddress_1.fax,
            tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname,
            'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' '
            + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation,
            tblCCAddress_3.company AS DParaLegalcompany,
            tblCCAddress_3.address1 AS DParaLegaladdr1,
            tblCCAddress_3.address2 AS DParaLegaladdr2,
            tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  '
            + tblCCAddress_3.zip AS DParaLegalcitystatezip,
            tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension,
                                                '') AS DParaLegalphone,
            tblCCAddress_3.email AS DParaLegalemail,
            tblCCAddress_3.fax AS DParaLegalfax,
            dbo.tblCase.typemedsrecd,
            dbo.tblCase.plaintiffattorneycode,
            dbo.tblCase.defenseattorneycode,
            dbo.tblCase.servicecode,
            dbo.tblCase.faxPattny,
            dbo.tblCase.faxdoctor,
            dbo.tblCase.faxclient,
            dbo.tblCase.emailclient,
            dbo.tblCase.emaildoctor,
            dbo.tblCase.emailPattny,
            dbo.tblCase.invoicedate,
            dbo.tblCase.invoiceamt,
            dbo.tblCase.commitdate,
            dbo.tblCase.WCBNbr,
            dbo.tblCase.specialinstructions,
            dbo.tblCase.priority,
            dbo.tblServices.description AS servicedesc,
            dbo.tblCase.usdvarchar1 AS caseusdvarchar1,
            dbo.tblCase.usdvarchar2 AS caseusdvarchar2,
            dbo.tblCase.usddate1 AS caseusddate1,
            dbo.tblCase.usddate2 AS caseusddate2,
            dbo.tblCase.usdtext1 AS caseusdtext1,
            dbo.tblCase.usdtext2 AS caseusdtext2,
            dbo.tblCase.usdint1 AS caseusdint1,
            dbo.tblCase.usdint2 AS caseusdint2,
            dbo.tblCase.usdmoney1 AS caseusdmoney1,
            dbo.tblCase.usdmoney2 AS caseusdmoney2,
            dbo.tblClient.title AS clienttitle,
            dbo.tblClient.prefix AS clientprefix,
            dbo.tblClient.suffix AS clientsuffix,
            dbo.tblClient.usdvarchar1 AS clientusdvarchar1,
            dbo.tblClient.usdvarchar2 AS clientusdvarchar2,
            dbo.tblClient.usddate1 AS clientusddate1,
            dbo.tblClient.usddate2 AS clientusddate2,
            dbo.tblClient.usdtext1 AS clientusdtext1,
            dbo.tblClient.usdtext2 AS clientusdtext2,
            dbo.tblClient.usdint1 AS clientusdint1,
            dbo.tblClient.usdint2 AS clientusdint2,
            dbo.tblClient.usdmoney1 AS clientusdmoney1,
            dbo.tblClient.usdmoney2 AS clientusdmoney2,
            dbo.tblDoctor.notes AS doctornotes,
            dbo.tblDoctor.prefix AS doctorprefix,
            dbo.tblDoctor.addr1 AS doctorcorrespaddr1,
            dbo.tblDoctor.addr2 AS doctorcorrespaddr2,
            dbo.tblDoctor.city + ', ' + dbo.tblDoctor.state + '  '
            + dbo.tblDoctor.zip AS doctorcorrespcitystatezip,
            dbo.tblDoctor.phone + ' ' + ISNULL(dbo.tblDoctor.phoneExt, ' ') AS doctorcorrespphone,
            dbo.tblDoctor.faxNbr AS doctorcorrespfax,
            dbo.tblDoctor.emailAddr AS doctorcorrespemail,
            dbo.tblDoctor.qualifications,
            dbo.tblDoctor.prepaid,
            dbo.tblDoctor.county AS doctorcorrespcounty,
            dbo.tblLocation.county AS doctorcounty,
            dbo.tblLocation.vicinity AS doctorvicinity,
            dbo.tblExaminee.county AS examineecounty,
            dbo.tblExaminee.prefix AS examineeprefix,
            dbo.tblExaminee.usdvarchar1 AS examineeusdvarchar1,
            dbo.tblExaminee.usdvarchar2 AS examineeusdvarchar2,
            dbo.tblExaminee.usddate1 AS examineeusddate1,
            dbo.tblExaminee.usddate2 AS examineeusddate2,
            dbo.tblExaminee.usdtext1 AS examineeusdtext1,
            dbo.tblExaminee.usdtext2 AS examineeusdtext2,
            dbo.tblExaminee.usdint1 AS examineeusdint1,
            dbo.tblExaminee.usdint2 AS examineeusdint2,
            dbo.tblExaminee.usdmoney1 AS examineeusdmoney1,
            dbo.tblExaminee.usdmoney2 AS examineeusdmoney2,
            dbo.tblDoctor.usdvarchar1 AS doctorusdvarchar1,
            dbo.tblDoctor.usdvarchar2 AS doctorusdvarchar2,
            dbo.tblDoctor.usddate1 AS doctorusddate1,
            dbo.tblDoctor.usddate2 AS doctorusddate2,
            dbo.tblDoctor.usdtext1 AS doctorusdtext1,
            dbo.tblDoctor.usdtext2 AS doctorusdtext2,
            dbo.tblDoctor.usdint1 AS doctorusdint1,
            dbo.tblDoctor.usdint2 AS doctorusdint2,
            dbo.tblDoctor.usdmoney1 AS doctorusdmoney1,
            dbo.tblDoctor.usdmoney2 AS doctorusdmoney2,
            dbo.tblCase.schedulenotes,
            dbo.tblCase.requesteddoc,
            dbo.tblCompany.usdvarchar1 AS companyusdvarchar1,
            dbo.tblCompany.usdvarchar2 AS companyusdvarchar2,
            dbo.tblCompany.usddate1 AS companyusddate1,
            dbo.tblCompany.usddate2 AS companyusddate2,
            dbo.tblCompany.usdtext1 AS companyusdtext1,
            dbo.tblCompany.usdtext2 AS companyusdtext2,
            dbo.tblCompany.usdint1 AS companyusdint1,
            dbo.tblCompany.usdint2 AS companyusdint2,
            dbo.tblCompany.usdmoney1 AS companyusdmoney1,
            dbo.tblCompany.usdmoney2 AS companyusdmoney2,
            dbo.tblDoctor.WCNbr AS doctorwcnbr,
            dbo.tblCaseType.description AS casetypedesc,
            dbo.tblLocation.location,
            dbo.tblCase.doctorlocation,
            dbo.tblCase.sinternalcasenbr AS internalcasenbr,
            dbo.tblDoctor.credentials AS doctordegree,
            dbo.tblSpecialty.description AS specialtydesc,
            dbo.tblExaminee.note AS chartnotes,
            dbo.tblExaminee.fax AS examineefax,
            dbo.tblExaminee.email AS examineeemail,
            dbo.tblExaminee.insured AS examineeinsured,
            dbo.tblCase.clientcode,
            dbo.tblCase.doctorcode,
            dbo.tblCase.feecode,
            dbo.tblClient.companycode,
            dbo.tblClient.notes AS clientnotes,
            dbo.tblCompany.notes AS companynotes,
            dbo.tblClient.billaddr1,
            dbo.tblClient.billaddr2,
            dbo.tblClient.billcity,
            dbo.tblClient.billstate,
            dbo.tblClient.billzip,
            dbo.tblClient.billattn,
            dbo.tblClient.ARKey,
            dbo.tblCase.icd9code,
            dbo.tblDoctor.remitattn,
            dbo.tblDoctor.remitaddr1,
            dbo.tblDoctor.remitaddr2,
            dbo.tblDoctor.remitcity,
            dbo.tblDoctor.remitstate,
            dbo.tblDoctor.remitzip,
            dbo.tblCase.doctorspecialty,
            dbo.tblServices.shortdesc,
            dbo.tblDoctor.licensenbr AS doctorlicense,
            dbo.tblLocation.notes AS doctorlocationnotes,
            dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontact,
            'Dear ' + dbo.tblLocation.contactfirst + ' '
            + dbo.tblLocation.contactlast AS doctorlocationcontactsalutation,
            dbo.tblRecordStatus.description AS medsstatus,
            dbo.tblExaminee.employer,
            dbo.tblExaminee.treatingphysician,
            dbo.tblExaminee.city AS examineecity,
            dbo.tblExaminee.state AS examineestate,
            dbo.tblExaminee.zip AS examineezip,
            dbo.tblDoctor.SSNTaxID AS DoctorTaxID,
            dbo.tblCase.billclientcode AS casebillclientcode,
            dbo.tblCase.billaddr1 AS casebilladdr1,
            dbo.tblCase.billaddr2 AS casebilladdr2,
            dbo.tblCase.billcity AS casebillcity,
            dbo.tblCase.billstate AS casebillstate,
            dbo.tblCase.billzip AS casebillzip,
            dbo.tblCase.billARKey AS casebillarkey,
            dbo.tblCase.billcompany AS casebillcompany,
            dbo.tblCase.billcontact AS casebillcontact,
            dbo.tblSpecialty.specialtycode,
            dbo.tblDoctorLocation.correspondence AS doctorcorrespondence,
            dbo.tblExaminee.lastname AS examineelastname,
            dbo.tblExaminee.firstname AS examineefirstname,
            dbo.tblCase.billfax AS casebillfax,
            dbo.tblClient.billfax AS clientbillfax,
            dbo.tblCase.officecode,
            dbo.tblDoctor.lastname AS doctorlastname,
            dbo.tblDoctor.firstname AS doctorfirstname,
            dbo.tblDoctor.middleinitial AS doctormiddleinitial,
            ISNULL(LEFT(dbo.tblDoctor.firstname, 1), '')
            + ISNULL(LEFT(dbo.tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(dbo.tblDoctor.lastname, 1), '') AS doctorinitials,
            dbo.tblCase.QARep,
            dbo.tblClient.lastname AS clientlastname,
            dbo.tblClient.firstname AS clientfirstname,
            tblCCAddress_1.prefix AS dattorneyprefix,
            tblCCAddress_1.lastname AS dattorneylastname,
            tblCCAddress_1.firstname AS dattorneyfirstname,
            tblCCAddress_2.prefix AS pattorneyprefix,
            tblCCAddress_2.lastname AS pattorneylastname,
            tblCCAddress_2.firstname AS pattorneyfirstname,
            dbo.tblLocation.contactprefix AS doctorlocationcontactprefix,
            dbo.tblLocation.contactfirst AS doctorlocationcontactfirstname,
            dbo.tblLocation.contactlast AS doctorlocationcontactlastname,
            dbo.tblExaminee.middleinitial AS examineemiddleinitial,
            dbo.tblCase.ICD9Code2,
            dbo.tblCase.ICD9Code3,
            dbo.tblCase.ICD9Code4,
            dbo.tblExaminee.InsuredAddr1,
            dbo.tblExaminee.InsuredCity,
            dbo.tblExaminee.InsuredState,
            dbo.tblExaminee.InsuredZip,
            dbo.tblExaminee.InsuredSex,
            dbo.tblExaminee.InsuredRelationship,
            dbo.tblExaminee.InsuredPhone,
            dbo.tblExaminee.InsuredPhoneExt,
            dbo.tblExaminee.InsuredFax,
            dbo.tblExaminee.InsuredEmail,
            dbo.tblExaminee.ExamineeStatus,
            dbo.tblExaminee.TreatingPhysicianAddr1,
            dbo.tblExaminee.TreatingPhysicianCity,
            dbo.tblExaminee.TreatingPhysicianState,
            dbo.tblExaminee.TreatingPhysicianZip,
            dbo.tblExaminee.TreatingPhysicianPhone,
            dbo.tblExaminee.TreatingPhysicianPhoneExt,
            dbo.tblExaminee.TreatingPhysicianFax,
            dbo.tblExaminee.TreatingPhysicianEmail,
            dbo.tblExaminee.TreatingPhysicianLicenseNbr,
            dbo.tblExaminee.EmployerAddr1,
            dbo.tblExaminee.EmployerCity,
            dbo.tblExaminee.EmployerState,
            dbo.tblExaminee.EmployerZip,
            dbo.tblExaminee.EmployerPhone,
            dbo.tblExaminee.EmployerPhoneExt,
            dbo.tblExaminee.EmployerFax,
            dbo.tblExaminee.EmployerEmail,
            dbo.tblExaminee.TreatingPhysicianTaxID,
            dbo.tblExaminee.Country,
            dbo.tblDoctor.UPIN,
            dbo.tblDoctor.schedulepriority,
            dbo.tblDoctor.feecode AS drfeecode,
            dbo.tblCase.PanelNbr,
            dbo.tblstate.StateName AS Jurisdiction,
            dbo.tblCase.photoRqd,
            dbo.tblCase.CertMailNbr,
            dbo.tblCase.HearingDate,
            dbo.tblCase.DoctorName,
            dbo.tblLocation.state AS doctorstate,
            dbo.tblClient.state AS clientstate,
            dbo.tblDoctor.state AS doctorcorrespstate,
            tblCCAddress_1.state AS dattorneystate,
            tblCCAddress_2.state AS pattorneystate,
            dbo.tblCase.prevappt,
            dbo.tblCase.mastersubcase,
            dbo.tblCase.mastercasenbr,
            dbo.tblLocation.city AS doctorcity,
            dbo.tblLocation.zip AS doctorzip,
            dbo.tblClient.city AS clientcity,
            dbo.tblClient.zip AS clientzip,
            dbo.tblExaminee.policynumber,
            tblCCAddress_2.city AS pattorneycity,
            tblCCAddress_2.zip AS pattorneyzip,
            dbo.tblDoctorSchedule.duration AS ApptDuration,
            dbo.tblDoctor.companyname AS PracticeName,
            dbo.tblCase.AssessmentToAddress,
            dbo.tblCase.OCF25Date,
            dbo.tblCase.AssessingFacility,
            dbo.tblCase.DateForminDispute,
            dbo.tblExaminee.EmployerContactLastName,
            dbo.tblExaminee.EmployerContactFirstName,
            dbo.tblDoctor.NPINbr AS DoctorNPINbr,
            dbo.tblCase.PublishOnWeb,
            dbo.tblProviderType.description AS DoctorProviderType,
            dbo.tblDoctor.ProvTypeCode,
            dbo.tblCase.Jurisdiction AS JurisdictionCode,
            dbo.tblCase.LegalEvent,
            dbo.tblCase.PILegalEvent,
            dbo.tblCase.transcode,
            dbo.tblTranscription.transcompany,
            dbo.tblCase.DateReceived,
            dbo.tblCase.usddate3 AS caseusddate3,
            dbo.tblCase.usddate4 AS caseusddate4,
            dbo.tblCase.UsdBit1 AS caseusdboolean1,
            dbo.tblCase.UsdBit2 AS caseusdboolean2,
            dbo.tblCase.usddate5 AS caseusddate5,
            dbo.tblDoctor.usddate3 AS doctorusddate3,
            dbo.tblDoctor.usddate4 AS doctorusddate4,
            dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3,
            dbo.tblDoctor.usddate5 AS doctorusddate5,
            dbo.tblDoctor.usddate6 AS doctorusddate6,
            dbo.tblDoctor.usddate7 AS doctorusddate7,
            dbo.tblCase.ClaimNbrExt,
            dbo.tblCase.sreqspecialty AS RequestedSpecialty,
            dbo.tblQueues.statusdesc,
            dbo.tblCase.AttorneyNote,
            dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc,
            dbo.tblCase.ExternalDueDate,
            dbo.tblCase.InternalDueDate,
            dbo.tblLocation.ExtName AS LocationExtName,
            dbo.tblVenue.County AS Venue,
            dbo.tblOffice.description AS office,
            dbo.tblOffice.usdvarchar1 AS OfficeUSDVarChar1,
            dbo.tblOffice.usdvarchar2 AS OfficeUSDVarChar2,
            dbo.tblCase.TransportationRequired,
            dbo.tblCase.InterpreterRequired,
            dbo.tblLanguage.Description AS LANGUAGE,
            dbo.tblCase.ForecastDate,
            dbo.tblCase.EWReferralType,
            dbo.tblCase.EWReferralEWFacilityID,
            dbo.tblEWFacilityLocal.DoctorCode AS EWFacilityDoctorCode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblExaminee ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr
            INNER JOIN dbo.tblOffice ON dbo.tblOffice.officecode = dbo.tblCase.officecode
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblProviderType ON dbo.tblDoctor.ProvTypeCode = dbo.tblProviderType.ProvTypeCode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctorLocation ON dbo.tblCase.doctorlocation = dbo.tblDoctorLocation.locationcode
                                                     AND dbo.tblCase.doctorcode = dbo.tblDoctorLocation.doctorcode
            LEFT OUTER JOIN dbo.tblVenue ON dbo.tblCase.VenueID = dbo.tblVenue.VenueID
            LEFT OUTER JOIN dbo.tblTranscription ON dbo.tblCase.transcode = dbo.tblTranscription.transcode
            LEFT OUTER JOIN dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode
            LEFT OUTER JOIN dbo.tblstate ON dbo.tblCase.Jurisdiction = dbo.tblstate.Statecode
            LEFT OUTER JOIN dbo.tblRecordStatus ON dbo.tblCase.reccode = dbo.tblRecordStatus.reccode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode
            LEFT OUTER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_1 ON dbo.tblCase.defenseattorneycode = tblCCAddress_1.cccode
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.cccode = dbo.tblCase.DefParaLegal
            LEFT OUTER JOIN dbo.tblLanguage ON dbo.tblLanguage.LanguageID = dbo.tblCase.LanguageID
            LEFT OUTER JOIN dbo.tblEWFacilityLocal ON tblCase.EWReferralEWFacilityID = tblEWFacilityLocal.EWFacilityID

GO

-------------------------------------------------------
--Added Accounting Phone and Fax to tblEWFacility table
-------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ADD [AcctingPhone] VARCHAR(15)
GO

ALTER TABLE [tblEWFacility]
  ADD [AcctingFax] VARCHAR(15)
GO

-------------------------------------------------------
--Include Intra-Company Doctor in voucher select form
-------------------------------------------------------

DROP VIEW [dbo].[vwVoucherSelect]
GO
CREATE VIEW [dbo].[vwVoucherSelect]
AS  SELECT  dbo.tblCase.casenbr,
            dbo.tblcase.doctorcode AS opcode,
            ISNULL(dbo.tblDoctor.lastname, '') + ', '
            + ISNULL(dbo.tblDoctor.firstname, '') + ' '
            + ISNULL(dbo.tblDoctor.credentials, '') AS Provider,
            tbldoctor.optype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblDoctor ON dbo.TblCase.doctorcode = dbo.tblDoctor.doctorcode
    UNION
    SELECT  dbo.tblCase.casenbr,
            dbo.tblcaseotherparty.opcode AS opcode,
            dbo.tblDoctor.companyname AS Provider,
            tbldoctor.optype
    FROM    dbo.tblCase
            INNER JOIN dbo.TblCaseOtherParty ON dbo.tblCase.casenbr = dbo.TblCaseOtherParty.casenbr
            INNER JOIN dbo.tblDoctor ON dbo.TblCaseOtherParty.OPCode = dbo.tblDoctor.doctorcode
    UNION
    SELECT  dbo.tblCase.casenbr,
            dbo.tblCasePanel.doctorcode AS opcode,
            ISNULL(dbo.tblDoctor.lastname, '') + ', '
            + ISNULL(dbo.tblDoctor.firstname, '') + ' '
            + ISNULL(dbo.tblDoctor.credentials, '') AS Provider,
            tbldoctor.optype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr
            INNER JOIN dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode
    UNION
    SELECT  dbo.tblCase.casenbr,
            dbo.tblDoctor.doctorcode AS opcode,
            ISNULL(dbo.tblDoctor.lastname, '') + ', '
            + ISNULL(dbo.tblDoctor.firstname, '') + ' '
            + ISNULL(dbo.tblDoctor.credentials, '') AS Provider,
            tbldoctor.optype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblEWFacilityLocal ON tblCase.EWReferralEWFacilityID = tblEWFacilityLocal.EWFacilityID
                                                 AND tblCase.EWReferralType = 2
            INNER JOIN dbo.tblDoctor ON dbo.tblEWFacilityLocal.DoctorCode = dbo.tblDoctor.doctorcode
GO


update tblControl set DBVersion='1.22'
GO