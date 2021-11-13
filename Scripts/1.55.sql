
--Changed DateCancelled to DateCanceled

exec sp_rename 'tblCase.DateCancelled', 'DateCanceled', 'COLUMN'

GO

DROP VIEW dbo.vwcasesummary
GO
CREATE VIEW dbo.vwCaseSummary
AS
    SELECT TOP 100 PERCENT
            dbo.tblCase.casenbr ,
            dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS schedulername ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblCase.priority ,
            dbo.tblCase.ApptDate ,
            dbo.tblCase.status ,
            dbo.tblCase.dateadded ,
            dbo.tblCase.claimnbr ,
            dbo.tblCase.doctorlocation ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.shownoshow ,
            dbo.tblCase.transcode ,
            dbo.tblCase.rptstatus ,
            dbo.tblLocation.location ,
            dbo.tblCase.dateedited ,
            dbo.tblCase.useridedited ,
            dbo.tblCase.apptselect ,
            dbo.tblClient.email AS adjusteremail ,
            dbo.tblClient.fax AS adjusterfax ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.requesteddoc ,
            dbo.tblCase.invoicedate ,
            dbo.tblCase.invoiceamt ,
            dbo.tblCase.datedrchart ,
            dbo.tblCase.drchartselect ,
            dbo.tblCase.inqaselect ,
            dbo.tblCase.intransselect ,
            dbo.tblCase.billedselect ,
            dbo.tblCase.awaittransselect ,
            dbo.tblCase.chartprepselect ,
            dbo.tblCase.apptrptsselect ,
            dbo.tblCase.transreceived ,
            dbo.tblTranscription.transcompany ,
            dbo.tblCase.servicecode ,
            dbo.tblQueues.statusdesc ,
            dbo.tblCase.miscselect ,
            dbo.tblCase.useridadded ,
            dbo.tblServices.shortdesc AS service ,
            dbo.tblCase.doctorcode ,
            dbo.tblClient.companycode ,
            dbo.tblCase.voucheramt ,
            dbo.tblCase.voucherdate ,
            dbo.tblCase.officecode ,
            dbo.tblCase.QARep ,
            dbo.tblCase.schedulercode ,
            DATEDIFF(day, dbo.tblCase.laststatuschg, GETDATE()) AS IQ ,
            dbo.tblCase.laststatuschg ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.mastersubcase ,
            dbo.tblCase.mastercasenbr ,
            dbo.tblCase.CertMailNbr ,
            dbo.tblCase.WebNotifyEmail ,
            dbo.tblCase.PublishOnWeb ,
            CASE WHEN dbo.tblcase.panelnbr IS NULL
                 THEN dbo.tbldoctor.lastname + ', '
                      + ISNULL(dbo.tbldoctor.firstname, ' ')
                 ELSE dbo.tblcase.doctorname
            END AS doctorname ,
            tblcase.datemedsrecd ,
            tblcase.sinternalcasenbr ,
            tblcase.doctorspecialty ,
            tblcase.usddate1 ,
            tblqueues.functioncode ,
            tblcase.casetype ,
            tblcase.DateCompleted ,
            tblCase.DateCanceled
    FROM    dbo.tblCase
            INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            LEFT OUTER JOIN dbo.tblTranscription ON dbo.tblCase.transcode = dbo.tblTranscription.transcode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblCompany
            INNER JOIN dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
    ORDER BY dbo.tblCase.priority ,
            dbo.tblCase.ApptDate

GO

--Changes for Web Portal by Gary

/****** Object:  StoredProcedure [proc_ICD9_GetDescByCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_ICD9_GetDescByCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_ICD9_GetDescByCode];
GO

CREATE PROCEDURE [proc_ICD9_GetDescByCode]
(
	@ICD9Code varchar(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT Description FROM tblICDCode WHERE Code = @ICD9Code

	SET @Err = @@Error

	RETURN @Err
END
GO



UPDATE tblControl SET DBVersion='1.55'
GO
