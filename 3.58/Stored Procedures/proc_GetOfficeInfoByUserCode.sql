CREATE PROCEDURE proc_GetOfficeInfoByUserCode

@UserCode int,
@UserType char(2)

AS
 
IF @UserType = 'DR'
	BEGIN
		select * from tblEWFacility where EWFacilityID = 
		(select top 1 tblOffice.EWFacilityID from tblCase 
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		where doctorcode = @UserCode
		group by tblOffice.EWFacilityID
		order by count(casenbr) desc)
	END
ELSE IF @UserType = 'CL'
	BEGIN
		select * from tblEWFacility where EWFacilityID = 
		(select top 1 tblOffice.EWFacilityID from tblCase 
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		where clientcode = @UserCode
		group by tblOffice.EWFacilityID
		order by count(casenbr) desc)
	END