/*
	this view is called by a CRN nightly process	
*/

CREATE VIEW [dbo].[vwCRNCaseDetailAssigned]
AS 
SELECT  d.DoctorCode AS ReviewerID, 
		ca.CaseNbr AS CaseID, 
		MAX(ca.DateAdded) AS AssignedDate
FROM    dbo.tblCaseAppt AS ca WITH (nolock) LEFT OUTER JOIN
        dbo.tblCaseApptPanel AS cp WITH (nolock) ON cp.CaseApptID = ca.CaseApptID LEFT OUTER JOIN
		dbo.tblDoctor AS d WITH (nolock) ON d.DoctorCode = COALESCE (cp.DoctorCode, ca.DoctorCode)
WHERE     (d.EWParentDocID IS NOT NULL)
GROUP BY d.DoctorCode, ca.CaseNbr