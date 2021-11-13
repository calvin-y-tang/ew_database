
----------------------------------------------------------------------------
--Update view and stored proc to add Case Type filter to Case Tracker screen
----------------------------------------------------------------------------

DROP VIEW [vwAcctingSummaryWithSecurity]
GO


CREATE VIEW [dbo].[vwAcctingSummaryWithSecurity]
AS
SELECT     TOP 100 PERCENT dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblacctingtrans.DrOpType, 
                      dbo.tblCase.PanelNbr, CASE isnull(dbo.tblcase.panelnbr, 0) 
                      WHEN 0 THEN CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + isnull(dbo.tbldoctor.firstname, '') 
                      WHEN '' THEN ISNULL(dbo.tbldoctor.lastname, '') + ', ' + isnull(dbo.tbldoctor.firstname, '') WHEN '' THEN isNULL(dbo.tblcase.doctorname, '') 
                      WHEN 'OP' THEN dbo.tbldoctor.companyname END ELSE CASE dbo.tblacctingtrans.droptype WHEN 'DR' THEN isNULL(dbo.tblcase.doctorname, '') 
                      WHEN '' THEN isNULL(dbo.tblcase.doctorname, '') WHEN 'OP' THEN dbo.tbldoctor.companyname END END AS doctorname, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblCompany.intname AS companyname, dbo.tblCase.priority, 
                      ISNULL(tblLocation_1.locationcode, dbo.tblCase.doctorlocation) AS doctorlocation, dbo.tblAcctingTrans.blnselect AS billedselect, 
                      dbo.tblCase.servicecode, dbo.tblQueues.statusdesc, dbo.tblCase.miscselect, dbo.tblcase.marketercode, dbo.tblacctingtrans.statuscode, 
                      dbo.tblCase.voucherselect, dbo.tblacctingtrans.documentnbr, dbo.tblacctingtrans.documentdate, dbo.tblacctingtrans.documentamount, 
                      dbo.tblServices.description AS servicedesc, dbo.tblCase.officecode, dbo.tblDoctor.companyname AS otherpartyname, dbo.tblDoctor.doctorcode, 
                      dbo.tblCase.casenbr, dbo.tblacctingtrans.SeqNO, dbo.tblCase.clientcode, dbo.tblCompany.companycode, dbo.tblCase.schedulercode, 
                      dbo.tblCase.QARep, dbo.tblacctingtrans.type, DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ, dbo.tblCase.laststatuschg, 
                      ISNULL(dbo.tblacctingtrans.apptdate, dbo.tblCase.ApptDate) AS apptdate, ISNULL(tblLocation_1.location, dbo.tblLocation.location) AS location, 
                      dbo.tblacctingtrans.appttime, dbo.tblacctingtrans.result, dbo.tblCase.mastersubcase, dbo.tblqueues.functioncode, dbo.tblUserofficefunction.userid, 
                      dbo.tblcase.billingnote, dbo.tblCase.rptStatus, dbo.tblCase.casetype
FROM         dbo.tblCase INNER JOIN
                      dbo.tblacctingtrans ON dbo.tblCase.casenbr = dbo.tblacctingtrans.casenbr INNER JOIN
                      dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode INNER JOIN
                      dbo.tbluserofficefunction ON dbo.tblUserOffice.userid = dbo.tbluserofficefunction.userid AND 
                      dbo.tblUserOffice.officecode = dbo.tbluserofficefunction.officecode AND 
                      dbo.tblqueues.functioncode = dbo.tbluserofficefunction.functioncode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblLocation tblLocation_1 ON dbo.tblacctingtrans.doctorlocation = tblLocation_1.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblacctingtrans.DrOpCode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr LEFT OUTER JOIN
                      dbo.tblCompany INNER JOIN
                      dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
WHERE     (dbo.tblacctingtrans.statuscode <> 20)




GO

DROP VIEW [vwcasemonitordetail]
GO





CREATE VIEW [dbo].[vwcasemonitordetail]
AS  SELECT  dbo.tblCase.status,
            dbo.tblCase.priority,
            dbo.tblCase.marketercode,
            dbo.tblCase.doctorlocation,
            dbo.tblCase.doctorcode,
            dbo.tblClient.companycode,
            CASE WHEN dbo.tblCase.priority = 'Normal'
                      OR dbo.tblCase.priority IS NULL THEN 1
                 ELSE 0
            END AS Normal,
            CASE WHEN dbo.tblCase.priority <> 'Normal' THEN 1
                 ELSE 0
            END AS Rush,
            dbo.tblCase.officecode,
            dbo.tblCase.schedulercode,
            dbo.tblCase.QARep AS QARepCode,
            dbo.tblCase.servicecode,
            dbo.tblCase.casetype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
    WHERE   ( dbo.tblCase.status <> 8 )
            AND ( dbo.tblCase.status <> 9 )





GO

DROP VIEW [vwcaseopenservices]
GO


CREATE VIEW [dbo].[vwcaseopenservices]
AS
SELECT     dbo.tblCase.casenbr, dbo.TblCaseOtherParty.duedate, dbo.TblCaseOtherParty.status, dbo.tblCase.officecode, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.marketercode, dbo.tblCase.doctorcode, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, 
                      dbo.TblCaseOtherParty.useridresponsible, dbo.tblCase.ApptDate, dbo.tblServices.shortdesc AS service, dbo.tblServices.servicecode, 
                      tblDoctor_1.companyname, tblDoctor_1.OPSubType, dbo.tblCase.schedulercode, dbo.tblCompany.companycode, dbo.tblCase.QARep AS QARepCode, 
                      dbo.TblCaseOtherParty.OPCode, dbo.tblCase.PanelNbr, dbo.tblCase.DoctorName, dbo.tblCase.casetype
FROM         dbo.TblCaseOtherParty INNER JOIN
                      dbo.tblCase ON dbo.TblCaseOtherParty.casenbr = dbo.tblCase.casenbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblDoctor tblDoctor_1 ON dbo.TblCaseOtherParty.OPCode = tblDoctor_1.doctorcode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
WHERE     (dbo.TblCaseOtherParty.status = 'Open')


GO

DROP VIEW [vwExportSummaryWithSecurity]
GO

CREATE VIEW [dbo].[vwExportSummaryWithSecurity]
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
                        dbo.tblCase.servicecode, dbo.tblCase.casetype
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

DROP VIEW [vwstatusappt]
GO

CREATE VIEW [dbo].[vwstatusappt]
AS
    SELECT TOP (100) PERCENT
            dbo.tblCase.casenbr
           ,dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename
           ,dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname
           ,dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS schedulername
           ,dbo.tblCompany.intname AS companyname
           ,dbo.tblCase.priority
           ,dbo.tblCase.ApptDate
           ,dbo.tblCase.status
           ,dbo.tblCase.dateadded
           ,dbo.tblCase.claimnbr
           ,dbo.tblCase.doctorlocation
           ,dbo.tblCase.Appttime
           ,dbo.tblCase.shownoshow
           ,dbo.tblCase.Transcode
           ,dbo.tblCase.rptstatus
           ,dbo.tblLocation.location
           ,dbo.tblCase.dateedited
           ,dbo.tblCase.useridedited
           ,dbo.tblCase.apptselect
           ,dbo.tblClient.email AS clientemail
           ,dbo.tblClient.fax AS clientfax
           ,dbo.tblCase.marketercode
           ,dbo.tblCase.requesteddoc
           ,dbo.tblCase.invoicedate
           ,dbo.tblCase.invoiceamt
           ,dbo.tblCase.datedrchart
           ,dbo.tblCase.drchartselect
           ,dbo.tblCase.inqaselect
           ,dbo.tblCase.intransselect
           ,dbo.tblCase.billedselect
           ,dbo.tblCase.awaittransselect
           ,dbo.tblCase.chartprepselect
           ,dbo.tblCase.apptrptsselect
           ,dbo.tblCase.transreceived
           ,dbo.tblTranscription.transcompany
           ,dbo.tblServices.shortdesc AS service
           ,dbo.tblCase.doctorcode
           ,dbo.tblClient.companycode
           ,dbo.tblCase.officecode
           ,dbo.tblCase.schedulercode
           ,dbo.tblCase.QARep
           ,DATEDIFF(day, dbo.tblCase.laststatuschg, GETDATE()) AS IQ
           ,dbo.tblCase.laststatuschg
           ,CASE WHEN dbo.tblcase.panelnbr IS NULL
                 THEN dbo.tbldoctor.lastname + ', '
                      + ISNULL(dbo.tbldoctor.firstname, ' ')
                 ELSE dbo.tblcase.doctorname
            END AS doctorname
           ,dbo.tblCase.PanelNbr
           ,dbo.tblQueues.functioncode
           ,dbo.tblUserOfficeFunction.userid
           ,dbo.tblCase.servicecode
           ,dbo.tblCase.casetype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            LEFT OUTER JOIN dbo.tblTranscription ON dbo.tblCase.Transcode = dbo.tblTranscription.Transcode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid
                                           AND dbo.tblUser.usertype = 'SC'
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblCompany
            INNER JOIN dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode
            INNER JOIN dbo.tblUserOfficeFunction ON dbo.tblUserOffice.userid = dbo.tblUserOfficeFunction.userid
                                                    AND dbo.tblUserOffice.officecode = dbo.tblUserOfficeFunction.officecode
                                                    AND dbo.tblQueues.functioncode = dbo.tblUserOfficeFunction.functioncode

GO

DROP VIEW [vwstatusNew]
GO


CREATE VIEW [dbo].[vwStatusNew]
AS
    SELECT DISTINCT
            dbo.tblCase.casenbr
           ,dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename
           ,CASE WHEN dbo.tblcase.panelnbr IS NULL
                 THEN dbo.tbldoctor.lastname + ', '
                      + ISNULL(dbo.tbldoctor.firstname, ' ')
                 ELSE dbo.tblcase.doctorname
            END AS doctorname
           ,dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname
           ,user1.lastname + ', ' + user1.firstname AS schedulername
           ,user1.lastname + ', ' + user1.firstname AS marketername
           ,dbo.tblCompany.intname AS companyname
           ,dbo.tblCase.priority
           ,dbo.tblCase.ApptDate
           ,dbo.tblCase.status
           ,dbo.tblCase.dateadded
           ,dbo.tblCase.requesteddoc
           ,dbo.tblCase.doctorcode
           ,dbo.tblCase.marketercode
           ,dbo.tblQueues.statusdesc
           ,dbo.tblServices.shortdesc AS service
           ,dbo.tblCase.doctorlocation
           ,dbo.tblClient.companycode
           ,dbo.tblCase.servicecode
           ,dbo.tblCase.QARep AS QARepCode
           ,dbo.tblCase.schedulercode
           ,dbo.tblCase.officecode
           ,dbo.tblCase.PanelNbr
           ,dbo.tblUserSecurity.userid
           ,dbo.tblGroupFunction.functioncode
           ,dbo.tblCase.casetype
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblCompany.companycode = dbo.tblClient.companycode
            INNER JOIN dbo.tblServices ON dbo.tblServices.servicecode = dbo.tblCase.servicecode
            INNER JOIN dbo.tblUserOffice ON dbo.tblUserOffice.officecode = dbo.tblCase.officecode
            INNER JOIN dbo.tblUserSecurity ON dbo.tblUserOffice.userid = dbo.tblUserSecurity.userid
                                              AND dbo.tblUserOffice.officecode = dbo.tblUserSecurity.officecode
            INNER JOIN dbo.tblGroupFunction ON dbo.tblGroupFunction.groupcode = dbo.tblUserSecurity.groupcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblUser tblUser_1 ON dbo.tblCase.schedulercode = tblUser_1.userid
            LEFT OUTER JOIN dbo.tblUser user1 ON user1.userid = dbo.tblCase.marketercode
            LEFT OUTER JOIN dbo.tblQueues ON dbo.tblQueues.statuscode = dbo.tblCase.status
    WHERE   (dbo.tblGroupFunction.functioncode = 'viewcase')



GO

DROP PROCEDURE [spFrmMainForm]
GO




/*
This procedure is used by the main case tracker form to filter based on office, company, doctor, location, marketer, scheduler, or QA Rep
dml 09/10/04
*/
CREATE procedure [dbo].[spFrmMainForm]
    @sForm varchar(50),
    @iOfficeCode int,
    @sFilterType varchar(50),
    @sFilterValue varchar(50),
    @sUserID varchar(50)
as 
    declare @sColumns varchar(1000)
    declare @sFrom varchar(1000)
    declare @sWhere varchar(1000)
    declare @sGroupBy varchar(1000)
    declare @sHaving varchar(100)
    declare @sSqlString nvarchar(2000)


    if ( @sForm = 'Case Monitor' ) 
        begin
            set @scolumns = 'COUNT(*) AS casecount, SUM(dbo.vwcasemonitordetail.Rush) AS rushcount, SUM(dbo.vwcasemonitordetail.Normal) AS normalcount, '
                + 'dbo.vwcasemonitordetail.status, MAX(dbo.tblQueues.displayorder) AS displayorder, dbo.tblQueues.statusdesc, dbo.tblQueues.formtoopen, '
                + 'dbo.tblQueues.functioncode, dbo.tblUserOffice.userid ' 
            set @sFrom = 'FROM dbo.tblQueues INNER JOIN '
                + 'dbo.vwcasemonitordetail ON dbo.tblQueues.statuscode = dbo.vwcasemonitordetail.status INNER JOIN '
                + 'dbo.tblUserOffice ON dbo.tblUserOffice.officecode = dbo.vwcasemonitordetail.officecode '
            set @sWhere = 'Where dbo.tbluseroffice.userid = ''' + @sUserid
                + ''''  

            if ( @iofficecode > 0 ) 
                begin
                    set @sWhere = @sWhere
                        + ' and tblQueues.functioncode in (select distinct functioncode from tblUserSecurity where tblUserSecurity.userid = '''
                        + @sUserid + ''' and tblUserSecurity.officecode = '
                        + cast(@iofficecode as varchar(30)) + ')'
                end
            else 
                begin
                    set @sWhere = @sWhere
                        + ' and tblQueues.functioncode in (select distinct functioncode from tblUserSecurity where tblUserSecurity.userid = '''
                        + @sUserid + ''')'
                end 

            set @sGroupBy = 'dbo.vwcasemonitordetail.status, dbo.tblQueues.statusdesc, dbo.tblQueues.formtoopen, dbo.tblQueues.functioncode, dbo.tblUserOffice.userid '
            set @sHaving = ''

        end
    else 
        begin
            set @scolumns = 'COUNT(*) AS casecount, dbo.tblQueues.statusdesc, dbo.tblQueues.formtoopen, dbo.tblqueues.functioncode,max(dbo.tblQueues.displayorder) as displayorder, '
                + ' dbo.tblacctingtrans.statuscode as status, dbo.tblqueues.functioncode '
            set @sFrom = 'FROM dbo.tblacctingtrans INNER JOIN dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode '
                + 'INNER JOIN dbo.tblCase ON dbo.tblacctingtrans.casenbr = dbo.tblCase.casenbr '
                + 'INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode  INNER JOIN dbo.tbluseroffice on dbo.tbluseroffice.officecode = dbo.tblcase.officecode '
            set @sGroupBy = 'dbo.tblacctingtrans.statuscode, dbo.tblQueues.statusdesc, dbo.tblQueues.formtoopen, dbo.tblqueues.functioncode '
            set @sHaving = 'HAVING  dbo.tblacctingtrans.statuscode <> 20'
            set @sWhere = 'Where dbo.tbluseroffice.userid = ''' + @sUserid
                + '''' 

        end

-- add officecode to sql statement, if needed

    if ( @iofficecode <> '-1' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.officecode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.officecode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.officecode'
                        end
                end 
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblcase.officecode' 
--  set @sFrom = @sFrom + ' INNER JOIN dbo.tblCase ON dbo.tblacctingtrans.casenbr = dbo.tblCase.casenbr'
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblcase.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.officecode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblcase.officecode = '
                                + cast(@iofficecode as varchar(5))
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.officecode'
                        end
                end
        end

-- add companycode to sql statement, if needed

    if ( @sFilterType = 'Company' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.companycode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.companycode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.companycode = '
                                + @sfiltervalue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.companycode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblclient.companycode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblclient.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblclient.companycode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblclient.companycode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblclient.companycode'
                        end
                end
    
        end
  
-- add doctor to sql statement, if needed

    if ( @sFilterType = 'Doctor' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.doctorcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.doctorcode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.doctorcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.doctorcode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.doctorcode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.tblacctingtrans.dropcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblacctingtrans.dropcode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblacctingtrans.dropcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblacctingtrans.dropcode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblacctingtrans.dropcode'
                        end
                end
        end
-- add DoctorLocation to sql statement, if needed

    if ( @sFilterType = 'Location' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.DoctorLocation' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.DoctorLocation' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.DoctorLocation'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblcase.DoctorLocation' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblcase.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.DoctorLocation' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblcase.DoctorLocation = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.DoctorLocation'
                        end
                end

        end

-- add marketercode to sql statement, if needed  
    if ( @sfiltertype = 'Marketer' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.Marketercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.marketercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.marketercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.marketercode = '''
                                + @sFilterValue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.marketercode' 
                        end
                end 
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblcase.Marketercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblcase.marketercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.marketercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblcase.marketercode = '''
                                + @sFilterValue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.marketercode' 
                        end
                end 

        end

-- add schedulercode to sql statement, if needed  
    if ( @sfiltertype = 'Scheduler' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.Schedulercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.Schedulercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.Schedulercode' 
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblcase.Schedulercode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblcase.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.Schedulercode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblcase.Schedulercode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblcase.Schedulercode' 
                        end
                end
        end

-- add QARepcode to sql statement, if needed  
    if ( @sfiltertype = 'QARep' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.QARepcode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.QARepcode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.QARepcode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.QARepcode = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.QARepcode' 
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns + ', dbo.tblcase.QARep' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblcase.QARep = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy + ',dbo.tblcase.QARep' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblcase.QARep = '''
                                + @sfiltervalue + ''''
                            set @sGroupBy = @sGroupBy + ',dbo.tblcase.QARep' 
                        end
                end

        end
-- add servce to sql statement, if needed

    if ( @sFilterType = 'Service' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.serviceCode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.serviceCode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.serviceCode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.serviceCode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.serviceCode'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.tblCase.serviceCode' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblCase.serviceCode = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblCase.serviceCode' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblCase.serviceCode = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblCase.serviceCode'
                        end
                end
        END
        
-- add case type to sql statement, if needed

    if ( @sFilterType = 'CaseType' ) 
        begin
            if ( @sForm = 'Case Monitor' ) 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.vwcasemonitordetail.caseType' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.vwcasemonitordetail.caseType = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.caseType' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.vwcasemonitordetail.caseType = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.vwcasemonitordetail.caseType'
                        end
                end
            else 
                begin
                    set @scolumns = @scolumns
                        + ', dbo.tblCase.caseType' 
                    if @sWhere is null 
                        begin
                            set @sWhere = 'Where dbo.tblCase.caseType = '
                                + @sFilterValue 
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblCase.caseType' 
                        end
                    else 
                        begin
                            set @sWhere = @sWhere
                                + ' and dbo.tblCase.caseType = '
                                + @sFilterValue
                            set @sGroupBy = @sGroupBy
                                + ',dbo.tblCase.caseType'
                        end
                end
        end

-- build sql statement
    set @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + 'GROUP BY ' + @sGroupby + ' '
        + @sHaving + ' ' + 'ORDER BY MAX(dbo.tblQueues.displayorder)'
--print 'sqlstring ' +  @ssqlstring
 
-- execute sql statement
    Exec Sp_executesql @sSqlString

GO


------------------------------------------------------------------------------------------------
--Add a new Admin attribute to determine if user has admin privilage
------------------------------------------------------------------------------------------------


ALTER TABLE [tblUser]
  ADD [Admin] BIT DEFAULT ((0)) NOT NULL
GO

UPDATE tblUser SET Admin=1 WHERE userid='admin'
GO

------------------------------------------------------------------------------------------------
--Add new field for Fax Server Type
------------------------------------------------------------------------------------------------

ALTER TABLE [tblIMEData]
  ADD [FaxServerType] VARCHAR(10)
GO

UPDATE tblIMEData SET FaxServerType='GoldFax'
 WHERE faxcapability=1
GO



update tblControl set DBVersion='1.34'
GO