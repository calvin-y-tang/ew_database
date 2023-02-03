CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@useEditDate Bit	
AS
SET NOCOUNT ON
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases

SELECT
	c.casenbr,
	s.description as 'Service File Type',
	convert(varchar, c.dateadded, 101) as 'Referral Date',
	sh.lastname + ', ' + sh.firstname as 'CM',
	e.lastname as Surname,
	e.firstname as 'First Name',
	co.ExtName as 'Client',
	co.city as 'Client Location',
	c.AddlClaimNbrs as 'Group Number',
	c.claimnbr as 'Claim Number',
	emp.Name as 'Group or Employer',
	cl.firstname + ' ' + cl.LastName as 'Case Manager 1',
	isnull(convert(varchar,c.dateofinjury,101),'') as 'Disability Date',
	convert(varchar, null) as 'EHQ-Rcvd',
	convert(varchar, null) as 'EHQ-Sent',
	convert(varchar, null) as 'Claims Received Date',
	convert(varchar, null) as 'TMHARecommend',
	convert(varchar, null) as 'TMHARequestSent',
	convert(varchar, null) as 'TMHAService',
	convert(int, null) as 'TMHARescheduled' ,
	convert(bit, null) as 'TMHACancelled' ,
	convert(datetime, null) as 'TMHARescheduledDate' ,
	c.RptSentDate as 'Final Sent',
	convert(varchar(1000), null) as Diagnosis,
	e.treatingphysician as 'GP Contact',
	convert(varchar, null) as 'GPContactDate',
	c.doctorname as 'Psychiatrist',
	convert(datetime, null) as 'GP Comm Fax Received' ,
	convert(varchar, null) as 'RTWDate',
	convert(varchar(2000), null) as 'RTWExplained',
	c.dateedited as 'ServiceFileModified'
into ##Temp_MedacaCases
from tblcase c with (nolock) 
	inner join tbloffice o with (nolock) on c.officecode = o.officecode
	inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
	inner join tblclient cl with (nolock) on cl.clientcode = c.clientcode
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	inner join tblservices s with (nolock) on s.ServiceCode = c.ServiceCode
	left join tblemployer emp with (nolock) on emp.EmployerID = c.EmployerID
	left join tbluser sh with (nolock) on sh.userid = c.schedulercode
where 
	IIF(@useEditDate = 1, c.dateedited, c.DateReceived) >= @startDate and c.dateedited < @endDate	

SET NOCOUNT OFF