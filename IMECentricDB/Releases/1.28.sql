-------------------------------------------------------------------
--Added Servicecode to vwStatusAppt so filter on case tracker works when opening the Awaiting Appt Queues
-------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwstatusappt]
AS
SELECT     TOP (100) PERCENT dbo.tblCase.casenbr, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS schedulername, 
                      dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, dbo.tblCase.ApptDate, dbo.tblCase.status, dbo.tblCase.dateadded, dbo.tblCase.claimnbr, 
                      dbo.tblCase.doctorlocation, dbo.tblCase.Appttime, dbo.tblCase.shownoshow, dbo.tblCase.Transcode, dbo.tblCase.rptstatus, dbo.tblLocation.location, 
                      dbo.tblCase.dateedited, dbo.tblCase.useridedited, dbo.tblCase.apptselect, dbo.tblClient.email AS clientemail, dbo.tblClient.fax AS clientfax, dbo.tblCase.marketercode, 
                      dbo.tblCase.requesteddoc, dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.datedrchart, dbo.tblCase.drchartselect, dbo.tblCase.inqaselect, 
                      dbo.tblCase.intransselect, dbo.tblCase.billedselect, dbo.tblCase.awaittransselect, dbo.tblCase.chartprepselect, dbo.tblCase.apptrptsselect, dbo.tblCase.transreceived, 
                      dbo.tblTranscription.transcompany, dbo.tblServices.shortdesc AS service, dbo.tblCase.doctorcode, dbo.tblClient.companycode, dbo.tblCase.officecode, 
                      dbo.tblCase.schedulercode, dbo.tblCase.QARep, DATEDIFF(day, dbo.tblCase.laststatuschg, GETDATE()) AS IQ, dbo.tblCase.laststatuschg, 
                      CASE WHEN dbo.tblcase.panelnbr IS NULL THEN dbo.tbldoctor.lastname + ', ' + isnull(dbo.tbldoctor.firstname, ' ') ELSE dbo.tblcase.doctorname END AS doctorname, 
                      dbo.tblCase.PanelNbr, dbo.tblQueues.functioncode, dbo.tblUserOfficeFunction.userid, dbo.tblCase.servicecode
FROM         dbo.tblCase INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblTranscription ON dbo.tblCase.Transcode = dbo.tblTranscription.Transcode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid AND dbo.tblUser.usertype = 'SC' LEFT OUTER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr LEFT OUTER JOIN
                      dbo.tblCompany INNER JOIN
                      dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode INNER JOIN
                      dbo.tblUserOfficeFunction ON dbo.tblUserOffice.userid = dbo.tblUserOfficeFunction.userid AND dbo.tblUserOffice.officecode = dbo.tblUserOfficeFunction.officecode AND
                       dbo.tblQueues.functioncode = dbo.tblUserOfficeFunction.functioncode
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------------------------------------------------------------------------------------
--New fields for ExamWork Doctor Panel
------------------------------------------------------------------------------------

ALTER TABLE [tblDoctor]
  ADD [EWDoctor] BIT
GO

ALTER TABLE [tblDoctor]
  ADD [DateLastUsed] DATETIME
GO

ALTER TABLE [tblDoctor]
  ADD [CredentialingStatus] VARCHAR(20)
GO

ALTER TABLE [tblDoctor]
  ADD [CredentialingSource] VARCHAR(10)
GO

ALTER TABLE [tblDoctor]
  ADD [CredentialingLastUpdate] DATETIME
GO

update tblControl set DBVersion='1.28'
GO