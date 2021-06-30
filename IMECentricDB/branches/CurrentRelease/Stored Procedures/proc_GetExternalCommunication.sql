CREATE PROCEDURE [dbo].[proc_GetExternalCommunication]
	@chID AS INTEGER,
	@parentCompanyID AS INTEGER
AS
	SELECT ch.EventDate,
		c.ChartNbr,
		ch.UserID,
		c.DoctorCode,
		c.DoctorSpecialty,
		c.ApptTime,
		c.DateCanceled,
		ch.[Type],
		ct.EWBusLineID,
		s.EWServiceTypeID,
		c.OfficeCode,
		c.DoctorLocation,
		c.claimnbr,
		f.EWFacilityID, 
		fgs.BusUnitGroupID,
		com.BulkBillingID
 FROM tblcasehistory AS ch 
 INNER JOIN tblcase AS c ON ch.casenbr = c.casenbr
 INNER JOIN tblcasetype AS ct ON c.casetype = ct.code
 INNER JOIN tblservices AS s ON c.servicecode = s.ServiceCode
 INNER JOIN tblcompany AS com ON c.companycode = com.companycode
 INNER JOIN tbloffice AS o ON c.OfficeCode = o.OfficeCode
 INNER JOIN tblEWFacility AS f ON o.EWFacilityID = f.EWFacilityID
 INNER JOIN tblEWFacilityGroupSummary AS fgs ON f.EWFacilityID = fgs.EWFacilityID
 WHERE (ch.ID = @chID)
   AND (com.ParentCompanyID = @parentCompanyID)
   AND (c.InputSourceID = 7)
   AND (s.EWServiceTypeID NOT IN (0))
   AND (ch.[Type] IN ('CANCEL', 'CANCELLED', 'FINALRPT', 'LATECANCEL', 'NEWCASE', 'NOSHOW', 'UNSCHEDULE',
					'RPTSENTEMAIL', 'RPTSENTFAX', 'RPTSENTPRINT', 'RPTSENTWEB', 'SCHEDULED', 'SHOW', 'TRANSCRIPTION')) 