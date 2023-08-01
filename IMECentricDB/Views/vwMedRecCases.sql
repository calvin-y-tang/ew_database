CREATE VIEW [dbo].[vwMedRecCases]
AS 
	    SELECT 
			C.CaseNbr,
			C.ExtCaseNbr, 
			DATEDIFF(DAY, C.LastStatusChg, GETDATE()) AS IQ,
			E.FirstName + ' ' + E.LastName AS ExamineeName,
			Com.IntName AS CompanyName,
			D.FirstName + ' ' + D.LastName AS DoctorName,
			C.ApptTime,
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
			C.Status AS CaseStatus,
			Q.StatusDesc,
			E.ChartNbr,		
			Serv.Description, 
			ServType.EWServiceTypeID, 
			ServType.Name As ServiceTypDesc,
			CT.ShortDesc AS CaseTypeDesc,
			C.RPAMedRecRequestDate,
			C.RPAMedRecUploadStatus,
			C.RPAMedRecUploadAckDate,
			C.RPAMedRecUploadAckUserID,
			C.RPAMedRecCompleteDate
    FROM tblCase AS C
			LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
			LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
			LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
			LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode	
			LEFT OUTER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
			LEFT OUTER JOIN tblServices AS Serv ON Serv.ServiceCode = C.ServiceCode
			LEFT OUTER JOIN tblEWServiceType AS ServType ON ServType.EWServiceTypeID = Serv.EWServiceTypeID
			LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

