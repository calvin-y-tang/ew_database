
--Modify sp_BuildUserOfficeTalbes to prevent FunctionCode get truncated to 15 chars,
--and instead of using cursor, use join to get better performance
DROP VIEW vwusersecurity
GO
CREATE VIEW vwUserSecurity
AS
    SELECT  tblUserSecurity.GroupCode ,
            tblUserOffice.OfficeCode ,
            tblUserSecurity.UserID ,
            tblGroupFunction.FunctionCode
    FROM    tblUserOffice
            INNER JOIN tblUserSecurity ON tblUserOffice.userid = tblUserSecurity.userid
                                          AND tblUserOffice.officecode = tblUserSecurity.officecode
            INNER JOIN tblGroupFunction ON tblUserSecurity.groupcode = tblGroupFunction.groupcode

GO

DROP PROC sp_buildUserOfficeTables
GO
CREATE PROC sp_buildUserOfficeTables
    @sUserID VARCHAR(100) ,
    @sUserGroup VARCHAR(100)
AS 
    IF @sUserID = ''
        AND @sUserGroup = '' 
        BEGIN
            DELETE  FROM tblUserOfficeFunction
            INSERT  INTO tblUserOfficeFunction
                    ( UserID ,
                      OfficeCode ,
                      FunctionCode 
                    )
                    SELECT  DISTINCT
                            UserID ,
                            OfficeCode ,
                            FunctionCode
                    FROM    vwUserSecurity
        END

    ELSE 
        IF @sUserGroup <> '' 
            BEGIN
                DELETE  FROM tblUserOfficeFunction
                WHERE   UserID IN ( SELECT  UserID
                                    FROM    tblUserSecurity
                                    WHERE   GroupCode = @sUserGroup )
                INSERT  INTO tblUserOfficeFunction
                        ( UserID ,
                          OfficeCode ,
                          FunctionCode 
                        )
                        SELECT  DISTINCT
                                UserID ,
                                OfficeCode ,
                                FunctionCode
                        FROM    vwUserSecurity
                        WHERE   UserID IN ( SELECT  UserID
                                            FROM    tblUserSecurity
                                            WHERE   GroupCode = @sUserGroup )

            END

        ELSE 
            IF @sUserid <> '' 
                BEGIN
                    DELETE  FROM tblUserOfficeFunction
                    WHERE   UserID = @sUserID
                    INSERT  INTO tblUserOfficeFunction
                            ( UserID ,
                              OfficeCode ,
                              FunctionCode 
                            )
                            SELECT  DISTINCT
                                    UserID ,
                                    OfficeCode ,
                                    FunctionCode
                            FROM    vwUserSecurity
                            WHERE   UserID = @sUserID
                END
GO



DROP VIEW vwAcctingSummary
GO

CREATE VIEW vwAcctingSummary
AS
    SELECT TOP 100 PERCENT
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
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
            tblCase.dateadded ,
            tblCase.claimnbr ,
            ISNULL(tblLocation_1.locationcode, tblCase.doctorlocation) AS doctorlocation ,
            tblCase.shownoshow ,
            tblCase.transcode ,
            tblCase.rptstatus ,
            tblCase.dateedited ,
            tblCase.useridedited ,
            tblCase.apptselect ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.requesteddoc ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.datedrchart ,
            tblCase.drchartselect ,
            tblCase.inqaselect ,
            tblCase.intransselect ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.awaittransselect ,
            tblCase.chartprepselect ,
            tblCase.apptrptsselect ,
            tblCase.transreceived ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblCase.useridadded ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.notes ,
            tblDoctor.notes AS doctornotes ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            ISNULL(tblLocation_1.location, tblLocation.location) AS location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result ,
            tblCase.mastersubcase ,
            tblcase.billingnote ,
            tblcasetype.description AS CaseType ,
            tblAcctingTrans.ApptStatusID ,
            tblAcctingTrans.CaseApptID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblcasetype ON tblcasetype.code = tblcase.casetype
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblLocation tblLocation_1 ON tblacctingtrans.doctorlocation = tblLocation_1.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )
    ORDER BY tblCase.ApptDate


GO


DROP VIEW vwDocumentAccting
GO
CREATE VIEW vwDocumentAccting
AS
    SELECT  tblCase.casenbr ,
            tblCase.claimnbr ,
            tblExaminee.addr1 AS examineeaddr1 ,
            tblExaminee.addr2 AS examineeaddr2 ,
            tblExaminee.city + ', ' + tblExaminee.state + '  '
            + tblExaminee.zip AS examineecitystatezip ,
            tblExaminee.SSN ,
            tblClient.firstname + ' ' + tblClient.lastname AS clientname ,
            tblCompany.extname AS company ,
            tblClient.phone1 + ' ' + ISNULL(tblClient.phone1ext, ' ') AS clientphone ,
            tblClient.phone2 + ' ' + ISNULL(tblClient.phone2ext, ' ') AS clientphone2 ,
            tblLocation.addr1 AS doctoraddr1 ,
            tblLocation.addr2 AS doctoraddr2 ,
            tblLocation.city + ', ' + tblLocation.state + '  '
            + tblLocation.zip AS doctorcitystatezip ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename ,
            tblExaminee.phone1 AS examineephone ,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblLocation.Phone AS doctorphone ,
            tblClient.addr1 AS clientaddr1 ,
            tblClient.addr2 AS clientaddr2 ,
            tblClient.city + ', ' + tblClient.state + '  '
            + tblClient.zip AS clientcitystatezip ,
            tblClient.fax AS clientfax ,
            tblClient.email AS clientemail ,
            ISNULL(tblUser.lastname, '')
            + CASE WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstname, '') AS scheduler ,
            tblCase.marketercode AS marketer ,
            tblCase.dateadded AS datecalledin ,
            tblCase.dateofinjury AS DOI ,
            tblCase.allegation ,
            tblCase.notes ,
            tblCase.casetype ,
            'Dear ' + tblExaminee.firstname + ' '
            + tblExaminee.lastname AS examineesalutation ,
            tblCase.status ,
            tblCase.calledinby ,
            tblCase.chartnbr ,
            'Dear ' + tblClient.firstname + ' ' + tblClient.lastname AS clientsalutation ,
            'Dear ' + tblDoctor.firstname + ' ' + tblDoctor.lastname
            + ', ' + ISNULL(tblDoctor.credentials, '') AS doctorsalutation ,
            tblLocation.insidedr ,
            tblLocation.email AS doctoremail ,
            tblLocation.fax AS doctorfax ,
            tblLocation.faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblCase.reportverbal ,
            tblCase.datemedsrecd AS medsrecd ,
            tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname ,
            'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' '
            + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation ,
            tblCCAddress_2.company AS Pattorneycompany ,
            tblCCAddress_2.address1 AS Pattorneyaddr1 ,
            tblCCAddress_2.address2 AS Pattorneyaddr2 ,
            tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  '
            + tblCCAddress_2.zip AS Pattorneycitystatezip ,
            tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone ,
            tblCCAddress_2.fax AS Pattorneyfax ,
            tblCCAddress_2.email AS Pattorneyemail ,
            tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname ,
            'Dear ' + ISNULL(tblCCAddress_1.firstname, '') + ' '
            + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation ,
            tblCCAddress_1.company AS Dattorneycompany ,
            tblCCAddress_1.address1 AS Dattorneyaddr1 ,
            tblCCAddress_1.address2 AS Dattorneyaddr2 ,
            tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  '
            + tblCCAddress_1.zip AS Dattorneycitystatezip ,
            tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension,
                                                '') AS Dattorneyphone ,
            tblCCAddress_1.fax AS Dattorneyfax ,
            tblCCAddress_1.email AS Dattorneyemail ,
            tblCCAddress_1.fax ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffattorneycode ,
            tblCase.defenseattorneycode ,
            tblCase.servicecode ,
            tblCase.faxPattny ,
            tblCase.faxdoctor ,
            tblCase.faxclient ,
            tblCase.emailclient ,
            tblCase.emaildoctor ,
            tblCase.emailPattny ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.commitdate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblServices.description AS servicedesc ,
            tblCase.usdvarchar1 AS caseusdvarchar1 ,
            tblCase.usdvarchar2 AS caseusdvarchar2 ,
            tblCase.usddate1 AS caseusddate1 ,
            tblCase.usddate2 AS caseusddate2 ,
            tblCase.usdtext1 AS caseusdtext1 ,
            tblCase.usdtext2 AS caseusdtext2 ,
            tblCase.usdint1 AS caseusdint1 ,
            tblCase.usdint2 AS caseusdint2 ,
            tblCase.usdmoney1 AS caseusdmoney1 ,
            tblCase.usdmoney2 AS caseusdmoney2 ,
            tblClient.title AS clienttitle ,
            tblClient.prefix AS clientprefix ,
            tblClient.suffix AS clientsuffix ,
            tblClient.usdvarchar1 AS clientusdvarchar1 ,
            tblClient.usdvarchar2 AS clientusdvarchar2 ,
            tblClient.usddate1 AS clientusddate1 ,
            tblClient.usddate2 AS clientusddate2 ,
            tblClient.usdtext1 AS clientusdtext1 ,
            tblClient.usdtext2 AS clientusdtext2 ,
            tblClient.usdint1 AS clientusdint1 ,
            tblClient.usdint2 AS clientusdint2 ,
            tblClient.usdmoney1 AS clientusdmoney1 ,
            tblClient.usdmoney2 AS clientusdmoney2 ,
            tblDoctor.notes AS doctornotes ,
            tblDoctor.prefix AS doctorprefix ,
            tblDoctor.addr1 AS doctorcorrespaddr1 ,
            tblDoctor.addr2 AS doctorcorrespaddr2 ,
            tblDoctor.city + ', ' + tblDoctor.state + '  '
            + tblDoctor.zip AS doctorcorrespcitystatezip ,
            tblDoctor.phone + ' ' + ISNULL(tblDoctor.phoneExt, ' ') AS doctorcorrespphone ,
            tblDoctor.faxNbr AS doctorcorrespfax ,
            tblDoctor.emailAddr AS doctorcorrespemail ,
            tblDoctor.qualifications ,
            tblDoctor.prepaid ,
            tblDoctor.county AS doctorcorrespcounty ,
            tblLocation.county AS doctorcounty ,
            tblLocation.vicinity AS doctorvicinity ,
            tblExaminee.county AS examineecounty ,
            tblExaminee.prefix AS examineeprefix ,
            tblExaminee.usdvarchar1 AS examineeusdvarchar1 ,
            tblExaminee.usdvarchar2 AS examineeusdvarchar2 ,
            tblExaminee.usddate1 AS examineeusddate1 ,
            tblExaminee.usddate2 AS examineeusddate2 ,
            tblExaminee.usdtext1 AS examineeusdtext1 ,
            tblExaminee.usdtext2 AS examineeusdtext2 ,
            tblExaminee.usdint1 AS examineeusdint1 ,
            tblExaminee.usdint2 AS examineeusdint2 ,
            tblExaminee.usdmoney1 AS examineeusdmoney1 ,
            tblExaminee.usdmoney2 AS examineeusdmoney2 ,
            tblDoctor.usdvarchar1 AS doctorusdvarchar1 ,
            tblDoctor.usdvarchar2 AS doctorusdvarchar2 ,
            tblDoctor.usddate1 AS doctorusddate1 ,
            tblDoctor.usddate2 AS doctorusddate2 ,
            tblDoctor.usdtext1 AS doctorusdtext1 ,
            tblDoctor.usdtext2 AS doctorusdtext2 ,
            tblDoctor.usdint1 AS doctorusdint1 ,
            tblDoctor.usdint2 AS doctorusdint2 ,
            tblDoctor.usdmoney1 AS doctorusdmoney1 ,
            tblDoctor.usdmoney2 AS doctorusdmoney2 ,
            tblCase.schedulenotes ,
            tblCase.requesteddoc ,
            tblCompany.usdvarchar1 AS companyusdvarchar1 ,
            tblCompany.usdvarchar2 AS companyusdvarchar2 ,
            tblCompany.usddate1 AS companyusddate1 ,
            tblCompany.usddate2 AS companyusddate2 ,
            tblCompany.usdtext1 AS companyusdtext1 ,
            tblCompany.usdtext2 AS companyusdtext2 ,
            tblCompany.usdint1 AS companyusdint1 ,
            tblCompany.usdint2 AS companyusdint2 ,
            tblCompany.usdmoney1 AS companyusdmoney1 ,
            tblCompany.usdmoney2 AS companyusdmoney2 ,
            tblDoctor.WCNbr AS doctorwcnbr ,
            tblCaseType.description AS casetypedesc ,
            tblLocation.location ,
            tblCase.sinternalcasenbr AS internalcasenbr ,
            tblDoctor.credentials AS doctordegree ,
            tblSpecialty.description AS specialtydesc ,
            tblExaminee.note AS chartnotes ,
            tblExaminee.fax AS examineefax ,
            tblExaminee.email AS examineeemail ,
            tblExaminee.insured AS examineeinsured ,
            tblCase.clientcode ,
            tblCase.feecode ,
            tblClient.companycode ,
            tblClient.notes AS clientnotes ,
            tblCompany.notes AS companynotes ,
            tblClient.billaddr1 ,
            tblClient.billaddr2 ,
            tblClient.billcity ,
            tblClient.billstate ,
            tblClient.billzip ,
            tblClient.billattn ,
            tblClient.ARKey ,
            tblCase.icd9code ,
            tblDoctor.remitattn ,
            tblDoctor.remitaddr1 ,
            tblDoctor.remitaddr2 ,
            tblDoctor.remitcity ,
            tblDoctor.remitstate ,
            tblDoctor.remitzip ,
            tblCase.doctorspecialty ,
            tblServices.shortdesc ,
            tblDoctor.licensenbr AS doctorlicense ,
            tblLocation.notes AS doctorlocationnotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS doctorlocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' '
            + tblLocation.contactlast AS doctorlocationcontactsalutation ,
            tblRecordStatus.description AS medsstatus ,
            tblExaminee.employer ,
            tblExaminee.treatingphysician ,
            tblExaminee.city AS examineecity ,
            tblExaminee.state AS examineestate ,
            tblExaminee.zip AS examineezip ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblCase.billclientcode AS casebillclientcode ,
            tblCase.billaddr1 AS casebilladdr1 ,
            tblCase.billaddr2 AS casebilladdr2 ,
            tblCase.billcity AS casebillcity ,
            tblCase.billstate AS casebillstate ,
            tblCase.billzip AS casebillzip ,
            tblCase.billARKey AS casebillarkey ,
            tblCase.billcompany AS casebillcompany ,
            tblCase.billcontact AS casebillcontact ,
            tblSpecialty.specialtycode ,
            tblDoctorLocation.correspondence AS doctorcorrespondence ,
            tblExaminee.lastname AS examineelastname ,
            tblExaminee.firstname AS examineefirstname ,
            tblCase.billfax AS casebillfax ,
            tblClient.billfax AS clientbillfax ,
            tblCase.officecode ,
            tblDoctor.lastname AS doctorlastname ,
            tblDoctor.firstname AS doctorfirstname ,
            tblDoctor.middleinitial AS doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstname, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastname, 1), '') AS doctorinitials ,
            tblCase.QARep ,
            tblClient.lastname AS clientlastname ,
            tblClient.firstname AS clientfirstname ,
            tblCCAddress_1.prefix AS dattorneyprefix ,
            tblCCAddress_1.lastname AS dattorneylastname ,
            tblCCAddress_1.firstname AS dattorneyfirstname ,
            tblCCAddress_2.prefix AS pattorneyprefix ,
            tblCCAddress_2.lastname AS pattorneylastname ,
            tblCCAddress_2.firstname AS pattorneyfirstname ,
            tblLocation.contactprefix AS doctorlocationcontactprefix ,
            tblLocation.contactfirst AS doctorlocationcontactfirstname ,
            tblLocation.contactlast AS doctorlocationcontactlastname ,
            tblExaminee.middleinitial AS examineemiddleinitial ,
            tblCase.ICD9Code2 ,
            tblCase.ICD9Code3 ,
            tblCase.ICD9Code4 ,
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
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.Country ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feecode AS drfeecode ,
            tblCase.PanelNbr ,
            tblState.StateName AS Jurisdiction ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblLocation.state AS doctorstate ,
            tblClient.state AS clientstate ,
            tblDoctor.state AS doctorcorrespstate ,
            tblCCAddress_1.state AS dattorneystate ,
            tblCCAddress_2.state AS pattorneystate ,
            tblAcctingTrans.apptdate ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode
                 ELSE tblAcctingTrans.DrOpCode
            END AS doctorCode ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation
                 ELSE tblAcctingTrans.doctorlocation
            END AS doctorLocation ,
            tblAcctingTrans.documentnbr ,
            tblAcctingTrans.type AS documenttype ,
            tblAcctingTrans.appttime ,
            tblCase.prevappt ,
            tblLocation.state ,
            tblClient.state AS Expr1 ,
            tblDoctor.state AS Expr2 ,
            tblCCAddress_1.state AS Expr3 ,
            tblCCAddress_2.state AS Expr4 ,
            tblLocation.city AS doctorcity ,
            tblLocation.zip AS doctorzip ,
            tblClient.city AS clientcity ,
            tblClient.zip AS clientzip ,
            tblExaminee.policynumber ,
            tblCCAddress_2.city AS pattorneycity ,
            tblCCAddress_2.zip AS pattorneyzip ,
            tblCase.mastercasenbr ,
            tblDoctorSchedule.duration AS ApptDuration ,
            tblDoctor.companyname AS PracticeName ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblExaminee.EmployerContactFirstName ,
            tblExaminee.EmployerContactLastName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblProviderType.description AS DoctorProviderType ,
            tblDoctor.ProvTypeCode ,
            tblCase.DateReceived ,
            tblCase.usddate3 AS caseusddate3 ,
            tblCase.usddate4 AS caseusddate4 ,
            tblCase.usddate5 AS caseusddate5 ,
            tblCase.UsdBit1 AS caseusdboolean1 ,
            tblCase.UsdBit2 AS caseusdboolean2 ,
            tblDoctor.usdvarchar3 AS doctorusdvarchar3 ,
            tblDoctor.usddate5 AS doctorusddate5 ,
            tblDoctor.usddate6 AS doctorusddate6 ,
            tblDoctor.usddate7 AS doctorusddate7 ,
            tblDoctor.usddate3 AS doctorusddate3 ,
            tblDoctor.usddate4 AS doctorusddate4 ,
            tblAcctingTrans.SeqNO ,
            tblOffice.usdvarchar1 AS officeusdvarchar1 ,
            tblOffice.usdvarchar2 AS officeusdvarchar2 ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname ,
            'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' '
            + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation ,
            tblCCAddress_3.company AS DParaLegalcompany ,
            tblCCAddress_3.address1 AS DParaLegaladdr1 ,
            tblCCAddress_3.address2 AS DParaLegaladdr2 ,
            tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  '
            + tblCCAddress_3.zip AS DParaLegalcitystatezip ,
            tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension,
                                                '') AS DParaLegalphone ,
            tblCCAddress_3.email AS DParaLegalemail ,
            tblCCAddress_3.fax AS DParaLegalfax ,
            tblCase.AttorneyNote ,
            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblLocation.ExtName AS LocationExtName ,
            tblVenue.County AS Venue ,
            tblOffice.description AS Office ,
            tblCase.ForecastDate ,
            tblDoctor.PrintOnCheckAs ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree,
            tblAcctingTrans.CaseApptID
    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCase.DefParaLegal = tblCCAddress_3.cccode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedcode = tblDoctorSchedule.schedcode
            LEFT OUTER JOIN tblDoctor ON CASE WHEN EWReferralType = 2
                                                  THEN tblCase.doctorcode
                                                  ELSE tblAcctingTrans.DrOpCode
                                             END = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON CASE WHEN EWReferralType = 2
                                                    THEN tblCase.doctorlocation
                                                    ELSE tblAcctingTrans.doctorlocation
                                               END = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.doctorlocation = tblDoctorLocation.locationcode
                                                     AND tblCase.doctorcode = tblDoctorLocation.doctorcode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.Statecode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.reccode = tblRecordStatus.reccode
            LEFT OUTER JOIN tblUser ON tblCase.schedulercode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseattorneycode = tblCCAddress_1.cccode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffattorneycode = tblCCAddress_2.cccode
GO

ALTER TABLE tblEWParentCompany
 ADD SeqNo INT
GO


UPDATE tblControl SET DBVersion='2.01'
GO
