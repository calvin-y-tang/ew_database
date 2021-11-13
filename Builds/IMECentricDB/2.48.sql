CREATE TABLE [tblCasePeerBill] (
  [PeerBillID] INTEGER IDENTITY(1,1) NOT NULL,
  [CaseNbr] INTEGER NOT NULL,
  [DateBillReceived] DATETIME,
  [ServiceDate] DATETIME,
  [BillNumber] VARCHAR(50),
  [BillAmount] MONEY,
  [ReferringProviderName] VARCHAR(50),
  [ReferringProviderTIN] VARCHAR(11),
  [ProviderName] VARCHAR(50),
  [ProviderTIN] VARCHAR(11),
  [ProviderSpecialtyCode] VARCHAR(50),
  [ServiceRendered] VARCHAR(250),
  [CPTCode] VARCHAR(20),
  [BillAmountApproved] MONEY,
  [BillAmountDenied] MONEY,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(15),
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(15),
  CONSTRAINT [PK_tblCasePeerBill] PRIMARY KEY ([PeerBillID])
)
GO

CREATE TABLE [tblTreatingDoctor] (
  [TreatingDoctorID] INTEGER IDENTITY(1,1) NOT NULL,
  [LastName] VARCHAR(50),
  [FirstName] VARCHAR(50),
  [MI] VARCHAR(2),
  [TaxID] VARCHAR(15),
  [DateAdded] DATETIME,
  [DateEdited] DATETIME,
  [UserIDAdded] VARCHAR(15),
  [UserIDEdited] VARCHAR(15),
  [Addr1] VARCHAR(50),
  [Addr2] VARCHAR(50),
  [City] VARCHAR(50),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Phone] VARCHAR(15),
  [Fax] VARCHAR(15),
  [Email] VARCHAR(70),
  CONSTRAINT [PK_tblTreatingDoctor] PRIMARY KEY ([TreatingDoctorID])
)
GO

CREATE TABLE [tblCaseOtherTreatingDoctor] (
  [CaseNbr] INTEGER NOT NULL,
  [TreatingDoctorID] INTEGER NOT NULL,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(15),
  CONSTRAINT [PK_tblCaseOtherTreatingDoctor] PRIMARY KEY ([CaseNbr],[TreatingDoctorID])
)
GO


ALTER TABLE [tblCase]
  ADD [Recommendation] TEXT
GO

ALTER TABLE [tblCase]
  ADD [NeedFurtherTreatment] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblCase]
  ADD [TreatmentLength] INTEGER
GO

ALTER TABLE [tblCase]
  ADD [TreatmentLengthUnit] VARCHAR(1)
GO

ALTER TABLE [tblCase]
  ADD [ReExam] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblCase]
  ADD [ReExamDate] DATETIME
GO

ALTER TABLE [tblCase]
  ADD [ReExamProcessed] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblCase]
  ADD [ReExamNoticePrinted] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblCase]
  ADD [IsReExam] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblCase]
  ADD [CourtIndexNbr] VARCHAR(50)
GO

ALTER TABLE [tblCaseHistory]
  ADD [FollowUpDate] DATETIME
GO


ALTER TABLE [tblIMEData]
  ADD [ReExamNoticeDocument] VARCHAR(15)
GO


ALTER TABLE tblTranscriptionJob
 ADD IntegrationID INT
GO




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
		C.QARep AS QARepCode ,
		C.CaseType ,
		C.ServiceCode ,

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
		CH.ID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
        INNER JOIN tblCaseHistory AS CH ON CH.CaseNbr = C.CaseNbr
WHERE   CH.FollowUpDate IS NOT NULL
GO

CREATE VIEW vwCaseOtherContacts
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

GO


UPDATE tblControl SET DBVersion='2.48'
GO
