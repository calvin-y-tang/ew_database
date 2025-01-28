-- Update Database to ver. 1.11. Generated on 5/26/2010

CREATE VIEW [dbo].[vwDoctorScheduleBMC]
AS
SELECT     TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                      dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                      dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                      dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                      + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                      dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                      dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, 
                      CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, tbllocation.addr1, 
                      tbllocation.addr2, tbllocation.city, tbllocation.state, tbllocation.zip
FROM         dbo.tblLocation INNER JOIN
                      dbo.tblDoctorSchedule INNER JOIN
                      dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                      dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                      dbo.tblCaseType INNER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                      dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                      dbo.tblIMEData INNER JOIN
                      dbo.tblOffice INNER JOIN
                      dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                      dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE     ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT     TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                      dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                      dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                      dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                      + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                      dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                      dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                      AS panelnote, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                      tbllocation.addr1, tbllocation.addr2, tbllocation.city, tbllocation.state, tbllocation.zip
FROM         dbo.tblCaseType INNER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                      dbo.tblLocation INNER JOIN
                      dbo.tblDoctorSchedule INNER JOIN
                      dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                      dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                      dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                      dbo.tblIMEData INNER JOIN
                      dbo.tblOffice INNER JOIN
                      dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                      dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE     (dbo.tblDoctorSchedule.status = 'scheduled') AND (tblcase.casenbr IS NOT NULL)
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime


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
            dbo.tblCase.servicecode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
    WHERE   ( dbo.tblCase.status <> 8 )
            AND ( dbo.tblCase.status <> 9 )




GO

DROP VIEW [vwQBInvoiceExport]
GO

CREATE VIEW [dbo].[vwQBInvoiceExport]
AS
SELECT     dbo.TblAcctHeader.documentnbr, dbo.TblAcctHeader.documenttype, dbo.TblAcctHeader.clientrefnbr, dbo.TblAcctHeader.clientAcctkey, 
                      dbo.tblproduct.description AS proddesc, dbo.TblAcctDetail.date AS servicedate, dbo.TblAcctDetail.CPTcode, dbo.TblAcctDetail.longdesc, 
                      dbo.TblAcctDetail.unit, dbo.TblAcctDetail.unitamount, dbo.TblAcctDetail.extendedamount, 
                      CASE WHEN dbo.TblAcctDetail.taxable = 0 THEN 'Non' ELSE dbo.tbltaxtable.taxcode END AS taxcode, dbo.tblproduct.INglacct, dbo.tblproduct.VOglacct, 
                      dbo.tblOffice.class
FROM         dbo.TblAcctHeader INNER JOIN
                      dbo.TblAcctDetail ON dbo.TblAcctHeader.documentnbr = dbo.TblAcctDetail.documentnbr AND 
                      dbo.TblAcctHeader.documenttype = dbo.TblAcctDetail.documenttype INNER JOIN
                      dbo.tblproduct ON dbo.TblAcctDetail.prodcode = dbo.tblproduct.prodcode INNER JOIN
                      dbo.TblTaxTable ON dbo.TblAcctHeader.taxcode = dbo.TblTaxTable.taxcode INNER JOIN
                      dbo.tblOffice ON dbo.TblAcctHeader.officecode = dbo.tblOffice.officecode

GO

DROP VIEW [vwExportSummaryWithSecurity]
GO



CREATE VIEW [dbo].[vwExportSummaryWithSecurity]
AS  SELECT TOP 100 PERCENT
            dbo.tblCase.casenbr,
            dbo.TblAcctHeader.documenttype,
            dbo.TblAcctHeader.documentnbr,
            dbo.tblacctingtrans.statuscode,
            dbo.tblQueues.statusdesc,
            dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename,
            dbo.tblacctingtrans.DrOpType,
            CASE isnull(dbo.tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + isnull(dbo.tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + isnull(dbo.tbldoctor.firstname, '')
                     WHEN '' THEN isNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
              ELSE CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR' THEN isNULL(dbo.tblcase.doctorname, '')
                     WHEN '' THEN isNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
            END AS doctorname,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname,
            dbo.tblCompany.intname AS companyname,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate,
            dbo.tblCase.dateadded,
            dbo.tblCase.claimnbr,
            dbo.tblCase.doctorlocation,
            dbo.tblCase.Appttime,
            dbo.tblCase.dateedited,
            dbo.tblCase.useridedited,
            dbo.tblClient.email AS adjusteremail,
            dbo.tblClient.fax AS adjusterfax,
            dbo.tblCase.marketercode,
            dbo.tblCase.useridadded,
            dbo.TblAcctHeader.documentdate,
            dbo.TblAcctHeader.INBatchSelect,
            dbo.TblAcctHeader.VOBatchSelect,
            dbo.TblAcctHeader.taxcode,
            dbo.TblAcctHeader.taxtotal,
            dbo.TblAcctHeader.documenttotal,
            dbo.TblAcctHeader.documentstatus,
            dbo.tblCase.clientcode,
            dbo.tblCase.doctorcode,
            dbo.TblAcctHeader.batchnbr,
            dbo.tblacctingtrans.documentnbr AS Expr1,
            dbo.tblCase.officecode,
            dbo.tblCase.schedulercode,
            dbo.tblClient.companycode,
            dbo.tblCase.QARep,
            dbo.tblCase.PanelNbr,
            DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ,
            dbo.tblCase.mastersubcase,
            tblqueues_1.statusdesc AS CaseStatus,
            tbluserofficefunction.userid,
            tblqueues.functioncode,
            tblservices.shortdesc AS SERVICE,
            dbo.tblCase.servicecode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblacctingtrans ON dbo.tblCase.casenbr = dbo.tblacctingtrans.casenbr
            INNER JOIN dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblQueues tblqueues_1 ON dbo.tblcase.status = tblQueues_1.statuscode
            INNER JOIN dbo.tblservices ON dbo.tblservices.servicecode = dbo.tblcase.servicecode
            INNER JOIN dbo.TblAcctHeader ON dbo.tblCase.casenbr = dbo.TblAcctHeader.casenbr
                                            AND dbo.tblacctingtrans.type = dbo.TblAcctHeader.documenttype
                                            AND dbo.tblacctingtrans.documentnbr = dbo.TblAcctHeader.documentnbr
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblacctingtrans.DrOpCode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            LEFT OUTER JOIN dbo.tblCompany
            INNER JOIN dbo.tblClient ON dbo.tblCompany.companycode = dbo.tblClient.companycode ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode
            INNER JOIN dbo.tbluserofficefunction ON dbo.tblUserOffice.userid = dbo.tbluserofficefunction.userid
                                                    AND dbo.tbluserofficefunction.officecode = dbo.tblcase.officecode
                                                    AND dbo.tblqueues.functioncode = dbo.tbluserofficefunction.functioncode
    WHERE   ( dbo.tblacctingtrans.statuscode <> 20 )
            AND ( dbo.TblAcctHeader.batchnbr IS NULL )
            AND ( dbo.TblAcctHeader.documentstatus = 'Final' )
    ORDER BY dbo.TblAcctHeader.documentdate,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate



GO

DROP VIEW [vwDoctorExportColumns]
GO

CREATE VIEW [dbo].[vwDoctorExportColumns]
AS
SELECT DISTINCT 
                      TOP 100 PERCENT dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctor.middleinitial, dbo.tblDoctor.credentials AS degree, 
                      dbo.tblDoctor.prefix, dbo.tblDoctor.status, dbo.tblDoctor.addr1 AS address1, dbo.tblDoctor.addr2 AS address2, dbo.tblDoctor.city, dbo.tblDoctor.state, 
                      dbo.tblDoctor.zip, dbo.tblDoctor.phone, dbo.tblDoctor.phoneExt AS Extension, dbo.tblDoctor.faxNbr AS Fax, dbo.tblDoctor.emailAddr AS email, 
                      dbo.tblDoctor.OPType, dbo.tblSpecialty.description AS Specialty, dbo.tblOffice.description AS Office, dbo.tblOffice.officecode, dbo.tblDoctor.doctorcode, 
                      dbo.tblProviderType.description AS ProviderType, dbo.tblDoctor.usdvarchar1, dbo.tblDoctor.usdvarchar2, dbo.tblDoctor.usddate1, 
                      dbo.tblDoctor.usddate2, dbo.tblDoctor.usdint1, dbo.tblDoctor.usdint2, dbo.tblDoctor.usdmoney1, dbo.tblDoctor.usdmoney2, dbo.tblDoctor.usddate3, 
                      dbo.tblDoctor.usddate4, dbo.tblDoctor.usdvarchar3, dbo.tblDoctor.usddate5, dbo.tblDoctor.usddate6, dbo.tblDoctor.usddate7
FROM         dbo.tblDoctor LEFT OUTER JOIN
                      dbo.tblProviderType ON dbo.tblDoctor.ProvTypeCode = dbo.tblProviderType.ProvTypeCode LEFT OUTER JOIN
                      dbo.tblOffice RIGHT OUTER JOIN
                      dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON 
                      dbo.tblDoctor.doctorcode = dbo.tblDoctorOffice.doctorcode LEFT OUTER JOIN
                      dbo.tblSpecialty INNER JOIN
                      dbo.tblDoctorSpecialty ON dbo.tblSpecialty.specialtycode = dbo.tblDoctorSpecialty.specialtycode ON 
                      dbo.tblDoctor.doctorcode = dbo.tblDoctorSpecialty.doctorcode
WHERE     (dbo.tblDoctor.OPType = 'DR')
ORDER BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblOffice.description, dbo.tblSpecialty.description

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
        end

-- build sql statement
    set @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + 'GROUP BY ' + @sGroupby + ' '
        + @sHaving + ' ' + 'ORDER BY MAX(dbo.tblQueues.displayorder)'
--print 'sqlstring ' +  @ssqlstring
 
-- execute sql statement
    Exec Sp_executesql @sSqlString



GO

DROP PROCEDURE [spClientCases]
GO



CREATE  PROCEDURE [dbo].[spClientCases]
@clientcode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'C' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
WHERE dbo.tblcase.clientcode = @clientcode
UNION
SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'B' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
WHERE dbo.tblcase.billclientcode = @clientcode
ORDER BY dbo.tblCase.ApptDate DESC

GO

DROP PROCEDURE [spExamineeCases]
GO


CREATE PROCEDURE [dbo].[spExamineeCases](@ChartNbr integer,
@userid varchar(30))
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ApptDate, dbo.tblCase.chartnbr, 
                      dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblLocation.location, dbo.tblQueues.statusdesc, 
                      ISNULL(tblSpecialty_2.description, tblSpecialty_1.description) AS specialtydesc, tblSpecialty_1.description, dbo.tblServices.shortdesc, 
                      dbo.tblCase.mastersubcase, ISNULL(dbo.tblCase.mastercasenbr, dbo.tblCase.casenbr) AS mastercasenbr, dbo.tblCase.DoctorName,
                      dbo.tbloffice.shortdesc as Office,
      (SELECT     TOP 1 type
                            FROM          tblcasehistory
                            WHERE      casenbr = dbo.tblcase.casenbr AND (type = 'Show' OR
                                                   type = 'NoShow' OR
                                                   type = 'Cancel' OR
                                                   type = 'latecancel') order by id desc) AS result

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
IF EXISTS 
(
    SELECT * FROM [information_schema].[routines]
    WHERE   routine_name = 'proc_FixWebUsers' 
)
DROP PROCEDURE [proc_FixWebUsers]
GO

CREATE PROCEDURE [dbo].[proc_FixWebUsers]

AS

--CLIENT CLEANUP
--update tblWebUserAccount with correct usercode
DECLARE @code NCHAR(20)
DECLARE @id NCHAR(20)
DECLARE @string NCHAR(500)
DECLARE @recCount int
SET @recCount = (SELECT COUNT(clientcode) FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT clientcode, tblClient.webuserid FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist 
 END
--set records with invalid webuserid to null
UPDATE tblClient SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CCADDRESS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(cccode) FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT cccode, tblCCaddress.webuserid FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblCCAddress SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DOCTOR CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(doctorcode) FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP'))
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT doctorcode, tblDoctor.webuserid FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP')
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblDoctor SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TRANS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(Transcode) FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT Transcode, tblTranscription.webuserid FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblTranscription SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--WEBUSER CLEANUP
--delete any webuseraccount records with invalid webuserid
DELETE FROM tblWebUserAccount WHERE webuserid NOT IN (SELECT webuserid FROM tblWebUser) --clean up

--delete all webuser records with an invalid imecentriccode
DELETE FROM tblWebUser WHERE imecentriccode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND userid <> 'admin'

--delete all webuseraccount records with an invalid usercode
DELETE FROM tblWebUserAccount WHERE UserCode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND webuserid <> 999999

GO

DROP PROCEDURE [proc_CCAddressCheckForDupe]
GO


CREATE PROCEDURE [proc_CCAddressCheckForDupe]

@Company varchar(100) = NULL,
@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int

SELECT TOP 1 cccode FROM tblCCAddress WHERE cccode > 0 
 AND Company LIKE '%' + COALESCE(@Company,Company) + '%'
 AND FirstName LIKE '%' +  COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' +  COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone)
 ORDER BY cccode
 
SET @Err = @@Error
RETURN @Err
 

GO

DROP PROCEDURE [proc_ExamineeCheckForDupe]
GO


CREATE PROCEDURE [proc_ExamineeCheckForDupe]

@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone1 varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int


SELECT TOP 1 chartnbr FROM tblExaminee WHERE chartnbr > 0 
 AND FirstName LIKE '%' + COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' + COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone1) 
 ORDER BY chartnbr
 
SET @Err = @@Error
RETURN @Err


GO

DROP PROCEDURE [proc_ValidateUserNew]
GO


CREATE PROCEDURE [proc_ValidateUserNew]

@UserID varchar(100),
@Password varchar(30)

AS

DECLARE @UserType CHAR(2)

SET @UserType = (SELECT UserType FROM tblWebUser WHERE UserID = @UserID AND Password = @Password)

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.lastname,
  tblClient.firstname,
  tblClient.clientcode,
  tblClient.email,
  ISNULL(tblClient.DefOfficeCode,0) AS DefOfficeCode,
  tblCompany.extName AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode AND tblClient.status = 'Active'
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblClient.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP' AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblCCAddress.lastname,
  tblCCAddress.firstname,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblTranscription.transcompany AS lastname,
  tblTranscription.email,
  tblWebUser.WebUserID AS firstname,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.Transcode AND tblTranscription.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END

GO

update tblControl set DBVersion='1.11'
GO