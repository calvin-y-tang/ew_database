
----------------------------------------------------------------
--Add a new system table
----------------------------------------------------------------

CREATE TABLE [tblEWFacilityGroupSummary] (
  [EWFacilityID] INTEGER NOT NULL,
  [Facility] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [RegionGroupID] INTEGER,
  [RegionGroupName] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [SubRegionGroupID] INTEGER,
  [SubRegionGroupName] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [BusUnitGroupID] INTEGER,
  [BusUnitGroupName] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  CONSTRAINT [PK_EWFacilityGroupSummary] PRIMARY KEY CLUSTERED ([EWFacilityID])
)
GO

----------------------------------------------------------------
--Changes for HCAI Interface - dml 09/17/10
----------------------------------------------------------------


CREATE TABLE [dbo].[tblEWUnitOfMeasure] (
	[UnitOfMeasureCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DateAdded] [datetime] NULL ,
	[UserIDAdded] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DateEdited] [datetime] NULL ,
	[UserIDEdited] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tblHCAIBatch] (
	[HCAIBatchNumber] [int] IDENTITY (100, 1) NOT NULL ,
	[DateAdded] [datetime] NULL ,
	[UserIDAdded] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblEWUnitOfMeasure] ADD 
	CONSTRAINT [PK_tblEWUnitOfMeasure] PRIMARY KEY  CLUSTERED 
	(
		[UnitOfMeasureCode]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblHCAIBatch] ADD 
	CONSTRAINT [PK_tblHCAIBatch] PRIMARY KEY  CLUSTERED 
	(
		[HCAIBatchNumber]
	)  ON [PRIMARY] 
GO


insert into tbluserfunction(functioncode, functiondesc) values('HCAIExport', 'Accounting - HCAI Export')
go

SET IDENTITY_INSERT dbo.tblQueues ON
go
INSERT INTO [tblqueues] ([statuscode],[statusdesc],[type],[shortdesc],[displayorder],[formtoopen],[dateadded],[dateedited],[useridadded],[useridedited],[status],[subtype],[functioncode],[WebStatusCode],[WebGUID],[NotifyScheduler],[NotifyQARep],[NotifyIMECompany])VALUES(21,'Invoices Awaiting Export to HCAI','System','HCAI',450,'frmStatusHCAIExport','Sep  8 2010  8:42:41:000AM','Sep  8 2010  8:43:17:000AM','admin','admin','Active','Case','HCAIExport',NULL,'419444A3-C069-48B3-8AB5-63A997FF816C',0,0,0)

go

SET IDENTITY_INSERT dbo.tblQueues OFF
go
insert into tblqueueforms (formname, description) values ('frmStatusHCAIExport', 'HCAI Export')
go

ALTER TABLE [tblAcctHeader] ADD
  [HCAIDocumentNumber] VARCHAR(60),
  [HCAIBatchNumber] int
GO

ALTER TABLE [tblProduct]
  ADD [UnitOfMeasureCode] VARCHAR(5) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER TABLE [tblAcctDetail]
  ADD [UnitOfMeasureCode] VARCHAR(5) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER TABLE [tblCaseTrans]
  ADD [UnitOfMeasureCode] VARCHAR(5) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('GD','Goods and Supplies','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('HR','Hour','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('KM','Kilometer','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('PG','Page','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('PR','Procedure','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
INSERT INTO [tblEWUnitOfMeasure] ([UnitOfMeasureCode],[Description],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES('SN','Session','Sep 15 2010 12:00:00:000AM','admin','Sep 15 2010 12:00:00:000AM','admin')
GO

-- view change needed for HCAI interface

ALTER VIEW [dbo].[vwexportsummary]
AS
SELECT     TOP (100) PERCENT dbo.tblCase.casenbr, dbo.TblAcctHeader.documenttype, dbo.TblAcctHeader.documentnbr, dbo.tblacctingtrans.statuscode, 
                      dbo.tblQueues.statusdesc, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblacctingtrans.DrOpType, 
                      CASE ISNULL(dbo.tblcase.panelnbr, 0) WHEN 0 THEN CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tbldoctor.lastname, '') 
                      + ', ' + ISNULL(dbo.tbldoctor.firstname, '') WHEN '' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + ISNULL(dbo.tbldoctor.firstname, '') 
                      WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') 
                      WHEN 'OP' THEN dbo.tbldoctor.companyname END ELSE CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tblcase.doctorname, '') 
                      WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') WHEN 'OP' THEN dbo.tbldoctor.companyname END END AS doctorname, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, dbo.tblCase.ApptDate, 
                      dbo.tblCase.dateadded, dbo.tblCase.claimnbr, dbo.tblCase.doctorlocation, dbo.tblCase.Appttime, dbo.tblCase.dateedited, dbo.tblCase.useridedited, 
                      dbo.tblClient.email AS adjusteremail, dbo.tblClient.fax AS adjusterfax, dbo.tblCase.marketercode, dbo.tblCase.useridadded, dbo.TblAcctHeader.documentdate, 
                      dbo.TblAcctHeader.INBatchSelect, dbo.TblAcctHeader.VOBatchSelect, dbo.TblAcctHeader.taxcode, dbo.TblAcctHeader.taxtotal, dbo.TblAcctHeader.documenttotal, 
                      dbo.TblAcctHeader.documentstatus, dbo.tblCase.clientcode, dbo.tblCase.doctorcode, dbo.TblAcctHeader.batchnbr, dbo.tblCase.officecode, dbo.tblCase.schedulercode, 
                      dbo.tblClient.companycode, dbo.tblCase.QARep, dbo.tblCase.PanelNbr, DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ, 
                      dbo.tblCase.mastersubcase, tblqueues_1.statusdesc AS CaseStatus, dbo.tblacctingtrans.SeqNO
FROM         dbo.TblAcctHeader INNER JOIN
                      dbo.tblacctingtrans ON dbo.TblAcctHeader.seqno = dbo.tblacctingtrans.SeqNO INNER JOIN
                      dbo.tblCase ON dbo.TblAcctHeader.casenbr = dbo.tblCase.casenbr LEFT OUTER JOIN
                      dbo.tblCompany ON dbo.TblAcctHeader.CompanyCode = dbo.tblCompany.companycode LEFT OUTER JOIN
                      dbo.tblClient ON dbo.TblAcctHeader.ClientCode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblQueues AS tblqueues_1 ON dbo.tblCase.status = tblqueues_1.statuscode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.TblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
WHERE     (dbo.tblacctingtrans.statuscode <> 20) AND (dbo.TblAcctHeader.batchnbr IS NULL) AND (dbo.TblAcctHeader.documentstatus = 'Final')
ORDER BY dbo.TblAcctHeader.documentdate, dbo.tblCase.priority, dbo.tblCase.ApptDate


GO


----------------------------------------------------------
--Custom table for POPB voucher auto creation
----------------------------------------------------------

CREATE TABLE [tblPOPBVoucher] (
  [DoctorCode] INTEGER,
  [Percentage] DECIMAL(10,2),
  [CaseDoctorPercentage] DECIMAL(10,2)
)
GO


update tblControl set DBVersion='1.24'
GO