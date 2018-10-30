
CREATE VIEW [dbo].[vwCaseOtherContacts]
AS
SELECT CaseNbr, 'CC' AS Type, FirstName, LastName, Company, Email, Fax from vwCaseCC
UNION
SELECT C.CaseNbr, 'DefAttny', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON DefenseAttorneyCode=CCCode
UNION
SELECT C.CaseNbr, 'DefParalegal:', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON C.DefParaLegal=CCCode
UNION
SELECT casenbr, type, firstname, lastname, companyname, emailAddr, faxNbr from vwCaseOtherParty
UNION
SELECT C.CaseNbr, 'ExamLoc', L.ContactFirst, L.ContactLast, L.Location, L.Email, L.Fax FROM tblCase AS C INNER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
UNION
SELECT C.CaseNbr, 'Treat Phy', E.TreatingPhysician, '', '', E.TreatingPhysicianEmail, E.TreatingPhysicianFax FROM tblCase AS C INNER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
UNION
SELECT C.CaseNbr, '3rd Party', CL.FirstName, CL.LastName, COM.IntName, CL.Email, COALESCE(NULLIF(CL.BillFax,''), NULLIF(CL.Fax,'')) FROM tblCase AS C INNER JOIN tblClient AS CL ON C.BillClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT C.CaseNbr, 'Processor', CL.ProcessorFirstName, CL.ProcessorLastName, COM.IntName, CL.ProcessorEmail, CL.ProcessorFax FROM tblCase AS C INNER JOIN tblClient AS CL ON C.ClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT TRO.CaseNbr, 'Facility', TF.ContactFirst, TF.ContactLast, TF.Name, TF.Email, TF.Fax FROM tblCase AS C INNER JOIN tblRecordsObtainment AS TRO ON TRO.CaseNbr = C.CaseNbr INNER JOIN tblFacility AS TF ON TF.FacilityID = TRO.FacilityID

