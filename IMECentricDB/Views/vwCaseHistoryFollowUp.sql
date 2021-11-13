CREATE VIEW vwCaseHistoryFollowUp
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
		CH.ID, 
		ISNULL(BillCompany.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID,
		ST.Name As ServiceTypDesc,
		S.EWServiceTypeID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
		LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
		LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
		LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = S.EWServiceTypeID
        INNER JOIN tblCaseHistory AS CH ON CH.CaseNbr = C.CaseNbr
WHERE   CH.FollowUpDate IS NOT NULL
