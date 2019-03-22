
CREATE VIEW [dbo].[vwRptProgressiveUpcomingAppt]
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 C.AddlClaimNbrs,
 Q.StatusDesc AS CaseStatus,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ClaimantName,
 C.DoctorSpecialty,

 C.DateReceived,
 C.ApptDate,
 (SELECT TOP 1 Description FROM tblCaseDocuments AS CD WHERE (CD.CaseNbr=C.CaseNbr OR (CD.MasterCaseNbr=C.MasterCaseNbr AND CD.SharedDoc=1)) AND Description LIKE '% EFF[ .]%' ORDER BY SeqNo DESC) AS LastEff,

 CL.CompanyCode,

 dbo.fnDateValue(C.ApptDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 WHERE 1=1
 AND S.EWServiceTypeID=1
GO


