
CREATE VIEW vwAutoPrepay
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

			DCR.Amount,
			DCR.CheckRequestID,

            CT.Description AS CaseTypeDesc ,
			CaseQ.StatusDesc AS CaseStatusDesc ,
            tblApptStatus.Name AS Result ,
            ATQ.StatusDesc ,
            ATQ.FunctionCode ,
            S.Description AS ServiceDesc, 
			C.ExtCaseNbr, 
			ISNULL(BCOM.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID
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
			INNER JOIN tblDoctorCheckRequest AS DCR ON AT.SeqNO = DCR.AcctingTransID
    WHERE   ( AT.StatusCode <> 20 )



