
CREATE VIEW [dbo].[vwRptProgressiveRptWebLog]
AS
SELECT
C.CaseNbr,
C.ClaimNbr,
EE.firstName + ' ' + EE.lastName AS Examinee,
CDT.Description AS DocType,
CD.Description AS DocDescrip,
POW.DateAdded AS DateUploaded,
CL.FirstName + ' ' + CL.LastName AS Client,
CL.EmployeeNumber AS ClientEmployeeNumber,
POW.DateViewed,
DATEDIFF(DAY, POW.DateAdded, POW.DateViewed) AS Days,
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
INNER JOIN tblClient AS CL ON POW.UserType='CL' AND POW.UserCode=CL.ClientCode
INNER JOIN tblCase AS C ON C.CaseNbr = CD.CaseNbr
INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
WHERE CD.CaseDocTypeID=5 OR CD.Description LIKE '%Closed Letter%'

GO


