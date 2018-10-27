

--------------------------------------------
--Change from Gary
--------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vw_WebCoverLetterInfo]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW [vw_WebCoverLetterInfo];
GO

CREATE VIEW vw_WebCoverLetterInfo

AS

SELECT
	--case     
	tblCase.casenbr AS Casenbr,
	tblCase.chartnbr AS Chartnbr,
	tblCase.doctorlocation AS Doctorlocation,
	tblCase.clientcode AS clientcode,
	tblCase.Appttime AS Appttime,
	tblCase.dateofinjury AS DOI,
	tblCase.usddate1 AS DOI2,
	tblCase.usddate2 AS DOI3,
	tblCase.usddate3 AS DOI4,
	tblCase.notes AS Casenotes,
	tblCase.DoctorName AS doctorformalname,
	tblCase.ClaimNbrExt AS ClaimNbrExt,
	tblCase.Jurisdiction AS Jurisdiction,
	tblCase.ApptDate AS Apptdate,
	tblCase.claimnbr AS claimnbr,
	tblCase.doctorspecialty AS Specialtydesc,
	
	--examinee
	tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblExaminee.addr1 AS examineeaddr1,
	tblExaminee.addr2 AS examineeaddr2,
	tblExaminee.city AS ExamineeCity,
	tblExaminee.state AS ExamineeState,
	tblExaminee.zip AS ExamineeZip,
	tblExaminee.phone1 AS examineephone,
	tblExaminee.SSN AS ExamineeSSN,
	tblExaminee.sex AS ExamineeSex,
	tblExaminee.DOB AS ExamineeDOB,
	tblExaminee.insured AS insured,
	tblExaminee.employer AS Employer,
	tblExaminee.treatingphysician AS TreatingPhysician,
	tblExaminee.EmployerAddr1 AS Employeraddr1,
	tblExaminee.EmployerCity AS Employercity,
	tblExaminee.EmployerState AS Employerstate,
	tblExaminee.EmployerZip AS Employerzip,
	tblExaminee.EmployerPhone AS Employerphone,
	tblExaminee.EmployerFax AS Employerfax,
	tblExaminee.EmployerEmail AS Employeremail,
	
	--case type
	tblCaseType.description AS Casetype,

	--service
	tblServices.description AS servicedesc,
	
	--client
	tblClient.firstname + ' ' + tblClient.lastname AS clientname,
	tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
	tblClient.phone1 AS clientphone,
	tblClient.fax AS Clientfax,
	
	--company
	tblCompany.intname company,
	
	--defense attorney
	cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
	cc1.company AS dattorneycompany,
	cc1.address1 AS dattorneyaddr1,
	cc1.address2 AS dattorneyaddr2,
	cc1.phone AS dattorneyphone,
	cc1.fax AS dattorneyfax,
	cc1.email AS dattorneyemail,
	
	--plaintiff attorney
	cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
	cc2.company AS pattorneycompany,
	cc2.address1 AS pattorneyaddr1,
	cc2.address2 AS pattorneyaddr2,
	cc2.phone AS pattorneyphone,
	cc2.fax AS pattorneyfax,
	cc2.email AS pattorneyemail,
	
	--doctor
	'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation,

	--problems
	tblProblem.description AS Problems

FROM  tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER JOIN	tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN	tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN	tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN	tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN	tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
	LEFT OUTER JOIN	tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
	LEFT OUTER JOIN	tblCaseProblem ON tblCase.casenbr = tblCaseProblem.casenbr
	LEFT OUTER JOIN	tblProblem ON tblCaseProblem.problemcode = tblProblem.problemcode
	
	
	
GO

--------------------------------------------
--Corrected invoice rounding issue with taxes
--------------------------------------------
ALTER VIEW [dbo].[vwInvoiceTax]
AS
SELECT TOP 100 PERCENT dbo.TblAcctHeader.documentnbr, dbo.TblAcctDetail.prodcode, dbo.tblproduct.description AS productdesc, 
dbo.tblProductTax.taxcode, dbo.tblTaxState.statecode, dbo.TblTaxTable.description, dbo.TblTaxTable.rate, dbo.TblAcctDetail.extendedamount, 
ROUND(CAST(dbo.TblTaxTable.rate AS numeric(10, 2)) * dbo.TblAcctDetail.extendedamount, 2) AS taxamount, dbo.TblAcctHeader.documenttype, dbo.TblAcctDetail.date, 
dbo.TblAcctDetail.DrOPCode, dbo.TblAcctDetail.taxable, dbo.tblacctingtrans.doctorlocation, 
CASE WHEN dbo.tblproducttax.taxcode = 'QST' THEN 1 ELSE 0 END AS sortorder, tblacctdetail.linenbr
FROM dbo.TblAcctHeader INNER JOIN
dbo.TblAcctDetail ON dbo.TblAcctHeader.documentnbr = dbo.TblAcctDetail.documentnbr AND 
dbo.TblAcctHeader.documenttype = dbo.TblAcctDetail.documenttype INNER JOIN
dbo.tblProductTax ON dbo.TblAcctDetail.prodcode = dbo.tblProductTax.prodcode INNER JOIN
dbo.tblTaxState ON dbo.tblProductTax.taxcode = dbo.tblTaxState.taxcode INNER JOIN
dbo.tblLocation ON dbo.tblTaxState.statecode = dbo.tblLocation.state INNER JOIN
dbo.TblTaxTable ON dbo.tblTaxState.taxcode = dbo.TblTaxTable.taxcode INNER JOIN
dbo.tblproduct ON dbo.TblAcctDetail.prodcode = dbo.tblproduct.prodcode INNER JOIN
dbo.tblacctingtrans ON dbo.TblAcctHeader.documentnbr = dbo.tblacctingtrans.documentnbr AND 
dbo.TblAcctHeader.documenttype = dbo.tblacctingtrans.type AND dbo.TblAcctHeader.casenbr = dbo.tblacctingtrans.casenbr AND 
dbo.tblLocation.locationcode = dbo.tblacctingtrans.doctorlocation
WHERE (dbo.tblacctdetail.taxable = 1)
ORDER BY CASE WHEN dbo.tblproducttax.taxcode = 'QST' THEN 1 ELSE 0 END

go

--------------------------------------------------
--Add a new CountryCode to EWFacility table
--------------------------------------------------

ALTER TABLE [dbo].[tblEWFacility] ADD
[CountryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL

GO

ALTER TABLE [dbo].[tblEWFacilityGroup] ADD
[CountryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO


--------------------------------------------------
--Add a new EWParentCompany table and link from tblCompany to it
--------------------------------------------------

CREATE TABLE [tblEWParentCompany] (
  [ParentCompanyID] INTEGER IDENTITY(1,1) NOT NULL,
  [Name] VARCHAR(40) NOT NULL,
  [GPParentCustomerID] VARCHAR(15),
  CONSTRAINT [PK_EWParentCompany] PRIMARY KEY ([ParentCompanyID])
)
GO

CREATE UNIQUE INDEX [IdxEWParentCompany_UNIQUE_Name] ON [tblEWParentCompany]([Name])
GO


ALTER TABLE [tblCompany]
  ADD [ParentCompanyID] INTEGER
GO

DROP VIEW [vwcompany]
GO

CREATE VIEW [vwCompany]
AS
    SELECT TOP 100 PERCENT
            dbo.tblCompany.*
    FROM    dbo.tblCompany
    ORDER BY intname

GO

INSERT  INTO tbluserfunction
        ( functioncode ,
          functiondesc
        )
        SELECT  'CompanySetParentCompany' ,
                'Company - Set Parent Company'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CompanySetParentCompany' )

GO

-- new columns needed for data conversions

ALTER TABLE [tblDocument]
  ADD [OldKey] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

Alter table dbo.tblCCAddress Add
	[OldKey] [int] NULL
go

INSERT INTO [tbllanguage] ([Description])VALUES('Creole')

go



UPDATE tblControl SET DBVersion='1.51'
GO
