CREATE VIEW dbo.vwDPSCases
AS
    SELECT 
        C.CaseNbr,
        C.ExtCaseNbr,
        B.DPSBundleID,
        DATEDIFF(d, B.DateEdited, GETDATE()) AS IQ,
        E.FirstName+' '+E.LastName AS ExamineeName,
        Com.IntName AS CompanyName,
        D.FirstName+' '+D.LastName AS DoctorName,
        C.ApptTime,
        B.ContactName,
		B.DateCompleted,
        B.DPSStatusID,       
        B.DateAcknowledged,
        C.OfficeCode,
        C.ServiceCode,
        C.SchedulerCode,
        C.QARep,
        C.MarketerCode,
        Com.ParentCompanyID,
        C.DoctorLocation,
        D.DoctorCode,
        Com.CompanyCode,
        C.CaseType,
        E.ChartNbr,
		S.Name AS Status
    FROM
        tblDPSBundle AS B
	LEFT OUTER JOIN tblDPSStatus AS S ON S.DPSStatusID = B.DPSStatusID
    LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
    LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
    LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
    LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
    LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode