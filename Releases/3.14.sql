PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient]
    ADD [DistributionNotes] VARCHAR (MAX) NULL;


GO
PRINT N'Altering [dbo].[tblCompany]...';


GO
ALTER TABLE [dbo].[tblCompany]
    ADD [DistributionNotes] VARCHAR (MAX) NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationRule]...';


GO
ALTER TABLE [dbo].[tblConfirmationRule]
    ADD [ExcludeFromList] BIT CONSTRAINT [DF_tblConfirmationRule_ExcludeFromList] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[vwConfirmationResultsReport]...';


GO
ALTER VIEW vwConfirmationResultsReport
AS 
			SELECT  
		c.Office, 
		c.ExtCaseNbr AS 'Case Nbr', 
		FORMAT(c.ApptTime,'MM-dd-yy') AS 'Appt',
		c.ExamineefirstName + ' ' + c.ExamineelastName AS Examinee, 
		ISNULL(c.PAttorneyCompany,'') AS 'Attorney Firm', 
		ISNULL(c.pAttorneyfirstName, '') + ISNULL(c.pAttorneylastName, '') AS Attorney, 
		c.Company, 
		ct.ShortDesc AS 'Case Type', 
		s.ShortDesc AS Service, 
		cl.ContactType AS 'Contact Type', 
		IIF(cl.ContactMethod=1,'Phone','Text') AS 'Contact Method', 
		cl.Phone,  
		FORMAT(cl.TargetCallTime,'M-d-yy h:mmtt') AS 'Call Target Time', 
		FORMAT(cl.ContactedDateTime,'M-d-yy h:mmtt') AS 'Actual Call Date Time', 
		cl.NbrOfCallAttempts AS 'Nbr Attempts', 
		cr.Description AS 'Call Result', 
		IIF(ca.apptconfirmed =0, 'No','Yes') AS Confirmed,
		c.officeCode,
		cl.StartDate,
		cs.Name AS StatusDescription,
		d.FirstName + ' ' + d.LastName AS 'Doctor Name',
		l.Location AS 'Exam Location',		
		IIF (cl.ConfirmationStatusID <> 112,cb.DateBatchPrepared, ca.ApptConfirmedDate) AS SentDate
	FROM tblconfirmationlist AS cl
	LEFT OUTER JOIN tblconfirmationresult AS cr ON cr.confirmationresultid = cl.confirmationresultid
	INNER JOIN tblcaseappt AS ca ON ca.caseapptid = cl.CaseApptID
	INNER JOIN vwdocument AS c ON c.casenbr = ca.CaseNbr
	INNER JOIN tblServices AS s ON c.servicecode = s.servicecode
	INNER JOIN tblCaseType AS ct ON c.casetype = ct.code
	INNER JOIN tblConfirmationStatus AS cs ON cl.ConfirmationStatusID = cs.ConfirmationStatusID
	LEFT OUTER JOIN tblConfirmationBatch AS cb ON cl.BatchNbr = cb.BatchNbr
	INNER JOIN tblDoctor AS d ON ca.DoctorCode = d.DoctorCode
	INNER JOIN tblLocation AS l ON ca.LocationCode = l.LocationCode
	WHERE  cl.BatchNbr <> 0 AND (cl.Selected = 1) 
	AND (cl.ConfirmationStatusID IN (NULL,3,4,5,112))
GO
PRINT N'Creating [dbo].[vwGBClaimRecords]...';


GO
CREATE VIEW [dbo].[vwGBClaimRecords]
	AS SELECT * FROM [CustomRepository].[dbo].[GallagherBassettClaim]
GO




TRUNCATE TABLE tblDPSPriority
SET IDENTITY_INSERT tblDPSPriority ON
INSERT INTO tblDPSPriority (DPSPriorityID, Name, ExtPriorityCode) VALUES (1, 'Standard', 'STANDARD')
INSERT INTO tblDPSPriority (DPSPriorityID, Name, ExtPriorityCode) VALUES (2, 'Rush', '4HRUSH')
INSERT INTO tblDPSPriority (DPSPriorityID, Name, ExtPriorityCode) VALUES (3, 'Immediate', 'IMMED')
SET IDENTITY_INSERT tblDPSPriority OFF
GO



Insert Into tblConfirmationStatus 
values (112, 'Skipped Manually Confirmed')

-- Issue 5390 - create new security token
INSERT INTO tblUserFunction
VALUES ('CaseCxlStatAwatAppt', 'Case - Cancel Case when set to Await Appt', GETDATE())
GO








UPDATE tblControl SET DBVersion='3.14'
GO
