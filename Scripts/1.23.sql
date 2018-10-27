-------------------------------------------------------
--Corrected Referrals by Month Report when run by Doctor and date called in
-------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwReferralbyMonthCalledInDocs]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[vwReferralbyMonthCalledInDocs]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.vwReferralbyMonthCalledInDocs
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.status, dbo.tblCase.doctorlocation AS locationcode, dbo.tblCase.marketercode, dbo.tblCase.clientcode, 
                      dbo.tblClient.companycode, dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer, dbo.tblCase.dateadded, 
                      dbo.tblCompany.intname AS companyname, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.lastname, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname, dbo.tblLocation.location, YEAR(dbo.tblCase.dateadded) AS year, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 1 THEN 1 ELSE 0 END AS jan, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 2 THEN 1 ELSE 0 END AS feb, CASE WHEN month(dbo.tblCase.dateadded) = 3 THEN 1 ELSE 0 END AS mar, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 4 THEN 1 ELSE 0 END AS apr, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 5 THEN 1 ELSE 0 END AS may, CASE WHEN month(dbo.tblCase.dateadded) = 6 THEN 1 ELSE 0 END AS jun, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 7 THEN 1 ELSE 0 END AS jul, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 8 THEN 1 ELSE 0 END AS aug, CASE WHEN month(dbo.tblCase.dateadded) = 9 THEN 1 ELSE 0 END AS sep, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 10 THEN 1 ELSE 0 END AS oct, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 11 THEN 1 ELSE 0 END AS nov, CASE WHEN month(dbo.tblCase.dateadded) = 12 THEN 1 ELSE 0 END AS dec, 1 AS total, 
                      dbo.tblCaseType.description AS CasetypeDesc, dbo.tblServices.description AS service, dbo.tblServices.servicecode, dbo.tblCase.casetype, 
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
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname, dbo.tblLocation.location, YEAR(dbo.tblCase.dateadded) AS year, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 1 THEN 1 ELSE 0 END AS jan, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 2 THEN 1 ELSE 0 END AS feb, CASE WHEN month(dbo.tblCase.dateadded) = 3 THEN 1 ELSE 0 END AS mar, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 4 THEN 1 ELSE 0 END AS apr, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 5 THEN 1 ELSE 0 END AS may, CASE WHEN month(dbo.tblCase.dateadded) = 6 THEN 1 ELSE 0 END AS jun, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 7 THEN 1 ELSE 0 END AS jul, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 8 THEN 1 ELSE 0 END AS aug, CASE WHEN month(dbo.tblCase.dateadded) = 9 THEN 1 ELSE 0 END AS sep, 
                      CASE WHEN month(dbo.tblCase.dateadded) = 10 THEN 1 ELSE 0 END AS oct, CASE WHEN month(dbo.tblCase.dateadded) 
                      = 11 THEN 1 ELSE 0 END AS nov, CASE WHEN month(dbo.tblCase.dateadded) = 12 THEN 1 ELSE 0 END AS dec, 1 AS total, 
                      dbo.tblCaseType.description AS CasetypeDesc, dbo.tblServices.description AS service, dbo.tblServices.servicecode, dbo.tblCase.casetype, 
                      dbo.tblCase.officecode, dbo.tblOffice.description AS officename, dbo.tblCase.QARep AS QARepcode, dbo.tblDoctor.doctorcode
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


----------------------------------------------------------------
--Increase tblEWFacility Phone and Fax size
----------------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ALTER COLUMN [AcctingPhone] VARCHAR(25)
GO

ALTER TABLE [tblEWFacility]
  ALTER COLUMN [AcctingFax] VARCHAR(25)
GO
ALTER TABLE [tblEWFacility]
  ALTER COLUMN [Phone] VARCHAR(25)
GO
ALTER TABLE [tblEWFacility]
  ALTER COLUMN [Fax] VARCHAR(25)
GO

----------------------------------------------------------------
--Corrected name of user function for Show/No Show report by month
----------------------------------------------------------------

update tbluserfunction 
set functiondesc = 'Report - Show/NoShow by Month'
where functioncode = 'apptbymthrpt'
go


-----------------------------------------------------
--Change by Gary for Web Portal
-----------------------------------------------------

/****** Object:  StoredVIEW [vw_WebCaseSummary]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[vw_WebCaseSummary]') AND OBJECTPROPERTY(id,N'IsView') = 1)
DROP VIEW [vw_WebCaseSummary];
GO

CREATE VIEW vw_WebCaseSummary

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
	
GO

----------------------------------------------------------
--Add new GPGLAcctNo
----------------------------------------------------------

ALTER TABLE tblEWBusLine
 ADD [GPGLAcctPart] VARCHAR(2)
GO

----------------------------------------------------------
--Add three new system tables
----------------------------------------------------------

CREATE TABLE [tblEWFacilityGroup] (
  [EWFacilityGroupID] INTEGER IDENTITY(1,1) NOT NULL,
  [GroupName] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [CategoryID] INTEGER,
  [SeqNo] INTEGER,
  CONSTRAINT [PK_FacilityGroup] PRIMARY KEY CLUSTERED ([EWFacilityGroupID])
)
GO

CREATE TABLE [tblEWFacilityGroupCategory] (
  [CategoryID] INTEGER NOT NULL,
  [CategoryName] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [SeqNo] INTEGER,
  CONSTRAINT [PK_FacilityGroupCategory] PRIMARY KEY CLUSTERED ([CategoryID])
)
GO

CREATE TABLE [tblEWFacilityGroupDetail] (
  [EWFacilityGroupID] INTEGER NOT NULL,
  [EWFacilityID] INTEGER NOT NULL,
  CONSTRAINT [PK_FacilityGroupDetail] PRIMARY KEY CLUSTERED ([EWFacilityGroupID],[EWFacilityID])
)
GO


update tblControl set DBVersion='1.23'
GO
