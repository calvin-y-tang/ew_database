
CREATE VIEW [dbo].[vwRptProgressiveRptWebLog]
AS
SELECT 
C.CaseNbr,
CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
EE.firstName + ' ' + EE.lastName AS Examinee,
CDT.Description AS DocType,
CD.Description AS DocDescrip,
POW.DateAdded AS DateUploaded,
CL.FirstName + ' ' + CL.LastName AS Client,
CL.EmployeeNumber AS ClientEmployeeNumber,
CL1.FirstName + ' ' + CL1.LastName AS ClientViewer,
CL1.EmployeeNumber AS ClientViewerEmployeeNumber,
TCD.FirstViewedOnWebDate AS DateViewed,
DATEDIFF(DAY, POW.DateAdded, TCD.FirstViewedOnWebDate) AS Days, 
S.Description AS Service,
CT.Description AS ClaimType,
C.ApptDate,
C.DoctorSpecialty,
C.DoctorName,
C.DateOfInjury,

CL.CompanyCode,
dbo.fnDateValue(POW.DateAdded) AS FilterDate

FROM tblCaseDocuments AS CD
INNER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
INNER JOIN tblPublishOnWeb AS POW ON POW.TableType='tblCaseDocuments' AND POW.TableKey=CD.SeqNo
INNER JOIN tblCaseDocuments AS TCD ON POW.TableKey = TCD.SeqNo
INNER JOIN tblWebUser AS TWU ON TCD.FirstViewedOnWebBy = TWU.UserID
INNER JOIN tblClient AS CL ON POW.UserType='CL' AND POW.UserCode=CL.ClientCode
INNER JOIN tblClient AS CL1 ON TWU.UserType='CL' AND TWU.IMECentricCode = CL1.ClientCode
INNER JOIN tblCase AS C ON C.CaseNbr = CD.CaseNbr
INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
WHERE CD.CaseDocTypeID=5 OR CD.Description LIKE '%Closed Letter%'
GO



