



-----------------------------------------------------------------------------
--Remove comma from marketer name if either first name or last name is blank
-----------------------------------------------------------------------------

DROP VIEW [vwReferralbyMonthApptDocs]
GO

CREATE VIEW [dbo].[vwReferralbyMonthApptDocs]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.status, dbo.tblCase.doctorlocation AS locationcode, dbo.tblCase.marketercode, dbo.tblCase.clientcode, 
                      dbo.tblClient.companycode,
                      ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer,
                      dbo.tblCase.dateadded, 
                      dbo.tblCompany.intname AS companyname, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.lastname, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname, dbo.tblLocation.location, YEAR(dbo.tblCase.ApptDate) AS year, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 1 THEN 1 ELSE 0 END AS jan, CASE WHEN month(dbo.tblCase.apptdate) = 2 THEN 1 ELSE 0 END AS feb, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 3 THEN 1 ELSE 0 END AS mar, CASE WHEN month(dbo.tblCase.apptdate) = 4 THEN 1 ELSE 0 END AS apr, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 5 THEN 1 ELSE 0 END AS may, CASE WHEN month(dbo.tblCase.apptdate) = 6 THEN 1 ELSE 0 END AS jun, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 7 THEN 1 ELSE 0 END AS jul, CASE WHEN month(dbo.tblCase.apptdate) = 8 THEN 1 ELSE 0 END AS aug, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 9 THEN 1 ELSE 0 END AS sep, CASE WHEN month(dbo.tblCase.apptdate) = 10 THEN 1 ELSE 0 END AS oct, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 11 THEN 1 ELSE 0 END AS nov, CASE WHEN month(dbo.tblCase.apptdate) = 12 THEN 1 ELSE 0 END AS dec,
                       1 AS total, dbo.tblCaseType.description AS CasetypeDesc, dbo.tblServices.description AS service, dbo.tblServices.servicecode, dbo.tblCase.casetype, 
                      dbo.tblCase.officecode, dbo.tblOffice.description AS officename, dbo.tblCase.QARep AS QARepCode, dbo.tblDoctor.doctorcode
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
WHERE     (dbo.tblCase.status <> 9)
UNION
SELECT     dbo.tblCase.casenbr, dbo.tblCase.status, dbo.tblCase.doctorlocation AS locationcode, dbo.tblCase.marketercode, dbo.tblCase.clientcode, 
                      dbo.tblClient.companycode, dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer, dbo.tblCase.dateadded, 
                      dbo.tblCompany.intname AS companyname, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.lastname, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname, dbo.tblLocation.location, YEAR(dbo.tblCase.ApptDate) AS year, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 1 THEN 1 ELSE 0 END AS jan, CASE WHEN month(dbo.tblCase.apptdate) = 2 THEN 1 ELSE 0 END AS feb, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 3 THEN 1 ELSE 0 END AS mar, CASE WHEN month(dbo.tblCase.apptdate) = 4 THEN 1 ELSE 0 END AS apr, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 5 THEN 1 ELSE 0 END AS may, CASE WHEN month(dbo.tblCase.apptdate) = 6 THEN 1 ELSE 0 END AS jun, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 7 THEN 1 ELSE 0 END AS jul, CASE WHEN month(dbo.tblCase.apptdate) = 8 THEN 1 ELSE 0 END AS aug, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 9 THEN 1 ELSE 0 END AS sep, CASE WHEN month(dbo.tblCase.apptdate) = 10 THEN 1 ELSE 0 END AS oct, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 11 THEN 1 ELSE 0 END AS nov, CASE WHEN month(dbo.tblCase.apptdate) = 12 THEN 1 ELSE 0 END AS dec,
                       1 AS total, dbo.tblCaseType.description AS CasetypeDesc, dbo.tblServices.description AS service, dbo.tblServices.servicecode, dbo.tblCase.casetype, 
                      dbo.tblCase.officecode, dbo.tblOffice.description AS officename, dbo.tblCase.QARep AS QARepCode, dbo.tblDoctor.doctorcode
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode INNER JOIN
                      dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr INNER JOIN
                      dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
WHERE     (dbo.tblCase.status <> 9)

GO

DROP VIEW [vwDocumentAccting]
GO

CREATE VIEW [dbo].[vwDocumentAccting]
AS
    SELECT  dbo.tblCase.casenbr
           ,dbo.tblCase.claimnbr
           ,dbo.tblExaminee.addr1 AS examineeaddr1
           ,dbo.tblExaminee.addr2 AS examineeaddr2
           ,dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  '
            + dbo.tblExaminee.zip AS examineecitystatezip
           ,dbo.tblExaminee.SSN
           ,dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname
           ,dbo.tblCompany.extname AS company
           ,dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext, ' ') AS clientphone
           ,dbo.tblClient.phone2 + ' ' + ISNULL(dbo.tblClient.phone2ext, ' ') AS clientphone2
           ,dbo.tblLocation.addr1 AS doctoraddr1
           ,dbo.tblLocation.addr2 AS doctoraddr2
           ,dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  '
            + dbo.tblLocation.zip AS doctorcitystatezip
           ,dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename
           ,dbo.tblExaminee.phone1 AS examineephone
           ,dbo.tblExaminee.sex
           ,dbo.tblExaminee.DOB
           ,dbo.tblLocation.Phone AS doctorphone
           ,dbo.tblClient.addr1 AS clientaddr1
           ,dbo.tblClient.addr2 AS clientaddr2
           ,dbo.tblClient.city + ', ' + dbo.tblClient.state + '  '
            + dbo.tblClient.zip AS clientcitystatezip
           ,dbo.tblClient.fax AS clientfax
           ,dbo.tblClient.email AS clientemail
           ,ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS scheduler
           ,dbo.tblCase.marketercode AS marketer
           ,dbo.tblCase.dateadded AS datecalledin
           ,dbo.tblCase.dateofinjury AS DOI
           ,dbo.tblCase.allegation
           ,dbo.tblCase.notes
           ,dbo.tblCase.casetype
           ,'Dear ' + dbo.tblExaminee.firstname + ' '
            + dbo.tblExaminee.lastname AS examineesalutation
           ,dbo.tblCase.status
           ,dbo.tblCase.calledinby
           ,dbo.tblCase.chartnbr
           ,'Dear ' + dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientsalutation
           ,'Dear ' + dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname
            + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorsalutation
           ,dbo.tblLocation.insidedr
           ,dbo.tblLocation.email AS doctoremail
           ,dbo.tblLocation.fax AS doctorfax
           ,dbo.tblLocation.faxdrschedule
           ,dbo.tblLocation.medrcdletter
           ,dbo.tblLocation.drletter
           ,dbo.tblCase.reportverbal
           ,dbo.tblCase.datemedsrecd AS medsrecd
           ,tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname
           ,'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' '
            + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation
           ,tblCCAddress_2.company AS Pattorneycompany
           ,tblCCAddress_2.address1 AS Pattorneyaddr1
           ,tblCCAddress_2.address2 AS Pattorneyaddr2
           ,tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  '
            + tblCCAddress_2.zip AS Pattorneycitystatezip
           ,tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone
           ,tblCCAddress_2.fax AS Pattorneyfax
           ,tblCCAddress_2.email AS Pattorneyemail
           ,tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname
           ,'Dear ' + ISNULL(tblCCAddress_1.firstname, '') + ' '
            + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation
           ,tblCCAddress_1.company AS Dattorneycompany
           ,tblCCAddress_1.address1 AS Dattorneyaddr1
           ,tblCCAddress_1.address2 AS Dattorneyaddr2
           ,tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  '
            + tblCCAddress_1.zip AS Dattorneycitystatezip
           ,tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension,
                                                '') AS Dattorneyphone
           ,tblCCAddress_1.fax AS Dattorneyfax
           ,tblCCAddress_1.email AS Dattorneyemail
           ,tblCCAddress_1.fax
           ,dbo.tblCase.typemedsrecd
           ,dbo.tblCase.plaintiffattorneycode
           ,dbo.tblCase.defenseattorneycode
           ,dbo.tblCase.servicecode
           ,dbo.tblCase.faxPattny
           ,dbo.tblCase.faxdoctor
           ,dbo.tblCase.faxclient
           ,dbo.tblCase.emailclient
           ,dbo.tblCase.emaildoctor
           ,dbo.tblCase.emailPattny
           ,dbo.tblCase.invoicedate
           ,dbo.tblCase.invoiceamt
           ,dbo.tblCase.commitdate
           ,dbo.tblCase.WCBNbr
           ,dbo.tblCase.specialinstructions
           ,dbo.tblCase.priority
           ,dbo.tblServices.description AS servicedesc
           ,dbo.tblCase.usdvarchar1 AS caseusdvarchar1
           ,dbo.tblCase.usdvarchar2 AS caseusdvarchar2
           ,dbo.tblCase.usddate1 AS caseusddate1
           ,dbo.tblCase.usddate2 AS caseusddate2
           ,dbo.tblCase.usdtext1 AS caseusdtext1
           ,dbo.tblCase.usdtext2 AS caseusdtext2
           ,dbo.tblCase.usdint1 AS caseusdint1
           ,dbo.tblCase.usdint2 AS caseusdint2
           ,dbo.tblCase.usdmoney1 AS caseusdmoney1
           ,dbo.tblCase.usdmoney2 AS caseusdmoney2
           ,dbo.tblClient.title AS clienttitle
           ,dbo.tblClient.prefix AS clientprefix
           ,dbo.tblClient.suffix AS clientsuffix
           ,dbo.tblClient.usdvarchar1 AS clientusdvarchar1
           ,dbo.tblClient.usdvarchar2 AS clientusdvarchar2
           ,dbo.tblClient.usddate1 AS clientusddate1
           ,dbo.tblClient.usddate2 AS clientusddate2
           ,dbo.tblClient.usdtext1 AS clientusdtext1
           ,dbo.tblClient.usdtext2 AS clientusdtext2
           ,dbo.tblClient.usdint1 AS clientusdint1
           ,dbo.tblClient.usdint2 AS clientusdint2
           ,dbo.tblClient.usdmoney1 AS clientusdmoney1
           ,dbo.tblClient.usdmoney2 AS clientusdmoney2
           ,dbo.tblDoctor.notes AS doctornotes
           ,dbo.tblDoctor.prefix AS doctorprefix
           ,dbo.tblDoctor.addr1 AS doctorcorrespaddr1
           ,dbo.tblDoctor.addr2 AS doctorcorrespaddr2
           ,dbo.tblDoctor.city + ', ' + dbo.tblDoctor.state + '  '
            + dbo.tblDoctor.zip AS doctorcorrespcitystatezip
           ,dbo.tblDoctor.phone + ' ' + ISNULL(dbo.tblDoctor.phoneExt, ' ') AS doctorcorrespphone
           ,dbo.tblDoctor.faxNbr AS doctorcorrespfax
           ,dbo.tblDoctor.emailAddr AS doctorcorrespemail
           ,dbo.tblDoctor.qualifications
           ,dbo.tblDoctor.prepaid
           ,dbo.tblDoctor.county AS doctorcorrespcounty
           ,dbo.tblLocation.county AS doctorcounty
           ,dbo.tblLocation.vicinity AS doctorvicinity
           ,dbo.tblExaminee.county AS examineecounty
           ,dbo.tblExaminee.prefix AS examineeprefix
           ,dbo.tblExaminee.usdvarchar1 AS examineeusdvarchar1
           ,dbo.tblExaminee.usdvarchar2 AS examineeusdvarchar2
           ,dbo.tblExaminee.usddate1 AS examineeusddate1
           ,dbo.tblExaminee.usddate2 AS examineeusddate2
           ,dbo.tblExaminee.usdtext1 AS examineeusdtext1
           ,dbo.tblExaminee.usdtext2 AS examineeusdtext2
           ,dbo.tblExaminee.usdint1 AS examineeusdint1
           ,dbo.tblExaminee.usdint2 AS examineeusdint2
           ,dbo.tblExaminee.usdmoney1 AS examineeusdmoney1
           ,dbo.tblExaminee.usdmoney2 AS examineeusdmoney2
           ,dbo.tblDoctor.usdvarchar1 AS doctorusdvarchar1
           ,dbo.tblDoctor.usdvarchar2 AS doctorusdvarchar2
           ,dbo.tblDoctor.usddate1 AS doctorusddate1
           ,dbo.tblDoctor.usddate2 AS doctorusddate2
           ,dbo.tblDoctor.usdtext1 AS doctorusdtext1
           ,dbo.tblDoctor.usdtext2 AS doctorusdtext2
           ,dbo.tblDoctor.usdint1 AS doctorusdint1
           ,dbo.tblDoctor.usdint2 AS doctorusdint2
           ,dbo.tblDoctor.usdmoney1 AS doctorusdmoney1
           ,dbo.tblDoctor.usdmoney2 AS doctorusdmoney2
           ,dbo.tblCase.schedulenotes
           ,dbo.tblCase.requesteddoc
           ,dbo.tblCompany.usdvarchar1 AS companyusdvarchar1
           ,dbo.tblCompany.usdvarchar2 AS companyusdvarchar2
           ,dbo.tblCompany.usddate1 AS companyusddate1
           ,dbo.tblCompany.usddate2 AS companyusddate2
           ,dbo.tblCompany.usdtext1 AS companyusdtext1
           ,dbo.tblCompany.usdtext2 AS companyusdtext2
           ,dbo.tblCompany.usdint1 AS companyusdint1
           ,dbo.tblCompany.usdint2 AS companyusdint2
           ,dbo.tblCompany.usdmoney1 AS companyusdmoney1
           ,dbo.tblCompany.usdmoney2 AS companyusdmoney2
           ,dbo.tblDoctor.WCNbr AS doctorwcnbr
           ,dbo.tblCaseType.description AS casetypedesc
           ,dbo.tblLocation.location
           ,dbo.tblCase.sinternalcasenbr AS internalcasenbr
           ,dbo.tblDoctor.credentials AS doctordegree
           ,dbo.tblSpecialty.description AS specialtydesc
           ,dbo.tblExaminee.note AS chartnotes
           ,dbo.tblExaminee.fax AS examineefax
           ,dbo.tblExaminee.email AS examineeemail
           ,dbo.tblExaminee.insured AS examineeinsured
           ,dbo.tblCase.clientcode
           ,dbo.tblCase.feecode
           ,dbo.tblClient.companycode
           ,dbo.tblClient.notes AS clientnotes
           ,dbo.tblCompany.notes AS companynotes
           ,dbo.tblClient.billaddr1
           ,dbo.tblClient.billaddr2
           ,dbo.tblClient.billcity
           ,dbo.tblClient.billstate
           ,dbo.tblClient.billzip
           ,dbo.tblClient.billattn
           ,dbo.tblClient.ARKey
           ,dbo.tblCase.icd9code
           ,dbo.tblDoctor.remitattn
           ,dbo.tblDoctor.remitaddr1
           ,dbo.tblDoctor.remitaddr2
           ,dbo.tblDoctor.remitcity
           ,dbo.tblDoctor.remitstate
           ,dbo.tblDoctor.remitzip
           ,dbo.tblCase.doctorspecialty
           ,dbo.tblServices.shortdesc
           ,dbo.tblDoctor.licensenbr AS doctorlicense
           ,dbo.tblLocation.notes AS doctorlocationnotes
           ,dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontact
           ,'Dear ' + dbo.tblLocation.contactfirst + ' '
            + dbo.tblLocation.contactlast AS doctorlocationcontactsalutation
           ,dbo.tblRecordStatus.description AS medsstatus
           ,dbo.tblExaminee.employer
           ,dbo.tblExaminee.treatingphysician
           ,dbo.tblExaminee.city AS examineecity
           ,dbo.tblExaminee.state AS examineestate
           ,dbo.tblExaminee.zip AS examineezip
           ,dbo.tblDoctor.SSNTaxID AS DoctorTaxID
           ,dbo.tblCase.billclientcode AS casebillclientcode
           ,dbo.tblCase.billaddr1 AS casebilladdr1
           ,dbo.tblCase.billaddr2 AS casebilladdr2
           ,dbo.tblCase.billcity AS casebillcity
           ,dbo.tblCase.billstate AS casebillstate
           ,dbo.tblCase.billzip AS casebillzip
           ,dbo.tblCase.billARKey AS casebillarkey
           ,dbo.tblCase.billcompany AS casebillcompany
           ,dbo.tblCase.billcontact AS casebillcontact
           ,dbo.tblSpecialty.specialtycode
           ,dbo.tblDoctorLocation.correspondence AS doctorcorrespondence
           ,dbo.tblExaminee.lastname AS examineelastname
           ,dbo.tblExaminee.firstname AS examineefirstname
           ,dbo.tblCase.billfax AS casebillfax
           ,dbo.tblClient.billfax AS clientbillfax
           ,dbo.tblCase.officecode
           ,dbo.tblDoctor.lastname AS doctorlastname
           ,dbo.tblDoctor.firstname AS doctorfirstname
           ,dbo.tblDoctor.middleinitial AS doctormiddleinitial
           ,ISNULL(LEFT(dbo.tblDoctor.firstname, 1), '')
            + ISNULL(LEFT(dbo.tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(dbo.tblDoctor.lastname, 1), '') AS doctorinitials
           ,dbo.tblCase.QARep
           ,dbo.tblClient.lastname AS clientlastname
           ,dbo.tblClient.firstname AS clientfirstname
           ,tblCCAddress_1.prefix AS dattorneyprefix
           ,tblCCAddress_1.lastname AS dattorneylastname
           ,tblCCAddress_1.firstname AS dattorneyfirstname
           ,tblCCAddress_2.prefix AS pattorneyprefix
           ,tblCCAddress_2.lastname AS pattorneylastname
           ,tblCCAddress_2.firstname AS pattorneyfirstname
           ,dbo.tblLocation.contactprefix AS doctorlocationcontactprefix
           ,dbo.tblLocation.contactfirst AS doctorlocationcontactfirstname
           ,dbo.tblLocation.contactlast AS doctorlocationcontactlastname
           ,dbo.tblExaminee.middleinitial AS examineemiddleinitial
           ,dbo.tblCase.ICD9Code2
           ,dbo.tblCase.ICD9Code3
           ,dbo.tblCase.ICD9Code4
           ,dbo.tblExaminee.InsuredAddr1
           ,dbo.tblExaminee.InsuredCity
           ,dbo.tblExaminee.InsuredState
           ,dbo.tblExaminee.InsuredZip
           ,dbo.tblExaminee.InsuredSex
           ,dbo.tblExaminee.InsuredRelationship
           ,dbo.tblExaminee.InsuredPhone
           ,dbo.tblExaminee.InsuredPhoneExt
           ,dbo.tblExaminee.InsuredFax
           ,dbo.tblExaminee.InsuredEmail
           ,dbo.tblExaminee.ExamineeStatus
           ,dbo.tblExaminee.TreatingPhysicianAddr1
           ,dbo.tblExaminee.TreatingPhysicianCity
           ,dbo.tblExaminee.TreatingPhysicianState
           ,dbo.tblExaminee.TreatingPhysicianZip
           ,dbo.tblExaminee.TreatingPhysicianPhone
           ,dbo.tblExaminee.TreatingPhysicianPhoneExt
           ,dbo.tblExaminee.TreatingPhysicianFax
           ,dbo.tblExaminee.TreatingPhysicianEmail
           ,dbo.tblExaminee.TreatingPhysicianLicenseNbr
           ,dbo.tblExaminee.TreatingPhysicianTaxID
           ,dbo.tblExaminee.EmployerAddr1
           ,dbo.tblExaminee.EmployerCity
           ,dbo.tblExaminee.EmployerState
           ,dbo.tblExaminee.EmployerZip
           ,dbo.tblExaminee.EmployerPhone
           ,dbo.tblExaminee.EmployerPhoneExt
           ,dbo.tblExaminee.EmployerFax
           ,dbo.tblExaminee.EmployerEmail
           ,dbo.tblExaminee.Country
           ,dbo.tblDoctor.UPIN
           ,dbo.tblDoctor.schedulepriority
           ,dbo.tblDoctor.feecode AS drfeecode
           ,dbo.tblCase.PanelNbr
           ,dbo.tblstate.StateName AS Jurisdiction
           ,dbo.tblCase.photoRqd
           ,dbo.tblCase.CertMailNbr
           ,dbo.tblCase.HearingDate
           ,dbo.tblCase.DoctorName
           ,dbo.tblLocation.state AS doctorstate
           ,dbo.tblClient.state AS clientstate
           ,dbo.tblDoctor.state AS doctorcorrespstate
           ,tblCCAddress_1.state AS dattorneystate
           ,tblCCAddress_2.state AS pattorneystate

           ,dbo.tblacctingtrans.apptdate
           ,CASE WHEN EWReferralType=2 THEN dbo.tblCase.doctorcode ELSE dbo.tblAcctingTrans.DrOpCode END AS doctorCode
           ,CASE WHEN EWReferralType=2 THEN dbo.tblCase.doctorlocation ELSE dbo.tblAcctingTrans.doctorlocation END AS doctorLocation
           ,dbo.tblacctingtrans.documentnbr
           ,dbo.tblacctingtrans.type AS documenttype
           ,dbo.tblacctingtrans.appttime

           ,dbo.tblCase.prevappt
           ,dbo.tblLocation.state
           ,dbo.tblClient.state AS Expr1
           ,dbo.tblDoctor.state AS Expr2
           ,tblCCAddress_1.state AS Expr3
           ,tblCCAddress_2.state AS Expr4
           ,dbo.tblLocation.city AS doctorcity
           ,dbo.tblLocation.zip AS doctorzip
           ,dbo.tblClient.city AS clientcity
           ,dbo.tblClient.zip AS clientzip
           ,dbo.tblExaminee.policynumber
           ,tblCCAddress_2.city AS pattorneycity
           ,tblCCAddress_2.zip AS pattorneyzip
           ,dbo.tblCase.mastercasenbr
           ,dbo.tblDoctorSchedule.duration AS ApptDuration
           ,dbo.tblDoctor.companyname AS PracticeName
           ,dbo.tblCase.AssessmentToAddress
           ,dbo.tblCase.OCF25Date
           ,dbo.tblCase.AssessingFacility
           ,dbo.tblCase.DateForminDispute
           ,dbo.tblExaminee.EmployerContactFirstName
           ,dbo.tblExaminee.EmployerContactLastName
           ,dbo.tblDoctor.NPINbr AS DoctorNPINbr
           ,dbo.tblProviderType.description AS DoctorProviderType
           ,dbo.tblDoctor.ProvTypeCode
           ,dbo.tblCase.DateReceived
           ,dbo.tblCase.usddate3 AS caseusddate3
           ,dbo.tblCase.usddate4 AS caseusddate4
           ,dbo.tblCase.usddate5 AS caseusddate5
           ,dbo.tblCase.UsdBit1 AS caseusdboolean1
           ,dbo.tblCase.UsdBit2 AS caseusdboolean2
           ,dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3
           ,dbo.tblDoctor.usddate5 AS doctorusddate5
           ,dbo.tblDoctor.usddate6 AS doctorusddate6
           ,dbo.tblDoctor.usddate7 AS doctorusddate7
           ,dbo.tblDoctor.usddate3 AS doctorusddate3
           ,dbo.tblDoctor.usddate4 AS doctorusddate4
           ,dbo.tblacctingtrans.SeqNO
           ,dbo.tblOffice.usdvarchar1 AS officeusdvarchar1
           ,dbo.tblOffice.usdvarchar2 AS officeusdvarchar2
           ,dbo.tblCase.ClaimNbrExt
           ,dbo.tblCase.sreqspecialty AS RequestedSpecialty
           ,tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname
           ,'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' '
            + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation
           ,tblCCAddress_3.company AS DParaLegalcompany
           ,tblCCAddress_3.address1 AS DParaLegaladdr1
           ,tblCCAddress_3.address2 AS DParaLegaladdr2
           ,tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  '
            + tblCCAddress_3.zip AS DParaLegalcitystatezip
           ,tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension,
                                                '') AS DParaLegalphone
           ,tblCCAddress_3.email AS DParaLegalemail
           ,tblCCAddress_3.fax AS DParaLegalfax
           ,dbo.tblCase.AttorneyNote
           ,dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc
           ,dbo.tblCase.ExternalDueDate
           ,dbo.tblCase.InternalDueDate
           ,dbo.tblLocation.ExtName AS LocationExtName
           ,dbo.tblVenue.County AS Venue
           ,dbo.tblOffice.description AS Office
           ,dbo.tblCase.ForecastDate
           
    FROM    dbo.tblCase
            INNER JOIN dbo.tblExaminee ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblacctingtrans ON dbo.tblCase.casenbr = dbo.tblacctingtrans.casenbr
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            
            LEFT OUTER JOIN dbo.tblVenue ON dbo.tblCase.VenueID = dbo.tblVenue.VenueID
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_3 ON dbo.tblCase.DefParaLegal = tblCCAddress_3.cccode
            LEFT OUTER JOIN dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode
            
            LEFT OUTER JOIN dbo.tblDoctor ON CASE WHEN EWReferralType=2 THEN dbo.tblCase.doctorcode ELSE dbo.tblAcctingTrans.DrOpCode END = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblLocation ON CASE WHEN EWReferralType=2 THEN dbo.tblCase.doctorlocation ELSE dbo.tblAcctingTrans.doctorlocation END = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctorLocation ON dbo.tblCase.doctorlocation = dbo.tblDoctorLocation.locationcode
                                                     AND dbo.tblCase.doctorcode = dbo.tblDoctorLocation.doctorcode

            LEFT OUTER JOIN dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode
            LEFT OUTER JOIN dbo.tblProviderType ON dbo.tblDoctor.ProvTypeCode = dbo.tblProviderType.ProvTypeCode
            
            LEFT OUTER JOIN dbo.tblstate ON dbo.tblCase.Jurisdiction = dbo.tblstate.Statecode
            LEFT OUTER JOIN dbo.tblRecordStatus ON dbo.tblCase.reccode = dbo.tblRecordStatus.reccode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_1 ON dbo.tblCase.defenseattorneycode = tblCCAddress_1.cccode
            LEFT OUTER JOIN dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode


GO

DROP VIEW [vwReferralbyMonthAppt]
GO


CREATE VIEW [dbo].[vwReferralbyMonthAppt]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.status, dbo.tblCase.doctorlocation AS locationcode, dbo.tblCase.marketercode, dbo.tblCase.clientcode, 
                      dbo.tblClient.companycode,
                      ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer,
                      dbo.tblCase.dateadded, 
                      dbo.tblCompany.intname AS companyname, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.lastname, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname, dbo.tblLocation.location, YEAR(dbo.tblCase.ApptDate) AS year, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 1 THEN 1 ELSE 0 END AS jan, CASE WHEN month(dbo.tblCase.apptdate) = 2 THEN 1 ELSE 0 END AS feb, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 3 THEN 1 ELSE 0 END AS mar, CASE WHEN month(dbo.tblCase.apptdate) = 4 THEN 1 ELSE 0 END AS apr, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 5 THEN 1 ELSE 0 END AS may, CASE WHEN month(dbo.tblCase.apptdate) = 6 THEN 1 ELSE 0 END AS jun, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 7 THEN 1 ELSE 0 END AS jul, CASE WHEN month(dbo.tblCase.apptdate) = 8 THEN 1 ELSE 0 END AS aug, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 9 THEN 1 ELSE 0 END AS sep, CASE WHEN month(dbo.tblCase.apptdate) = 10 THEN 1 ELSE 0 END AS oct, 
                      CASE WHEN month(dbo.tblCase.apptdate) = 11 THEN 1 ELSE 0 END AS nov, CASE WHEN month(dbo.tblCase.apptdate) = 12 THEN 1 ELSE 0 END AS dec,
                       1 AS total, dbo.tblCaseType.description AS CasetypeDesc, dbo.tblServices.description AS service, dbo.tblServices.servicecode, dbo.tblCase.casetype, 
                      dbo.tblCase.officecode, dbo.tblOffice.description AS officename, dbo.tblCase.QARep AS QARepCode, dbo.tblDoctor.doctorcode, 
                      dbo.tblcase.doctorlocation
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
WHERE     (dbo.tblCase.status <> 9)


GO

DROP VIEW [vwapptsbymth]
GO


CREATE VIEW [dbo].[vwapptsbymth]
AS
    SELECT DISTINCT
            dbo.tblCase.casenbr ,
            dbo.tblCase.doctorcode ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            dbo.tblCaseHistory.eventdesc ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            dbo.tblCaseHistory.type ,
            dbo.tblCase.ApptDate ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS adjustername ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.ApptDate) AS year ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 1
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS janns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 2
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS febns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 3
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS marns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 4
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS aprns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 5
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS mayns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 6
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS junns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 7
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS julns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 8
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS augns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 9
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS sepns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 10
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS octns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 11
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS novns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 12
                      AND ( dbo.tblCaseHistory.type ) = 'NoShow' THEN 1
                 ELSE 0
            END AS decns ,
            1 AS total ,
            CASE WHEN dbo.tblCaseHistory.type = 'NoShow'
                      OR dbo.tblCase.status = 9 THEN 1
                 ELSE 0
            END AS totalns ,
            dbo.tblCase.officecode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblCaseHistory ON dbo.tblCase.casenbr = dbo.tblCaseHistory.casenbr
    WHERE   ( dbo.tblCaseHistory.type = 'Show' )
            OR ( dbo.tblCaseHistory.type = 'NoShow' )


GO

DROP VIEW [vwdocument]
GO


CREATE VIEW [dbo].[vwdocument]
AS
SELECT  dbo.tblCase.casenbr,
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
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS scheduler,
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
   dbo.tblcase.defparalegal,
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

DROP VIEW [vwReferralbyMonthDateReceived]
GO

CREATE VIEW [dbo].[vwReferralbyMonthDateReceived]
AS
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )

GO

DROP VIEW [vwReferralbyMonthDateReceivedDocs]
GO


CREATE VIEW [dbo].[vwReferralbyMonthDateReceivedDocs]
AS
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepCode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
    UNION
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            INNER JOIN dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr
            INNER JOIN dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
    WHERE   ( dbo.tblCase.status <> 9 )


GO

DROP VIEW [vwmarketer]
GO



CREATE VIEW [dbo].[vwmarketer]
AS
    SELECT DISTINCT TOP 100 PERCENT
            dbo.tblUser.userid ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS Marketer
    FROM    dbo.tblUser
            INNER JOIN dbo.tblUserOffice ON dbo.tblUser.userid = dbo.tblUserOffice.userid
    WHERE   ( dbo.tblUser.usertype = 'MK' )
            OR ( dbo.tblUser.usertype = '*' )
    ORDER BY Marketer



GO

DROP VIEW [vwscheduler]
GO



CREATE VIEW [dbo].[vwscheduler]
AS
    SELECT DISTINCT
            dbo.tblUser.userid ,
            ISNULL(LastName,'') + CASE WHEN ISNULL(LastName,'')='' OR ISNULL(FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(FirstName, '') AS Scheduler
    FROM    dbo.tblUser
            INNER JOIN dbo.tblUserOffice ON dbo.tblUser.userid = dbo.tblUserOffice.userid
    WHERE   ( dbo.tblUser.usertype = 'SC' )
            OR ( dbo.tblUser.usertype = '*' )



GO

DROP VIEW [vwStatusNew]
GO



CREATE VIEW [dbo].[vwStatusNew]
AS
    SELECT DISTINCT
            dbo.tblCase.casenbr
           ,dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename
           ,CASE WHEN dbo.tblcase.panelnbr IS NULL
                 THEN dbo.tbldoctor.lastname + ', '
                      + ISNULL(dbo.tbldoctor.firstname, ' ')
                 ELSE dbo.tblcase.doctorname
            END AS doctorname
           ,dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname
           ,ISNULL(Scheduler.LastName,'') + CASE WHEN ISNULL(Scheduler.LastName,'')='' OR ISNULL(Scheduler.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Scheduler.FirstName, '') AS schedulername
           ,ISNULL(Marketer.LastName,'') + CASE WHEN ISNULL(Marketer.LastName,'')='' OR ISNULL(Marketer.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Marketer.FirstName, '') AS marketername
           ,dbo.tblCompany.intname AS companyname
           ,dbo.tblCase.priority
           ,dbo.tblCase.ApptDate
           ,dbo.tblCase.status
           ,dbo.tblCase.dateadded
           ,dbo.tblCase.requesteddoc
           ,dbo.tblCase.doctorcode
           ,dbo.tblCase.marketercode
           ,dbo.tblQueues.statusdesc
           ,dbo.tblServices.shortdesc AS service
           ,dbo.tblCase.doctorlocation
           ,dbo.tblClient.companycode
           ,dbo.tblCase.servicecode
           ,dbo.tblCase.QARep AS QARepCode
           ,dbo.tblCase.schedulercode
           ,dbo.tblCase.officecode
           ,dbo.tblCase.PanelNbr
           ,dbo.tblUserSecurity.userid
           ,dbo.tblGroupFunction.functioncode
           ,dbo.tblCase.casetype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblCompany.companycode = dbo.tblClient.companycode
            INNER JOIN dbo.tblServices ON dbo.tblServices.servicecode = dbo.tblCase.servicecode
            INNER JOIN dbo.tblUserOffice ON dbo.tblUserOffice.officecode = dbo.tblCase.officecode
            INNER JOIN dbo.tblUserSecurity ON dbo.tblUserOffice.userid = dbo.tblUserSecurity.userid
                                              AND dbo.tblUserOffice.officecode = dbo.tblUserSecurity.officecode
            INNER JOIN dbo.tblGroupFunction ON dbo.tblGroupFunction.groupcode = dbo.tblUserSecurity.groupcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblUser AS Scheduler ON dbo.tblCase.schedulercode = Scheduler.UserID
            LEFT OUTER JOIN dbo.tblUser AS Marketer ON Marketer.UserID = dbo.tblCase.marketercode
            LEFT OUTER JOIN dbo.tblQueues ON dbo.tblQueues.statuscode = dbo.tblCase.status
    WHERE   (dbo.tblGroupFunction.functioncode = 'viewcase')

GO



--------------------------------------------------------
--New doctor fields for WA State and National ID
--------------------------------------------------------

ALTER TABLE [tblDoctor]
  ADD [WAProviderStateID] VARCHAR(20)
GO

ALTER TABLE [tblDoctor]
  ADD [WAProviderNationalID] VARCHAR(20)
GO



DROP PROCEDURE [spDoctors]
GO


CREATE PROCEDURE [dbo].[spDoctors]
AS 
    SELECT  dbo.tblDoctor.*
    FROM    dbo.tblDoctor
    WHERE   ( OPType = 'Dr' )
    ORDER BY lastname

GO


INSERT  INTO tbluserfunction
        ( functioncode ,
          functiondesc
        )
        SELECT  'SetDoctorWashingtonIDs' ,
                'Doctor - Set Washington IDs'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'SetDoctorWashingtonIDs' )

GO




--------------------------------------------------------------
--Add a default value in company for Case Tye and Jurisdiction
--------------------------------------------------------------

ALTER TABLE [tblCompany]
  ADD [CaseType] INTEGER
GO

ALTER TABLE [tblCompany]
  ADD [Jurisdiction] VARCHAR(5)
GO

DROP VIEW [vwCompany]
GO


CREATE VIEW [dbo].[vwCompany]
AS
    SELECT TOP 100 PERCENT
            tblCompany.*
    FROM    tblCompany
    ORDER BY intname


GO

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
            dbo.tblClient.photoRqd ,
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


UPDATE tblControl SET DBVersion='1.60'
GO
