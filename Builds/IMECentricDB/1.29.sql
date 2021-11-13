-------------------------------------------------------------------
--SQL Changes required for Cortex EDI interface dml 11/2/10
-------------------------------------------------------------------

ALTER TABLE [tblIMEData]
  ADD [NextEDIBatchNbr] INTEGER 
GO

update tblIMEData
	set NextEDIBatchNbr = 100
GO

ALTER TABLE [tblOffice]
  ADD [UseEDIExport] BIT Default(0)
GO

update tblOffice
	set UseEDIExport = 0
GO

ALTER TABLE [tblAcctHeader]
  ADD [EDIBatchNbr] INTEGER 
GO

ALTER TABLE [tblCompany]
  ADD [EDIFormat] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER TABLE [tblClaimInfo]
  ADD [BillingProviderNonNPINbr] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS
GO
ALTER TABLE [tbloffice]
  ADD [BillingProviderNonNPINbr] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwcompany]
AS
SELECT      TOP 100 PERCENT dbo.tblCompany.*
FROM          dbo.tblCompany
ORDER BY intname
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

insert into tbluserfunction(functioncode, functiondesc) values('EDIExport', 'Accounting - EDI Export')
go

SET IDENTITY_INSERT dbo.tblQueues ON
INSERT INTO [tblqueues] ([statuscode],[statusdesc],[type],[shortdesc],[displayorder],[formtoopen],[dateadded],[dateedited],[useridadded],[useridedited],[status],[subtype],[functioncode])VALUES(22,'Invoices Awaiting EDI Export','System','EDI',450,'frmStatusEDIExport','Sep  8 2010  8:42:41:000AM','Sep  8 2010  8:43:17:000AM','admin','admin','Active','Case','EDIExport')
SET IDENTITY_INSERT dbo.tblQueues OFF
go


ALTER VIEW [dbo].[vwOfficeIMEData]
AS
SELECT     dbo.tblOffice.officecode, dbo.tblIMEData.*
FROM         dbo.tblOffice INNER JOIN
                      dbo.tblIMEData ON dbo.tblOffice.imecode = dbo.tblIMEData.IMEcode
GO


------------------------------------------------------------------
--Field changes for Doctor Credentialing
------------------------------------------------------------------

ALTER TABLE [tblDoctor]
  ADD [CredentialingNotes] VARCHAR(50)
GO

EXEC sp_rename '[tblDoctor].[CredentialingLastUpdate]', 'CredentialingUpdated', 'COLUMN'
GO


INSERT  INTO tbluserfunction
        (
          functioncode,
          functiondesc
        )
        SELECT  'EWDoctorPanel',
                'Doctor - ExamWorks Doctor Panel'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'EWDoctorPanel' )

GO
INSERT  INTO tbluserfunction
        (
          functioncode,
          functiondesc
        )
        SELECT  'DrCredentialingStatus',
                'Doctor - Credentialing Status'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'DrCredentialingStatus' )

GO

UPDATE tblDoctor SET DateLastUsed=
    (SELECT MAX(ISNULL(CASE WHEN apptdate>GETDATE() THEN documentdate ELSE apptdate END, documentdate))
     FROM tblAcctingTrans AS a
     WHERE tblDoctor.doctorcode = a.DrOPCode AND a.type='VO' AND ISNULL(a.result,'')='' AND a.statusCode=20)
     WHERE DateLastUsed IS NULL
GO
update tblControl set DBVersion='1.29'
GO