CREATE TABLE [tblEWNetwork] (
  [EWNetworkID] INTEGER IDENTITY(1,1) NOT NULL,
  [Name] VARCHAR(40),
  [OutOfNetwork] BIT NOT NULL,
  [Active] BIT NOT NULL,
  [SeqNo] INTEGER NOT NULL,
  CONSTRAINT [PK_tblEWNetwork] PRIMARY KEY ([EWNetworkID])
)
GO

CREATE TABLE [tblCompanyNetwork] (
  [CompanyCode] INTEGER NOT NULL,
  [EWNetworkID] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(15),
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblCompanyNetwork] PRIMARY KEY ([CompanyCode],[EWNetworkID])
)
GO

CREATE TABLE [tblDoctorNetwork] (
  [DoctorCode] INTEGER NOT NULL,
  [EWNetworkID] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(15),
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblDoctorNetwork] PRIMARY KEY ([DoctorCode],[EWNetworkID])
)
GO


ALTER TABLE [tblCase]
  ADD [EWNetworkID] INTEGER
GO


INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'SetDoctorEWNetworkID' ,
                'Doctor - Set Network ID'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'SetDoctorEWNetworkID' )

GO

INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'SetCompanyEWNetworkID' ,
                'Company - Set Network ID'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'SetCompanyEWNetworkID' )

GO



ALTER TABLE [tblCompany]
  ADD [TaxExempt] BIT
GO

ALTER TABLE [tblDoctor]
  ADD [CalcTaxOnVouchers] BIT
GO

ALTER TABLE [tblEWCompany]
  ADD [TaxExempt] BIT
GO

ALTER TABLE [tblIMEData]
  ADD [CalcTaxOnVouchers] BIT
GO

UPDATE tblCompany SET TaxExempt=0
GO
UPDATE tblDoctor SET CalcTaxOnVouchers=0
GO

--Set existing data to true if the Country ID is Canada, else false
UPDATE tblIMEData SET CalcTaxOnVouchers=(CASE WHEN CountryID=2 THEN 1 ELSE 0 END)
GO


DROP VIEW vwAcctingSummary
GO
CREATE VIEW vwAcctingSummary
AS
    SELECT 
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblCase.dateadded ,
            tblCase.claimnbr ,
            tblLocation.locationcode AS doctorlocation ,
            tblCase.shownoshow ,
            tblCase.transcode ,
            tblCase.rptstatus ,
            tblCase.dateedited ,
            tblCase.useridedited ,
            tblCase.apptselect ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.requesteddoc ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.datedrchart ,
            tblCase.drchartselect ,
            tblCase.inqaselect ,
            tblCase.intransselect ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.awaittransselect ,
            tblCase.chartprepselect ,
            tblCase.apptrptsselect ,
            tblCase.transreceived ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblCase.useridadded ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.notes ,
            tblDoctor.notes AS doctornotes ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            tblLocation.location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result ,
            tblCase.mastersubcase ,
            tblcase.billingnote ,
            tblcasetype.description AS CaseType ,
            tblAcctingTrans.ApptStatusID ,
            tblAcctingTrans.CaseApptID ,
            BCOM.CompanyCode AS BillCompanyCode
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblcasetype ON tblcasetype.code = tblcase.casetype
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblClient AS BCL ON ISNULL(tblCase.BillClientCode, tblCase.ClientCode)=BCL.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation ON tblacctingtrans.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )
GO

DROP VIEW vwAcctingSummaryWithSecurity
GO
CREATE VIEW vwAcctingSummaryWithSecurity
AS
    SELECT 
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblLocation.locationcode AS doctorlocation ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblcase.marketercode ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            tblLocation.location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result,
            tblCase.mastersubcase ,
            tblqueues.functioncode ,
            tblUserofficefunction.userid ,
            tblcase.billingnote ,
            tblCase.rptStatus ,
            tblCase.casetype,
            tblAcctingTrans.ApptStatusID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblUserOffice ON tblCase.officecode = tblUserOffice.officecode
            INNER JOIN tbluserofficefunction ON tblUserOffice.userid = tbluserofficefunction.userid
                                                AND tblUserOffice.officecode = tbluserofficefunction.officecode
                                                AND tblqueues.functioncode = tbluserofficefunction.functioncode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode 
            LEFT OUTER JOIN tblLocation ON tblacctingtrans.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )

GO

DROP VIEW vwInvoiceTax
GO
CREATE VIEW vwInvoiceTax
AS
SELECT  tblAcctHeader.DocumentNbr ,
        tblAcctDetail.ProdCode ,
        tblProduct.Description AS ProductDesc ,
        tblTaxTable.TaxCode ,
        tblTaxState.StateCode ,
        tblTaxTable.Description ,
        tblTaxTable.Rate ,
        tblAcctDetail.ExtendedAmount ,
        ROUND(CAST(tblTaxTable.rate AS NUMERIC(10, 2))
              * tblAcctDetail.extendedAmount, 2) AS TaxAmount ,
        tblAcctHeader.DocumentType ,
        tblAcctDetail.Date ,
        tblAcctDetail.DrOPCode ,
        tblAcctDetail.Taxable ,
        tblAcctingTrans.DoctorLocation ,
        tblAcctDetail.LineNbr
FROM    tblAcctHeader
        INNER JOIN tblAcctDetail ON tblAcctHeader.DocumentNbr = tblAcctDetail.DocumentNbr
                                    AND tblAcctHeader.Documenttype = tblAcctDetail.Documenttype
        INNER JOIN tblProduct ON tblAcctDetail.prodCode = tblproduct.prodCode
        INNER JOIN tblAcctingTrans ON tblAcctHeader.DocumentNbr = tblacctingtrans.DocumentNbr
                                      AND tblAcctHeader.Documenttype = tblacctingtrans.type
        INNER JOIN tblTaxState ON tblTaxState.StateCode = tblAcctHeader.ServiceState
        INNER JOIN tblTaxTable ON tblTaxState.TaxCode = tblTaxTable.TaxCode
WHERE   tblAcctDetail.Taxable = 1
GO


UPDATE tblControl SET DBVersion='2.03'
GO
