PRINT N'Altering [dbo].[vwAcctDocuments]...';


GO
ALTER VIEW vwAcctDocuments
AS
    SELECT  tblCase.CaseNbr ,
            tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            CASE WHEN tblDoctor.Credentials IS NOT NULL
                 THEN tblDoctor.FirstName + ' ' + tblDoctor.LastName + ', '
                      + tblDoctor.Credentials
                 ELSE tblDoctor.[Prefix] + ' ' + tblDoctor.FirstName + ' '
                      + tblDoctor.LastName
            END AS DoctorName ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblAcctHeader.ClientCode AS InvClientCode ,
            tblAcctHeader.CompanyCode AS InvCompanyCode ,
            InvCl.LastName + ', ' + InvCl.FirstName AS InvClientName ,
            InvCom.IntName AS InvCompanyName ,
            tblCase.Priority ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS adjusteremail ,
            tblClient.Fax AS adjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.BatchNbr ,
            tblCase.ServiceCode ,
            tblAcctHeader.OfficeCode ,
            tblDoctor.DoctorCode ,
            tblAcctHeader.ApptDate ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblAcctHeader
            INNER JOIN tblCase ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
            LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode
GO
PRINT N'Altering [dbo].[vwacctexception]...';


GO
ALTER VIEW [dbo].[vwacctexception]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblQueues.statusdesc, dbo.tblCase.status, dbo.tblCase.ApptDate, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname AS doctorname, 
                      dbo.tblCompany.intname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblCase.voucheramt, 
                      dbo.tblCase.voucherdate, dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.officecode, dbo.tblCase.ExtCaseNbr 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
WHERE     (dbo.tblCase.status = 8) AND (dbo.tblCase.voucheramt <> 0) AND (dbo.tblCase.invoiceamt = 0) OR
                      (dbo.tblCase.status = 8) AND (dbo.tblCase.voucheramt = 0) AND (dbo.tblCase.invoiceamt <> 0)
GO
PRINT N'Altering [dbo].[vwAcctingParam]...';


GO
ALTER VIEW vwAcctingParam
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.ServiceCode ,
            C.Notes ,
			C.ExtCaseNbr, 

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                     + ISNULL(ATDr.firstName, '')
            END AS DrOpName ,

            COM.CompanyCode ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
			ATL.LocationCode AS DoctorLocation ,
            ATL.Location AS Location ,

			C.BillingNote ,
            COM.Notes AS CompanyNotes ,
            CL.Notes AS ClientNotes ,
            ATDr.Notes AS DoctorNotes ,
			ATDr.DrAcctingNote ,

            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO
PRINT N'Altering [dbo].[vwAcctingSummary]...';


GO
ALTER VIEW vwAcctingSummary
AS
    Select 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            AT.blnSelect AS billedSelect ,
            C.ApptSelect ,
            C.drchartSelect ,
            C.inqaSelect ,
            C.inTransSelect ,
            C.awaitTransSelect ,
            C.chartprepSelect ,
            C.ApptrptsSelect ,
            C.miscSelect ,
            C.voucherSelect ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.ServiceCode ,
            C.Notes ,

            C.QARep ,
            C.LastStatusChg ,
            C.CaseType,
			C.Status AS CaseStatusCode ,
            C.Priority ,
            C.MasterSubCase ,

            C.MarketerCode ,
            C.SchedulerCode ,
            C.RequestedDoc ,
            C.InvoiceDate ,
            C.InvoiceAmt ,
            C.DateDrChart ,
            C.TransReceived ,
            C.ShownoShow ,
            C.TransCode ,
            C.rptStatus ,

            C.DateAdded ,
            C.DateEdited ,
            C.UserIDEdited ,
            C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END AS DrOpName ,

            COM.CompanyCode ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
			ATL.LocationCode AS DoctorLocation ,
            ATL.Location AS Location ,

            CT.Description AS CaseTypeDesc ,
			CaseQ.StatusDesc AS CaseStatusDesc ,
            tblApptStatus.Name AS Result ,
            ATQ.StatusDesc ,
            ATQ.FunctionCode ,
            S.Description AS ServiceDesc, 
			C.ExtCaseNbr 

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO
PRINT N'Altering [dbo].[vwApptLogByAppt]...';


GO
ALTER VIEW dbo.vwApptLogByAppt
AS
    SELECT TOP 100 PERCENT
            dbo.tblCase.ApptDate ,
            dbo.tblCaseType.ShortDesc AS [Case Type] ,
            dbo.tblCase.DoctorName AS Doctor ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS Client ,
            dbo.tblCompany.intname AS Company ,
            dbo.tblCase.DoctorLocation ,
            dbo.tblLocation.Location ,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee ,
            dbo.tblCase.MarketerCode ,
            dbo.tblCase.SchedulerCode ,
            dbo.tblExaminee.SSN ,
            dbo.tblQueues.statusdesc ,
            dbo.tblDoctor.doctorcode ,
            dbo.tblCase.clientcode ,
            dbo.tblCompany.companycode ,
            dbo.tblCase.dateadded ,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.CaseNbr ,
            dbo.tblCase.priority ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.status ,
            dbo.tblCase.servicecode ,
            dbo.tblServices.shortdesc ,
            dbo.tblSpecialty.description ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS OfficeName ,
            GETDATE() AS today ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblCase.HearingDate ,
            dbo.tblCase.casetype ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.mastersubcase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<tblCase.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            dbo.tblDoctor.ProvTypeCode ,
            dbo.tblDoctor.phone AS DoctorPhone ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName ,
            dbo.tblCase.ExternalDueDate ,
            dbo.tblCase.InternalDueDate ,
            dbo.tblCase.ForecastDate , 
			dbo.tblCase.ExtCaseNbr 
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode
            LEFT OUTER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
    GROUP BY dbo.tblCase.ApptDate ,
            dbo.tblCaseType.ShortDesc ,
            dbo.tblCase.DoctorName ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname ,
            dbo.tblCompany.intname ,
            dbo.tblCase.doctorlocation ,
            dbo.tblLocation.location ,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.schedulercode ,
            dbo.tblExaminee.SSN ,
            dbo.tblQueues.statusdesc ,
            dbo.tblDoctor.doctorcode ,
            dbo.tblCase.clientcode ,
            dbo.tblCompany.companycode ,
            dbo.tblCase.dateadded ,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, '') ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.casenbr ,
            dbo.tblCase.priority ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.status ,
            dbo.tblCase.servicecode ,
            dbo.tblServices.shortdesc ,
            dbo.tblSpecialty.description ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description ,
            dbo.tblCase.QARep ,
            dbo.tblCase.HearingDate ,
            dbo.tblCase.casetype ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.mastersubcase ,
            dbo.tblDoctor.ProvTypeCode ,
            dbo.tblDoctor.phone ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname ,
            dbo.tblCase.ExternalDueDate ,
            dbo.tblCase.InternalDueDate ,
            dbo.tblCase.ForecastDate,
            dbo.tblCase.CaseApptID , 
			dbo.tblCase.ExtCaseNbr
GO
PRINT N'Altering [dbo].[vwCaseHistoryFollowUp]...';


GO
ALTER VIEW vwCaseHistoryFollowUp
AS
SELECT  C.CaseNbr ,
        C.DoctorName ,
        C.ApptDate ,
        C.ClaimNbr ,

		C.DoctorCode ,
		C.SchedulerCode ,
		C.OfficeCode ,
		C.MarketerCode ,
		CL.CompanyCode ,
		C.ClientCode ,
		C.DoctorLocation ,
		C.QARep ,
		C.CaseType ,
		C.ServiceCode , 
		C.ExtCaseNbr , 

        EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
        CL.LastName + ', ' + CL.FirstName AS ClientName ,
        COM.IntName AS CompanyName ,
        L.Location ,

        S.ShortDesc AS Service ,
        Q.ShortDesc AS Status ,

        CH.EventDate ,
        CH.Eventdesc ,
        CH.UserID ,
        CH.OtherInfo ,
        CH.FollowUpDate ,
		CH.ID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
        INNER JOIN tblCaseHistory AS CH ON CH.CaseNbr = C.CaseNbr
WHERE   CH.FollowUpDate IS NOT NULL
GO
PRINT N'Altering [dbo].[vwCaseOpenServices]...';


GO
ALTER VIEW vwCaseOpenServices
AS
    SELECT  tblCase.CaseNbr ,
            tblCaseOtherParty.DueDate ,
            tblCaseOtherParty.Status ,
            tblCase.OfficeCode ,
            tblCase.DoctorLocation ,
            tblCase.MarketerCode ,
            tblCase.DoctorCode ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblCaseOtherParty.UserIDResponsible ,
            tblCase.ApptDate ,
            tblServices.ShortDesc AS service ,
            tblServices.ServiceCode ,
            tblDoctor_1.CompanyName ,
            tblDoctor_1.OPSubType ,
            tblCase.SchedulerCode ,
            tblCompany.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor tblDoctor_1 ON tblCaseOtherParty.OPCode = tblDoctor_1.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
GO
PRINT N'Altering [dbo].[vwCaseSummary]...';


GO
ALTER VIEW vwCaseSummary
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
            tblCase.ForecastDate ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
			tblCase.ReExam ,
			tblCase.ReExamDate ,
			tblCase.ReExamProcessed,
			tblCase.ReExamNoticePrinted,
            tblCase.DateCompleted ,
            tblCase.DateCanceled ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.ClaimNbrExt ,
            tblLocation.Addr1 AS LocationAddr1 ,
            tblLocation.Addr2 AS LocationAddr2 ,
            tblLocation.City AS LocationCity ,
            tblLocation.State AS LocationState ,
            tblLocation.Zip AS LocationZip , 
			tblCase.ExtCaseNbr 
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.transCode = tblTranscription.transCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
GO
PRINT N'Altering [dbo].[vwDoctorSchedule]...';


GO
ALTER VIEW vwDoctorSchedule
AS
     select  tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
from tblDoctorSchedule 
	inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
	inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
	left outer join tblCase
		inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
		inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
		inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
		inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
		inner join tblCaseType on tblCase.CaseType = tblCaseType.Code
	on tblDoctorSchedule.SchedCode = tblCase.SchedCode	
    UNION
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
    FROM    tblDoctorSchedule 
				inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				inner join tblCasePanel on tblDoctorSchedule.SchedCode = tblCasePanel.SchedCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code					
				on tblCasePanel.PanelNbr = tblCase.PanelNbr
    WHERE   tblCase.PanelNbr IS NOT NULL
GO
PRINT N'Altering [dbo].[vwDoctorScheduleMEI]...';


GO
ALTER VIEW vwDoctorScheduleMEI
AS
    SELECT  tblDoctorSchedule.date ,
            tblDoctorSchedule.StartTime ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.SchedCode ,
            tblCase.CaseNbr ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS examineename ,
            tblLocation.Location ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS doctorname ,
            tblLocation.Phone AS doctorphone ,
            tblLocation.Fax AS doctorfax ,
            tblCase.PanelNbr ,
            tblDoctorOffice.OfficeCode ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblExaminee.Sex ,
            tblLocation.Addr1 ,
            tblLocation.Addr2 ,
            tblLocation.City ,
            tblLocation.State ,
            tblLocation.Zip ,
            tblEWFacility.LegalName AS CompanyName ,
            tblLocation.LocationCode ,
            tblServices.ShortDesc , 
			tblCase.ExtCaseNbr 
    FROM    tblLocation
            INNER JOIN tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON tblLocation.LocationCode = tblDoctorSchedule.LocationCode
            LEFT OUTER JOIN tblCaseType
            INNER JOIN tblClient
            INNER JOIN tblCase ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.CaseType
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON tblDoctorSchedule.SchedCode = tblCase.SchedCode
            LEFT OUTER JOIN tblEWFacility
            INNER JOIN tblOffice
            INNER JOIN tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblEWFacility.EWFacilityID = tblOffice.EWFacilityID ON tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
    WHERE   ( tblDoctorSchedule.Status = 'open' )
            OR ( tblDoctorSchedule.Status = 'Hold' )
            OR ( tblDoctorSchedule.Status = 'scheduled' )
            AND ( tblCase.SchedCode IS NOT NULL );
GO
PRINT N'Altering [dbo].[vwDocument]...';


GO
ALTER VIEW vwDocument
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,

            tblApptStatus.Name AS ApptStatus ,

            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,

            tblCase.DoctorCode ,
            tblCase.DoctorLocation ,


            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblExaminee.county AS Examineecounty ,
            tblExaminee.Prefix AS ExamineePrefix ,

            tblExaminee.USDvarchar1 AS ExamineeUSDvarchar1 ,
            tblExaminee.USDvarchar2 AS ExamineeUSDvarchar2 ,
            tblExaminee.USDDate1 AS ExamineeUSDDate1 ,
            tblExaminee.USDDate2 AS ExamineeUSDDate2 ,
            tblExaminee.USDtext1 AS ExamineeUSDtext1 ,
            tblExaminee.USDtext2 AS ExamineeUSDtext2 ,
            tblExaminee.USDint1 AS ExamineeUSDint1 ,
            tblExaminee.USDint2 AS ExamineeUSDint2 ,
            tblExaminee.USDmoney1 AS ExamineeUSDmoney1 ,
            tblExaminee.USDmoney2 AS ExamineeUSDmoney2 ,

            tblExaminee.note AS ChartNotes ,
            tblExaminee.Fax AS ExamineeFax ,
            tblExaminee.Email AS ExamineeEmail ,
            tblExaminee.insured AS Examineeinsured ,
            tblExaminee.middleinitial AS Examineemiddleinitial ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            tblExaminee.InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,

            tblExaminee.TreatingPhysician ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
            tblClient.Fax AS ClientFax ,
            tblClient.Email AS ClientEmail ,
            'Dear ' + tblClient.firstName + ' ' + tblClient.lastName AS ClientSalutation ,
            tblClient.title AS Clienttitle ,
            tblClient.Prefix AS ClientPrefix ,
            tblClient.suffix AS Clientsuffix ,
            tblClient.USDvarchar1 AS ClientUSDvarchar1 ,
            tblClient.USDvarchar2 AS ClientUSDvarchar2 ,
            tblClient.USDDate1 AS ClientUSDDate1 ,
            tblClient.USDDate2 AS ClientUSDDate2 ,
            tblClient.USDtext1 AS ClientUSDtext1 ,
            tblClient.USDtext2 AS ClientUSDtext2 ,
            tblClient.USDint1 AS ClientUSDint1 ,
            tblClient.USDint2 AS ClientUSDint2 ,
            tblClient.USDmoney1 AS ClientUSDmoney1 ,
            tblClient.USDmoney2 AS ClientUSDmoney2 ,
            tblClient.CompanyCode ,
            tblClient.Notes AS ClientNotes ,
            tblClient.BillAddr1 ,
            tblClient.BillAddr2 ,
            tblClient.BillCity ,
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
            tblClient.City AS ClientCity ,
            tblClient.Zip AS ClientZip ,

            tblCompany.extName AS Company ,
            tblCompany.USDvarchar1 AS CompanyUSDvarchar1 ,
            tblCompany.USDvarchar2 AS CompanyUSDvarchar2 ,
            tblCompany.USDDate1 AS CompanyUSDDate1 ,
            tblCompany.USDDate2 AS CompanyUSDDate2 ,
            tblCompany.USDtext1 AS CompanyUSDtext1 ,
            tblCompany.USDtext2 AS CompanyUSDtext2 ,
            tblCompany.USDint1 AS CompanyUSDint1 ,
            tblCompany.USDint2 AS CompanyUSDint2 ,
            tblCompany.USDmoney1 AS CompanyUSDmoney1 ,
            tblCompany.USDmoney2 AS CompanyUSDmoney2 ,
            tblCompany.Notes AS CompanyNotes ,

            tblCase.QARep ,
            tblCase.Doctorspecialty ,
            tblCase.BillClientCode AS CaseBillClientCode ,
            tblCase.officeCode ,
            tblCase.PanelNbr ,

            ISNULL(tblUser.lastName, '')
            + Case WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstName, '') AS scheduler ,

            tblCase.marketerCode AS Marketer ,
            tblCase.Dateadded AS DateCalledIn ,
            tblCase.Dateofinjury AS DOI ,
            tblCase.Allegation ,
            tblCase.Notes ,
            tblCase.CaseType ,
            'Dear ' + tblExaminee.firstName + ' ' + tblExaminee.lastName AS Examineesalutation ,
            tblCase.status ,
            tblCase.calledInBy ,
            tblCase.chartnbr ,
            tblCase.reportverbal ,
            tblCase.Datemedsrecd AS medsrecd ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffAttorneyCode ,
            tblCase.defenseAttorneyCode ,
            tblCase.serviceCode ,
            tblCase.FaxPattny ,
            tblCase.FaxDoctor ,
            tblCase.FaxClient ,
            tblCase.EmailClient ,
            tblCase.EmailDoctor ,
            tblCase.EmailPattny ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.commitDate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblCase.scheduleNotes ,
            tblCase.requesteddoc ,

            tblCase.USDvarchar1 AS CaseUSDvarchar1 ,
            tblCase.USDvarchar2 AS CaseUSDvarchar2 ,
            tblCase.USDDate1 AS CaseUSDDate1 ,
            tblCase.USDDate2 AS CaseUSDDate2 ,
            tblCase.USDtext1 AS CaseUSDtext1 ,
            tblCase.USDtext2 AS CaseUSDtext2 ,
            tblCase.USDint1 AS CaseUSDint1 ,
            tblCase.USDint2 AS CaseUSDint2 ,
            tblCase.USDmoney1 AS CaseUSDmoney1 ,
            tblCase.USDmoney2 AS CaseUSDmoney2 ,
            tblCase.USDDate3 AS CaseUSDDate3 ,
            tblCase.USDDate4 AS CaseUSDDate4 ,
            tblCase.USDDate5 AS CaseUSDDate5 ,
            tblCase.USDBit1 AS CaseUSDboolean1 ,
            tblCase.USDBit2 AS CaseUSDboolean2 ,

            tblCase.sinternalCasenbr AS internalCasenbr ,
            tblDoctor.credentials AS Doctordegree ,
            tblCase.ClientCode ,
            tblCase.feeCode ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
            tblCase.CertMailNbr2 ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.masterCasenbr ,
            tblCase.prevappt ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblCase.DateReceived ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCase.AttorneyNote ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblCase.ForecastDate ,
            tblCase.DefParaLegal ,

            tblCase.MasterSubCase ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.PublishOnWeb ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.TransCode ,
            tblCase.RptFinalizedDate ,

			tblCase.ICDCodeA ,
			tblCase.ICDCodeB ,
			tblCase.ICDCodeC ,
			tblCase.ICDCodeD ,
			tblCase.ICDCodeE ,
			tblCase.ICDCodeF ,
			tblCase.ICDCodeG ,
			tblCase.ICDCodeH ,
			tblCase.ICDCodeI ,
			tblCase.ICDCodeJ ,
			tblCase.ICDCodeK ,
			tblCase.ICDCodeL ,

            'Dear ' + tblDoctor.firstName + ' ' + tblDoctor.lastName + ', ' + ISNULL(tblDoctor.credentials, '') AS DoctorSalutation ,
            tblDoctor.Notes AS DoctorNotes ,
            tblDoctor.Prefix AS DoctorPrefix ,
            tblDoctor.Addr1 AS DoctorcorrespAddr1 ,
            tblDoctor.Addr2 AS DoctorcorrespAddr2 ,
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
            tblDoctor.Phone + ' ' + ISNULL(tblDoctor.PhoneExt, ' ') AS DoctorcorrespPhone ,
            tblDoctor.FaxNbr AS DoctorcorrespFax ,
            tblDoctor.EmailAddr AS DoctorcorrespEmail ,
            tblDoctor.Qualifications ,
            tblDoctor.Prepaid ,
            tblDoctor.county AS DoctorCorrespCounty ,

            tblDoctor.USDvarchar1 AS DoctorUSDvarchar1 ,
            tblDoctor.USDvarchar2 AS DoctorUSDvarchar2 ,
            tblDoctor.USDvarchar3 AS DoctorUSDvarchar3 ,
            tblDoctor.USDDate1 AS DoctorUSDDate1 ,
            tblDoctor.USDDate2 AS DoctorUSDDate2 ,
            tblDoctor.USDDate3 AS DoctorUSDDate3 ,
            tblDoctor.USDDate4 AS DoctorUSDDate4 ,
            tblDoctor.USDDate5 AS DoctorUSDDate5 ,
            tblDoctor.USDDate6 AS DoctorUSDDate6 ,
            tblDoctor.USDDate7 AS DoctorUSDDate7 ,
            tblDoctor.USDtext1 AS DoctorUSDtext1 ,
            tblDoctor.USDtext2 AS DoctorUSDtext2 ,
            tblDoctor.USDint1 AS DoctorUSDint1 ,
            tblDoctor.USDint2 AS DoctorUSDint2 ,
            tblDoctor.USDmoney1 AS DoctorUSDmoney1 ,
            tblDoctor.USDmoney2 AS DoctorUSDmoney2 ,
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,
			tblDoctor.ExpectedVisitDuration As ExpectedVisitDuration,

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
            tblDoctor.remitZip ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feeCode AS drfeeCode ,
            tblDoctor.licensenbr AS Doctorlicense ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblDoctor.lastName AS DoctorlastName ,
            tblDoctor.firstName AS DoctorfirstName ,
            tblDoctor.middleinitial AS Doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstName, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastName, 1), '') AS Doctorinitials ,
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.insidedr ,
            tblLocation.Email AS DoctorEmail ,
            tblLocation.Fax AS DoctorFax ,
            tblLocation.Faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblLocation.county AS Doctorcounty ,
            tblLocation.vicinity AS Doctorvicinity ,
            tblLocation.contactPrefix AS DoctorLocationcontactPrefix ,
            tblLocation.contactfirst AS DoctorLocationcontactfirstName ,
            tblLocation.contactlast AS DoctorLocationcontactlastName ,
            tblLocation.Notes AS DoctorLocationNotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontactsalutation ,
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,


            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCaseType.description AS CaseTypeDesc ,

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany,                          
			
			dbo.tblCase.DateOfInjury2 AS DOI2, 
			dbo.tblCase.DateOfInjury3 AS DOI3, 
			dbo.tblCase.DateOfInjury4 AS DOI4 
    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode

            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode

            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblApptStatus ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID
GO
PRINT N'Altering [dbo].[vwDocumentAccting]...';


GO
ALTER VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,

            tblAcctingTrans.SeqNO ,
            AH.DocumentNbr ,
            tblAcctingTrans.type AS DocumentType ,

            tblAcctingTrans.ApptDate ,
            tblAcctingTrans.ApptTime ,
            tblAcctingTrans.CaseApptID ,
			tblAcctingTrans.ApptStatusID ,

            CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END AS DoctorCode ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END AS DoctorLocation ,

            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblExaminee.county AS Examineecounty ,
            tblExaminee.Prefix AS ExamineePrefix ,

            tblExaminee.USDvarchar1 AS ExamineeUSDvarchar1 ,
            tblExaminee.USDvarchar2 AS ExamineeUSDvarchar2 ,
            tblExaminee.USDDate1 AS ExamineeUSDDate1 ,
            tblExaminee.USDDate2 AS ExamineeUSDDate2 ,
            tblExaminee.USDtext1 AS ExamineeUSDtext1 ,
            tblExaminee.USDtext2 AS ExamineeUSDtext2 ,
            tblExaminee.USDint1 AS ExamineeUSDint1 ,
            tblExaminee.USDint2 AS ExamineeUSDint2 ,
            tblExaminee.USDmoney1 AS ExamineeUSDmoney1 ,
            tblExaminee.USDmoney2 AS ExamineeUSDmoney2 ,

            tblExaminee.note AS ChartNotes ,
            tblExaminee.Fax AS ExamineeFax ,
            tblExaminee.Email AS ExamineeEmail ,
            tblExaminee.insured AS Examineeinsured ,
            tblExaminee.middleinitial AS Examineemiddleinitial ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            tblExaminee.InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,

            tblExaminee.TreatingPhysician ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
            tblClient.Fax AS ClientFax ,
            tblClient.Email AS ClientEmail ,
            'Dear ' + tblClient.firstName + ' ' + tblClient.lastName AS ClientSalutation ,
            tblClient.title AS Clienttitle ,
            tblClient.Prefix AS ClientPrefix ,
            tblClient.suffix AS Clientsuffix ,
            tblClient.USDvarchar1 AS ClientUSDvarchar1 ,
            tblClient.USDvarchar2 AS ClientUSDvarchar2 ,
            tblClient.USDDate1 AS ClientUSDDate1 ,
            tblClient.USDDate2 AS ClientUSDDate2 ,
            tblClient.USDtext1 AS ClientUSDtext1 ,
            tblClient.USDtext2 AS ClientUSDtext2 ,
            tblClient.USDint1 AS ClientUSDint1 ,
            tblClient.USDint2 AS ClientUSDint2 ,
            tblClient.USDmoney1 AS ClientUSDmoney1 ,
            tblClient.USDmoney2 AS ClientUSDmoney2 ,
            tblClient.CompanyCode ,
            tblClient.Notes AS ClientNotes ,
            tblClient.BillAddr1 ,
            tblClient.BillAddr2 ,
            tblClient.BillCity ,
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
            tblClient.City AS ClientCity ,
            tblClient.Zip AS ClientZip ,

            tblCompany.extName AS Company ,
            tblCompany.USDvarchar1 AS CompanyUSDvarchar1 ,
            tblCompany.USDvarchar2 AS CompanyUSDvarchar2 ,
            tblCompany.USDDate1 AS CompanyUSDDate1 ,
            tblCompany.USDDate2 AS CompanyUSDDate2 ,
            tblCompany.USDtext1 AS CompanyUSDtext1 ,
            tblCompany.USDtext2 AS CompanyUSDtext2 ,
            tblCompany.USDint1 AS CompanyUSDint1 ,
            tblCompany.USDint2 AS CompanyUSDint2 ,
            tblCompany.USDmoney1 AS CompanyUSDmoney1 ,
            tblCompany.USDmoney2 AS CompanyUSDmoney2 ,
            tblCompany.Notes AS CompanyNotes ,

            tblCase.QARep ,
            tblCase.Doctorspecialty ,
            tblCase.BillClientCode AS CaseBillClientCode ,
            tblCase.officeCode ,
            tblCase.PanelNbr ,

            ISNULL(tblUser.lastName, '')
            + Case WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstName, '') AS scheduler ,

            tblCase.marketerCode AS Marketer ,
            tblCase.Dateadded AS DateCalledIn ,
            tblCase.Dateofinjury AS DOI ,
            tblCase.Allegation ,
            tblCase.Notes ,
            tblCase.CaseType ,
            'Dear ' + tblExaminee.firstName + ' ' + tblExaminee.lastName AS Examineesalutation ,
            tblCase.status ,
            tblCase.calledInBy ,
            tblCase.chartnbr ,
            tblCase.reportverbal ,
            tblCase.Datemedsrecd AS medsrecd ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffAttorneyCode ,
            tblCase.defenseAttorneyCode ,
            tblCase.serviceCode ,
            tblCase.FaxPattny ,
            tblCase.FaxDoctor ,
            tblCase.FaxClient ,
            tblCase.EmailClient ,
            tblCase.EmailDoctor ,
            tblCase.EmailPattny ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.commitDate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblCase.scheduleNotes ,
            tblCase.requesteddoc ,

            tblCase.USDvarchar1 AS CaseUSDvarchar1 ,
            tblCase.USDvarchar2 AS CaseUSDvarchar2 ,
            tblCase.USDDate1 AS CaseUSDDate1 ,
            tblCase.USDDate2 AS CaseUSDDate2 ,
            tblCase.USDtext1 AS CaseUSDtext1 ,
            tblCase.USDtext2 AS CaseUSDtext2 ,
            tblCase.USDint1 AS CaseUSDint1 ,
            tblCase.USDint2 AS CaseUSDint2 ,
            tblCase.USDmoney1 AS CaseUSDmoney1 ,
            tblCase.USDmoney2 AS CaseUSDmoney2 ,
            tblCase.USDDate3 AS CaseUSDDate3 ,
            tblCase.USDDate4 AS CaseUSDDate4 ,
            tblCase.USDDate5 AS CaseUSDDate5 ,
            tblCase.USDBit1 AS CaseUSDboolean1 ,
            tblCase.USDBit2 AS CaseUSDboolean2 ,

            tblCase.sinternalCasenbr AS internalCasenbr ,
            tblDoctor.credentials AS Doctordegree ,
            tblCase.ClientCode ,
            tblCase.feeCode ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
			tblCase.CertMailNbr2 ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.masterCasenbr ,
            tblCase.prevappt ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblCase.DateReceived ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCase.AttorneyNote ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblCase.ForecastDate ,
            tblCase.DefParaLegal ,

            tblCase.MasterSubCase ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.PublishOnWeb ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.TransCode ,
            tblCase.RptFinalizedDate ,

			tblCase.ICDCodeA ,
			tblCase.ICDCodeB ,
			tblCase.ICDCodeC ,
			tblCase.ICDCodeD ,
			tblCase.ICDCodeE ,
			tblCase.ICDCodeF ,
			tblCase.ICDCodeG ,
			tblCase.ICDCodeH ,
			tblCase.ICDCodeI ,
			tblCase.ICDCodeJ ,
			tblCase.ICDCodeK ,
			tblCase.ICDCodeL ,

            'Dear ' + tblDoctor.firstName + ' ' + tblDoctor.lastName + ', ' + ISNULL(tblDoctor.credentials, '') AS DoctorSalutation ,
            tblDoctor.Notes AS DoctorNotes ,
            tblDoctor.Prefix AS DoctorPrefix ,
            tblDoctor.Addr1 AS DoctorcorrespAddr1 ,
            tblDoctor.Addr2 AS DoctorcorrespAddr2 ,
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
            tblDoctor.Phone + ' ' + ISNULL(tblDoctor.PhoneExt, ' ') AS DoctorcorrespPhone ,
            tblDoctor.FaxNbr AS DoctorcorrespFax ,
            tblDoctor.EmailAddr AS DoctorcorrespEmail ,
            tblDoctor.Qualifications ,
            tblDoctor.Prepaid ,
            tblDoctor.county AS DoctorCorrespCounty ,

            tblDoctor.USDvarchar1 AS DoctorUSDvarchar1 ,
            tblDoctor.USDvarchar2 AS DoctorUSDvarchar2 ,
            tblDoctor.USDvarchar3 AS DoctorUSDvarchar3 ,
            tblDoctor.USDDate1 AS DoctorUSDDate1 ,
            tblDoctor.USDDate2 AS DoctorUSDDate2 ,
            tblDoctor.USDDate3 AS DoctorUSDDate3 ,
            tblDoctor.USDDate4 AS DoctorUSDDate4 ,
            tblDoctor.USDDate5 AS DoctorUSDDate5 ,
            tblDoctor.USDDate6 AS DoctorUSDDate6 ,
            tblDoctor.USDDate7 AS DoctorUSDDate7 ,
            tblDoctor.USDtext1 AS DoctorUSDtext1 ,
            tblDoctor.USDtext2 AS DoctorUSDtext2 ,
            tblDoctor.USDint1 AS DoctorUSDint1 ,
            tblDoctor.USDint2 AS DoctorUSDint2 ,
            tblDoctor.USDmoney1 AS DoctorUSDmoney1 ,
            tblDoctor.USDmoney2 AS DoctorUSDmoney2 ,
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,
			tblDoctor.ExpectedVisitDuration As ExpectedVisitDuration,

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
            tblDoctor.remitZip ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feeCode AS drfeeCode ,
            tblDoctor.licensenbr AS Doctorlicense ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblDoctor.lastName AS DoctorlastName ,
            tblDoctor.firstName AS DoctorfirstName ,
            tblDoctor.middleinitial AS Doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstName, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastName, 1), '') AS Doctorinitials ,
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.insidedr ,
            tblLocation.Email AS DoctorEmail ,
            tblLocation.Fax AS DoctorFax ,
            tblLocation.Faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblLocation.county AS Doctorcounty ,
            tblLocation.vicinity AS Doctorvicinity ,
            tblLocation.contactPrefix AS DoctorLocationcontactPrefix ,
            tblLocation.contactfirst AS DoctorLocationcontactfirstName ,
            tblLocation.contactlast AS DoctorLocationcontactlastName ,
            tblLocation.Notes AS DoctorLocationNotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontactsalutation ,
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,

			
            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCaseType.description AS CaseTypeDesc ,

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,
			tblCase.DateOfInjury2 AS DOI2, 
			tblCase.DateOfInjury3 AS DOI3, 
			tblCase.DateOfInjury4 AS DOI4,

            tblTranscription.TransCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode

            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = tblAcctingTrans.SeqNO

            LEFT OUTER JOIN tblDoctor ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode
			
            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
GO
PRINT N'Altering [dbo].[vwEDIExportSummary]...';


GO
ALTER VIEW vwEDIExportSummary
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctingTrans.SeqNO ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime , 
			tblCase.ExtCaseNbr 
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO
PRINT N'Altering [dbo].[vwExportSummary]...';


GO
ALTER VIEW vwExportSummary
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime , 
			tblCase.ExtCaseNbr 
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO
PRINT N'Altering [dbo].[vwReportTATRpt]...';


GO
 
ALTER VIEW vwReportTATRpt
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
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode, tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vwReportTATRptDocs]...';


GO
 
ALTER VIEW vwReportTATRptDocs
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
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode, tblCase.ExtCaseNbr 
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
                      tblCase.OfficeCode, tblCase.QARep AS qarepCode, tblCaseType.Description AS Casetypedesc, tblDoctor.DoctorCode, tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vwspecialservices]...';


GO

ALTER VIEW [dbo].[vwspecialservices]
AS
SELECT     dbo.TblCaseOtherParty.casenbr, dbo.TblCaseOtherParty.Type, dbo.TblCaseOtherParty.duedate, dbo.TblCaseOtherParty.useridresponsible, 
                      dbo.TblCaseOtherParty.status, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') AS contactname, dbo.tblDoctor.addr1, dbo.tblDoctor.addr2, 
                      dbo.tblDoctor.city, dbo.tblDoctor.state, dbo.tblDoctor.zip, dbo.tblDoctor.phone, dbo.tblDoctor.phoneExt, dbo.tblDoctor.faxNbr, dbo.tblDoctor.emailAddr, 
                      dbo.tblDoctor.companyname, dbo.vwdocument.examineename, dbo.vwdocument.examineeaddr1, dbo.vwdocument.examineeaddr2, 
                      dbo.vwdocument.examineecitystatezip, dbo.vwdocument.clientname, dbo.vwdocument.company, dbo.vwdocument.DoctorName, dbo.vwdocument.doctoraddr1, 
                      dbo.vwdocument.doctoraddr2, dbo.vwdocument.doctorcitystatezip, dbo.vwdocument.ApptDate, dbo.vwdocument.Appttime, dbo.vwdocument.doctorphone, 
                      dbo.vwdocument.location, dbo.vwdocument.examineephone, dbo.vwdocument.officecode, dbo.TblCaseOtherParty.description, dbo.vwdocument.statusdesc, 
					  dbo.vwDocument.ExtCaseNbr 
FROM         dbo.TblCaseOtherParty INNER JOIN
                      dbo.tblDoctor ON dbo.TblCaseOtherParty.OPCode = dbo.tblDoctor.doctorcode INNER JOIN
                      dbo.vwdocument ON dbo.TblCaseOtherParty.casenbr = dbo.vwdocument.casenbr
GO
PRINT N'Altering [dbo].[vwStatusAppt]...';


GO
ALTER VIEW vwStatusAppt
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblClient.LastName + ', ' + tblClient.FirstName AS clientname ,
            tblUser.LastName + ', ' + tblUser.FirstName AS schedulername ,
            tblCompany.IntName AS companyname ,
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
            tblClient.Email AS clientemail ,
            tblClient.Fax AS clientfax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblServices.ShortDesc AS service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblCase.QARep ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            tblCase.ServiceCode ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
GO
PRINT N'Altering [dbo].[vwStatusNew]...';


GO
ALTER VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,CASE WHEN tblcase.panelnbr IS NULL
                 THEN tbldoctor.lastname + ', '
                      + ISNULL(tbldoctor.firstname, ' ')
                 ELSE tblcase.doctorname
            END AS doctorname
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,ISNULL(Scheduler.LastName,'') + CASE WHEN ISNULL(Scheduler.LastName,'')='' OR ISNULL(Scheduler.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Scheduler.FirstName, '') AS schedulername
           ,ISNULL(Marketer.LastName,'') + CASE WHEN ISNULL(Marketer.LastName,'')='' OR ISNULL(Marketer.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Marketer.FirstName, '') AS marketername
           ,tblCompany.intname AS companyname
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.status
           ,tblCase.dateadded
           ,tblCase.requesteddoc
           ,tblCase.doctorcode
           ,tblCase.marketercode
           ,tblQueues.statusdesc
           ,tblServices.shortdesc AS service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,'ViewCase' AS FunctionCode
           ,tblCase.casetype
		   ,tblCase.ExtCaseNbr 
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblUser AS Scheduler ON tblCase.schedulercode = Scheduler.UserID
            LEFT OUTER JOIN tblUser AS Marketer ON Marketer.UserID = tblCase.marketercode
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
GO
PRINT N'Altering [dbo].[vwTranscriptionTracker]...';


GO
 ALTER VIEW vwTranscriptionTracker
 AS
    SELECT  CT.TranscriptionJobID ,
			CT.TranscriptionStatusCode ,
            CT.CaseNbr ,
            CASE WHEN C.CaseNbr IS NULL THEN 0
                 ELSE 1
            END AS CaseSelected ,
            DATEDIFF(DAY, C.LastStatusChg, GETDATE()) AS IQ ,
            C.ApptDate ,
            C.ApptTime ,
            C.Priority ,
			IsNull(P.Rank, 100) AS PriorityRank ,
            EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
            CASE WHEN C.PanelNbr IS NULL
                 THEN D.LastName + ', ' + ISNULL(D.FirstName, ' ')
                 ELSE C.DoctorName
            END AS DoctorName ,
            L.Location ,
            COM.IntName AS CompanyName ,
            S.ShortDesc AS Service ,
            CASE WHEN CT.TransCode = -1 THEN '<Job Request>'
                 ELSE T.TransCompany
            END AS TransGroup ,
            Q.ShortDesc AS CaseStatus ,
            TS.Descrip AS TransStatus ,
            C.OfficeCode ,
            T.TransCode ,
			T.Workflow ,
            CT.DateAdded ,
            CT.DateCompleted ,
			CT.LastStatusChg ,
            TD.Name AS TransDept ,
			CT.EWTransDeptID , 
			C.ExtCaseNbr  
    FROM    tblTranscriptionJob CT
            INNER JOIN tblTranscriptionStatus TS ON CT.TranscriptionStatusCode = TS.TranscriptionStatusCode
            LEFT OUTER JOIN tblTranscription T ON T.TransCode = CT.TransCode
            LEFT OUTER JOIN tblCase C ON CT.CaseNbr = C.CaseNbr
            LEFT OUTER JOIN tblExaminee EE ON C.ChartNbr = EE.ChartNbr
            LEFT OUTER JOIN tblQueues Q ON C.Status = Q.StatusCode
            LEFT OUTER JOIN tblServices S ON C.ServiceCode = S.ServiceCode
            LEFT OUTER JOIN tblClient CL ON C.ClientCode = CL.ClientCode
            LEFT OUTER JOIN tblCompany COM ON COM.CompanyCode = CL.CompanyCode
            LEFT OUTER JOIN tblDoctor D ON C.DoctorCode = D.DoctorCode
            LEFT OUTER JOIN tblLocation L ON C.DoctorLocation = L.LocationCode
            LEFT OUTER JOIN tblPriority P ON C.Priority = P.PriorityCode
            LEFT OUTER JOIN tblEWTransDept TD ON CT.EWTransDeptID = TD.EWTransDeptID
GO
PRINT N'Altering [dbo].[vwRegisterTotal]...';


GO
ALTER VIEW vwRegisterTotal
AS
    SELECT  Casenbr ,
            HeaderID ,
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
            Casetype , 
			ExtCaseNbr 
    FROM    vwAcctDocuments
GO
PRINT N'Altering [dbo].[vwApptLog]...';


GO

ALTER VIEW vwApptLog
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
            '' AS ProvTypeCode , 
			tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vwCancelAppt]...';


GO
ALTER VIEW vwCancelAppt
AS
    SELECT DISTINCT 
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.DoctorNames ,
            tblLocation.Location ,
            vwCaseAppt.CanceledByExtName ,
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
            tblServices.ServiceCode , 
			tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vwRptCancelDetail]...';


GO
 
ALTER VIEW vwRptCancelDetail
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
            vwCaseAppt.CanceledByExtName ,
            tblCase.Casetype ,
            tblCase.MastersubCase , 
			tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vwRptNoShowDetail]...';


GO
 
ALTER VIEW vwRptNoShowDetail
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
            tblCase.Casetype , 
			tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[vw_WebCaseSummary]...';


GO
ALTER VIEW vw_WebCaseSummary

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes, 
	tblCase.ExtCaseNbr, 
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
GO
PRINT N'Altering [dbo].[vwPDFCaseData]...';


GO
ALTER VIEW vwPDFCaseData
AS
    SELECT  C.CaseNbr ,
			C.ExtCaseNbr,
			C.PanelNbr ,
			C.OfficeCode ,
            C.ClaimNbr ,
            C.Jurisdiction ,
            C.WCBNbr ,
            
			C.DoctorCode AS CaseDoctorCode ,
            C.DoctorLocation AS CaseLocationCode ,
			C.DoctorSpecialty AS CaseDoctorSpecialty ,
            C.DoctorName ,
            C.ApptDate ,
            C.ApptTime ,

			C.MasterCaseNbr ,
			C.MasterSubCase ,
			B.BlankValue AS MasterCaseDoctorName ,
			B.BlankValue AS MasterCaseDoctorNPINbr ,
			B.BlankValue AS MasterCaseDoctorLicense ,
			B.BlankValue AS MasterCaseDoctorLicQualID ,
            
			C.DateOfInjury AS DOIValue ,
			B.BlankValue AS DOI ,
			B.BlankValue AS InjuryCurrentDateMM ,
			B.BlankValue AS InjuryCurrentDateDD ,
			B.BlankValue AS InjuryCurrentDateYYYY ,
			CASE WHEN C.DateOfInjury IS NULL THEN '' ELSE '431' END AS InjuryCurrentDateQual ,

			B.BlankValue AS ICD9Code1a ,
			B.BlankValue AS ICD9Code1b ,
			B.BlankValue AS ICD9Code1c ,
			B.BlankValue AS ICD9Code2a ,
			B.BlankValue AS ICD9Code2b ,
			B.BlankValue AS ICD9Code2c ,
			B.BlankValue AS ICD9Code3a ,
			B.BlankValue AS ICD9Code3b ,
			B.BlankValue AS ICD9Code3c ,
			B.BlankValue AS ICD9Code4a ,
			B.BlankValue AS ICD9Code4b ,
			B.BlankValue AS ICD9Code4c ,

            C.ICDCodeA AS ICD9Code1 ,
            C.ICDCodeB AS ICD9Code2 ,
            C.ICDCodeC AS ICD9Code3 ,
            C.ICDCodeD AS ICD9Code4 ,
			C.ICDCodeA ,
			C.ICDCodeB ,
			C.ICDCodeC ,
			C.ICDCodeD ,
			C.ICDCodeE ,
			C.ICDCodeF ,
			C.ICDCodeG ,
			C.ICDCodeH ,
			C.ICDCodeI ,
			C.ICDCodeJ ,
			C.ICDCodeK ,
			C.ICDCodeL ,

			C.ICDFormat ,
			B.BlankValue AS ICDIndicator ,


			B.BlankValueLong AS ProblemList ,
            
			CO.ExtName AS Company ,
            
			CL.FirstName + ' ' + CL.LastName AS ClientName ,
			B.BlankValue AS ReferringProvider,	--Fill by system option

            CL.Addr1 AS ClientAddr1 ,
            CL.Addr2 AS ClientAddr2 ,
            CL.City + ', ' + CL.State + '  ' + CL.Zip AS ClientCityStateZip ,
            B.BlankValue AS ClientFullAddress ,
            CL.Phone1 + ' ' + ISNULL(CL.Phone1ext, ' ') AS ClientPhone , --Need Extension?
            CL.Fax AS ClientFax ,
            CL.Email AS ClientEmail ,
			CL.Phone1 AS ClientPhoneAreaCode ,
			CL.Phone1 AS ClientPhoneNumber ,
			CL.Fax AS ClientFaxAreaCode ,
			CL.Fax AS ClientFaxNumber ,

            EE.LastName AS ExamineeLastName ,
            EE.FirstName AS ExamineeFirstName ,
            EE.MiddleInitial AS ExamineeMiddleInitial ,
			B.BlankValue AS ExamineeNameLFMI ,
			B.BlankValue AS ExamineeNameFMIL ,

            EE.SSN AS ExamineeSSN ,
            EE.SSN AS ExamineeSSNLast4Digits ,

            EE.Addr1 AS ExamineeAddr1 ,
            EE.Addr2 AS ExamineeAddr2 ,
            EE.City + ', ' + EE.State + '  ' + EE.Zip AS ExamineeCityStateZip ,
            EE.City AS ExamineeCity ,
            EE.State AS ExamineeState ,
            EE.Zip AS ExamineeZip ,
			B.BlankValue AS ExamineeAddress ,
			B.BlankValue AS ExamineeFullAddress ,
            EE.County AS ExamineeCounty ,

            EE.Phone1 AS ExamineePhone ,
            EE.Phone1 AS ExamineePhoneAreaCode ,
            EE.Phone1 AS ExamineePhoneNumber ,

            EE.DOB AS ExamineeDOBValue ,
			B.BlankValue AS ExamineeDOB ,
			B.BlankValue AS ExamineeDOBMM ,
			B.BlankValue AS ExamineeDOBDD ,
			B.BlankValue AS ExamineeDOBYYYY ,

            EE.Sex AS ExamineeSex ,
			EE.Sex AS ExamineeSexM ,
			EE.Sex AS ExamineeSexF ,
            EE.Employer ,
            EE.EmployerAddr1 ,
            EE.EmployerCity ,
            EE.EmployerState ,
            EE.EmployerZip ,
			B.BlankValue AS EmployerFullAddress ,

            EE.EmployerPhone ,
            EE.EmployerPhone AS EmployerPhoneAreaCode ,
            EE.EmployerPhone AS EmployerPhoneNumber ,

            EE.EmployerFax ,
            EE.EmployerEmail ,

            EE.TreatingPhysicianAddr1 ,
            EE.TreatingPhysicianCity ,
            EE.TreatingPhysicianState ,
            EE.TreatingPhysicianZip ,
			B.BlankValue AS TreatingPhysicianFullAddress ,

            EE.TreatingPhysicianPhone ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneAreaCode ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneNumber ,
            EE.TreatingPhysicianFax ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxAreaCode ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxNumber ,

            EE.TreatingPhysicianLicenseNbr ,
            EE.TreatingPhysician ,
            EE.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            PA.FirstName + ' ' + PA.LastName AS PAttorneyName ,
            PA.Address1 AS PAttorneyAddr1 ,
            PA.Address2 AS PAttorneyAddr2 ,
            PA.City + ', ' + PA.State + '  ' + PA.Zip AS PAttorneyCityStateZip ,
			B.BlankValue AS PAttorneyFullAddress ,

            PA.Phone + ' ' + ISNULL(PA.Phoneextension, '') AS PAttorneyPhone , --Need Extension?
			PA.Phone AS PAttorneyPhoneAreaCode ,
			PA.Phone AS PAttorneyPhoneNumber ,
            PA.Fax AS PAttorneyFax ,
			PA.Fax AS PAttorneyFaxAreaCode ,
			PA.Fax AS PAttorneyFaxNumber ,
            PA.Email AS PAttorneyEmail ,

			CT.EWBusLineID ,
			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr

    FROM    tblCase AS C
            INNER JOIN tblExaminee AS EE ON EE.chartNbr = C.chartNbr
            INNER JOIN tblClient AS CL ON C.clientCode = CL.clientCode
            INNER JOIN tblCompany AS CO ON CL.companyCode = CO.companyCode
			INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
            LEFT OUTER JOIN tblCCAddress AS PA ON C.plaintiffAttorneyCode = PA.ccCode
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO
PRINT N'Altering [dbo].[vwprofit]...';


GO
ALTER VIEW [dbo].[vwprofit]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblQueues.statusdesc, dbo.tblCase.status, dbo.tblCase.ApptDate, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.intname AS company, 
                      dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblCase.voucheramt, dbo.tblCase.voucherdate, 
                      dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.doctorlocation, dbo.tblCase.marketercode, dbo.tblCase.clientcode, 
                      dbo.tblClient.companycode, dbo.tblServices.servicecode, dbo.tblServices.description, dbo.tblCase.officecode, dbo.tblCase.casetype, 
                      dbo.tblCaseType.description AS casetypedesc, dbo.tblCase.doctorcode, dbo.tblCase.DoctorName, dbo.tblCase.ExtCaseNbr 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
GO
PRINT N'Altering [dbo].[vwRptOutstandingAuthorizations]...';


GO
ALTER VIEW [dbo].[vwRptOutstandingAuthorizations]
AS
SELECT     TOP 100 PERCENT dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS Examinee, dbo.tblCase.claimnbr, dbo.tblCase.casenbr, 
                      dbo.tblRecordsObtainment.DateRequested, dbo.tblRecordsObtainment.DateReceived, 
                      dbo.tblCCAddress.lastname + ', ' + dbo.tblCCAddress.firstname AS AttorneyName, dbo.tblCCAddress.company AS FirmName, dbo.tblCCAddress.phone, 
                      dbo.tblCCAddress.fax, DATEDIFF(dd, dbo.tblRecordsObtainment.DateRequested, GETDATE()) AS DOS, dbo.tblCase.officecode, dbo.tblCase.ExtCaseNbr 
FROM         dbo.tblRecordsObtainment INNER JOIN
                      dbo.tblCase ON dbo.tblRecordsObtainment.CaseNbr = dbo.tblCase.casenbr INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr LEFT OUTER JOIN
                      dbo.tblCCAddress ON dbo.tblCase.plaintiffattorneycode = dbo.tblCCAddress.cccode
WHERE     (dbo.tblRecordsObtainment.ObtainmentTypeID = 1) AND (dbo.tblRecordsObtainment.DateReceived IS NULL)
GO
PRINT N'Altering [dbo].[vwRptOutstandingRecords]...';


GO
 
ALTER VIEW vwRptOutstandingRecords
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
            tblRecordsObtainmentDetail.NotAvailable , 
			dbo.tblCase.ExtCaseNbr 
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
PRINT N'Altering [dbo].[spAttorneyCases]...';


GO

-- 01/08/2015 - JAP - Issue 2176. Create new SP to source the AttorneyCases form.
ALTER PROCEDURE [dbo].[spAttorneyCases]
     @AttorneyCode AS INTEGER
AS
     SELECT 
          CaseNbr, 
		  ExtCaseNbr,
          SUBSTRING(AttyTypes, 1, LEN(AttyTypes) - 1) AS AttorneyTypes,
          ExamineeName,
          ApptDate, 
          Description,
          ClientCode,
          ClientName,
          CompanyCode,
          IntName,
          Location, 
          DoctorCode, 
          StatusDesc, 
          DoctorName, 
          PlaintiffAttorneyCode, 
          DefenseAttorneyCode, 
          DefParaLegal, 
	  ShortDesc 
     FROM 
          (SELECT 
               dbo.tblCase.casenbr,  
			   dbo.tblCase.ExtCaseNbr,
               dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineeName, 
               dbo.tblCase.ApptDate, 
               dbo.tblCaseType.description, 
               dbo.tblCase.clientcode, 
               dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, 
               dbo.tblClient.companycode, 
               dbo.tblCompany.intname, 
               dbo.tblLocation.location, 
               dbo.tblDoctor.doctorcode, 
               dbo.tblQueues.statusdesc, 
               dbo.tblCase.DoctorName,
               -- @AttorneyCode AS AttrnyCode,
               dbo.tblCase.PlaintiffAttorneyCode, 
               dbo.tblCase.DefenseAttorneyCode, 
               dbo.tblCase.DefParaLegal, 
               CASE 
                    WHEN dbo.tblCase.PlaintiffAttorneyCode IS NOT NULL AND dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode
                    THEN 'PA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefenseAttorneyCode IS NOT NULL AND dbo.tblCase.DefenseAttorneyCode = @AttorneyCode 
                    THEN 'DA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefParaLegal IS NOT NULL AND dbo.tblCase.DefParaLegal = @AttorneyCode
                    THEN 'DP,' 
                    ELSE '' 
               END  
               +
               CASE 
                    WHEN dbo.tblExamineeCC.ccCode IS NOT NULL AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    THEN 'CC,' 
                    ELSE '' 
               END AS AttyTypes, 
	       dbo.tbloffice.ShortDesc 
          FROM 
               dbo.tblCase 
                    INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
                    INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
                    INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    LEFT OUTER JOIN dbo.tblExamineeCC ON dbo.tblCase.chartnbr = dbo.tblExamineeCC.chartnbr AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode 
                    LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode 
	            LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
          WHERE 
               dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode 
            OR dbo.tblCase.DefenseAttorneyCode = @AttorneyCode
            OR dbo.tblCase.DefParaLegal = @AttorneyCode
			OR dbo.tblExamineeCC.ccCode = @AttorneyCode
          ) AS CaseListForAttorney
GO
PRINT N'Altering [dbo].[spClientCases]...';


GO

ALTER  PROCEDURE [dbo].[spClientCases]
@clientcode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ExtCaseNbr, 'C' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tbloffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					 dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcase.clientcode = @clientcode
UNION
SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ExtCaseNbr, 'B' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tbloffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					  dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcase.billclientcode = @clientcode
ORDER BY dbo.tblCase.ApptDate DESC
GO
PRINT N'Altering [dbo].[spCompanyCases]...';


GO
ALTER  PROCEDURE [dbo].[spCompanyCases]
@companycode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblCase.ExtCaseNbr, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tblOffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					  dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcompany.companycode = @companycode
ORDER BY dbo.tblCase.ApptDate DESC
GO
PRINT N'Altering [dbo].[spDoctorCases]...';


GO
ALTER PROC spDoctorCases
    @doctorCode AS INTEGER
AS 
    SELECT TOP 100 PERCENT
            tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS ExamineeName ,
            tblCase.ApptDate ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorName ,
            tblCase.ClientCode ,
            tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
            tblClient.CompanyCode ,
            tblCompany.IntName ,
            tblLocation.Location ,
            @doctorCode AS DoctorCode ,
            tblQueues.StatusDesc, 
			tbloffice.ShortDesc
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblDoctor ON tblDoctor.DoctorCode = @doctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode 
			LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
    WHERE   tblCase.DoctorCode = @doctorcode
            OR tblCase.PanelNbr IN ( SELECT PanelNbr
                                     FROM   tblCasePanel
                                     WHERE  DoctorCode = @doctorCode )
    ORDER BY tblCase.apptdate DESC
GO
PRINT N'Altering [dbo].[spExamineeCases]...';


GO
ALTER PROC spExamineeCases
    (
      @ChartNbr INTEGER
    )
AS 
    SELECT  *
    FROM    ( SELECT    tblCase.CaseNbr , tblCase.ExtCaseNbr,
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
            ) AS eeCases
    ORDER BY eeCases.MasterCaseNbr DESC ,
            eeCases.MasterSubCase ,
            eeCases.ApptDate DESC ,
            eeCases.CaseApptID DESC
GO
