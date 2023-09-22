CREATE PROCEDURE [dbo].[sp_CreateExternalCommunications]
	@caseHistoryID INT,
	@currDateTime DATETIME, 
	@entityType VARCHAR(2), 
	@entityID VARCHAR(64)
AS
BEGIN
	-- create new entry in table
	INSERT INTO tblExternalCommunications(DateAdded, EventDate, CaseNbr, ChartNbr, CaseHistoryID, UserID, 
		DoctorCode, DoctorSpecialty, ApptDateTime, DateCanceled, CaseHistoryType, EWBusLineID, EWServiceTypeID, 
		OfficeCode, ApptLocationCode, ClaimNbr, EWFacilityID, EntityType, EntityID)
			SELECT @currDateTime, 
				   ch.EventDate, 
				   ch.CaseNbr, 
				   c.ChartNbr, 
				   ch.ID, 
				   ch.UserID, 
				   c.DoctorCode, 
				   c.DoctorSpecialty, 
				   c.ApptTime,
				   c.DateCanceled, 
				   ch.Type, 
				   ct.EWBusLineID, 
				   s.EWServiceTypeID, 
				   c.OfficeCode, 
				   c.DoctorLocation,
				   c.ClaimNbr, 
				   f.EWFacilityID, 
				   @entityType, 
				   @entityID 
			  FROM tblcasehistory AS ch 
					 INNER JOIN tblcase AS c ON ch.casenbr = c.casenbr
					 INNER JOIN tblcasetype AS ct ON c.casetype = ct.code
					 INNER JOIN tblservices AS s ON c.servicecode = s.ServiceCode
					 INNER JOIN tbloffice AS o ON c.OfficeCode = o.OfficeCode
					 INNER JOIN tblEWFacility AS f ON o.EWFacilityID = f.EWFacilityID
					 INNER JOIN tblEWFacilityGroupSummary AS fgs ON f.EWFacilityID = fgs.EWFacilityID 
			 WHERE ch.ID = @caseHistoryID
	
	-- return PKey of item created
	SELECT @@IDENTITY as newID

END
