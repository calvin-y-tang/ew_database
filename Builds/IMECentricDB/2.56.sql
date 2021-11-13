CREATE TABLE [tblCaseNF10] (
  [CaseNbr] INTEGER NOT NULL,
  [NF10TemplateID] INTEGER NOT NULL,
  [Document] VARCHAR(15),
  [EntireClaimDenied] bit NOT NULL,
  [PartialDenied] bit NOT NULL,
  [LossEarningsDenied] bit NOT NULL,
  [LossEarningsAmt] VARCHAR(20),
  [HealthBenefitDenied] bit NOT NULL,
  [HealthBenefitAmt] VARCHAR(20),
  [NecessaryExpensesDenied] bit NOT NULL,
  [NecessaryExpensesAmt] VARCHAR(20),
  [ReasonDenied] VARCHAR(1000),
  [ExamineeName] VARCHAR(100),
  [ExamineeAddress] VARCHAR(100),
  [NF10Date] datetime,
  CONSTRAINT [PK_tblCaseNF10] PRIMARY KEY ([CaseNbr])
)
  ON [PRIMARY]
GO

CREATE TABLE [tblCompanyNF10Template] (
  [NF10TemplateID] INTEGER IDENTITY(1,1) NOT NULL,
  [Name] VARCHAR(25),
  [CompanyCode] INTEGER NOT NULL,
  [Document] VARCHAR(15),
  [EntireClaimDenied] bit NOT NULL,
  [PartialDenied] bit NOT NULL,
  [LossEarningsDenied] bit NOT NULL,
  [LossEarningsAmt] VARCHAR(20),
  [HealthBenefitDenied] bit NOT NULL,
  [HealthBenefitAmt] VARCHAR(20),
  [NecessaryExpensesDenied] bit NOT NULL,
  [NecessaryExpensesAmt] VARCHAR(20),
  [ReasonDenied] VARCHAR(1000),
  CONSTRAINT [PK_tblCompanyNF10Template] PRIMARY KEY ([NF10TemplateID])
)
  ON [PRIMARY]
GO

ALTER TABLE [tblIMEData]
  ADD [UseNF10] BIT DEFAULT 0 NOT NULL
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'vwDoctorScheduleMEI') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwDoctorScheduleMEI
GO

CREATE VIEW dbo.vwDoctorScheduleMEI
AS
SELECT        TOP (100) PERCENT dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.StartTime, dbo.tblDoctorSchedule.Status, dbo.tblDoctorSchedule.DoctorCode, 
                         dbo.tblDoctorSchedule.SchedCode, dbo.tblCase.CaseNbr, dbo.tblExaminee.FirstName + ' ' + dbo.tblExaminee.LastName AS examineename, 
                         dbo.tblLocation.Location, ISNULL(dbo.tblDoctor.FirstName, '') + ' ' + ISNULL(dbo.tblDoctor.LastName, '') + ', ' + ISNULL(dbo.tblDoctor.Credentials, '') AS doctorname, 
                         dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.Fax AS doctorfax, dbo.tblCase.PanelNbr, dbo.tblDoctorOffice.OfficeCode, 
                         CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter, dbo.tblExaminee.Sex, dbo.tblLocation.Addr1, dbo.tblLocation.Addr2, 
                         dbo.tblLocation.City, dbo.tblLocation.State, dbo.tblLocation.Zip, dbo.tblIMEData.CompanyName, dbo.tblLocation.LocationCode, dbo.tblServices.ShortDesc
FROM            dbo.tblLocation INNER JOIN
                         dbo.tblDoctorSchedule INNER JOIN
                         dbo.tblDoctor ON dbo.tblDoctorSchedule.DoctorCode = dbo.tblDoctor.DoctorCode ON 
                         dbo.tblLocation.LocationCode = dbo.tblDoctorSchedule.LocationCode LEFT OUTER JOIN
                         dbo.tblCaseType INNER JOIN
                         dbo.tblClient INNER JOIN
                         dbo.tblCase ON dbo.tblClient.ClientCode = dbo.tblCase.ClientCode INNER JOIN
                         dbo.tblCompany ON dbo.tblClient.CompanyCode = dbo.tblCompany.CompanyCode INNER JOIN
                         dbo.tblExaminee ON dbo.tblCase.ChartNbr = dbo.tblExaminee.ChartNbr ON dbo.tblCaseType.Code = dbo.tblCase.CaseType INNER JOIN
                         dbo.tblServices ON dbo.tblCase.ServiceCode = dbo.tblServices.ServiceCode ON dbo.tblDoctorSchedule.SchedCode = dbo.tblCase.SchedCode LEFT OUTER JOIN
                         dbo.tblIMEData INNER JOIN
                         dbo.tblOffice INNER JOIN
                         dbo.tblDoctorOffice ON dbo.tblOffice.OfficeCode = dbo.tblDoctorOffice.OfficeCode ON dbo.tblIMEData.IMECode = dbo.tblOffice.IMECode ON 
                         dbo.tblDoctorSchedule.DoctorCode = dbo.tblDoctorOffice.DoctorCode
WHERE        (dbo.tblDoctorSchedule.Status = 'open') OR
                         (dbo.tblDoctorSchedule.Status = 'Hold') OR
                         (dbo.tblDoctorSchedule.Status = 'scheduled') AND (dbo.tblCase.SchedCode IS NOT NULL)
Go



DROP VIEW vwCaseAppt
GO
CREATE VIEW vwCaseAppt
AS
WITH allDoctors AS (
          SELECT  
               CA.CaseApptID ,
               ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
               CASE WHEN CA.DoctorCode IS NULL THEN
               LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
               ELSE
               LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
               END AS DoctorName,
               ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
           FROM tblCaseAppt AS CA
           LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
        CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CB.ExtName AS CanceledByExtName ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,
        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(100)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS Specialties,
          CA.DateReceived, 
          FZ.Name AS FeeZoneName
     FROM tblCaseAppt AS CA
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
     LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID

GO

Insert into tblMessageToken values ('@ClientEmail@','')
Insert into tblMessageToken values ('@HCAIDocumentNbr@','')
Insert into tblMessageToken values ('@HearingDate@','')
Insert into tblMessageToken values ('@InternalCaseNbr@','')
Insert into tblMessageToken values ('@WCBNbr@','')
GO



UPDATE tblProduct SET AllowInvoice=1
 FROM tblProduct AS P
 INNER JOIN tblAcctDetail AS AD ON AD.ProdCode = P.ProdCode
 INNER JOIN tblAcctHeader AS AH ON AH.DocumentNbr=AD.DocumentNbr AND AH.DocumentType=AD.DocumentType
 WHERE (YEAR(AH.DocumentDate)>=2014 OR AH.DocumentDate IS NULL)
 AND AH.DocumentType='IN'
 AND P.AllowInvoice=0
GO

UPDATE tblProduct SET AllowVoucher=1
 FROM tblProduct AS P
 INNER JOIN tblAcctDetail AS AD ON AD.ProdCode = P.ProdCode
 INNER JOIN tblAcctHeader AS AH ON AH.DocumentNbr=AD.DocumentNbr AND AH.DocumentType=AD.DocumentType
 WHERE (YEAR(AH.DocumentDate)>=2014 OR AH.DocumentDate IS NULL)
 AND AH.DocumentType='VO'
 AND P.AllowVoucher=0
GO

update tblproduct set allowVoucher=1
 WHERE voGLAcct in ('50090', '50095')

GO



UPDATE tblControl SET DBVersion='2.56'
GO
