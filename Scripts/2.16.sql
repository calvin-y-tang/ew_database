
--Remove unused views
DROP VIEW vwavailabledoctors
DROP VIEW vwavailabledoctorskeywords
DROP VIEW vwavailabledrspecialties
DROP VIEW vwavailabledrspecialtieskeywords
DROP VIEW vwavailablepaneldoctors
DROP VIEW vwavailablepaneldoctorskeywords
GO

DROP VIEW vwbillingstatus
DROP VIEW vwbillingstatuscompany
DROP VIEW vwbillingstatusdoctor
DROP VIEW vwbillingstatuslocation
DROP VIEW vwbillingstatusmarketer
DROP VIEW vwbillingstatusoffice
DROP VIEW vwbillingstatusQARep
DROP VIEW vwbillingstatusscheduler
GO

DROP VIEW vwCaseHistory
DROP VIEW vwcaseletters
DROP VIEW vwcasemonitorcompany
DROP VIEW vwcasemonitordoctor
DROP VIEW vwcasemonitorlocation
DROP VIEW vwcasemonitormarketer
DROP VIEW vwcasemonitoroffice
DROP VIEW vwcasemonitorQARep
DROP VIEW vwcasemonitorscheduler
GO

DROP VIEW vwcasereports
DROP VIEW vwcasestatus
GO

DROP VIEW vwclientcases
DROP VIEW vwdoctorcases
DROP VIEW vwdoctorlocation
GO

DROP VIEW vwissue
DROP VIEW vwmarketer
DROP VIEW vwproblem
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwtest]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwtest
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwExportDynamics]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwExportDynamics
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwExportDynamicsLineItems]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwExportDynamicsLineItems
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_tblCaseInsert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROC proc_tblCaseInsert
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetWebCompanyByCompanyID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROC proc_GetWebCompanyByCompanyID
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_tblCaseUpdate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROC proc_tblCaseUpdate
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Company_LoadByParentCompany]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROC proc_Company_LoadByParentCompany
GO


DROP VIEW vw30DaySchedule
DROP VIEW vwAcctDocuments
DROP VIEW vwAcctingVOSummary
DROP VIEW vwApptLog
DROP VIEW vwApptLogDocs
DROP VIEW vwAssocCases
DROP VIEW vwavailablepaneldrswithnotes
DROP VIEW vwCancelAppt
DROP VIEW vwcasecc
DROP VIEW vwCaseHistoryDesc
DROP VIEW vwcasemonitor
DROP VIEW vwcaseproblem
DROP VIEW vwCaseSummary
DROP VIEW vwCaseSummaryWithSecurity
DROP VIEW vwcasetypeservicequeues
DROP VIEW vwCCExport
DROP VIEW vwccs
DROP VIEW vwClientExportColumns
DROP VIEW vwDaySheetWithOffice
DROP VIEW vwDoctorExportColumns
DROP VIEW vwDoctorSchedule
DROP VIEW vwDoctorScheduleBMC
DROP VIEW vwdoctorschedulesummary
DROP VIEW vwDoctorSchedulewithoffice
DROP VIEW vwexamineecases
DROP VIEW vwExceptionDefinitionListing
DROP VIEW vwExportSummaryWithSecurity

DROP VIEW vwMatrixClientExport
DROP VIEW vwMatrixTDExport
DROP VIEW vwpatientccs
DROP VIEW vwReportTATRpt
DROP VIEW vwReportTATRptDocs
DROP VIEW vwRptCancelDetail
DROP VIEW vwRptCancelDetailDocs
DROP VIEW vwRptNoShowDetail
DROP VIEW vwRptNoShowDetailDocs
DROP VIEW vwRptOutstandingRecords
DROP VIEW vwexportsummary
GO

CREATE VIEW vw30DaySchedule
AS
    SELECT  tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.LocationCode ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctor.Booking
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctorLocation ON tblDoctorSchedule.DoctorCode = tblDoctorLocation.DoctorCode
                                            AND tblDoctorSchedule.LocationCode = tblDoctorLocation.LocationCode
            INNER JOIN tblDoctor ON tblDoctorLocation.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorLocation.LocationCode = tblLocation.LocationCode
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )

GO


CREATE VIEW vwAcctDocuments
AS
SELECT  
	    tblCase.Casenbr,
        tblAcctHeader.documenttype,
        tblAcctHeader.documentnbr,
        tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName,
        CASE WHEN tblDoctor.Credentials IS NOT NULL
             THEN tblDoctor.FirstName + ' ' + tblDoctor.LastName
                  + ', ' + tblDoctor.Credentials
             ELSE tblDoctor.[Prefix] + ' ' + tblDoctor.FirstName + ' '
                  + tblDoctor.LastName
        END AS DoctorName,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblClient.LastName + ', ' + tblClient.FirstName AS ClientName,
        tblCompany.intName AS CompanyName,
        tblAcctHeader.ClientCode AS InvClientCode,
        tblAcctHeader.CompanyCode AS InvCompanyCode,
        InvCl.LastName + ', ' + InvCl.FirstName AS InvClientName,
        InvCom.intName AS InvCompanyName,
        tblCase.priority,
        tblCase.DateAdded,
        tblCase.Claimnbr,
        tblCase.DoctorLocation,
        tblCase.ApptTime,
        tblCase.DateEdited,
        tblCase.useridEdited,
        tblClient.email AS adjusteremail,
        tblClient.Fax AS adjusterFax,
        tblCase.marketerCode,
        tblCase.useridAdded,
        tblAcctHeader.documentDate,
        tblAcctHeader.INBatchSelect,
        tblAcctHeader.VOBatchSelect,
        tblAcctHeader.taxCode,
        tblAcctHeader.taxtotal,
        tblAcctHeader.documenttotal,
        tblAcctHeader.documentstatus,
        tblAcctHeader.batchnbr,
        tblCase.serviceCode,
        tblAcctHeader.officeCode,
        tblDoctor.DoctorCode,
        tblAcctHeader.apptDate,
        tblCase.Casetype
FROM    tblAcctHeader
        INNER JOIN tblCase ON tblCase.Casenbr = TblAcctHeader.Casenbr
        LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
        LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
        LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
        LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
        LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
        LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode
GO


CREATE VIEW vwAcctingVOSummary
AS
    SELECT 
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineeName ,
            tblacctingtrans.DrOpType ,
            CASE tblacctingtrans.droptype
              WHEN 'DR'
              THEN ISNULL(tblDoctor.LastName, '') + ', '
                   + ISNULL(tblDoctor.FirstName, '')
              WHEN ''
              THEN ISNULL(tblDoctor.LastName, '') + ', '
                   + ISNULL(tblDoctor.FirstName, '')
              WHEN '' THEN ISNULL(tblCase.DoctorName, '')
              WHEN 'OP' THEN tblDoctor.CompanyName
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.intName AS CompanyName ,
            tblCase.priority ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            ISNULL(tblLocation_1.LocationCode, tblCase.DoctorLocation) AS DoctorLocation ,
            tblCase.shownoshow ,
            tblCase.transCode ,
            tblCase.rptstatus ,
            tblCase.DateEdited ,
            tblCase.useridEdited ,
            tblCase.apptSelect ,
            tblClient.email AS adjusteremail ,
            tblClient.Fax AS adjusterFax ,
            tblCase.marketerCode ,
            tblCase.requesteddoc ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.Datedrchart ,
            tblCase.drchartSelect ,
            tblCase.inqaSelect ,
            tblCase.intransSelect ,
            tblAcctingTrans.blnSelect AS billedSelect ,
            tblCase.awaittransSelect ,
            tblCase.chartprepSelect ,
            tblCase.apptrptsSelect ,
            tblCase.transreceived ,
            tblCase.ServiceCode ,
            tblQueues.statusDesc ,
            tblCase.miscSelect ,
            tblCase.useridAdded ,
            tblacctingtrans.statusCode ,
            tblCase.voucherSelect ,
            tblacctingtrans.DocumentNbr ,
            tblacctingtrans.DocumentDate ,
            tblacctingtrans.Documentamount ,
            tblServices.Description AS ServiceDesc ,
            tblCase.officeCode ,
            tblDoctor.CompanyName AS otherpartyName ,
            tblDoctor.DoctorCode ,
            tblCase.CaseNbr ,
            tblacctingtrans.SeqNO ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.schedulerCode ,
            tblCase.notes ,
            tblDoctor.notes AS Doctornotes ,
            tblCompany.notes AS Companynotes ,
            tblClient.notes AS Clientnotes ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.Laststatuschg, GETDATE()) AS IQ ,
            tblCase.Laststatuschg ,
            ISNULL(tblacctingtrans.apptDate, tblCase.ApptDate) AS apptDate ,
            ISNULL(tblLocation_1.Location, tblLocation.Location) AS Location ,
            tblacctingtrans.apptTime ,
            tblApptStatus.Name AS Result ,
            tblCase.mastersubCase ,
            tblCase.billingnote ,
            tblCasetype.Description AS CaseType,
            tblAcctingTrans.ApptStatusID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.CaseNbr = tblacctingtrans.CaseNbr
            INNER JOIN tblQueues ON tblacctingtrans.statusCode = tblQueues.statusCode
            INNER JOIN tblCaseType ON tblCasetype.Code = tblCase.Casetype
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblLocation tblLocation_1 ON tblacctingtrans.DoctorLocation = tblLocation_1.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartNbr = tblExaminee.chartNbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID=tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statusCode <> 20 )
            AND tblacctingtrans.type = 'VO'
GO

CREATE VIEW vwApptLog
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.DateAdded ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes AS DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            vwCaseAppt.Specialties AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<vwCaseAppt.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            '' AS ProvTypeCode 
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9 
GO

CREATE VIEW vwApptLogDocs
AS
    SELECT 
            tblCase.CaseNbr ,
            CA.DateAdded ,
            CA.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, CA.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            ISNULL(CA.SpecialtyCode, tblCaseApptPanel.SpecialtyCode) AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        PriorAppt.ApptTime
              FROM      tblCaseAppt AS PriorAppt
                        WHERE PriorAppt.CaseNbr = tblCase.CaseNbr
                        AND PriorAppt.CaseApptID<CA.CaseApptID
              ORDER BY  PriorAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tblDoctor.ProvTypeCode
    FROM    tblCaseAppt AS CA
			INNER JOIN tblApptStatus ON CA.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON CA.CaseNbr = tblCase.CaseNbr

            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            
			LEFT OUTER JOIN tblCaseApptPanel ON CA.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = CA.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(CA.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode

            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON CA.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9 
GO

CREATE VIEW vwAssocCases
AS
SELECT      tblDoctor.LastName, tblDoctor.FirstName, tblDoctor.Credentials AS degree, tblSpecialty.Description AS Specialty, 
                      tblCase.ApptDate, tblCase.ApptTime, tblCase.CaseNbr, tblCase.MasterSubCase, tblCase.MasterCaseNbr, tblDoctor.Prefix, 
                      tblSpecialty.SpecialtyCode, tblDoctor.DoctorCode, tblDoctor.WCNbr, tblDoctor.UnRegNbr, tblServices.Description AS Service, 
                      tblLocation.Addr1, tblLocation.Addr2, tblLocation.City, tblLocation.State, tblLocation.Zip, tblLocation.Phone, 
                      tblLocation.Fax, tblDoctorSchedule.duration, tblCase.Status, tblProviderType.Description AS DoctorProviderType
FROM         tblServices INNER JOIN
                      tblCase ON tblServices.ServiceCode = tblCase.ServiceCode LEFT OUTER JOIN
                      tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode LEFT OUTER JOIN
                      tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode LEFT OUTER JOIN
                      tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode LEFT OUTER JOIN
                      tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode LEFT OUTER JOIN
                      tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
GO

CREATE VIEW vwAvailablePanelDrsWithNotes
AS
    SELECT  tblDoctor.notes ,
            tblAvailDoctor.*
    FROM    tblAvailDoctor
            INNER JOIN tblDoctor ON tblAvailDoctor.DoctorCode = tblDoctor.DoctorCode
GO
 
CREATE VIEW vwCancelAppt
AS
    SELECT DISTINCT 
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.DoctorNames ,
            tblLocation.Location ,
            vwCaseAppt.CanceledBy ,
            vwCaseAppt.Reason ,
            vwCaseAppt.ApptTime ,
            vwCaseAppt.DateEdited ,
            vwCaseAppt.UserIDEdited ,
            tblOffice.Description AS Office ,
            tblCaseType.Description AS CaseType ,
            vwClient.Client ,
            vwClient.IntName AS Company ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee ,
            tblServices.Description AS Service ,
            tblCase.MarketerCode ,
            tblCase.CaseNbr ,
            tblCase.QARep ,
            tblCase.OfficeCode ,
            tblCaseType.Code ,
            vwClient.CompanyCode ,
            vwClient.ClientCode ,
            tblExaminee.ChartNbr ,
            tblServices.ServiceCode
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN vwClient ON tblCase.ClientCode = vwClient.ClientCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
GO
 
CREATE VIEW vwCaseCC
AS
    SELECT  tblCase.CaseNbr ,
            tblCCAddress.Prefix ,
            tblCCAddress.LastName ,
            tblCCAddress.FirstName ,
            CASE WHEN tblCCAddress.LastName IS NULL THEN ''
                 ELSE ISNULL(tblCCAddress.Prefix, '') + ' '
                      + ISNULL(tblCCAddress.FirstName, '') + ' '
                      + ISNULL(tblCCAddress.LastName, '')
            END AS contact ,
            tblCCAddress.Company ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            tblCCAddress.State ,
            tblCCAddress.Zip ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCase.ChartNbr ,
            tblCCAddress.Status ,
            tblCCAddress.ccCode ,
            tblCCAddress.City + ', ' + tblCCAddress.State + '  '
            + tblCCAddress.Zip AS CityStateZip
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblExamineecc ON tblCase.ChartNbr = tblExamineecc.ChartNbr
            INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
    WHERE   ( tblCCAddress.Status = 'Active' )
GO
 
CREATE VIEW vwCaseHistoryDesc
AS
    SELECT  CASE WHEN tblCasehistory.type = 'StatChg'
                 THEN CAST(ISNULL(tblCasehistory.duration / 24,
                                  DATEDIFF(day, tblCase.LastStatuschg,
                                           GETDATE())) AS DECIMAL(6, 1))
            END AS IQ ,
            tblCaseHistory.id ,
            tblCaseHistory.duration ,
            tblCaseHistory.type ,
            tblCaseHistory.Status ,
            tblCaseHistory.PublishOnWeb ,
            tblCaseHistory.CaseNbr ,
            tblCaseHistory.eventDate ,
            tblCaseHistory.eventdesc ,
            tblCaseHistory.UserID ,
            tblCaseHistory.otherinfo ,
            tblCasehistory.highlight ,
            tblCasehistory.publishedto
    FROM    tblCaseHistory
            INNER JOIN tblCase ON tblCaseHistory.CaseNbr = tblCase.CaseNbr
GO
 
CREATE VIEW vwCaseMonitor
AS
    SELECT  COUNT(*) AS Casecount ,
            SUM(vwCaseMonitorDetail.Rush) AS RushCount ,
            SUM(vwCaseMonitorDetail.Normal) AS NormalCount ,
            vwCaseMonitorDetail.Status ,
            MAX(tblQueues.DisplayOrder) AS DisplayOrder ,
            tblQueues.StatusDesc ,
            tblQueues.formtoOpen
    FROM    tblQueues
            INNER JOIN vwCaseMonitorDetail ON tblQueues.StatusCode = vwCaseMonitorDetail.Status
    GROUP BY vwCaseMonitorDetail.Status ,
            tblQueues.StatUSDesc ,
            tblQueues.formtoopen
GO
 
CREATE VIEW vwCaseProblem
AS
    SELECT  tblCaseproblem.CaseNbr ,
            tblCaseproblem.problemCode ,
            tblproblem.Description
    FROM    tblCaseproblem
            INNER JOIN tblproblem ON tblCaseproblem.problemCode = tblproblem.problemCode
GO
 
CREATE VIEW vwCaseSummary
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.INQASelect ,
            tblCase.INTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.transReceived ,
            tblTranscription.TransCompany ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.MiscSelect ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.VoucherAmt ,
            tblCase.VoucherDate ,
            tblCase.OfficeCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            tblCase.PanelNbr ,
            tblCase.CommitDate ,
            tblCase.MasterSubCase ,
            tblCase.MasterCaseNbr ,
            tblCase.CertMailNbr ,
            tblCase.WebNotifyEmail ,
            tblCase.PublishOnWeb ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS DoctorName ,
            tblCase.Datemedsrecd ,
            tblCase.sInternalCaseNbr ,
            tblCase.DoctorSpecialty ,
            tblCase.USDDate1 ,
            tblqueues.FunctionCode ,
            tblCase.Casetype ,
            tblCase.DateCompleted ,
            tblCase.DateCanceled ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.ClaimNbrExt ,
            tblLocation.Addr1 AS LocationAddr1 ,
            tblLocation.Addr2 AS LocationAddr2 ,
            tblLocation.City AS LocationCity ,
            tblLocation.State AS LocationState ,
            tblLocation.Zip AS LocationZip
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblTranscription ON tblCase.transCode = tblTranscription.transCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany
            INNER JOIN tblClient ON tblCompany.CompanyCode = tblClient.CompanyCode ON tblCase.ClientCode = tblClient.ClientCode
GO
 
CREATE VIEW vwCaseSummaryWithSecurity
AS
SELECT      tblCase.CaseNbr, tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName, 
                      tblClient.LastName + ', ' + tblClient.FirstName AS ClientName, tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName, 
                      tblCompany.IntName AS CompanyName, tblCase.Priority, tblCase.ApptDate, tblCase.Status, tblCase.DateAdded, 
                      tblCase.ClaimNbr, tblCase.DoctorLocation, tblCase.ApptTime, tblCase.shownoshow, tblCase.transCode, tblCase.rptStatus, 
                      tblLocation.Location, tblCase.DateEdited, tblCase.UserIDEdited, tblCase.ApptSelect, tblClient.Email AS AdjusterEmail, 
                      tblClient.Fax AS AdjusterFax, tblCase.MarketerCode, tblCase.Requesteddoc, tblCase.InvoiceDate, tblCase.Invoiceamt, 
                      tblCase.DatedrChart, tblCase.drChartSelect, tblCase.inqaSelect, tblCase.intransSelect, tblCase.billedSelect, 
                      tblCase.awaittransSelect, tblCase.ChartprepSelect, tblCase.ApptrptsSelect, tblCase.transreceived, tblTranscription.transCompany, 
                      tblCase.ServiceCode, tblQueues.StatUSDesc, tblCase.miscSelect, tblCase.UserIDAdded, tblServices.ShortDesc AS Service, 
                      tblCase.DoctorCode, tblClient.CompanyCode, tblCase.Voucheramt, tblCase.VoucherDate, tblCase.OfficeCode, tblCase.QARep, 
                      tblCase.SchedulerCode, DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ, tblCase.LastStatuschg, tblCase.PanelNbr, 
                      tblCase.CommitDate, tblCase.MastersubCase, tblCase.MasterCaseNbr, tblCase.CertMailNbr, tblCase.WebNotifyEmail, 
                      tblCase.PublishOnWeb, CASE WHEN tblCase.PanelNbr IS NULL THEN tblDoctor.LastName + ', ' + isnull(tblDoctor.FirstName, ' ') 
                      ELSE tblCase.DoctorName END AS DoctorName, tblCase.Datemedsrecd, tblCase.sinternalCaseNbr, tblCase.DoctorSpecialty, 
                      tblCase.USDDate1, tblqueues.functionCode, tbluserOfficefunction.UserID, tblCase.Casetype, tblCase.ForecastDate, tblCase.externaldueDate, tblCase.internaldueDate
FROM         tblCase INNER JOIN
                      tblQueues ON tblCase.Status = tblQueues.StatusCode INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode LEFT OUTER JOIN
                      tblTranscription ON tblCase.transCode = tblTranscription.transCode LEFT OUTER JOIN
                      tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode LEFT OUTER JOIN
                      tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode LEFT OUTER JOIN
                      tblUser ON tblCase.SchedulerCode = tblUser.UserID LEFT OUTER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr LEFT OUTER JOIN
                      tblCompany INNER JOIN
                      tblClient ON tblCompany.CompanyCode = tblClient.CompanyCode ON tblCase.ClientCode = tblClient.ClientCode INNER JOIN
                      tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode INNER JOIN
                      tbluserOfficefunction ON tblUserOffice.UserID = tbluserOfficefunction.UserID AND 
                      tblUserOffice.OfficeCode = tbluserOfficefunction.OfficeCode AND tblqueues.functionCode = tbluserOfficefunction.functionCode
GO
 
CREATE VIEW vwCaseTypeServiceQueues
AS
    SELECT  tblCaseTypeService.CaseType ,
            tblCaseTypeService.ServiceCode ,
            tblServiceQueues.StatusCode ,
            tblQueues.DisplayOrder ,
            tblServices.Description AS ServiceDesc ,
            tblQueues.StatUSDesc AS queuedesc ,
            tblCaseType.Description AS CaseTypeDesc ,
            tblQueues.ShortDesc ,
            tblServiceQueues.queueOrder ,
            tblCaseTypeService.OfficeCode
    FROM    tblCaseTypeService
            INNER JOIN tblServiceQueues ON tblCaseTypeService.ServiceCode = tblServiceQueues.ServiceCode
            INNER JOIN tblQueues ON tblServiceQueues.StatusCode = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCaseTypeService.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblCaseType ON tblCaseTypeService.Casetype = tblCaseType.Code
    WHERE   ( tblQueues.subtype = 'Case' )
GO
 
CREATE VIEW vwCCExport
AS
    SELECT DISTINCT
            tblCCAddress.LastName ,
            tblCCAddress.FirstName ,
            tblCCAddress.Prefix ,
            tblCCAddress.Company ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            tblCCAddress.State ,
            tblCCAddress.Zip ,
            tblCCAddress.Phone ,
            tblCCAddress.Phoneextension AS extension ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCCAddress.Status ,
            tblCCAddress.OfficeCode ,
            tblOffice.Description AS Office
    FROM    tblCCAddress
            LEFT OUTER JOIN tblOffice ON tblCCAddress.OfficeCode = tblOffice.OfficeCode
GO
 
CREATE VIEW vwCCs
AS
    SELECT  ccCode ,
            CASE WHEN tblCCAddress.LastName IS NULL THEN tblCCAddress.Company
                 ELSE ISNULL(tblCCAddress.LastName, '') + ', '
                      + ISNULL(tblCCAddress.FirstName, '')
            END AS Contact ,
            Address1 AS Address ,
            City ,
            State ,
            Status ,
            Company ,
            ISNULL(Company, LastName + ', ' + FirstName) AS displayName ,
            OfficeCode
    FROM    tblCCAddress
    WHERE   ( Status = 'Active' )
GO
 
CREATE VIEW vwClientExportColumns
AS
SELECT DISTINCT 
                         tblClient.LastName, tblClient.FirstName, tblCompany.extName AS Company, tblClient.title, tblClient.Prefix, 
                        tblClient.suffix, tblClient.Addr1 AS Address1, tblClient.Addr2 AS Address2, tblClient.City, tblClient.State, tblClient.Zip, 
                        tblClient.Phone1 AS Phone, tblClient.Phone1ext AS extension, tblClient.Fax, tblClient.Email, tblClient.MarketerCode AS Marketer, 
                        tblCompany.IntName AS CompanyinternalName, tblClient.Status, tblClient.QARep, tblOffice.ShortDesc AS Office, 
                        tblClient.CompanyCode, tblClient.ClientCode, tblOffice.OfficeCode, tblClientType.Description AS ClientType, 
                        tblEWCompanyType.Name AS CompanyType, tblEWFacility.ShortName AS FacilityName
FROM          tblClient INNER JOIN
                        tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode LEFT OUTER JOIN
                        tblEWFacility ON tblCompany.EWFacilityID = tblEWFacility.EWFacilityID LEFT OUTER JOIN
                        tblEWCompanyType ON tblCompany.EWCompanyTypeID = tblEWCompanyType.EWCompanyTypeID LEFT OUTER JOIN
                        tblCase ON tblClient.ClientCode = tblCase.ClientCode LEFT OUTER JOIN
                        tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode LEFT OUTER JOIN
                        tblClientType ON tblClient.TypeCode = tblClientType.typeCode
GO
 
CREATE VIEW vwDaySheetWithOffice
AS
SELECT      tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                      tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                      tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                      tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                      + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                      tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                      tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, NULL AS Panelnote, tblCase.OfficeCode, 
                      CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, tblServices.ShortDesc, 
                      tblimedata.Fax,Case when (Select top 1 type from tblrecordhistory where type = 'F' and CaseNbr = tblCase.CaseNbr) = 'F' then 'Films' else '' end as films
FROM         tblLocation INNER JOIN
                      tblDoctorSchedule INNER JOIN
                      tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                      tblLocation.LocationCode = tblDoctorSchedule.LocationCode LEFT OUTER JOIN
                      tblCaseType INNER JOIN
                      tblClient INNER JOIN
                      tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON tblDoctorSchedule.schedCode = tblCase.schedCode INNER JOIN
                      tblOffice ON tblOffice.OfficeCode = tblCase.OfficeCode INNER JOIN
                      tblIMEData ON tblIMEData.IMECode = tblOffice.imeCode
WHERE     (tblCase.schedCode IS NOT NULL)
UNION
SELECT      tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                      tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                      tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                      tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                      + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                      tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                      tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, CAST(tblCasePanel.Panelnote AS varchar(50)) 
                      AS Panelnote, tblCase.OfficeCode, CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL 
                      END AS ScheduleDescription, tblServices.ShortDesc, tblimedata.Fax,Case when (Select top 1 type from tblrecordhistory where type = 'F' and CaseNbr = tblCase.CaseNbr) = 'F' then 'Films' else '' end as films
FROM         tblCaseType INNER JOIN
                      tblClient INNER JOIN
                      tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                      tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr RIGHT OUTER JOIN
                      tblLocation INNER JOIN
                      tblDoctorSchedule INNER JOIN
                      tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                      tblLocation.LocationCode = tblDoctorSchedule.LocationCode ON tblCasePanel.schedCode = tblDoctorSchedule.schedCode INNER JOIN
                      tblOffice ON tblOffice.OfficeCode = tblCase.OfficeCode INNER JOIN
                      tblIMEData ON tblIMEData.IMECode = tblOffice.imeCode
WHERE     ((tblDoctorSchedule.Status = 'open') OR
                      (tblDoctorSchedule.Status = 'Scheduled') OR
                      (tblDoctorSchedule.Status = 'Hold')) AND tblCase.PanelNbr IS NOT NULL
GO
 
CREATE VIEW vwDoctorExportColumns
AS
SELECT DISTINCT 
              tblDoctor.LastName, tblDoctor.FirstName, tblDoctor.middleinitial, tblDoctor.Credentials AS degree, tblDoctor.Prefix, 
               tblDoctor.Status, tblDoctor.Addr1 AS Address1, tblDoctor.Addr2 AS Address2, tblDoctor.City, tblDoctor.State, tblDoctor.Zip, 
               tblDoctor.Phone, tblDoctor.PhoneExt AS Extension, tblDoctor.FaxNbr AS Fax, tblDoctor.EmailAddr AS Email, tblDoctor.OPType, 
               tblSpecialty.Description AS Specialty, tblOffice.Description AS Office, tblOffice.OfficeCode, tblDoctor.DoctorCode, 
               tblProviderType.Description AS ProviderType, tblDoctor.USDvarchar1, tblDoctor.USDvarchar2, tblDoctor.USDDate1, tblDoctor.USDDate2, 
               tblDoctor.USDint1, tblDoctor.USDint2, tblDoctor.USDmoney1, tblDoctor.USDmoney2, tblDoctor.USDDate3, tblDoctor.USDDate4, 
               tblDoctor.USDvarchar3, tblDoctor.USDDate5, tblDoctor.USDDate6, tblDoctor.USDDate7, tblDoctor.licenseNbr, tblDoctor.WCNbr
FROM  tblDoctor LEFT OUTER JOIN
               tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode LEFT OUTER JOIN
               tblOffice RIGHT OUTER JOIN
               tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON 
               tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode LEFT OUTER JOIN
               tblSpecialty INNER JOIN
               tblDoctorSpecialty ON tblSpecialty.SpecialtyCode = tblDoctorSpecialty.SpecialtyCode ON 
               tblDoctor.DoctorCode = tblDoctorSpecialty.DoctorCode
WHERE (tblDoctor.OPType = 'DR')
GO
 
CREATE VIEW vwDoctorSchedule
AS
SELECT       tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                        tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                        tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                        tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                        tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                        tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, NULL AS Panelnote, 
                        CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, 
                        tblServices.ShortDesc, tblimedata.Fax, CASE WHEN tblCase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter, 
                        tblDoctorSchedule.duration, tblCompany.IntName AS CompanyIntName
FROM          tblLocation INNER JOIN
                        tblDoctorSchedule INNER JOIN
                        tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                        tblLocation.LocationCode = tblDoctorSchedule.LocationCode LEFT OUTER JOIN
                        tblCaseType INNER JOIN
                        tblClient INNER JOIN
                        tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                        tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                        tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON 
                        tblDoctorSchedule.schedCode = tblCase.schedCode LEFT OUTER JOIN
                        tblIMEData INNER JOIN
                        tblOffice INNER JOIN
                        tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                        tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE      (tblDoctorSchedule.Status = 'open') OR
                        (tblDoctorSchedule.Status = 'Hold') OR
                        ((tblDoctorSchedule.Status = 'Scheduled') AND (tblCase.schedCode IS NOT NULL))
UNION
SELECT       tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                        tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                        tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                        tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                        tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                        tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, CAST(tblCasePanel.Panelnote AS varchar(50)) 
                        AS Panelnote, CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, 
                        tblServices.ShortDesc, tblimedata.Fax, CASE WHEN tblCase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter, 
                        tblDoctorSchedule.duration, tblCompany.IntName AS CompanyIntName
FROM          tblCaseType INNER JOIN
                        tblClient INNER JOIN
                        tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                        tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                        tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                        tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr RIGHT OUTER JOIN
                        tblLocation INNER JOIN
                        tblDoctorSchedule INNER JOIN
                        tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                        tblLocation.LocationCode = tblDoctorSchedule.LocationCode ON 
                        tblCasePanel.schedCode = tblDoctorSchedule.schedCode LEFT OUTER JOIN
                        tblIMEData INNER JOIN
                        tblOffice INNER JOIN
                        tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                        tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE      ((tblDoctorSchedule.Status = 'open') OR
                        (tblDoctorSchedule.Status = 'Scheduled') OR
                        (tblDoctorSchedule.Status = 'Hold')) AND tblCase.PanelNbr IS NOT NULL
GO
 
CREATE VIEW vwDoctorScheduleBMC
AS
SELECT      tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                      tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                      tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                      tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                      + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                      tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                      tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, NULL AS Panelnote, 
                      CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, tblLocation.Addr1, 
                      tblLocation.Addr2, tblLocation.City, tblLocation.State, tblLocation.Zip
FROM         tblLocation INNER JOIN
                      tblDoctorSchedule INNER JOIN
                      tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                      tblLocation.LocationCode = tblDoctorSchedule.LocationCode LEFT OUTER JOIN
                      tblCaseType INNER JOIN
                      tblClient INNER JOIN
                      tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON 
                      tblDoctorSchedule.schedCode = tblCase.schedCode LEFT OUTER JOIN
                      tblIMEData INNER JOIN
                      tblOffice INNER JOIN
                      tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                      tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE     ((tblDoctorSchedule.Status = 'Scheduled') AND (tblCase.schedCode IS NOT NULL))
UNION
SELECT      tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                      tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                      tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                      tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                      + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                      tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                      AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                      tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, CAST(tblCasePanel.Panelnote AS varchar(50)) 
                      AS Panelnote, CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, 
                      tblLocation.Addr1, tblLocation.Addr2, tblLocation.City, tblLocation.State, tblLocation.Zip
FROM         tblCaseType INNER JOIN
                      tblClient INNER JOIN
                      tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                      tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr RIGHT OUTER JOIN
                      tblLocation INNER JOIN
                      tblDoctorSchedule INNER JOIN
                      tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                      tblLocation.LocationCode = tblDoctorSchedule.LocationCode ON 
                      tblCasePanel.schedCode = tblDoctorSchedule.schedCode LEFT OUTER JOIN
                      tblIMEData INNER JOIN
                      tblOffice INNER JOIN
                      tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                      tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE     (tblDoctorSchedule.Status = 'Scheduled') AND (tblCase.CaseNbr IS NOT NULL)
GO
 
CREATE VIEW vwDoctorScheduleSummary
AS
    SELECT  tblDoctor.LastName ,
            tblDoctor.FirstName ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblLocation.InsideDr ,
            tblDoctor.DoctorCode ,
            tblDoctorOffice.OfficeCode ,
            tblDoctorSchedule.LocationCode ,
            tblDoctor.Booking ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctorSchedule.StartTime
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
            INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )
GO
 
CREATE VIEW vwDoctorSchedulewithOffice
AS
SELECT       tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                        tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                        tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                        tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                        tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                        tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, NULL AS Panelnote, tblDoctorOffice.OfficeCode, 
                        CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL END AS ScheduleDescription, 
                        tblServices.ShortDesc, tblimedata.Fax, CASE WHEN tblCase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter
FROM          tblLocation INNER JOIN
                        tblDoctorSchedule INNER JOIN
                        tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                        tblLocation.LocationCode = tblDoctorSchedule.LocationCode LEFT OUTER JOIN
                        tblCaseType INNER JOIN
                        tblClient INNER JOIN
                        tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                        tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                        tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON 
                        tblDoctorSchedule.schedCode = tblCase.schedCode LEFT OUTER JOIN
                        tblIMEData INNER JOIN
                        tblOffice INNER JOIN
                        tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                        tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE      (tblDoctorSchedule.Status = 'open') OR
                        (tblDoctorSchedule.Status = 'Hold') OR
                        ((tblDoctorSchedule.Status = 'Scheduled') AND (tblCase.schedCode IS NOT NULL))
UNION
SELECT       tblDoctorSchedule.LocationCode, tblDoctorSchedule.Date, tblDoctorSchedule.StartTime, 
                        tblDoctorSchedule.Description, tblDoctorSchedule.Status, tblDoctorSchedule.DoctorCode, tblDoctorSchedule.schedCode, 
                        tblCase.CaseNbr, tblCompany.extName AS Company, tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName, 
                        tblLocation.Location, tblIMEData.CompanyName, ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName, tblCase.ClaimNbr, tblClient.FirstName + ' ' + tblClient.LastName AS ClientName, 
                        tblCaseType.Description AS Casetypedesc, tblServices.Description AS Servicedesc, CAST(tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, tblCase.WCBNbr, tblLocation.Phone AS DoctorPhone, tblLocation.Fax AS DoctorFax, tblCase.photoRqd, 
                        tblClient.Phone1 AS ClientPhone, tblCase.DoctorName AS Paneldesc, tblCase.PanelNbr, CAST(tblCasePanel.Panelnote AS varchar(50)) 
                        AS Panelnote, tblDoctorOffice.OfficeCode, CASE WHEN tblCase.CaseNbr IS NULL THEN tblDoctorSchedule.CaseNbr1desc ELSE NULL 
                        END AS ScheduleDescription, tblServices.ShortDesc, tblimedata.Fax, 
                        CASE WHEN tblCase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter
FROM          tblCaseType INNER JOIN
                        tblClient INNER JOIN
                        tblCase ON tblClient.ClientCode = tblCase.ClientCode INNER JOIN
                        tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.Casetype INNER JOIN
                        tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                        tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr RIGHT OUTER JOIN
                        tblLocation INNER JOIN
                        tblDoctorSchedule INNER JOIN
                        tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON 
                        tblLocation.LocationCode = tblDoctorSchedule.LocationCode ON 
                        tblCasePanel.schedCode = tblDoctorSchedule.schedCode LEFT OUTER JOIN
                        tblIMEData INNER JOIN
                        tblOffice INNER JOIN
                        tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblIMEData.IMECode = tblOffice.imeCode ON 
                        tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
WHERE      ((tblDoctorSchedule.Status = 'open') OR
                        (tblDoctorSchedule.Status = 'Scheduled') OR
                        (tblDoctorSchedule.Status = 'Hold')) AND tblCase.PanelNbr IS NOT NULL
GO
 
CREATE VIEW vwExamineeCases
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ApptDate ,
            tblCase.ChartNbr ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblLocation.Location ,
            tblQueues.StatUSDesc ,
            ISNULL(tblSpecialty_2.Description, tblSpecialty_1.Description) AS Specialtydesc ,
            tblSpecialty_1.Description ,
            tblServices.ShortDesc ,
            tblCase.MastersubCase ,
            ISNULL(tblCase.MasterCaseNbr, tblCase.CaseNbr) AS MasterCaseNbr ,
            tblCase.DoctorName
    FROM    tblSpecialty tblSpecialty_2
            RIGHT OUTER JOIN tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblSpecialty tblSpecialty_1 ON tblCase.sreqSpecialty = tblSpecialty_1.SpecialtyCode ON tblSpecialty_2.SpecialtyCode = tblCase.DoctorSpecialty
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
GO
 
CREATE VIEW vwExceptionDefinitionListing
AS
SELECT      tblExceptionDefinition.Description, tblExceptionDefinition.Entity, tblExceptionList.Description AS ExceptionDesc, 
                      isnull(tblCaseType.Description, 'All') AS CaseType, isnull(tblServices.Description, 'All') AS Service, isnull(tblQueues.StatUSDesc, 'All') 
                      AS Status, tblExceptionDefinition.StatusCodeValue, tblExceptionDefinition.DisplayMessage, tblExceptionDefinition.RequireComment, 
                      tblExceptionDefinition.EmailMessage, tblExceptionDefinition.GenerateDocument, tblExceptionDefinition.Message, 
                      tblExceptionDefinition.EditEmail, tblExceptionDefinition.EmailScheduler, tblExceptionDefinition.EmailQA, 
                      tblExceptionDefinition.EmailOther, tblExceptionDefinition.EmailSubject, tblExceptionDefinition.EmailText, 
                      tblExceptionDefinition.Document1, tblExceptionDefinition.Document2, tblExceptionDefinition.Status AS Active, 
                      tblExceptionDefinition.DateAdded, tblExceptionDefinition.UserIDAdded, tblExceptionDefinition.DateEdited, 
                      tblExceptionDefinition.UserIDEdited, CASE WHEN tblexceptiondefinition.entity = 'CL' THEN isnull
                          ((SELECT     LastName + ', ' + FirstName
                              FROM         tblClient
                              WHERE     ClientCode = tblexceptiondefinition.imecentricCode), 'All Clients') WHEN tblexceptiondefinition.entity = 'CO' THEN isnull
                          ((SELECT     IntName
                              FROM         tblCompany
                              WHERE     CompanyCode = tblexceptiondefinition.imecentricCode), 'All Companies') 
                      WHEN tblexceptiondefinition.entity = 'DR' THEN isnull
                          ((SELECT     LastName + ', ' + FirstName
                              FROM         tblDoctor
                              WHERE     DoctorCode = tblexceptiondefinition.imecentricCode), 'All Doctors') WHEN tblexceptiondefinition.entity = 'OP' THEN isnull
                          ((SELECT     CompanyName
                              FROM         tblDoctor
                              WHERE     DoctorCode = tblexceptiondefinition.imecentricCode), 'All Other Parties') 
                      WHEN tblexceptiondefinition.entity = 'AT' THEN isnull
                          ((SELECT     isnull(Company, '') + ' ' + isnull(LastName, '') + ', ' + isnull(FirstName, '')
                              FROM         tblccAddress
                              WHERE     ccCode = tblexceptiondefinition.imecentricCode), 'All Attorneys') WHEN tblexceptiondefinition.entity = 'CC' THEN isnull
                          ((SELECT     isnull(Company, '') + ' ' + isnull(LastName, '') + ', ' + isnull(FirstName, '')
                              FROM         tblccAddress
                              WHERE     ccCode = tblexceptiondefinition.imecentricCode), 'All CCs') 
                      WHEN tblexceptiondefinition.entity = 'CS' THEN 'All Cases' END AS EntityDescription
FROM         tblExceptionDefinition INNER JOIN
                      tblExceptionList ON tblExceptionDefinition.ExceptionID = tblExceptionList.ExceptionID LEFT OUTER JOIN
                      tblQueues ON tblExceptionDefinition.StatusCode = tblQueues.StatusCode LEFT OUTER JOIN
                      tblServices ON tblExceptionDefinition.ServiceCode = tblServices.ServiceCode LEFT OUTER JOIN
                      tblCaseType ON tblExceptionDefinition.CaseTypeCode = tblCaseType.Code
GO
 
CREATE VIEW vwExportSummaryWithSecurity
AS
SELECT  tblCase.CaseNbr, tblAcctHeader.documenttype, tblAcctHeader.documentNbr, tblAcctingTrans.StatusCode, 
			                  tblAcctHeader.EDIBatchNbr, tblAcctHeader.EDIStatus, tblAcctHeader.EDILastStatusChg, tblAcctHeader.EDIRejectedMsg,
                        tblQueues.StatUSDesc, tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName, tblAcctingTrans.DrOpType, 
                        CASE ISNULL(tblCase.PanelNbr, 0) WHEN 0 THEN CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.FirstName, '') WHEN '' THEN ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.FirstName, '') 
                        WHEN '' THEN ISNULL(tblCase.DoctorName, '') 
                        WHEN 'OP' THEN tblDoctor.CompanyName END ELSE CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '') 
                        WHEN '' THEN ISNULL(tblCase.DoctorName, '') WHEN 'OP' THEN tblDoctor.CompanyName END END AS DoctorName, 
                        tblClient.LastName + ', ' + tblClient.FirstName AS ClientName, tblCompany.IntName AS CompanyName, tblCase.Priority, 
                        tblCase.ApptDate, tblCase.DateAdded, tblCase.ClaimNbr, tblCase.DoctorLocation, tblCase.ApptTime, tblCase.DateEdited, 
                        tblCase.UserIDEdited, tblClient.Email AS AdjusterEmail, tblClient.Fax AS AdjusterFax, tblCase.MarketerCode, tblCase.UserIDAdded, 
                        tblAcctHeader.documentDate, tblAcctHeader.INBatchSelect, tblAcctHeader.VOBatchSelect, tblAcctHeader.taxCode, 
                        tblAcctHeader.taxtotal, tblAcctHeader.documenttotal, tblAcctHeader.documentStatus, tblCase.ClientCode, tblCase.DoctorCode, 
                        tblAcctHeader.batchNbr, tblCase.OfficeCode, tblCase.SchedulerCode, tblClient.CompanyCode, tblCase.QARep, 
                        tblCase.PanelNbr, DATEDIFF(day, tblAcctingTrans.LastStatuschg, GETDATE()) AS IQ, tblCase.MastersubCase, 
                        tblqueues_1.StatUSDesc AS CaseStatus, tblUserOfficeFunction.UserID, tblQueues.functionCode, tblServices.ShortDesc AS Service, 
                        tblCase.ServiceCode, tblCase.Casetype
FROM          tblAcctHeader INNER JOIN
                        tblAcctingTrans ON tblAcctHeader.seqno = tblAcctingTrans.SeqNO INNER JOIN
                        tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr LEFT OUTER JOIN
                        tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode LEFT OUTER JOIN
                        tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode INNER JOIN
                        tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode INNER JOIN
                        tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode LEFT OUTER JOIN
                        tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode LEFT OUTER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr INNER JOIN
                        tblServices ON tblServices.ServiceCode = tblCase.ServiceCode INNER JOIN
                        tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode INNER JOIN
                        tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID AND 
                        tblUserOfficeFunction.OfficeCode = tblCase.OfficeCode AND tblQueues.functionCode = tblUserOfficeFunction.functionCode
WHERE      (tblAcctingTrans.StatusCode <> 20) AND (tblAcctHeader.batchNbr IS NULL) AND (tblAcctHeader.documentStatus = 'Final')
GO

 
CREATE VIEW vwMatrixClientExport
AS
SELECT DISTINCT  ClaimNbr, ClientName, ChartNbr, Specialtydesc, ExamineeName, ApptDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'FinalRpt'
                            ORDER BY eventDate DESC) AS ReportDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'Scheduled'
                            ORDER BY eventDate DESC) AS ScheduledDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'Cancel'
                            ORDER BY eventDate DESC) AS CancelDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'ReSchedule'
                            ORDER BY eventDate DESC) AS ReScheduledDate, Servicedesc, Datecalledin AS DateAdded, ClientLastName, ClientFirstName, medsrecd, 
                      ExamineeLastName, ExamineeFirstName, CompanyCode, CaseNbr
FROM vwDocument
GO
 
CREATE VIEW vwMatrixTDExport
AS
SELECT    CaseNbr, ClaimNbr, ClientName, ChartNbr, Specialtydesc, ExamineeCity, ExamineeState, ExamineeName, DOI, DoctorLastName, DoctorCity, ApptDate, 
                      notes,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          TblAcctHeader
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'IN') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS InvoiceTotal,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          TblAcctHeader AS TblAcctHeader_2
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'VO') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS Vouchertotal,
                          (SELECT     SUM(taxamount1) AS Expr1
                            FROM          TblAcctHeader AS TblAcctHeader_1
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'IN') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS GST,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'FinalRpt')
                            ORDER BY eventDate DESC) AS ReportDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_3
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'Scheduled')
                            ORDER BY eventDate DESC) AS ScheduledDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_2
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'Cancel')
                            ORDER BY eventDate DESC) AS CancelDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_1
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'ReSchedule')
                            ORDER BY eventDate DESC) AS ReScheduledDate, OCF25Date AS DateofNotice, Servicedesc, Datecalledin AS DateAdded, CompanyCode, ClientLastName, 
                      ClientFirstName, medsrecd, ISNULL(CaseUSDvarchar1, 'Not Assigned') AS PrincipleInsurer, CaseUSDDate2 AS ClaimantContactDate, CompanyUSDvarchar1, 
                      AssessmentToAddress, Company, calledinby, Location, CaseUSDvarchar1 AS Brand
FROM vwDocument
GO
 
CREATE VIEW vwPatientCCs
AS
    SELECT  tblExamineecc.ChartNbr ,
            tblExamineecc.ccCode ,
            tblCCAddress.Prefix ,
            tblCCAddress.LastName + ', ' + tblCCAddress.FirstName AS contact ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            tblCCAddress.State ,
            tblCCAddress.Phone ,
            tblCCAddress.Zip ,
            tblCCAddress.Phoneextension ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCCAddress.UserIDAdded ,
            tblCCAddress.DateAdded ,
            tblCCAddress.UserIDEdited ,
            tblCCAddress.DateEdited ,
            tblCCAddress.Status
    FROM    tblExamineecc
            INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
    WHERE   ( tblCCAddress.Status = 'Active' )
GO
 
CREATE VIEW vwReportTATRpt
AS
SELECT      tblCaseHistory.CaseNbr, tblCaseHistory.eventDate, tblCaseHistory.eventdesc, 
                      tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee, tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctor, 
                      tblCase.ApptDate, DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) AS Age, tblCompany.CompanyCode, 
                      tblCase.ServiceCode, tblServices.Description AS Service, tblCompany.IntName AS Company, 
                      tblClient.LastName + ', ' + tblClient.FirstName AS Client, tblClient.ClientCode, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 7 THEN 1 ELSE 0 END AS age1count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 7 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 14 THEN 1 ELSE 0 END AS age2count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 14 AND DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 21 THEN 1 ELSE 0 END AS age3count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 21 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 28 THEN 1 ELSE 0 END AS age4count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 28 THEN 1 ELSE 0 END AS age5count, 
                      tblCase.DoctorLocation AS Location, tblCase.MarketerCode, tblCase.Casetype, tblServices.ShortDesc AS ServiceShortDesc, 
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode
FROM         tblCaseHistory INNER JOIN
                      tblCase ON tblCaseHistory.CaseNbr = tblCase.CaseNbr INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr INNER JOIN
                      tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode INNER JOIN
                      tblClient ON tblCase.ClientCode = tblClient.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                      tblCaseType ON tblCase.Casetype = tblCaseType.Code
WHERE     (tblCaseHistory.type = 'FinalRpt')
GO
 
CREATE VIEW vwReportTATRptDocs
AS
SELECT      tblCaseHistory.CaseNbr, tblCaseHistory.eventDate, tblCaseHistory.eventdesc, 
                      tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee, tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctor, 
                      tblCase.ApptDate, DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) AS Age, tblCompany.CompanyCode, 
                      tblCase.ServiceCode, tblServices.Description AS Service, tblCompany.IntName AS Company, 
                      tblClient.LastName + ', ' + tblClient.FirstName AS Client, tblClient.ClientCode, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 7 THEN 1 ELSE 0 END AS age1count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 7 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 14 THEN 1 ELSE 0 END AS age2count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 14 AND DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 21 THEN 1 ELSE 0 END AS age3count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 21 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 28 THEN 1 ELSE 0 END AS age4count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 28 THEN 1 ELSE 0 END AS age5count, 
                      tblCase.DoctorLocation AS Location, tblCase.MarketerCode, tblCase.Casetype, tblServices.ShortDesc AS ServiceShortDesc, 
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode
FROM         tblCaseHistory INNER JOIN
                      tblCase ON tblCaseHistory.CaseNbr = tblCase.CaseNbr INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr INNER JOIN
                      tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode INNER JOIN
                      tblClient ON tblCase.ClientCode = tblClient.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                      tblCaseType ON tblCase.Casetype = tblCaseType.Code
WHERE     (tblCaseHistory.type = 'FinalRpt')
UNION
SELECT      tblCaseHistory.CaseNbr, tblCaseHistory.eventDate, tblCaseHistory.eventdesc, 
                      tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee, tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctor, 
                      tblCase.ApptDate, DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) AS Age, tblCompany.CompanyCode, 
                      tblCase.ServiceCode, tblServices.Description AS Service, tblCompany.IntName AS Company, 
                      tblClient.LastName + ', ' + tblClient.FirstName AS Client, tblClient.ClientCode, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 7 THEN 1 ELSE 0 END AS age1count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 7 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 14 THEN 1 ELSE 0 END AS age2count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 14 AND DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) <= 21 THEN 1 ELSE 0 END AS age3count, CASE WHEN DATEDIFF(dd, tblCase.ApptDate, 
                      tblCaseHistory.eventDate) > 21 AND DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) <= 28 THEN 1 ELSE 0 END AS age4count, 
                      CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.eventDate) > 28 THEN 1 ELSE 0 END AS age5count, 
                      tblCase.DoctorLocation AS Location, tblCase.MarketerCode, tblCase.Casetype, tblServices.ShortDesc AS ServiceShortDesc, 
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode
FROM         tblCaseHistory INNER JOIN
                      tblCase ON tblCaseHistory.CaseNbr = tblCase.CaseNbr INNER JOIN
                      tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr INNER JOIN
                      tblClient ON tblCase.ClientCode = tblClient.ClientCode INNER JOIN
                      tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode INNER JOIN
                      tblServices ON tblCase.ServiceCode = tblServices.ServiceCode INNER JOIN
                      tblCaseType ON tblCase.Casetype = tblCaseType.Code INNER JOIN
                      tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr INNER JOIN
                      tblDoctor ON tblCasePanel.DoctorCode = tblDoctor.DoctorCode
WHERE     (tblCaseHistory.type = 'FinalRpt')
GO
 
CREATE VIEW vwRptCancelDetail
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.Reason ,
            vwCaseAppt.CanceledBy ,
            tblCase.Casetype ,
            tblCase.MastersubCase
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
GO
 
CREATE VIEW vwRptCancelDetailDocs
AS
    SELECT 
            tblCaseAppt.CaseNbr ,
            tblCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCaseAppt.ApptStatusID ,
            tblApptStatus.Name AS ApptStatus ,
            tblCaseAppt.LastStatusChg ,
            tblCaseAppt.Reason ,
            tblCanceledBy.Name AS CanceledBy ,
            tblCase.Casetype ,
            tblCase.MastersubCase
    FROM    tblCaseAppt
			INNER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON tblCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblCaseApptPanel ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = tblCaseAppt.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCaseAppt.ApptStatusID IN (50, 51)
GO
 
CREATE VIEW vwRptNoShowDetail
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            tblCase.Casetype
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
GO
 
CREATE VIEW vwRptNoShowDetailDocs
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            tblCase.Casetype
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblCaseApptPanel ON tblCaseApptPanel.CaseApptID = vwCaseAppt.CaseApptID
            INNER JOIN tblDoctor ON tblCaseApptPanel.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
GO
 
CREATE VIEW vwRptOutstandingRecords
AS
    SELECT DISTINCT
            tblFacility.Name AS Facility ,
            tblFacility.Phone AS FacilityPhone ,
            tblFacility.Fax AS FacilityFax ,
            tblRecordsObtainment.CheckDate ,
            tblRecordsObtainment.Fee ,
            tblRecordsObtainment.CheckNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee ,
            tblCase.ClaimNbr ,
            tblCase.CaseNbr ,
            tblRecordsObtainmentDetail.DateReceived ,
            tblCase.OfficeCode ,
            tblRecordsObtainment.WaitingForInvoice ,
            tblRecordsObtainmentDetail.NotAvailable
    FROM    tblRecordsObtainment
            INNER JOIN tblRecordsObtainmentDetail ON tblRecordsObtainment.RecordsID = tblRecordsObtainmentDetail.RecordsID
            INNER JOIN tblFacility ON tblRecordsObtainment.FacilityID = tblFacility.FacilityID
            INNER JOIN tblCase ON tblRecordsObtainment.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
    WHERE   ( tblRecordsObtainmentDetail.DateReceived IS NULL )
            AND ( tblRecordsObtainmentDetail.NotAvailable = 0
                  OR tblRecordsObtainmentDetail.NotAvailable IS NULL
                )
            AND ( tblRecordsObtainment.CheckNbr IS NOT NULL )
            AND ( tblRecordsObtainment.Fee <> 0 )
GO


CREATE VIEW vwExportSummary
AS
    SELECT  tblCase.casenbr ,
            TblAcctHeader.documenttype ,
            TblAcctHeader.documentnbr ,
            tblacctingtrans.statuscode ,
            TblAcctHeader.HCAIBranchID ,
            TblAcctHeader.HCAIInsurerID ,
            TblAcctHeader.Message ,
            tblQueues.statusdesc ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
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
            tblCase.ApptDate ,
            tblCase.dateadded ,
            tblCase.claimnbr ,
            tblCase.doctorlocation ,
            tblCase.Appttime ,
            tblCase.dateedited ,
            tblCase.useridedited ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.useridadded ,
            TblAcctHeader.documentdate ,
            TblAcctHeader.INBatchSelect ,
            TblAcctHeader.VOBatchSelect ,
            TblAcctHeader.taxcode ,
            TblAcctHeader.taxtotal ,
            TblAcctHeader.documenttotal ,
            TblAcctHeader.documentstatus ,
            tblCase.clientcode ,
            tblCase.doctorcode ,
            TblAcctHeader.batchnbr ,
            tblacctingtrans.documentnbr AS Expr1 ,
            tblCase.officecode ,
            tblCase.schedulercode ,
            tblClient.companycode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.mastersubcase ,
            tblqueues_1.statusdesc AS CaseStatus ,
            tblacctingtrans.SeqNO
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblQueues tblqueues_1 ON tblcase.status = tblQueues_1.statuscode
            INNER JOIN TblAcctHeader ON tblCase.casenbr = TblAcctHeader.casenbr
                                        AND tblacctingtrans.type = TblAcctHeader.documenttype
                                        AND tblacctingtrans.documentnbr = TblAcctHeader.documentnbr
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblCompany
            INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode
    WHERE   ( tblacctingtrans.statuscode <> 20 )
            AND ( TblAcctHeader.batchnbr IS NULL )
            AND ( TblAcctHeader.documentstatus = 'Final' )
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[spIMEWORKFLOW_GetClientsToSynch]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROC spIMEWORKFLOW_GetClientsToSynch
GO
CREATE PROC spIMEWORKFLOW_GetClientsToSynch
AS 
    BEGIN
        DECLARE @LastWebCutoff DATETIME

        SELECT  @LastWebCutoff = LastWebCutoffDate
        FROM    tblControl

        SELECT  tblClient.companycode ,
                tblClient.lastname ,
                tblClient.firstname ,
                tblClient.email ,
                tblClient.WebGUID ,
                tblClient.clientcode ,
                tblCompany.extname ,
                tblCompany.WebGUID AS CompanyWebGUID
        FROM    tblClient
                INNER JOIN tblCompany ON tblClient.companyCode = tblCompany.CompanyCode
        WHERE   tblClient.publishOnWeb = 1
                AND tblCompany.publishOnWeb = 1
                AND tblClient.email IS NOT NULL
                AND ( tblClient.WebGUID IS NULL
                      OR ( tblClient.dateedited < @LastWebCutoff
                           AND tblClient.dateedited > tblClient.WebLastSynchDate
                         )
                    )
    END
GO

DROP PROC spExamineeCases
GO
CREATE PROC spExamineeCases
    (
      @ChartNbr INTEGER ,
      @UserID VARCHAR(30)
    )
AS 
    SELECT  *
    FROM    ( SELECT    tblCase.CaseNbr ,
                        DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
                        tblCase.ChartNbr ,
                        tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
                        tblLocation.Location ,
                        CASE WHEN tblCaseAppt.CaseApptID = tblCase.CaseApptID
                                  OR ROW_NUMBER() OVER ( PARTITION BY tblCase.CaseNbr ORDER BY tblCaseAppt.CaseApptID DESC ) = 1
                             THEN tblQueues.StatusDesc
                             ELSE ''
                        END AS StatusDesc ,
                        ISNULL(ApptSpec.Description,
                               ISNULL(CaseSpec.Description,
                                      ReqSpec.Description)) AS SpecialtyDesc ,
                        ReqSpec.Description ,
                        tblServices.ShortDesc ,
                        tblCase.MasterSubCase ,
                        ISNULL(tblCase.mastercasenbr, tblCase.casenbr) AS MasterCaseNbr ,
                        tblDoctor.FirstName + ' ' + tblDoctor.LastName AS DoctorName ,
                        tbloffice.shortdesc AS Office ,
                        tblApptStatus.Name AS Result ,
                        tblCaseAppt.CaseApptID
              FROM      tblCase
                        INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
                        INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
                        INNER JOIN tblUserOffice ON tblCase.officecode = tblUserOffice.officecode
                        INNER JOIN tbloffice ON tbloffice.officecode = tblcase.officecode
                        LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseNbr = tblCaseAppt.CaseNbr
                        LEFT OUTER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
                        LEFT OUTER JOIN tblSpecialty AS ReqSpec ON tblCase.sreqspecialty = ReqSpec.specialtycode
                        LEFT OUTER JOIN tblSpecialty AS CaseSpec ON tblCase.DoctorSpecialty = CaseSpec.specialtycode
                        LEFT OUTER JOIN tblSpecialty AS ApptSpec ON ApptSpec.specialtycode = tblCaseAppt.SpecialtyCode
                        LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode,
                                                            tblCase.DoctorCode) = tblDoctor.doctorcode
                        LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.locationcode
                        LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
              WHERE     ( tblCase.chartnbr = @ChartNbr )
                        AND ( tblUserOffice.userid = @UserID )
            ) AS eeCases
    ORDER BY eeCases.MasterCaseNbr DESC ,
            eeCases.MasterSubCase ,
            eeCases.ApptDate DESC ,
            eeCases.CaseApptID DESC
GO


DROP VIEW vwregistertotal
GO
CREATE VIEW vwRegisterTotal
AS
    SELECT  Casenbr ,
            documenttype ,
            documentnbr ,
            ExamineeName ,
            DoctorName ,
            ClientCode ,
            CompanyCode ,
            ClientName ,
            CompanyName ,
            InvClientCode ,
            InvCompanyCode ,
            InvClientName ,
            InvCompanyName ,
            priority ,
            DateAdded ,
            Claimnbr ,
            DoctorLocation ,
            ApptTime ,
            DateEdited ,
            useridEdited ,
            adjusteremail ,
            adjusterFax ,
            marketerCode ,
            useridAdded ,
            documentDate ,
            INBatchSelect ,
            VOBatchSelect ,
            taxCode ,
            taxtotal ,
            documenttotal ,
            documentstatus ,
            batchnbr ,
            serviceCode ,
            officeCode ,
            DoctorCode ,
            apptDate ,
            Casetype
    FROM    vwAcctDocuments
GO

DROP VIEW vwregister
GO
CREATE VIEW vwRegister
AS
    SELECT  tblAcctDetail.extendedamount ,
            tblproduct.INglacct ,
            tblproduct.VOglacct ,
            tblAcctDetail.longdesc ,
            vwAcctDocuments.Casenbr ,
            vwAcctDocuments.documenttype ,
            vwAcctDocuments.documentnbr ,
            vwAcctDocuments.ExamineeName ,
            vwAcctDocuments.DoctorName ,
            vwAcctDocuments.ClientCode ,
            vwAcctDocuments.CompanyCode ,
            vwAcctDocuments.ClientName ,
            vwAcctDocuments.CompanyName ,
            vwAcctDocuments.InvClientCode ,
            vwAcctDocuments.InvCompanyCode ,
            vwAcctDocuments.InvClientName ,
            vwAcctDocuments.InvCompanyName ,
            vwAcctDocuments.priority ,
            vwAcctDocuments.DateAdded ,
            vwAcctDocuments.Claimnbr ,
            vwAcctDocuments.DoctorLocation ,
            vwAcctDocuments.ApptTime ,
            vwAcctDocuments.DateEdited ,
            vwAcctDocuments.useridEdited ,
            vwAcctDocuments.adjusteremail ,
            vwAcctDocuments.adjusterFax ,
            vwAcctDocuments.marketerCode ,
            vwAcctDocuments.useridAdded ,
            vwAcctDocuments.documentDate ,
            vwAcctDocuments.INBatchSelect ,
            vwAcctDocuments.VOBatchSelect ,
            vwAcctDocuments.taxCode ,
            vwAcctDocuments.taxtotal ,
            vwAcctDocuments.documenttotal ,
            vwAcctDocuments.documentstatus ,
            vwAcctDocuments.batchnbr ,
            vwAcctDocuments.serviceCode ,
            vwAcctDocuments.officeCode ,
            vwAcctDocuments.DoctorCode ,
            vwAcctDocuments.apptDate ,
            vwAcctDocuments.Casetype
    FROM    tblAcctDetail
            INNER JOIN tblproduct ON tblAcctDetail.prodcode = tblproduct.prodcode
            INNER JOIN vwAcctDocuments ON tblAcctDetail.documenttype = vwAcctDocuments.documenttype
                                              AND tblAcctDetail.documentnbr = vwAcctDocuments.documentnbr

GO

DROP VIEW vwDoctorExport
GO
CREATE VIEW vwDoctorExport
AS
    SELECT  vwDoctorExportColumns.LastName ,
            vwDoctorExportColumns.FirstName ,
            vwDoctorExportColumns.middleinitial ,
            vwDoctorExportColumns.degree ,
            vwDoctorExportColumns.Prefix ,
            vwDoctorExportColumns.Status ,
            vwDoctorExportColumns.Address1 ,
            vwDoctorExportColumns.Address2 ,
            vwDoctorExportColumns.City ,
            vwDoctorExportColumns.State ,
            vwDoctorExportColumns.Zip ,
            vwDoctorExportColumns.Phone ,
            vwDoctorExportColumns.Extension ,
            vwDoctorExportColumns.Fax ,
            vwDoctorExportColumns.Email ,
            vwDoctorExportColumns.OPType ,
            vwDoctorExportColumns.Specialty ,
            vwDoctorExportColumns.Office ,
            vwDoctorExportColumns.OfficeCode ,
            vwDoctorExportColumns.DoctorCode ,
            vwDoctorExportColumns.ProviderType ,
            vwDoctorExportColumns.USDvarchar1 ,
            vwDoctorExportColumns.USDvarchar2 ,
            vwDoctorExportColumns.USDDate1 ,
            vwDoctorExportColumns.USDDate2 ,
            vwDoctorExportColumns.USDint1 ,
            vwDoctorExportColumns.USDint2 ,
            vwDoctorExportColumns.USDmoney1 ,
            vwDoctorExportColumns.USDmoney2 ,
            vwDoctorExportColumns.USDDate3 ,
            vwDoctorExportColumns.USDDate4 ,
            vwDoctorExportColumns.USDvarchar3 ,
            vwDoctorExportColumns.USDDate5 ,
            vwDoctorExportColumns.USDDate6 ,
            vwDoctorExportColumns.USDDate7 ,
            vwDoctorExportColumns.licenseNbr ,
            vwDoctorExportColumns.WCNbr ,
            tblDoctor.notes ,
            tblDoctor.usdtext1 ,
            tblDoctor.usdtext2
    FROM    vwDoctorExportColumns
            INNER JOIN tblDoctor ON vwDoctorExportColumns.doctorcode = tblDoctor.doctorcode
GO

DROP VIEW vwAvailablePanelDrsWithNotes
GO
CREATE VIEW vwAvailablePanelDrsWithNotes
AS
    SELECT  tblDoctor.notes ,
            tblAvailDoctor.RecID ,
            tblAvailDoctor.UserID ,
            tblAvailDoctor.DoctorCode ,
            tblAvailDoctor.LocationCode ,
            tblAvailDoctor.FirstAvail ,
            tblAvailDoctor.Doctorname ,
            tblAvailDoctor.Location ,
            tblAvailDoctor.City ,
            tblAvailDoctor.State ,
            tblAvailDoctor.County ,
            tblAvailDoctor.Prepaid ,
            tblAvailDoctor.vicinity ,
            tblAvailDoctor.Phone ,
            tblAvailDoctor.Specialty ,
            tblAvailDoctor.proximity ,
            tblAvailDoctor.SchedulePriority ,
            tblAvailDoctor.degree ,
            tblAvailDoctor.StartTime ,
            tblAvailDoctor.selected ,
            tblAvailDoctor.SortDate ,
            tblAvailDoctor.SortProximity
    FROM    tblAvailDoctor
            INNER JOIN tblDoctor ON tblAvailDoctor.DoctorCode = tblDoctor.DoctorCode
GO

DROP VIEW vwClientExport
GO
CREATE VIEW vwClientExport
AS
    SELECT  vwClientExportColumns.LastName ,
            vwClientExportColumns.FirstName ,
            vwClientExportColumns.Company ,
            vwClientExportColumns.title ,
            vwClientExportColumns.Prefix ,
            vwClientExportColumns.suffix ,
            vwClientExportColumns.Address1 ,
            vwClientExportColumns.Address2 ,
            vwClientExportColumns.City ,
            vwClientExportColumns.State ,
            vwClientExportColumns.Zip ,
            vwClientExportColumns.Phone ,
            vwClientExportColumns.extension ,
            vwClientExportColumns.Fax ,
            vwClientExportColumns.Email ,
            vwClientExportColumns.Marketer ,
            vwClientExportColumns.CompanyinternalName ,
            vwClientExportColumns.Status ,
            vwClientExportColumns.QARep ,
            vwClientExportColumns.Office ,
            vwClientExportColumns.CompanyCode ,
            vwClientExportColumns.ClientCode ,
            vwClientExportColumns.OfficeCode ,
            vwClientExportColumns.ClientType ,
            vwClientExportColumns.CompanyType ,
            vwClientExportColumns.FacilityName ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes
    FROM    vwClientExportColumns
            INNER JOIN tblCompany ON vwClientExportColumns.companycode = tblCompany.companycode
            INNER JOIN tblClient ON vwClientExportColumns.clientcode = tblClient.clientcode
GO

DROP VIEW vwOfficeIMEData
GO
CREATE VIEW vwOfficeIMEData
AS
    SELECT  tblOffice.OfficeCode ,
            tblIMEData.CompanyName ,
            tblIMEData.Addr1 ,
            tblIMEData.Addr2 ,
            tblIMEData.City ,
            tblIMEData.State ,
            tblIMEData.Zip ,
            tblIMEData.Phone ,
            tblIMEData.Fax ,
            tblIMEData.Website ,
            tblIMEData.EmailAddress ,
            tblIMEData.Logo ,
            tblIMEData.DirTemplate ,
            tblIMEData.DirDocument ,
            tblIMEData.DirDirections ,
            tblIMEData.NoShowLtrDocument ,
            tblIMEData.EmailCapability ,
            tblIMEData.FaxCapability ,
            tblIMEData.LabelCapability ,
            tblIMEData.SupportCompany ,
            tblIMEData.SupportEmail ,
            tblIMEData.FaxServerName ,
            tblIMEData.FaxCoverPage ,
            tblIMEData.UserIDAdded ,
            tblIMEData.DateAdded ,
            tblIMEData.UserIDEdited ,
            tblIMEData.DateEdited ,
            tblIMEData.DistanceUofM ,
            tblIMEData.MedsRecdDocument ,
            tblIMEData.SerialNumber ,
            tblIMEData.DaysToCancel ,
            tblIMEData.OrderCCDropdown ,
            tblIMEData.IMECreate ,
            tblIMEData.RequirePDF ,
            tblIMEData.VerbalDocument ,
            tblIMEData.VerbalQueue ,
            tblIMEData.BrqInternalCaseNbr ,
            tblIMEData.SortCaseHistoryDesc ,
            tblIMEData.INFeeCode ,
            tblIMEData.VOFeeCode ,
            tblIMEData.NextInvoiceNbr ,
            tblIMEData.INDocumentCode ,
            tblIMEData.VODocumentCode ,
            tblIMEData.AccountingSystem ,
            tblIMEData.CreateVouchers ,
            tblIMEData.InvoiceDesc ,
            tblIMEData.DefARAcctNbr ,
            tblIMEData.DefAPAcctNbr ,
            tblIMEData.NextVoucherNbr ,
            tblIMEData.IMEAccount ,
            tblIMEData.StdTerms ,
            tblIMEData.NextBatchNbr ,
            tblIMEData.TaxCode ,
            tblIMEData.InvoiceCopies ,
            tblIMEData.DirImport ,
            tblIMEData.VoucherCopies ,
            tblIMEData.InvoiceDate ,
            tblIMEData.SourceDirectory ,
            tblIMEData.Country ,
            tblIMEData.QBCustMask ,
            tblIMEData.QBVendorMask ,
            tblIMEData.IMECode ,
            tblIMEData.QAfterNoShow ,
            tblIMEData.UsePanelExam ,
            tblIMEData.blnUseSubCases ,
            tblIMEData.ShowOntarioAutoFields ,
            tblIMEData.DirAcctDocument ,
            tblIMEData.DefaultAddressLabel ,
            tblIMEData.DefaultCaseLabel ,
            tblIMEData.UseBillingCompany ,
            tblIMEData.InvoiceNoShows ,
            tblIMEData.InvoiceLateCancels ,
            tblIMEData.VoucherNoShows ,
            tblIMEData.VoucherLateCancels ,
            tblIMEData.ShowEWFacilityOnInvVo ,
            tblIMEData.ShowProductDescOnClaimForm ,
            tblIMEData.ShowClientAsReferringProvider ,
            tblIMEData.UseHCAIInterface ,
            tblIMEData.NextEDIBatchNbr ,
            tblIMEData.FaxServerType ,
            tblIMEData.ATSecurityProfileID ,
            tblIMEData.CLSecurityProfileID ,
            tblIMEData.DRSecurityProfileID ,
            tblIMEData.OPSecurityProfileID ,
            tblIMEData.TRSecurityProfileID ,
            tblIMEData.ApptDuration ,
            tblIMEData.MonetaryUnit ,
            tblIMEData.UseMutipleTreatingPhysicians ,
            tblIMEData.MultiPortal ,
            tblIMEData.TranscriptionCapability ,
            tblIMEData.UseCustomRptCoverLetterDir ,
            tblIMEData.DirRptCoverLetter ,
            tblIMEData.DirDictationFiles ,
            tblIMEData.DirTranscription ,
            tblIMEData.WorkHourStart ,
            tblIMEData.WorkHourEnd ,
            tblIMEData.CountryID ,
            tblIMEData.DirVoicePlayer ,
            tblIMEData.DrDocFolderID ,
            tblIMEData.QAfterLateCancel ,
            tblIMEData.CalcTaxOnVouchers ,
            tblIMEData.TaxCalcMethod ,
            tblIMEData.IncludeSubCaseOnMaster
    FROM    tblOffice
            INNER JOIN tblIMEData ON tblOffice.IMECode = tblIMEData.IMEcode
GO

DROP VIEW vwavailabledoctorswithnotes
GO
CREATE VIEW vwAvailableDoctorsWithNotes
AS
    SELECT  tblDoctor.notes ,
            tblDoctor.usdmoney1 ,
            tblDoctor.usdmoney2 ,
            tblAvailDoctor.RecID ,
            tblAvailDoctor.UserID ,
            tblAvailDoctor.DoctorCode ,
            tblAvailDoctor.LocationCode ,
            tblAvailDoctor.FirstAvail ,
            tblAvailDoctor.Doctorname ,
            tblAvailDoctor.Location ,
            tblAvailDoctor.City ,
            tblAvailDoctor.State ,
            tblAvailDoctor.County ,
            tblAvailDoctor.Prepaid ,
            tblAvailDoctor.vicinity ,
            tblAvailDoctor.Phone ,
            tblAvailDoctor.Specialty ,
            tblAvailDoctor.proximity ,
            tblAvailDoctor.SchedulePriority ,
            tblAvailDoctor.degree ,
            tblAvailDoctor.StartTime ,
            tblAvailDoctor.selected ,
            tblAvailDoctor.SortDate ,
            tblAvailDoctor.SortProximity
    FROM    tblavaildoctor
            INNER JOIN tblDoctor ON tblavaildoctor.doctorcode = tblDoctor.doctorcode
GO

DROP VIEW vwExamineeRecordHistory
GO
CREATE VIEW vwExamineeRecordHistory
AS
    SELECT  tblRecordActions.Description ,
            tblRecordHistory.MedRecID ,
            tblRecordHistory.CaseNbr ,
            tblRecordHistory.ActionID ,
            tblRecordHistory.Type ,
            tblRecordHistory.Inches ,
            tblRecordHistory.Pages ,
            tblRecordHistory.Notes ,
            tblRecordHistory.DateAdded ,
            tblRecordHistory.UserIDAdded ,
            tblRecordHistory.DateEdited ,
            tblRecordHistory.UserIDEdited ,
            tblRecordHistory.OnINDocument ,
            tblRecordHistory.OnVODocument
    FROM    tblRecordHistory
            INNER JOIN tblRecordActions ON tblRecordHistory.ActionID = tblRecordActions.ActionID
GO

DROP VIEW vwCaseTrans
GO
CREATE VIEW vwCaseTrans
AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DocumentNbr ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode
    FROM    TblCaseTrans
    WHERE   ( documentnbr IS NULL )
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.CaseNbr = @CaseNbr
		
	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTranscriptionJobID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTranscriptionJobID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TranscriptionJobID = @TranscriptionJobID
		
	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTransCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByTransCode];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTransCode]
(
	@TransCode int,
	@TranscriptionStatusCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	(SELECT COUNT(TranscriptionJobID) FROM tblTranscriptionJob WHERE tblTranscriptionJob.TransCode = @TransCode AND TranscriptionStatusCode = @TranscriptionStatusCode) AS 'TransCount',
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND TranscriptionStatusCode = @TranscriptionStatusCode
	SET @Err = @@Error

	RETURN @Err
END
GO


ALTER TABLE tblScanSettingWorkstation
 ADD EnableLogFile BIT DEFAULT (0)
GO
ALTER TABLE tblScanSetting
 ADD AutoScan INT DEFAULT (1)
GO
UPDATE tblScanSetting set AutoScan=1
GO

UPDATE tblControl SET DBVersion='2.16'
GO
