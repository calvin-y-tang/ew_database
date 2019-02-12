CREATE VIEW vwRptProgressiveReferral
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 C.SReqSpecialty AS RequestedSpecialty,
 L.County,
 L.State,

 C.DateReceived,
 C.DateOfInjury,

 FZ.Name AS FeeZone,
 (SELECT TOP 1 Description FROM tblCaseDocuments AS CD WHERE (CD.CaseNbr=C.CaseNbr OR (CD.MasterCaseNbr=C.MasterCaseNbr AND CD.SharedDoc=1)) 
     AND Description LIKE '% EFF[ .]%' ORDER BY SeqNo DESC) AS LastEff,

 CL.CompanyCode,
 dbo.fnDateValue(C.DateReceived) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblEWFeeZone AS FZ ON FZ.EWFeeZoneID = C.EWFeeZoneID
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 WHERE 1=1
 AND S.EWServiceTypeID=1