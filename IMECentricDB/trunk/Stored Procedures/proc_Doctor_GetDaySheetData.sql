
CREATE proc [dbo].[proc_Doctor_GetDaySheetData]
	@fromDate datetime,
	@toDate datetime,
	@office int,
	@casetype int, 
	@doctor int,
	@location int,
	@alloffices int,
	@usenewdata int,
	@userid varchar(15)
as
begin
	
	----------------------------------------------------------------------------------------
	--Paramter preparation
	----------------------------------------------------------------------------------------
	if @alloffices is null or @alloffices < 0
	begin
		set @alloffices = -1;
	end

	if @usenewdata is null or @usenewdata <= 0
	begin
		set @usenewdata = -1;
	end

	if @userid is null 
	begin
		set @userid = '';
	end

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   


	----------------------------------------------------------------------------------------
	--Primary dataset using tblDoctorSchedule the old way into temp table
	----------------------------------------------------------------------------------------
	select 

			tblCaseAppt.CaseApptID,		
			tblDoctor.DoctorCode,
			tblLocation.LocationCode,		
			tblLocation.Location,
			(rtrim(tblLocation.Addr1 + ' ' + isnull(tblLocation.Addr2, '')) +  ', ' + tblLocation.City + ' ' + tblLocation.State + ' ' + tblLocation.Zip) as DoctorAddress,				
			CAST(CAST(tblCaseAppt.ApptTime AS DATE) AS DATETIME) as ApptDate,
			tblCaseAppt.ApptTime as ApptDateTime,
			stuff(replace(right(convert(varchar(19), tblCaseAppt.ApptTime, 0), 7), ' ', '0'), 6, 0, ' ') as ApptTime,		
			ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.Credentials, '') as DoctorName,		
			(case 
				when ltrim(rtrim(isnull(tblDoctor.DaysheetEmailAddr, ''))) <> '' then ltrim(rtrim(tblDoctor.DaysheetEmailAddr)) 
				when ltrim(rtrim(tblDoctor.EmailAddr)) <> '' then ltrim(rtrim(tblDoctor.EmailAddr)) 
				else null end) as DoctorEmail,		
			tblLocation.Phone as LocationPhone,
			(case 
				when ltrim(rtrim(isnull(tblDoctor.DaysheetFaxNbr, ''))) <> '' then ltrim(rtrim(tblDoctor.DaysheetFaxNbr)) 
				when ltrim(rtrim(isnull(tblLocation.Fax, ''))) <> '' then ltrim(rtrim(tblLocation.Fax)) 
				else null end) as LocationFax,
			tblLocation.ContactLast,
			tblLocation.ContactFirst,
			tblLocation.ExtName as LocationExtName,
			tblLocationOffice.OfficeCode as LocationOffice, 
			tblDoctorOffice.OfficeCode as DoctorOffice,
			tblCaseAppt.CaseNbr as caCaseNbr,
			tblCase.OfficeCode, 
			tblCase.CaseNbr, 
			tblCase.ExtCaseNbr

		into #daysheetdata		

		FROM tblCaseAppt with (nolock)
		INNER JOIN tblCase WITH (NOLOCK) ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
		LEFT OUTER JOIN tblCaseApptPanel WITH (NOLOCK) ON tblCaseApptPanel.CaseApptID = tblCaseAppt.CaseApptID
			inner join tblDoctor with (nolock) on ISNULL(tblCaseApptPanel.DoctorCode, tblCaseAppt.DoctorCode) = tblDoctor.DoctorCode	
			inner join tblLocation with (nolock) on tblCaseAppt.LocationCode = tblLocation.LocationCode 
			inner join tblDoctorOffice with (nolock) on tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
			inner join tblLocationOffice with (nolock) on tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode	

		WHERE 					
			(tblCaseAppt.ApptTime >= @fromDate and tblCaseAppt.ApptTime < DATEADD(day,1,@toDate))			
			and tblCaseAppt.ApptStatusID IN (10, 100,101,102)
			and tblDoctor.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), tblDoctor.DoctorCode))
			and tblLocation.LocationCode = (COALESCE(NULLIF(@location, '-1'), tblLocation.LocationCode))
			
	;

	----------------------------------------------------------------------------------------
	--Filter the temp table from above base on Office selection in CTE
	----------------------------------------------------------------------------------------
	with
	ddata as (

		select 
			distinct 
			CaseApptID, OfficeCode, DoctorCode, LocationCode, Location, DoctorAddress, CaseNbr, ExtCaseNbr, ApptDate, ApptDateTime, ApptTime,  
			DoctorName, DoctorEmail, LocationPhone, LocationFax, ContactLast, ContactFirst, LocationExtName
		from #daysheetdata
		where 
		(1=1 and 
				--// favorites
				(
					1 = (case when @alloffices = 0 then 1 else 0 end) 
					and	OfficeCode in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
					and LocationOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid) 
					and DoctorOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
				)

				or

				----// default
				(
					2 = (case when @alloffices = -1 then 2 else 0 end) 
					and	OfficeCode = @office
					and LocationOffice = @office 
					and DoctorOffice = @office
				)

				or
			
				----// all offices
				(
					3 = (case when @alloffices = 1 then 3 else 0 end) 						
				)
		)

	)

	----------------------------------------------------------------------------------------
	--Execute the actual query by joining the CTE (from temp table) to other tables for all the column outputs
	----------------------------------------------------------------------------------------
	select 
		d.*,
		tblOffice.ShortDesc as OfficeName,
		tblExaminee.FirstName + ' ' + tblExaminee.LastName as Examinee,
		tblCaseType.Description as CaseType,
		tblCaseType.ExternalDesc as CaseTypeShort,
		tblServices.Description as [Service],
		tblServices.ShortDesc as [ServiceShort],
		tblCase.DoctorSpecialty as Specialty,
		(tblServices.ShortDesc + ' / ' + tblCase.DoctorSpecialty) as ServiceSpecialty,		
		(case when tblCase.PhotoRqd is not null and tblCase.PhotoRqd = 1 then convert(bit, 1) else convert(bit, 0) end) as PhotoRequired,
		(case when tblCase.InterpreterRequired = 1 then 'Interpreter' else '' end) as Interpreter,
		(case when tblCase.LanguageID > 0 then tblLanguage.Description else '' end) as [InterpreterLanguage],
		(case when (select top 1 [Type] from tblRecordHistory with (nolock) where [Type] = 'F' and CaseNbr = tblCase.CaseNbr) = 'F' then 'Films' else '' end) as Comments,
		tblEWFacility.Logo as LogoURL
	from ddata d
			inner join tblCase with (nolock) on tblCase.CaseNbr = d.CaseNbr
			inner join tblClient with (nolock) on tblCase.ClientCode = tblClient.ClientCode
			inner join tblCompany with (nolock) on tblClient.CompanyCode = tblCompany.CompanyCode
			inner join tblOffice with (nolock) on tblCase.OfficeCode = tblOffice.OfficeCode
			inner join tblEWFacility with (nolock) on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
			inner join tblServices with (nolock) on tblCase.ServiceCode = tblServices.ServiceCode 
			inner join tblExaminee with (nolock) on tblCase.ChartNbr = tblExaminee.ChartNbr
			inner join tblCaseType with (nolock) on tblCase.CaseType = tblCaseType.Code		
			left outer join tblLanguage with (nolock) on tblLanguage.LanguageID = tblcase.LanguageID
	;

	----------------------------------------------------------------------------------------
	--Cleanup
	----------------------------------------------------------------------------------------
	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

end
GO
