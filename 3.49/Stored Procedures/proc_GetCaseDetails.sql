
CREATE PROCEDURE [dbo].[proc_GetCaseDetails] 

@caseNbr int 

AS 

SELECT DISTINCT
	tblCase.casenbr, 
	tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, 
	tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
	tblCompany.intname AS companyname, 
	CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate, 
	tblCase.claimnbr, 
	tblCase.claimnbrext, 
	tblCase.invoicedate,
	tblCase.invoiceamt,
	tblLocation.location,
	datediff(day,apptdate,eventdate) RPTAT,
	tblServices.description AS service, 
	isnull(tblCase.DoctorName, tblCase.requesteddoc) AS provider, 
	tblWebQueues.description AS WebStatus, 
	tblQueues.statusdesc AS Status, 
	tblWebQueues.statuscode, 
	ISNULL(tblCase.sinternalcasenbr, tblCase.casenbr) AS webcontrolnbr
FROM tblCase 
	INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
	INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
	LEFT JOIN tblCaseHistory ON tblCase.casenbr = tblCaseHistory.casenbr AND tblCaseHistory.type = 'FinalRpt'
	LEFT JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
	LEFT JOIN tblCompany 
	INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode 
	LEFT JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
WHERE tblCase.casenbr = @caseNbr
