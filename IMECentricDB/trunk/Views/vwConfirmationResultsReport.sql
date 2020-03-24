CREATE VIEW vwConfirmationResultsReport
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
		IIF(ca.apptConfirmedByExaminee=1 OR ca.apptConfirmedByAttorney=1, 'Yes','No') AS Confirmed,
		c.officeCode,
		cl.StartDate,
		cs.Name AS StatusDescription,
		d.FirstName + ' ' + d.LastName AS 'Doctor Name',
		l.Location AS 'Exam Location',		
		CONVERT(date, cb.DateBatchPrepared) AS SentDate,
		c.Employer
	FROM tblconfirmationlist AS cl
	LEFT OUTER JOIN tblconfirmationresult AS cr ON cr.confirmationresultid = cl.confirmationresultid
	INNER JOIN tblcaseappt AS ca ON ca.caseapptid = cl.CaseApptID
	INNER JOIN vwdocument AS c ON c.casenbr = ca.CaseNbr
	INNER JOIN tblServices AS s ON c.servicecode = s.servicecode
	INNER JOIN tblCaseType AS ct ON c.casetype = ct.code
	INNER JOIN tblConfirmationStatus AS cs ON cl.ConfirmationStatusID = cs.ConfirmationStatusID
	LEFT OUTER JOIN tblConfirmationBatch AS cb ON cl.BatchNbr = cb.BatchNbr
	LEFT OUTER JOIN tblDoctor AS d ON ca.DoctorCode = d.DoctorCode
	INNER JOIN tblLocation AS l ON ca.LocationCode = l.LocationCode
	WHERE (cl.Selected = 1) 
	AND (cl.ConfirmationStatusID IN (NULL,3,4,5,112))


