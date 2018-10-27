ALTER TABLE [tblCaseHistory]
  ADD [Locked] BIT DEFAULT ((0)) NOT NULL
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vw_WebCaseSummary]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW [vw_WebCaseSummary];
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
                      dbo.tblCaseType.code, dbo.tblCaseType.description, dbo.tblCaseType.instructionfilename, dbo.tblCaseType.WebSynchDate, dbo.tblCaseType.WebID, 
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

DROP PROCEDURE [spExamineeCases]
GO


CREATE PROCEDURE [dbo].[spExamineeCases](@ChartNbr integer,
@userid varchar(30))
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ApptDate, dbo.tblCase.chartnbr, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblLocation.location, dbo.tblQueues.statusdesc, 
                      ISNULL(tblSpecialty_2.description, tblSpecialty_1.description) AS specialtydesc, tblSpecialty_1.description, dbo.tblServices.shortdesc, 
                      dbo.tblCase.mastersubcase, ISNULL(dbo.tblCase.mastercasenbr, dbo.tblCase.casenbr) AS mastercasenbr, dbo.tblCase.DoctorName,
                      dbo.tbloffice.shortdesc as Office
FROM         dbo.tblSpecialty tblSpecialty_2 RIGHT OUTER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblSpecialty tblSpecialty_1 ON dbo.tblCase.sreqspecialty = tblSpecialty_1.specialtycode ON 
                      tblSpecialty_2.specialtycode = dbo.tblCase.doctorspecialty LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode inner join
                      dbo.tbloffice on dbo.tbloffice.officecode = dbo.tblcase.officecode
WHERE     (dbo.tblCase.chartnbr = @chartnbr) AND (dbo.tblUserOffice.userid = @userid)
ORDER BY ISNULL(dbo.tblCase.mastercasenbr, dbo.tblCase.casenbr) DESC, dbo.tblCase.mastersubcase, dbo.tblCase.ApptDate DESC


GO

update tblControl set DBVersion='1.04'
GO