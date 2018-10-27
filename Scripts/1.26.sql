------------------------------------------------------------
--HCAI Changes
------------------------------------------------------------
ALTER TABLE [dbo].[tblAcctDetail] ADD
[HCAIProviderOccupation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[tblDoctor] ADD
[HCAIProviderRegistryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[tblClient] ADD
[HCAIInsurerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HCAIBranchID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[tblAcctHeader] ADD
[HCAIInsurerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HCAIBranchID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE tblIMEData
	ADD UseHCAIInterface BIT NOT NULL DEFAULT 0
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwOfficeIMEData]
AS
SELECT     dbo.tblOffice.officecode, dbo.tblIMEData.companyname, dbo.tblIMEData.addr1, dbo.tblIMEData.addr2, dbo.tblIMEData.city, dbo.tblIMEData.state, dbo.tblIMEData.zip, 
                      dbo.tblIMEData.phone, dbo.tblIMEData.fax, dbo.tblIMEData.website, dbo.tblIMEData.emailaddress, dbo.tblIMEData.logo, dbo.tblIMEData.dirtemplate, 
                      dbo.tblIMEData.dirdocument, dbo.tblIMEData.dirdirections, dbo.tblIMEData.noshowltrdocument, dbo.tblIMEData.emailcapability, dbo.tblIMEData.faxcapability, 
                      dbo.tblIMEData.labelcapability, dbo.tblIMEData.supportcompany, dbo.tblIMEData.supportemail, dbo.tblIMEData.faxservername, dbo.tblIMEData.faxcoverpage, 
                      dbo.tblIMEData.useridadded, dbo.tblIMEData.dateadded, dbo.tblIMEData.useridedited, dbo.tblIMEData.dateedited, dbo.tblIMEData.distanceUofM, 
                      dbo.tblIMEData.medsrecddocument, dbo.tblIMEData.serialnumber, dbo.tblIMEData.daystocancel, dbo.tblIMEData.orderccdropdown, dbo.tblIMEData.imecreate, 
                      dbo.tblIMEData.requirepdf, dbo.tblIMEData.verbaldocument, dbo.tblIMEData.verbalqueue, dbo.tblIMEData.brqinternalcasenbr, dbo.tblIMEData.sortcasehistorydesc, 
                      dbo.tblIMEData.infeecode, dbo.tblIMEData.vofeecode, dbo.tblIMEData.nextinvoicenbr, dbo.tblIMEData.indocumentcode, dbo.tblIMEData.vodocumentcode, 
                      dbo.tblIMEData.accountingsystem, dbo.tblIMEData.createvouchers, dbo.tblIMEData.Invoicedesc, dbo.tblIMEData.defARAcctnbr, dbo.tblIMEData.defAPAcctnbr, 
                      dbo.tblIMEData.nextvouchernbr, dbo.tblIMEData.imeaccount, dbo.tblIMEData.stdterms, dbo.tblIMEData.nextbatchnbr, dbo.tblIMEData.taxcode, 
                      dbo.tblIMEData.invoicecopies, dbo.tblIMEData.dirimport, dbo.tblIMEData.vouchercopies, dbo.tblIMEData.invoicedate, dbo.tblIMEData.sourcedirectory, 
                      dbo.tblIMEData.country, dbo.tblIMEData.QBCustMask, dbo.tblIMEData.QBVendorMask, dbo.tblIMEData.IMEcode, dbo.tblIMEData.QAfterNoShow, 
                      dbo.tblIMEData.UsePanelExam, dbo.tblIMEData.blnUseSubCases, dbo.tblIMEData.ShowOntarioAutoFields, dbo.tblIMEData.dirAcctDocument, 
                      dbo.tblIMEData.DefaultAddressLabel, dbo.tblIMEData.DefaultCaseLabel, dbo.tblIMEData.UseBillingCompany, dbo.tblIMEData.InvoiceNoShows, 
                      dbo.tblIMEData.InvoiceLateCancels, dbo.tblIMEData.VoucherNoShows, dbo.tblIMEData.VoucherLateCancels, dbo.tblIMEData.ShowEWFacilityOnInvVo, 
                      dbo.tblIMEData.ShowProductDescOnClaimForm, dbo.tblIMEData.ShowClientAsReferringProvider, dbo.tblIMEData.UseHCAIInterface
FROM         dbo.tblOffice INNER JOIN
                      dbo.tblIMEData ON dbo.tblOffice.imecode = dbo.tblIMEData.IMEcode
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  StoredProcedure [proc_tblHCAIBatch_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_tblHCAIBatch_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_tblHCAIBatch_Insert];
GO

CREATE PROCEDURE [proc_tblHCAIBatch_Insert]
(
	@HCAIBatchNumber int = NULL output,
	@dateadded datetime,
	@useridadded varchar(50)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblHCAIBatch]
	(
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error

	SELECT @HCAIBatchNumber = SCOPE_IDENTITY()

	RETURN @Err
END
GO
/****** Object:  StoredTABLE [tblHCAIInsurer]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[tblHCAIInsurer]') AND OBJECTPROPERTY(id,N'IsTABLE') = 1)
    DROP TABLE [tblHCAIInsurer];
GO

CREATE TABLE [tblHCAIInsurer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InsurerName] [varchar](50) NULL,
	[InsurerID] [varchar](50) NULL,
	[BranchName] [varchar](50) NULL,
	[BranchID] [varchar](50) NULL,
 CONSTRAINT [PK_tblHCAIInsurer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




/****** Object:  StoredTABLE [tblHCAIProvider]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[tblHCAIProvider]') AND OBJECTPROPERTY(id,N'IsTABLE') = 1)
    DROP TABLE [tblHCAIProvider];
GO

CREATE TABLE [tblHCAIProvider](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[ProviderRegistryID] [varchar](50) NULL,
	[ProviderOccupation] [varchar](50) NULL,
	[RegistrationNumber] [varchar](50) NULL,
 CONSTRAINT [PK_tblHCAIProvider] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  StoredVIEW [vwexportsummary]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[vwexportsummary]') AND OBJECTPROPERTY(id,N'IsVIEW') = 1)
    DROP VIEW [vwexportsummary];
GO

CREATE VIEW [vwexportsummary]
AS
SELECT     TOP (100) PERCENT tblCase.casenbr, TblAcctHeader.documenttype, TblAcctHeader.documentnbr, tblacctingtrans.statuscode, 
                      tblQueues.statusdesc, tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, tblacctingtrans.DrOpType, 
                      CASE ISNULL(tblcase.panelnbr, 0) WHEN 0 THEN CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tbldoctor.lastname, '') 
                      + ', ' + ISNULL(tbldoctor.firstname, '') WHEN '' THEN ISNULL(tbldoctor.lastname, '') + ', ' + ISNULL(tbldoctor.firstname, '') 
                      WHEN '' THEN ISNULL(tblcase.doctorname, '') 
                      WHEN 'OP' THEN tbldoctor.companyname END ELSE CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tblcase.doctorname, '') 
                      WHEN '' THEN ISNULL(tblcase.doctorname, '') WHEN 'OP' THEN tbldoctor.companyname END END AS doctorname, 
                      tblClient.lastname + ', ' + tblClient.firstname AS clientname, tblCompany.intname AS companyname, tblCase.priority, tblCase.ApptDate, 
                      tblCase.dateadded, tblCase.claimnbr, tblCase.doctorlocation, tblCase.Appttime, tblCase.dateedited, tblCase.useridedited, 
                      tblClient.email AS adjusteremail, tblClient.fax AS adjusterfax, tblCase.marketercode, tblCase.useridadded, TblAcctHeader.documentdate, 
                      TblAcctHeader.INBatchSelect, TblAcctHeader.VOBatchSelect, TblAcctHeader.taxcode, TblAcctHeader.taxtotal, TblAcctHeader.documenttotal, 
                      TblAcctHeader.documentstatus, tblCase.clientcode, tblCase.doctorcode, TblAcctHeader.batchnbr, tblCase.officecode, tblCase.schedulercode, 
                      tblClient.companycode, tblCase.QARep, tblCase.PanelNbr, DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ, 
                      tblCase.mastersubcase, tblqueues_1.statusdesc AS CaseStatus, tblacctingtrans.SeqNO
FROM         TblAcctHeader INNER JOIN
                      tblacctingtrans ON TblAcctHeader.seqno = tblacctingtrans.SeqNO INNER JOIN
                      tblCase ON TblAcctHeader.casenbr = tblCase.casenbr LEFT OUTER JOIN
                      tblCompany ON TblAcctHeader.CompanyCode = tblCompany.companycode LEFT OUTER JOIN
                      tblClient ON TblAcctHeader.ClientCode = tblClient.clientcode INNER JOIN
                      tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode INNER JOIN
                      tblQueues AS tblqueues_1 ON tblCase.status = tblqueues_1.statuscode LEFT OUTER JOIN
                      tblDoctor ON TblAcctHeader.DrOpCode = tblDoctor.doctorcode LEFT OUTER JOIN
                      tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
WHERE     (tblacctingtrans.statuscode <> 20) AND (TblAcctHeader.batchnbr IS NULL) AND (TblAcctHeader.documentstatus = 'Final')
ORDER BY TblAcctHeader.documentdate, tblCase.priority, tblCase.ApptDate

GO


-------------------------------------------------------------------
--Add new invoice remit address fields to tblEWFacility
-------------------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ADD [RemitAddress] VARCHAR(50)
GO

ALTER TABLE [tblEWFacility]
  ADD [RemitCity] VARCHAR(20)
GO

ALTER TABLE [tblEWFacility]
  ADD [RemitState] VARCHAR(2)
GO

ALTER TABLE [tblEWFacility]
  ADD [RemitZip] VARCHAR(10)
GO



update tblControl set DBVersion='1.26'
GO