CREATE VIEW vwWALI
AS
SELECT  CA.CaseApptID,
		ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
		dbo.fnDateValue(CA.ApptTime) AS ApptDate,
		CA.CaseNbr,
		CT.EWBusLineID,
		C.ServiceCode
FROM    tblCaseAppt AS CA 
INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
INNER JOIN tblCodes ON Category = 'WALI CAC' AND SubCategory = 'ServiceCode' AND Value=CAST(C.ServiceCode AS VARCHAR)
LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = CA.CaseApptID
WHERE CT.EWBusLineID=3
AND CA.ApptStatusID=10