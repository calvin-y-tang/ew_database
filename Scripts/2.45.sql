ALTER TABLE tblUserActivity
 ADD AutoLogin BIT
GO
UPDATE tblUserActivity SET AutoLogin=0
GO

ALTER TABLE [tblCaseHistory]
  ADD [ConversationLog] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblCanceledBy]
  ADD [ExtName] VARCHAR(25)
GO

UPDATE tblCanceledBy SET ExtName=Name
UPDATE tblCanceledBy SET ExtName='Attorney' WHERE CanceledByID=5
GO

ALTER TABLE tblWebActivation ALTER COLUMN EmailAddress VARCHAR(150) NULL
GO


SET IDENTITY_INSERT [dbo].[tblQueues] ON
GO
INSERT INTO 
     [dbo].[tblQueues] ([StatusCode],
                        [StatusDesc],
                        [Type],
                        [ShortDesc],
                        [DisplayOrder],
                        [FormToOpen],
                        [DateAdded],
                        [DateEdited],
                        [UserIDAdded],
                        [UserIDEdited],
                        [Status],
                        [SubType],
                        [FunctionCode],
                        [WebStatusCode],
                        [WebGUID],
                        [NotifyScheduler],
                        [NotifyQARep],
                        [NotifyIMECompany],
                        [AllowToAwaitingScheduling])
     VALUES (31, 
             'Invoices Awaiting Electronic Attachment',
             'System',
             'EIPExp',
             451,
             'frmStatusEIPAttachment',
             CURRENT_TIMESTAMP, 
             CURRENT_TIMESTAMP,
             'Admin', 
             'Admin', 
             'Active', 
             'Accting',
             'EDIExport',
             NULL,
             NULL, 
             0,
             0, 
             1, 
             NULL)
GO
SET IDENTITY_INSERT [dbo].[tblQueues] OFF

GO
-- update display order for acknowledgment and acknowledgment error queues
UPDATE [dbo].[tblQueues]
   SET DisplayOrder = DisplayOrder + 1
 WHERE StatusCode in (27, 28)

GO
-- new view that will used to provide guidance on required attachment types 
-- based on CPT codes that may be posted to invoice.
CREATE VIEW [dbo].[vwInvoiceAttachmentGuidance]
AS
     -- Attachment Type 06 for CPT:98770-98774
          SELECT CaseNbr, '06 - Initial Assessment' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '98770' AND Detail.CPTCode <= '98774'

     UNION

     -- Attachment Type 09 for CPT: 99081 and CPT:99214-99215
          SELECT CaseNbr, '09 - Progress Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode IN ('99081', '99214', '99215')
     UNION

     -- Attachment Type DG for CPT:95804-95830
          SELECT CaseNbr, 'DG - Description for Code Not Available' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '95804' AND Detail.CPTCode <= '95830'

     UNION

     -- Attachment Type J1 for CPT:99201-99205
          SELECT CaseNbr, 'J1 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99201' AND Detail.CPTCode <= '99205'

     UNION

     -- Attachment Type J2 for ALL BR codes, CPT:97545, CPT:97546, CPT:99080 
          SELECT CaseNbr, 'J2 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND (Detail.CPTCode IN ('97545', '97546', '99080') OR Detail.CPTCode LIKE '%BR')

     UNION

     -- Attachment Type J7 for CPT:99241-99245
          SELECT CaseNbr, 'J7 - Consultation Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99241' AND Detail.CPTCode <= '99245'

     UNION

     -- Attachment Type LA for CPT:80047-89398 CPT:G0430-G0434
          SELECT CaseNbr, 'LA - Laboratory Results' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '80047' AND Detail.CPTCode <= '89398') 
                    OR 
                    (Detail.CPTCode >= 'G0430' AND Detail.CPTCode <= 'G0434') 
                    )

     UNION

     -- Attachment Type OB for CPT:10021-69999
          SELECT CaseNbr, 'OB - Operative Note' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '10021' AND Detail.CPTCode <= '69999'

     UNION

     -- Attachment Type OZ for CPT:00100-01999
          SELECT CaseNbr, 'OZ - Support Data for Claim' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '00100' AND Detail.CPTCode <= '01999'

     UNION

     -- Attachment Type RR for CPT:70000-79999
          SELECT CaseNbr, 'RR - Radiology Reports' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '70000' AND Detail.CPTCode <= '79999'

     UNION

     -- Attachment Type RT for CPT:95831-95852, CPT: 96100�96117
          SELECT CaseNbr, 'RT - Report of Tests and Analysis Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.DocumentNbr = Header.DocumentNbr
                         AND Detail.DocumentType = Header.DocumentType
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '95831' AND Detail.CPTCode <= '95852') 
                    OR 
                    (Detail.CPTCode >= '96100' AND Detail.CPTCode <= '96117') 
                    )

GO
-- create require attachment column in tblEWBulkBilling table
ALTER TABLE [dbo].[tblEWBulkBilling] ADD EDIRequireAttachment bit NULL DEFAULT 0

GO
-- create new table to track documents attached to an invoice and their type
-- this is a "keys" table between tblAcctHeader and tblCaseDocuments 
-- tblAcctHeader PKEY ==> DocumentNbr, DocumentType
-- tblCaseDocuments PKEY ==> SeqNo
CREATE TABLE [dbo].[tblInvoiceAttachments](
     [InvAttachID] [int] IDENTITY(1,1) NOT NULL,
     [DocumentNbr] [int] NULL,
     [DocumentType] [varchar](10) NULL,
     [SeqNo] [int] NULL,
     [AttachType] [varchar](5) NULL,
     CONSTRAINT [PK_tblInvoiceAttachments] PRIMARY KEY CLUSTERED ([InvAttachID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE tblSpecialty ADD NUCCTaxonomyCode VARCHAR(16) NULL
GO



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
		CA.DateReceived
     FROM tblCaseAppt AS CA
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
GO

DROP VIEW vwApptLogDocs
GO
CREATE VIEW vwApptLogDocs
AS
    SELECT 
            tblCase.CaseNbr ,
            CA.DateAdded ,
            CA.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, CA.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            ISNULL(CA.SpecialtyCode, tblCaseApptPanel.SpecialtyCode) AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        PriorAppt.ApptTime
              FROM      tblCaseAppt AS PriorAppt
                        WHERE PriorAppt.CaseNbr = tblCase.CaseNbr
                        AND PriorAppt.CaseApptID<CA.CaseApptID
              ORDER BY  PriorAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tblDoctor.ProvTypeCode
    FROM    tblCaseAppt AS CA
			INNER JOIN tblApptStatus ON CA.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON CA.CaseNbr = tblCase.CaseNbr

            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            
			LEFT OUTER JOIN tblCaseApptPanel ON CA.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblDoctor ON ISNULL(CA.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode

            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON CA.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9 
GO


DROP VIEW vwRptCancelDetail
GO
 
CREATE VIEW vwRptCancelDetail
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.Reason ,
            vwCaseAppt.CanceledByExtName ,
            tblCase.Casetype ,
            tblCase.MastersubCase
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
GO

DROP VIEW vwRptCancelDetailDocs
GO 
CREATE VIEW vwRptCancelDetailDocs
AS
    SELECT 
            tblCaseAppt.CaseNbr ,
            tblCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCaseAppt.ApptStatusID ,
            tblApptStatus.Name AS ApptStatus ,
            tblCaseAppt.LastStatusChg ,
            tblCaseAppt.Reason ,
            tblCanceledBy.ExtName AS CanceledByExtName ,
            tblCase.Casetype ,
            tblCase.MastersubCase
    FROM    tblCaseAppt
			INNER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON tblCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblCaseApptPanel ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = tblCaseAppt.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCaseAppt.ApptStatusID IN (50, 51)
GO

DROP VIEW vwCancelAppt
GO
CREATE VIEW vwCancelAppt
AS
    SELECT DISTINCT 
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.DoctorNames ,
            tblLocation.Location ,
            vwCaseAppt.CanceledByExtName ,
            vwCaseAppt.Reason ,
            vwCaseAppt.ApptTime ,
            vwCaseAppt.DateEdited ,
            vwCaseAppt.UserIDEdited ,
            tblOffice.Description AS Office ,
            tblCaseType.Description AS CaseType ,
            vwClient.Client ,
            vwClient.IntName AS Company ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee ,
            tblServices.Description AS Service ,
            tblCase.MarketerCode ,
            tblCase.CaseNbr ,
            tblCase.QARep ,
            tblCase.OfficeCode ,
            tblCaseType.Code ,
            vwClient.CompanyCode ,
            vwClient.ClientCode ,
            tblExaminee.ChartNbr ,
            tblServices.ServiceCode
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN vwClient ON tblCase.ClientCode = vwClient.ClientCode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
GO




CREATE VIEW vw_EDIFileAttachments AS
SELECT	CaseDocs.[Description], 
		CaseDocs.sFilename, 
		CaseDocs.SeqNo, 
		CaseDocs.CaseNbr, 
		Header.DocumentNbr, 
		Header.DocumentType, 
		InvAttach.InvAttachID, 
		InvAttach.AttachType, 
		CaseDocs.[Type] 
  FROM tblCaseDocuments CaseDocs 
	LEFT OUTER JOIN tblAcctHeader Header ON ((Header.CaseNbr = CaseDocs.CaseNbr) AND (Header.DocumentType = 'IN')) 
	LEFT OUTER JOIN tblInvoiceAttachments InvAttach ON ((InvAttach.DocumentNbr = Header.DocumentNbr) 
		AND (InvAttach.DocumentType = Header.DocumentType) 
		AND (InvAttach.SeqNo = CaseDocs.SeqNo)) 
	WHERE (CaseDocs.[Type] IN ('document', 'report')) 

GO



UPDATE tblControl SET DBVersion='2.45'
GO
