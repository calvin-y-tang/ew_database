-------------------------------------------------------------------
--Changes by Gary for HCAI
-------------------------------------------------------------------

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
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[vwexportsummary]') AND OBJECTPROPERTY(id,N'IsVIEW') = 1)
    DROP VIEW [vwexportsummary];
GO

CREATE VIEW [vwexportsummary]
AS
SELECT     TOP 100 PERCENT tblCase.casenbr, TblAcctHeader.documenttype, TblAcctHeader.documentnbr, tblacctingtrans.statuscode, 
					  TblAcctHeader.HCAIBranchID, TblAcctHeader.HCAIInsurerID, TblAcctHeader.Message,
                      tblQueues.statusdesc, tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, tblacctingtrans.DrOpType, 
                      CASE isnull(tblcase.panelnbr, 0) WHEN 0 THEN CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tbldoctor.lastname, '') 
                      + ', ' + isnull(tbldoctor.firstname, '') WHEN '' THEN ISNULL(tbldoctor.lastname, '') + ', ' + isnull(tbldoctor.firstname, '') 
                      WHEN '' THEN isNULL(tblcase.doctorname, '') 
                      WHEN 'OP' THEN tbldoctor.companyname END ELSE CASE tblacctingtrans.droptype WHEN 'DR' THEN isNULL(tblcase.doctorname, '') 
                      WHEN '' THEN isNULL(tblcase.doctorname, '') WHEN 'OP' THEN tbldoctor.companyname END END AS doctorname, 
                      tblClient.lastname + ', ' + tblClient.firstname AS clientname, tblCompany.intname AS companyname, tblCase.priority, 
                      tblCase.ApptDate, tblCase.dateadded, tblCase.claimnbr, tblCase.doctorlocation, tblCase.Appttime, tblCase.dateedited, 
                      tblCase.useridedited, tblClient.email AS adjusteremail, tblClient.fax AS adjusterfax, tblCase.marketercode, tblCase.useridadded, 
                      TblAcctHeader.documentdate, TblAcctHeader.INBatchSelect, TblAcctHeader.VOBatchSelect, TblAcctHeader.taxcode, 
                      TblAcctHeader.taxtotal, TblAcctHeader.documenttotal, TblAcctHeader.documentstatus, tblCase.clientcode, tblCase.doctorcode, 
                      TblAcctHeader.batchnbr, tblacctingtrans.documentnbr AS Expr1, tblCase.officecode, tblCase.schedulercode, 
                      tblClient.companycode, tblCase.QARep, tblCase.PanelNbr, DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ, 
                      tblCase.mastersubcase, tblqueues_1.statusdesc AS CaseStatus,tblacctingtrans.SeqNO
FROM         tblCase INNER JOIN
                      tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr INNER JOIN
                      tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode INNER JOIN
                      tblQueues tblqueues_1 ON tblcase.status = tblQueues_1.statuscode INNER JOIN
                      TblAcctHeader ON tblCase.casenbr = TblAcctHeader.casenbr AND tblacctingtrans.type = TblAcctHeader.documenttype AND 
                      tblacctingtrans.documentnbr = TblAcctHeader.documentnbr LEFT OUTER JOIN
                      tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode LEFT OUTER JOIN
                      tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr LEFT OUTER JOIN
                      tblCompany INNER JOIN
                      tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode
WHERE     (tblacctingtrans.statuscode <> 20) AND (TblAcctHeader.batchnbr IS NULL) AND (TblAcctHeader.documentstatus = 'Final')
ORDER BY TblAcctHeader.documentdate, tblCase.priority, tblCase.ApptDate

GO

-------------------------------------------------------------------
--Added Servicecode to vwExportSummaryWithSecurity so filter on case tracker works
-------------------------------------------------------------------


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwExportSummaryWithSecurity]
AS
SELECT      TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblAcctHeader.documenttype, dbo.tblAcctHeader.documentnbr, dbo.tblAcctingTrans.statuscode, 
                        dbo.tblQueues.statusdesc, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblAcctingTrans.DrOpType, 
                        CASE ISNULL(dbo.tblcase.panelnbr, 0) WHEN 0 THEN CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tbldoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tbldoctor.firstname, '') WHEN '' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + ISNULL(dbo.tbldoctor.firstname, '') 
                        WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') 
                        WHEN 'OP' THEN dbo.tbldoctor.companyname END ELSE CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tblcase.doctorname, '') 
                        WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '') WHEN 'OP' THEN dbo.tbldoctor.companyname END END AS doctorname, 
                        dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, 
                        dbo.tblCase.ApptDate, dbo.tblCase.dateadded, dbo.tblCase.claimnbr, dbo.tblCase.doctorlocation, dbo.tblCase.Appttime, dbo.tblCase.dateedited, 
                        dbo.tblCase.useridedited, dbo.tblClient.email AS adjusteremail, dbo.tblClient.fax AS adjusterfax, dbo.tblCase.marketercode, dbo.tblCase.useridadded, 
                        dbo.tblAcctHeader.documentdate, dbo.tblAcctHeader.INBatchSelect, dbo.tblAcctHeader.VOBatchSelect, dbo.tblAcctHeader.taxcode, 
                        dbo.tblAcctHeader.taxtotal, dbo.tblAcctHeader.documenttotal, dbo.tblAcctHeader.documentstatus, dbo.tblCase.clientcode, dbo.tblCase.doctorcode, 
                        dbo.tblAcctHeader.batchnbr, dbo.tblCase.officecode, dbo.tblCase.schedulercode, dbo.tblClient.companycode, dbo.tblCase.QARep, 
                        dbo.tblCase.PanelNbr, DATEDIFF(day, dbo.tblAcctingTrans.laststatuschg, GETDATE()) AS IQ, dbo.tblCase.mastersubcase, 
                        tblqueues_1.statusdesc AS CaseStatus, dbo.tblUserOfficeFunction.userid, dbo.tblQueues.functioncode, dbo.tblServices.shortdesc AS service, 
                        dbo.tblCase.servicecode
FROM          dbo.tblAcctHeader INNER JOIN
                        dbo.tblAcctingTrans ON dbo.tblAcctHeader.seqno = dbo.tblAcctingTrans.SeqNO INNER JOIN
                        dbo.tblCase ON dbo.tblAcctHeader.casenbr = dbo.tblCase.casenbr LEFT OUTER JOIN
                        dbo.tblCompany ON dbo.tblAcctHeader.CompanyCode = dbo.tblCompany.companycode LEFT OUTER JOIN
                        dbo.tblClient ON dbo.tblAcctHeader.ClientCode = dbo.tblClient.clientcode INNER JOIN
                        dbo.tblQueues ON dbo.tblAcctingTrans.statuscode = dbo.tblQueues.statuscode INNER JOIN
                        dbo.tblQueues tblqueues_1 ON dbo.tblCase.status = tblqueues_1.statuscode LEFT OUTER JOIN
                        dbo.tblDoctor ON dbo.tblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                        dbo.tblServices ON dbo.tblServices.servicecode = dbo.tblCase.servicecode INNER JOIN
                        dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode INNER JOIN
                        dbo.tblUserOfficeFunction ON dbo.tblUserOffice.userid = dbo.tblUserOfficeFunction.userid AND 
                        dbo.tblUserOfficeFunction.officecode = dbo.tblCase.officecode AND dbo.tblQueues.functioncode = dbo.tblUserOfficeFunction.functioncode
WHERE      (dbo.tblAcctingTrans.statuscode <> 20) AND (dbo.tblAcctHeader.batchnbr IS NULL) AND (dbo.tblAcctHeader.documentstatus = 'Final')
ORDER BY dbo.tblAcctHeader.documentdate, dbo.tblCase.priority, dbo.tblCase.ApptDate
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



update tblControl set DBVersion='1.27'
GO