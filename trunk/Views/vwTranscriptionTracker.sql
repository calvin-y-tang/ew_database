 CREATE VIEW vwTranscriptionTracker
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
			C.ExtCaseNbr ,
			TD.EWTimeZoneID ,
			DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()) AS TransDeptDateTime,
			dbo.fnGetTATMins(CT.LastStatusChg, DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE())) AS TAT,
			dbo.fnGetTATString(dbo.fnGetTATMins(CT.LastStatusChg, DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, CTRL.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()))) AS TATString
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
			LEFT OUTER JOIN tblControl AS CTRL ON 1=1